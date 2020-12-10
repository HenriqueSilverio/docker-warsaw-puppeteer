FROM ubuntu:bionic-20200921

ARG DEBIAN_FRONTEND=noninteractive
ARG CHROME_VERSION=87
ARG XFCE_VERSION=4.12.4
ARG XFWM4_VERSION=4.12.5
ARG X11VNC_VERSION=0.9.13-3
ARG XVFB_VERSION=2:1.19.6
ARG NOVNC_VERSION=1:0.4
ARG OPENSSL_VERSION=1.1.1-1
ARG NODE_VERSION=14.15.1
ARG PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ARG PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

RUN apt-get update && apt-get install -y \
  libnss3-tools \
  zenity \
  libgtk2.0-0 \
  dbus-x11 \
  yad \
  libcurl4 \
  libdbus-1.3 \
  sudo gosu \
  libxss1 \
  lsb-release \
  wget \
  xdg-utils \
  net-tools \
  openssl=${OPENSSL_VERSION}* \
  xfce4=${XFCE_VERSION}* \
  xfwm4=${XFWM4_VERSION}* \
  x11vnc=${X11VNC_VERSION}* \
  xvfb=${XVFB_VERSION}* \
  novnc=${NOVNC_VERSION}* \
  chromium-browser=${CHROME_VERSION}* \
  xz-utils \
  unzip \
  curl \
  && dpkg -l | awk '{print "|" $2 "|" $3 "|"}' > /installed-packages.txt \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" \
  && tar -xJf "node-v${NODE_VERSION}-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-v${NODE_VERSION}-linux-x64.tar.xz"

RUN apt-get install -y vim less

ENV USER_UID=1000
ENV USER_GID=1000

ADD https://cloud.gastecnologia.com.br/cef/warsaw/install/GBPCEFwr64.deb /w.deb

RUN mkdir -p /var/run/dbus

COPY rootfs /

RUN groupadd -g $USER_GID user \
  && useradd -u $USER_UID -g $USER_GID -ms /bin/bash user \
  && chown -R user.user /home/user

WORKDIR /home/user

COPY --chown=user:user ["package.json", "package-lock.json", "./"]

RUN gosu user:user npm ci --only=production

COPY --chown=user:user src ./src

STOPSIGNAL SIGRTMIN+3

RUN systemctl enable xvfb \
  && systemctl enable xfwm \
  && systemctl enable vnc \
  && systemctl enable novnc \
  && systemctl enable chromium \
  && systemctl enable banner \
  && systemctl enable puppeteer \
  && echo OK

ENTRYPOINT ["/usr/local/bin/epoint.sh"]
