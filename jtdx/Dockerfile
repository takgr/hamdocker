ARG VERSION=latest
#JTDX Build Script

FROM debian:sid-slim as jtbase
MAINTAINER m0khr.uk+docker@gmail.com
ENV DEBIAN_FRONTEND=noninteractive
RUN export DEBIAN_FRONTEND=noninteractive && ln -fs /usr/share/zoneinfo/posix/UTC /etc/localtime
ENV TZ=Europe/London
ENV LANG en_US.UTF-8 
RUN /bin/sh -c echo $TZ > /etc/timezone && apt-get update && apt-get upgrade -y && apt-get install -y tzdata locales && rm /etc/localtime && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata && date >> ~/buildtime 
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    update-locale LANG=en_GB.UTF-8
    
FROM jtbase as jtbuilder
MAINTAINER m0khr.uk+docker@gmail.com
ENV DEBIAN_FRONTEND=noninteractive
RUN export DEBIAN_FRONTEND=noninteractive && ln -fs /usr/share/zoneinfo/posix/UTC /etc/localtime && mkdir /jtdx-src/
ENV TZ=Europe/London
COPY buildapps.sh /jtdx-src/  
RUN /bin/bash /jtdx-src/buildapps.sh

##Build runtime
FROM jtbase as jtruntime
MAINTAINER m0khr.uk+docker@gmail.com
ENV DEBIAN_FRONTEND=noninteractive
RUN export DEBIAN_FRONTEND=noninteractive && ln -fs /usr/share/zoneinfo/posix/UTC /etc/localtime
ENV TZ=Europe/London
RUN /bin/sh -c echo $TZ > /etc/timezone \
&& cat ~/buildtime \
&& mkdir -p /run/systemd \
&& echo 'docker' > /run/systemd/container \
&& apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y \
    hicolor-icon-theme \
    libqt5multimedia5-plugins \ 
    libcanberra-gtk* \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	libpulse0 \
	libv4l-0 \
	libfftw3-3 \
	libqt5printsupport5 \
	libqt5multimedia5 \
	libqt5sql5 \
	libqt5serialport5 \
	libqt5websockets5 \
	locales \
	libboost-log1.74.0 \
	libgfortran5 \
	libusb-1.0-0 \
	libpulse0 \
	fonts-symbola \
	alsa-utils \
	pulseaudio \
        libportaudio2 \
	x11vnc \
        xvfb \
        fluxbox \
&& mkdir /jtdx/ /hamlib//
ENV LC_ALL=C
ENV DISPLAY :20
EXPOSE 5920
WORKDIR /
COPY --from=jtbuilder /jtdx/ /jtdx/
COPY --from=jtbuilder /hamlib/ /hamlib/
COPY jtdx.sh /jtdx/jtdx.sh
CMD ["/jtdx/jtdx.sh"]

#Run me like this
# docker run -it --rm \
# --name jtdx \
# --device /dev/snd:/dev/snd \
# --device /dev/dri \
# --device=/dev/ttyUSB0 \
# -e DISPLAY=unix:0 \
# -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
# -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
# -v ~/.config/pulse/cookie:/root/.config/pulse/cookie \
# -v volume/.local/share/JTDX:/root/.local/share/JTDX
# -v ~/volume/.config:/root/.config \
# -v /dev/shm:/dev/shm \
# -v /tmp/.X11-unix:/tmp/.X11-unix \
# -v /run/dbus/:/run/dbus/ \
# -v /dev/shm:/dev/shm \
# --group-add $(getent group audio | cut -d: -f3) \
# hakankoseoglu/jtdx:latest
