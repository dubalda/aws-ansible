FROM fedora:34

# verify the signatures awscli by using the GnuPG tool
COPY amazon-public-key /tmp/amazon-public-key

RUN set +euo pipefail && \
    dnf -y install \
      ca-certificates \
      openssl \
      gnupg2 \
      jq \
      tree \
      unzip \
      python3-pip \
      groff \
      less \
      ansible && \
    dnf clean all && \
    pip3 install --no-cache-dir boto botocore boto3 yq && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    gpg --import /tmp/amazon-public-key && \
    curl -o awscliv2.sig https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig && \
    gpg --verify awscliv2.sig awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install && \
    aws --version && \
    ansible --version