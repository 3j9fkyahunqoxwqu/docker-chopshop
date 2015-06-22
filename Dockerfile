FROM blacktop/yara:3.1.0

MAINTAINER blacktop, https://github.com/blacktop

# COPY install scripts to tmp folder
COPY install /tmp/install
RUN chmod -R 755 /tmp/install

# Install ChopShop Required Dependencies
RUN buildDeps='autoconf \
                automake \
                apt-utils \
                build-essential \
                git-core \
                libmagic-dev \
                libpcap-dev \
                libpcre3-dev \
                python-dev \
                python-pip' \
  && set -x \
  && echo "[INFO] Installing Dependancies..." \
  && apt-get -qq update \
  && apt-get install -yq $buildDeps \
                          libpcre3 \
                          libtool \
                          python \
                          swig --no-install-recommends \
  && pip install --upgrade pip \
  && /usr/local/bin/pip install pymongo \
                                M2Crypto \
                                pycrypto \
                                dnslib \
  && echo "[INFO] Installing ChopShop..." \
  && cd /tmp \
  && install/pynids.sh \
  && install/htpy.sh \
  && install/yaraprocessor.sh \
  && install/pylibemu.sh \
  && install/chopshop.sh \
  && echo "[INFO] Remove Build Dependancies..." \
  && apt-get remove --purge -y $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#
# # COPY install scripts to tmp folder
# COPY install /tmp/install
# RUN chmod -R 755 /tmp/install
#
# # Install ChopShop Required Dependencies
# RUN buildDeps='autoconf \
#                 automake \
#                 build-base \
#                 file-dev \
#                 git \
#                 libpcap-dev \
#                 pcre-dev \
#                 openssl-dev \
#                 py-pip \
#                 python-dev' \
#   && set -x \
#   && echo "[INFO] Installing Dependancies..." \
#   && apk --update add $buildDeps pcre libtool python swig gawk \
#   && pip install --upgrade pip \
#   && pip install pymongo \
#   && pip install M2Crypto \
#   && pip install pycrypto \
#   && pip install dnslib \
#   && echo "[INFO] Installing ChopShop..." \
#   && cd /tmp \
#   && install/pynids.sh \
#   && install/htpy.sh \
#   && install/yaraprocessor.sh \
#   # && install/pylibemu.sh \
#   && install/chopshop.sh \
#   && echo "[INFO] Remove Build Dependancies..." \
#   && apk del --purge $buildDeps \
#   && rm -rf /tmp/* /root/.cache /var/cache/apk/*
#
# # Install pynids and remove install dir after to conserve space
# RUN \
#   cd /tmp/ && \
#   git clone --recursive git://github.com/MITRECND/pynids && \
#   cd pynids && \
#   python setup.py build && \
#   python setup.py install && \
#   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
# # Install htpy and remove install dir after to conserve space
# RUN \
#   cd /tmp/ && \
#   git clone --recursive git://github.com/MITRECND/htpy && \
#   cd htpy && \
#   python setup.py build && \
#   python setup.py install && \
#   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
# # Install yaraprocessor and remove install dir after to conserve space
# RUN \
#   cd /tmp/ && \
#   git clone git://github.com/MITRECND/yaraprocessor.git && \
#   cd yaraprocessor && \
#   python setup.py install && \
#   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
# # Install pylibemu and remove install dir after to conserve space
# RUN \
#   cd /tmp/ && \
#   git clone git://git.carnivore.it/libemu.git && \
#   cd libemu && autoreconf -v -i && \
#   ./configure --enable-python-bindings --prefix=/opt/libemu && \
#   make install && \
#   echo "/opt/libemu/lib/" >> /etc/ld.so.conf.d/libemu.conf && \
#   ldconfig && \
#   git clone git://github.com/buffer/pylibemu.git && \
#   cd pylibemu && \
#   echo /opt/libemu/lib > /etc/ld.so.conf.d/pylibemu.conf && \
#   python setup.py build && \
#   python setup.py install && \
#   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
# # Install ChopShop and remove install dir after to conserve space
# ADD chopshop.cfg /root/.chopshop.cfg
# RUN \
#   cd /tmp/ && \
#   git clone --recursive git://github.com/MITRECND/chopshop && \
#   cd chopshop && \
#   make && \
#   make install && \
#   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/pcap"]
WORKDIR /pcap

ENTRYPOINT ["/usr/local/bin/chopshop"]

CMD ["-h"]
