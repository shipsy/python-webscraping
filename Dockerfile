FROM ubuntu:16.04

RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository -y ppa:alex-p/tesseract-ocr
RUN apt-get update && apt-get install -y tesseract-ocr-all
WORKDIR /home/ubuntu
EXPOSE 8000
# Installing Splash
ENV DEBIAN_FRONTEND noninteractive
ENV PATH="/opt/qt59/5.9.1/gcc_64/bin:${PATH}"
COPY ./splash splash
RUN cp splash/dockerfiles/splash/provision.sh /tmp/provision.sh
RUN cp splash/dockerfiles/splash/qt-installer-noninteractive.qs /tmp/script.qs
RUN apt-get update
RUN apt-get install -y python3-pip

RUN /tmp/provision.sh \
    prepare_install \
    install_deps \
    install_qtwebkit_deps \
    install_official_qt \
    install_qtwebkit \
    install_pyqt5 \
    install_python_deps \
    install_flash \
    install_msfonts \
    install_extra_fonts \
    remove_builddeps \
    remove_extra && \
    rm /tmp/provision.sh
RUN cp splash/. /app -r
RUN pip3 install /app
ENV PYTHONPATH $PYTHONPATH:/app
VOLUME [ \
    "/etc/splash/proxy-profiles", \
    "/etc/splash/js-profiles", \
    "/etc/splash/filters", \
    "/etc/splash/lua_modules" \
    ]
RUN apt-get install -y g++
# RUN apt-get install -y gcc
RUN apt-get install -y python3-dateutil
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt 
RUN apt-get install -y python-opencv

RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN npm config set registry http://registry.npmjs.org/
RUN npm i -g pm2
RUN ln -s /usr/bin/nodejs /usr/bin/node

COPY . .
ENTRYPOINT ["./scr_main.sh"]
