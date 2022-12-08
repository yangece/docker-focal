ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive 

#RUN  echo "52.22.146.88 index.docker.io" >> /etc/hosts \
RUN apt-get update \
  && apt-get install -y -qq --no-install-recommends \
       curl \
       apt-utils \
       lsb-release \
       apt-transport-https \
       software-properties-common \
       ca-certificates \
  \
  && apt-get install -y -qq \
     iputils-ping \
     build-essential 

RUN apt-get install -y -qq --no-install-recommends \
     vim \
     git \
     sudo \
     xterm \
     xauth \
     xorg \
     dbus-x11 \
     xfonts-100dpi \
     xfonts-75dpi \
     xfonts-cyrillic


#RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
#  && apt-key fingerprint 0EBFCD88 \
#  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
#  && apt-get update && apt-get -y install -qq --no-install-recommends docker-ce \

RUN apt-get install -y docker.io \
  && apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* \
  \
  && mkdir /tmp/.X11-unix \
  && chmod 1777 /tmp/.X11-unix \
  && chown root:root /tmp/.X11-unix/

RUN apt-get update \
  && apt-get install -y \
  apt-utils \
  file \
  wget \
  cmake \
  bash-completion \
  python3-software-properties \
  python3 \
  python3-pip \
  python3-dev \
  python3-tk \
  python3-venv \
  python3-numpy \
  sqlite3 \
  libproj-dev \
  libjsoncpp-dev \
  libgeos-dev \
  libproj-dev \
  libxml2-dev \
  libpq-dev \
  libnetcdf-dev \
  libpoppler-dev \
  libcurl4-gnutls-dev \
  libhdf4-alt-dev \
  libhdf5-serial-dev \
  libgeographic-dev \
  libfftw3-dev \
  libtiff5-dev \
  libgmp3-dev \
  libmpfr-dev \
  libxerces-c-dev \
  libmpfr-dev \
  libmuparser-dev \
  libboost-date-time-dev \
  libboost-system-dev \
  libboost-filesystem-dev \
  libgsl-dev \
  libgeos++-dev \
  libpng-dev \
  sudo \
  xvfb \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/*

# Install image processing related packages
#RUN pip3 --no-cache-dir install scipy 
RUN pip3 --no-cache-dir install -U scikit-learn \
  && pip3 --no-cache-dir install scikit-image \
  && pip3 --no-cache-dir install opencv-python \
  && pip3 install tifffile 


# Install latest su-exec
RUN  set -ex; \
     \
     curl -o /usr/local/bin/su-exec.c https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c; \
     \
     fetch_deps='gcc libc-dev'; \
     apt-get update; \
     apt-get install -y --no-install-recommends $fetch_deps; \
     rm -rf /var/lib/apt/lists/*; \
     gcc -Wall \
         /usr/local/bin/su-exec.c -o/usr/local/bin/su-exec; \
     chown root:root /usr/local/bin/su-exec; \
     chmod 0755 /usr/local/bin/su-exec; \
     rm /usr/local/bin/su-exec.c; \
     \
     apt-get purge -y --auto-remove $fetch_deps

# Enable the dynamic setting of the user
COPY provision_container.sh /usr/local/bin/
RUN chmod 1777 /usr/local/bin/provision_container.sh

ENTRYPOINT ["/usr/local/bin/provision_container.sh"]
CMD ["/bin/bash"]

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.vendor="HITSZ AI Team" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="1.0.0-rc1"
