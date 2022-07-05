# Workshop for introduce container security

This repository is provided for learning about platform that report vulnerabilities in container image.  

## Prerequisite

- docker
- docker-compose

## Step to walkthrough workshop

1. Provision docker-compose

    ```bash
    $ docker-compose up -d
    Creating network "lab_container_security_default" with the default driver
    Creating lab_container_security_db_1 ... done
    Creating lab_container_security_catalog_1 ... done
    Creating lab_container_security_analyzer_1      ... done
    Creating lab_container_security_api_1           ... done
    Creating lab_container_security_queue_1         ... done
    Creating lab_container_security_policy-engine_1 ... done
    Creating lab_container_security_cli_1           ... done
    ```

2. Verify all container is running

    ```bash
    docker ps
    b9c8fe5d8e58   opsta/anchore-cli:0.9.3         "tail -f /dev/null"      About a minute ago   Up About a minute                                                         lab_container_security_cli_1
    00c12008d710   anchore/anchore-engine:v1.1.0   "/docker-entrypoint.…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:8228->8228/tcp, :::8228->8228/tcp   lab_container_security_api_1
    b5f28b5becd6   anchore/anchore-engine:v1.1.0   "/docker-entrypoint.…"   About a minute ago   Up About a minute (healthy)   8228/tcp                                    lab_container_security_queue_1
    aeb0d6173ced   anchore/anchore-engine:v1.1.0   "/docker-entrypoint.…"   About a minute ago   Up About a minute (healthy)   8228/tcp                                    lab_container_security_policy-engine_1
    1679e0af4bc3   anchore/anchore-engine:v1.1.0   "/docker-entrypoint.…"   About a minute ago   Up About a minute (healthy)   8228/tcp                                    lab_container_security_analyzer_1
    bbf8815855c9   anchore/anchore-engine:v1.1.0   "/docker-entrypoint.…"   About a minute ago   Up About a minute (healthy)   8228/tcp                                    lab_container_security_catalog_1
    1c3c80e4a993   postgres:14                     "docker-entrypoint.s…"   About a minute ago   Up About a minute (healthy)   5432/tcp                                    lab_container_security_db_1
    ```

3. Execute to `cli` container

    ```bash
    ## docker exec -it <container-id> ash
    docker exec -it b9c8fe5d8e58 ash
    ```

4. Export binary path

    ```bash
    $ export PATH=$PATH:$HOME/.local/bin
    $ env
    ...
    PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/anchore/.local/bin
    ...
    ```

5. Work with anchore-cli, export anchore endpoint and credentials.

    ```bash
    export ANCHORE_CLI_URL=http://api:8228/v1
    export ANCHORE_CLI_USER=admin
    export ANCHORE_CLI_PASS=foobar
    ```

6. Add first image to analyzed.

    ```bash
    $ anchore-cli image add opsta/fluentd:1.14-alpine-gelf
    Image Digest: sha256:81e696732b4e6e19f1ba406ee2b69665b19c191dfb19337e010485119744e525
    Parent Digest: sha256:81e696732b4e6e19f1ba406ee2b69665b19c191dfb19337e010485119744e525
    Analysis Status: not_analyzed
    Image Type: docker
    Analyzed At: None
    Image ID: e400a76cc87992a0f22f30ef30efd079a04df69441abf34407bba91005514104
    Dockerfile Mode: None
    Distro: None
    Distro Version: None
    Size: None
    Architecture: None
    Layer Count: None

    Full Tag: docker.io/opsta/fluentd:1.14-alpine-gelf
    Tag Detected At: 2022-07-05T08:16:08Z
    ```

7. Get current status of imported image

    ```bash
    anchore-cli image get opsta/fluentd:1.14-alpine-gelf
    Image Digest: sha256:81e696732b4e6e19f1ba406ee2b69665b19c191dfb19337e010485119744e525
    Parent Digest: sha256:81e696732b4e6e19f1ba406ee2b69665b19c191dfb19337e010485119744e525
    Analysis Status: analyzed
    Image Type: docker
    Analyzed At: 2022-07-05T08:16:41Z
    Image ID: e400a76cc87992a0f22f30ef30efd079a04df69441abf34407bba91005514104
    Dockerfile Mode: Guessed
    Distro: alpine
    Distro Version: 3.13.7
    Size: 57026560
    Architecture: amd64
    Layer Count: 7

    Full Tag: docker.io/opsta/fluentd:1.14-alpine-gelf
    Tag Detected At: 2022-07-05T08:16:08Z
    ```

8. Get vulnerabilities report to image. We can get 3 types of report like `os`, `non-os`, and `all`.

    ```bash
    $ anchore-cli image vuln opsta/fluentd:1.14-alpine-gelf all
    Vulnerability ID           Package                       Severity        Fix              CVE Refs              Vulnerability URL                                                   Type        Feed Group         Package Path                                                           
    CVE-2022-28391             busybox-1.32.1-r7             Critical        1.32.1-r8        CVE-2022-28391        http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-28391        APKG        alpine:3.13        pkgdb                                                                  
    ```
