# syntax=docker/dockerfile:1
ARG ansible_version

FROM cytopia/ansible:${ansible_version}-tools AS base

  RUN apk add --update --no-cache git openssh curl ca-certificates make

# ----------------------------------------------------------------------------------------------------------------------------------
# helm
# ----------------------------------------------------------------------------------------------------------------------------------

FROM base AS helm_builder

  ARG helm_version

  ARG BASE_URL="https://get.helm.sh"
  ARG TAR_FILE="helm-v${helm_version}-linux-amd64.tar.gz"

  RUN curl -L ${BASE_URL}/${TAR_FILE} |tar xvz && \
      mv linux-amd64/helm /usr/bin/helm && \
      chmod +x /usr/bin/helm && \
      rm -rf linux-amd64 && \
      helm version


# ----------------------------------------------------------------------------------------------------------------------------------
# kustomize
# ----------------------------------------------------------------------------------------------------------------------------------

FROM base AS kustomize_builder

  ARG KUSTOMIZE_VER="4.1.2"
  ARG KUSTOMIZE_URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VER}/kustomize_v${KUSTOMIZE_VER}_linux_amd64.tar.gz"

  RUN curl -L "${KUSTOMIZE_URL}" |tar xvz \
      && mv kustomize /usr/bin/kustomize \
      && chmod +x /usr/bin/kustomize \
      && kustomize version


# ----------------------------------------------------------------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------------------------------------------------------------

FROM base

  RUN pip3 install pygments jsonschema boto3

  ENV ANSIBLE_COLLECTIONS_PATHS   /opt/keployr

  ARG cidre_version
  ARG keployr_version

  ##
  # Install ansible collections
  ##
  RUN ansible-galaxy collection install \
        community.general \
        community.kubernetes \
        ebuildy.cidre:==${cidre_version} \
        ebuildy.keployr:==${keployr_version} \
        -vvv

  ENV ANSIBLE_ROLES_PATH          ~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
  ENV INJECT_FACTS_AS_VARS        False
  ENV LOCALHOST_WARNING           False
  ENV KEPLOYR_HOME                /opt/keployr/app
  ENV ANSIBLE_CONFIG              $KEPLOYR_HOME/ansible.cfg

  COPY --from=helm_builder      /usr/bin/helm       /usr/bin/helm
  COPY --from=kustomize_builder /usr/bin/kustomize  /usr/bin/kustomize

  RUN rm -rf \
        /usr/share/doc/ \
        /usr/share/man/ \
        /usr/share/locale/ \
        /var/cache/apk/*

  ADD app $KEPLOYR_HOME

  WORKDIR $KEPLOYR_HOME