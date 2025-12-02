# Dockerfile for building Android custom ROMs
# Base image: Ubuntu 24.04 (noble)

FROM ubuntu:24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    sudo \
    zsh \
    bc \
    bison \
    build-essential \
    ccache \
    curl \
    flex \
    fontconfig \
    g++-multilib \
    gcc-multilib \
    git \
    git-lfs \
    gnupg \
    gperf \
    imagemagick \
    lib32ncurses-dev \
    lib32readline-dev \
    lib32z1-dev \
    liblz4-tool \
    libncurses6 \
    libncurses-dev \
    libsdl1.2-dev \
    libssl-dev \
    libwxgtk3.2-dev \
    libxml2 \
    libxml2-utils \
    lzop \
    openjdk-21-jdk \
    pngcrush \
    rsync \
    schedtool \
    squashfs-tools \
    unzip \
    wget \
    xsltproc \
    zip \
    python3 \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

FROM base

ENV TZ=Asia/Manila \
    CCACHE_DIR=/ccache \
    CCACHE_MAXSIZE=50G

ARG BUILD_USER=ubuntu
ARG BUILD_UID=1000

RUN usermod -s /bin/bash ${BUILD_USER}

# Setup ccache directory
RUN mkdir -p ${CCACHE_DIR} \
 && chown -R ${BUILD_USER}:${BUILD_USER} ${CCACHE_DIR}

# Install Google's repo tool
RUN curl -fsSL https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo \
 && chmod a+x /usr/local/bin/repo

# Create symlink for python to python3
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Copy minimal zshrc configuration
COPY .zshrc /home/${BUILD_USER}/.zshrc
RUN chown ${BUILD_USER}:${BUILD_USER} /home/${BUILD_USER}/.zshrc

# Configure git defaults for the build user
RUN git config --system user.email "builder@localhost" \
 && git config --system user.name "Builder" \
 && git config --system color.ui auto

USER ${BUILD_USER}
WORKDIR /home/${BUILD_USER}

ENV PATH="/usr/local/bin:${PATH}"

CMD ["/bin/zsh"]

# Notes:
# - This Dockerfile assumes Ubuntu 24.04 package names. If a package isn't
#   available in the chosen Ubuntu release (for example some wxGTK dev packages),
#   update the package name or add appropriate PPAs before installing.