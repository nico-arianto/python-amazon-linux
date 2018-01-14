FROM amazonlinux:2

LABEL maintainer="Nico Arianto <nico.arianto@gmail.com>"

ENV PYTHON_VERSION=2.7.14

RUN buildDeps="wget bzip2-devel libdb-devel gdbm-devel ncurses-devel readline-devel sqlite-devel openssl-devel tcl-devel tk-devel xz-devel expat-devel libpcap-devel" && \
    yum -y update && \
    yum -y groupinstall "Development Tools" && \
    yum -y install $buildDeps && \
    mkdir -p /tmp/downloads && \
    wget -P /tmp/downloads/ https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz && \
    wget -P /tmp/downloads/ https://bootstrap.pypa.io/get-pip.py && \
    tar -xvf /tmp/downloads/Python-$PYTHON_VERSION.tar.xz -C /tmp/downloads/ && \
    cd /tmp/downloads/Python-$PYTHON_VERSION && \
    ./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" --enable-optimizations && \
    make && \
    make install && \
    python /tmp/downloads/get-pip.py && \
    yum -y autoremove $buildDeps && \
    yum -y autoremove autoconf bison byacc cscope ctags diffstat doxygen elfutils flex gcc gettext git indent patch patchutils rcs rpm-sign && \
    sed -i -e "s/python/\/usr\/bin\/python/g" -r /usr/bin/amazon-linux-extras && \
    rm -rf /tmp/downloads
