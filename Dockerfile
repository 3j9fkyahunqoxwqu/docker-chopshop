FROM debian:wheezy

MAINTAINER blacktop, https://github.com/blacktop

# Prevent daemon start during install
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

# Install ChopShop Required Dependencies
RUN \
  apt-get -qq update && \
  apt-get install -yq python-setuptools \
                      build-essential \
                      libmagic-dev \
                      libpcre3-dev \
                      libpcap-dev \
                      python-dev \
                      git-core \
                      autoconf \
                      automake \
                      libpcre3 \
                      libtool \
                      python \
                      swig \
                      gcc --no-install-recommends && \
  easy_install pymongo && \
  easy_install M2Crypto && \
  easy_install pycrypto && \
  easy_install dnslib && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Yara and remove install dir after to conserve space
RUN  \
  git clone --recursive --branch v3.1.0 git://github.com/plusvic/yara && \
  cd yara && \
  ./bootstrap.sh && \
  ./configure --enable-magic && \
  make && \
  make install && \
  echo "/usr/local/lib" >> /etc/ld.so.conf && \
  ldconfig && \
  cd yara-python && \
  python setup.py build && \
  python setup.py install && \
  rm -rf /yara && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install pynids and remove install dir after to conserve space
RUN  \
  git clone --recursive git://github.com/MITRECND/pynids && \
  cd pynids && \
  python setup.py build && \
  python setup.py install && \
  rm -rf /pynids && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install htpy and remove install dir after to conserve space
RUN  \
  git clone --recursive git://github.com/MITRECND/htpy && \
  cd htpy && \
  python setup.py build && \
  python setup.py install && \
  rm -rf /htpy && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install yaraprocessor and remove install dir after to conserve space
RUN  \
  git clone git://github.com/MITRECND/yaraprocessor.git && \
  cd yaraprocessor && \
  python setup.py install && \
  rm -rf /yaraprocessor && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install pylibemu and remove install dir after to conserve space
RUN  \
  git clone git://git.carnivore.it/libemu.git && \
  cd libemu && autoreconf -v -i && \
  ./configure --enable-python-bindings --prefix=/opt/libemu && \
  make install && \
  echo "/opt/libemu/lib/" >> /etc/ld.so.conf.d/libemu.conf && \
  ldconfig && \
  git clone git://github.com/buffer/pylibemu.git && \
  cd pylibemu && \
  echo /opt/libemu/lib > /etc/ld.so.conf.d/pylibemu.conf && \
  python setup.py build && \
  python setup.py install && \
  rm -rf /libemu && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install ChopShop and remove install dir after to conserve space
ADD chopshop.cfg /root/.chopshop.cfg
RUN  \
  git clone --recursive git://github.com/MITRECND/chopshop && \
  cd chopshop && \
  make && \
  make install && \
  rm -rf /chopshop && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/pcap"]
WORKDIR /pcap

ENTRYPOINT ["/usr/local/bin/chopshop"]

CMD ["-h"]
