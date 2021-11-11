# See here for image contents: https://github.com/microsoft/vscode-dev-containers/blob/v0.202.3/containers/python-3/.devcontainer/base.Dockerfile
# [Choice] Python version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.9, 3.8, 3.7, 3.6, 3-bullseye, 3.9-bullseye, 3.8-bullseye, 3.7-bullseye, 3.6-bullseye, 3-buster, 3.9-buster, 3.8-buster, 3.7-buster, 3.6-buster
ARG VARIANT=3-bullseye
ARG EXTRA_CERTS=exclude
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT} as custom_include
ONBUILD RUN echo "Including certs"
#Adding CA certs to CA store
ONBUILD ADD certs/cert1.crt /usr/local/share/ca-certificates/cert1.crt
ONBUILD ADD certs/cert2.crt /usr/local/share/ca-certificates/cert2.crt
#Update CA cert Store
ONBUILD RUN chmod 644 /usr/local/share/ca-certificates/* && update-ca-certificates

ARG VARIANT
ARG EXTRA_CERTS
FROM mcr.microsoft.com/vscode/devcontainers/python:0-${VARIANT} as custom_exclude
ONBUILD RUN echo "Excluding certs"


ARG EXTRA_CERTS
FROM custom_${EXTRA_CERTS}
# [Optional] Allow the vscode user to pip install globally w/o sudo
ENV PIP_TARGET=/usr/local/pip-global
ENV PYTHONPATH=${PIP_TARGET}:${PYTHONPATH}
ENV PATH=${PIP_TARGET}/bin:${PATH}
RUN if ! cat /etc/group | grep -e "^pip-global:" > /dev/null 2>&1; then groupadd -r pip-global; fi \
    && usermod -a -G pip-global vscode \
    && umask 0002 && mkdir -p ${PIP_TARGET} \
    && chown :pip-global ${PIP_TARGET} \
    && ( [ ! -f "/etc/profile.d/00-restore-env.sh" ] || sed -i -e "s/export PATH=/export PATH=\/usr\/local\/pip-global:/" /etc/profile.d/00-restore-env.sh )

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update \
    && apt-get install -y gnupg software-properties-common curl \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends terraform \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -L -o /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/download/v0.33.1/tflint_linux_amd64.zip \
    && unzip -u /tmp/tflint.zip -d /tmp/ \
    && install -c -v /tmp/tflint /usr/local/bin \
    && rm -f /tmp/tflint.zip /tmp/tflint \
    && curl -L -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.35.7/terragrunt_linux_amd64 \
    && chmod 755 /usr/local/bin/terragrunt \
    && curl -L -o /tmp/awscli.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    && unzip -u /tmp/awscli.zip -d /tmp/ \
    && ./tmp/aws/install \
    && rm -f /tmp/awscli.zip \
    && curl -L -o /tmp/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip \
    && unzip -u /tmp/ngrok.zip -d /usr/local/bin/ \
    && rm -f /tmp/ngrok.zip


# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1