FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ARG LMOD_VERSION=8.7.37

RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    git \
    wget \
    rsync \
    build-essential \
    bc \
    ca-certificates \
    tcl-dev \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# isntall lua
# follow by https://lmod.readthedocs.io/en/latest/030_installing.html#integrating-module-into-users-shells
RUN cd /tmp \
    && wget https://sourceforge.net/projects/lmod/files/lua-5.1.4.9.tar.bz2 \
    && tar -xvf lua-5.1.4.9.tar.bz2 \
    && cd lua-5.1.4.9 \
    && ./configure --prefix=/opt/apps/lua/5.1.4.9 \
    && make; make install \
    && cd /opt/apps/lua; ln -s 5.1.4.9 lua \
    && ln -s /opt/apps/lua/lua/bin/lua /usr/local/bin \
    && ln -s /opt/apps/lua/lua/bin/luac /usr/local/bin \
    && rm -rf /tmp/lua-5.1.4.9.tar.bz2 \
    && rm -rf /tmp/lua-5.1.4.9

# install lmod
RUN cd /tmp \
    && wget https://github.com/TACC/Lmod/archive/refs/tags/${LMOD_VERSION}.tar.gz \
    && tar -xvf ${LMOD_VERSION}.tar.gz \
    && cd Lmod-${LMOD_VERSION} \
    && ./configure --prefix=/opt/apps \
    && make install \
    && ln -s /opt/apps/lmod/lmod/init/profile        /etc/profile.d/z00_lmod.sh \
    && ln -s /opt/apps/lmod/lmod/init/cshrc          /etc/profile.d/z00_lmod.csh \
    && rm -rf /tmp/${LMOD_VERSION}.tar.gz \
    && rm -rf /tmp/Lmod-${LMOD_VERSION} \
    && echo "source /etc/profile.d/z00_lmod.sh" >> ~/.bashrc

# Please set MODULEPATH env by yourself when you start a new container