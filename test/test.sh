#!/bin/sh -x

KEPLOYR_USER=gitlab-runner \
KEPLOYR_USER_UID=999 \
INFRA_ENV=dev_kube_par1_c2 \
KEPLOYR_FILE=./test.yaml \
KEPLOYR_SKIP_TAGS="deploy" \
  keployr "always,debug,untagged"

git --version
