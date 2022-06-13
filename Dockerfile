FROM ubuntu:bionic

ENV PACKAGES "locales git curl ca-certificates build-essential libreadline-dev zlib1g-dev zip unzip libssl1.0-dev lsb-release"

RUN apt-get clean && apt-get update && apt-get install -y --no-install-recommends ${PACKAGES} && apt-get clean

# use rbenv understandable version
ARG RUBY_VERSION
ENV RUBY_VERSION=${RUBY_VERSION:-2.5.9}
ENV PATH=/root/.rbenv/bin:/root/.rbenv/shims:$PATH

RUN locale-gen "en_US.UTF-8"
RUN update-locale LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

COPY scripts/package-setup.sh /
RUN /package-setup.sh $RUBY_VERSION
RUN rm -fv /package-setup.sh

COPY scripts/rbenv-setup.sh /
RUN bash /rbenv-setup.sh $RUBY_VERSION
RUN rm -fv /rbenv-setup.sh

RUN curl -L https://github.com/mikefarah/yq/releases/download/3.3.0/yq_linux_amd64 -o yq && chmod +x yq && mv yq /usr/local/bin/yq
RUN ln -s /usr/local/bin/yq /usr/local/bin/yaml

COPY scripts/init.sh /init.sh
