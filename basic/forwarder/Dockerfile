FROM debian:buster-slim

WORKDIR /workspace

# Install APT packages
RUN apt-get -y -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y -qq install \
        bind9-host \
        curl \
        groff-base \
        jq \
        less \
        netcat \
        openssh-client \
        postgresql-client \
        procps \
        unzip \
        vim \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl -LO https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip awscli-exe-linux-x86_64.zip && \
    ./aws/install && \
    rm -rf aws awscli-exe-linux-x86_64.zip

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm -f kubectl

# Configure AWS CLI
ARG STACK
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION

# Uses `eval '...'` to suppress printing values to the console during build

RUN eval 'test -n "$STACK"' # Required build arg
RUN eval 'test -n "$AWS_ACCESS_KEY_ID"' # Required build arg
RUN eval 'test -n "$AWS_SECRET_ACCESS_KEY"' # Required build arg
RUN eval 'test -n "$AWS_DEFAULT_REGION"' # Required build arg

RUN eval 'aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile "$STACK"' && \
    eval 'aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile "$STACK"' && \
    eval 'aws configure set region "$AWS_DEFAULT_REGION" --profile "$STACK"' && \
    eval 'aws configure set output json --profile "$STACK"'

ENV AWS_PROFILE=$STACK

# Configure kubectl
ARG ENV=dev

RUN aws eks update-kubeconfig --name="$STACK-$ENV-eks"

# Install SSH key
RUN mkdir -p "$HOME/.ssh" && \
    kubectl -n bastion get secret bastion-ssh-key -o json | jq -r '.data.private_key_pem' | base64 -d > "$HOME/.ssh/id_rsa" && \
    chmod 400 "$HOME/.ssh/id_rsa"

# Bootstrap
COPY commands bin
COPY entrypoint.sh ./

RUN for file in bin/*.sh; do mv "$file" "${file%.sh}"; done

ENV STACK=$STACK \
    ENV=$ENV

ENTRYPOINT ["./entrypoint.sh"]
CMD []
