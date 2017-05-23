FROM debian:stretch

# Setup demo environment variables
ENV HOME=/root \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768

# Install git, supervisor, VNC, & X11 packages
RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      bash \
      fluxbox \
      git \
      socat \
      supervisor \
      x11vnc \
      xterm \
      xvfb

# Clone noVNC from github
RUN set -ex; \
    git clone https://github.com/kanaka/noVNC.git /root/noVNC; \
    git clone https://github.com/kanaka/websockify /root/noVNC/utils/websockify; \
    rm -rf /root/noVNC/.git; \
    rm -rf /root/noVNC/utils/websockify/.git; \
    apt-get remove -y --purge git

# Modify the launch script 'ps -p'
RUN sed -i -- "s/ps -p/ps -o pid | grep/g" /root/noVNC/utils/launch.sh

COPY . /app

CMD ["/usr/bin/supervisord", "-c", "/app/supervisord.conf"]
EXPOSE 8080
