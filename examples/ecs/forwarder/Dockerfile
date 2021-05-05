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

# Bootstrap
COPY commands bin
COPY entrypoint.sh ./

RUN for file in bin/*.sh; do mv "$file" "${file%.sh}"; done

ARG ENV=dev
ENV STACK=$STACK \
    ENV=$ENV \
    PATH=/workspace/bin:$PATH

ENTRYPOINT ["./entrypoint.sh"]
CMD []
