## Docker image

### programs

- kubectl
- kustomize
- helm
- ansible
- python 3

### binaries

- bash, git, gpg, jq, ssh, yq

### base image

https://github.com/cytopia/docker-ansible ``cytopia/ansible:2.11-tools``

## Ansible galaxy

- ebuildy.cidre     https://github.com/ebuildy/ansible-cidre
- ebuildy.keployr   https://github.com/ebuildy/ansible-keployr

## usage

```
docker run -ti -v /my-playbook:/src --rm keployr ansible-playbook /src/playbook.yaml
```

### Specify user / UID,GID

use case: run with gitlab-ci

```
docker run -ti --rm -e USER=ansible -e MY_UID=1000 -e MY_GID=1000 keployr whoami
```