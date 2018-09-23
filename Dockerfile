FROM alpine

MAINTAINER RekGRpth

ADD entrypoint.sh /

ENV GROUP=pgadmin \
    HOME=/data \
    LANG=ru_RU.UTF-8 \
    PGADMIN_PORT=5050 \
    PGADMIN_SETUP_EMAIL=container@pgadmin.org \
    PGADMIN_SETUP_PASSWORD=Conta1ner \
    PGADMIN_VERSION=3.3 \
    PYTHONIOENCODING=UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=pgadmin

RUN addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" ${USER} \
    && apk add --no-cache \
        shadow \
        su-exec \
        tzdata \
    && apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        coreutils \
        dpkg-dev dpkg \
        expat-dev \
        findutils \
        freetype-dev \
        gcc \
        gdbm-dev \
        git \
        jpeg-dev \
        libc-dev \
        libffi-dev \
        libnsl-dev \
        libressl-dev \
        libtirpc-dev \
        linux-headers \
        make \
        ncurses-dev \
        pax-utils \
        postgresql-dev \
        readline-dev \
        sqlite-dev \
        tcl-dev \
        tk \
        tk-dev \
        util-linux-dev \
        xz-dev \
        zlib-dev \
    && mkdir -p /usr/src \
    && git clone --progress --recursive https://github.com/python/cpython.git /usr/src/python \
    && cd /usr/src/python \
    && ./configure \
        --enable-loadable-sqlite-extensions \
        --enable-shared \
        --with-ensurepip=upgrade \
        --with-system-expat \
        --with-system-ffi \
    && make -j "$(nproc)" \
    && make install \
    && cd /usr/local/bin \
    && ln -s idle3 idle \
    && ln -s pip3 pip \
    && ln -s pydoc3 pydoc \
    && ln -s python3 python \
    && ln -s python3-config python-config \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir \
        pipdate \
    && pip install --no-cache-dir "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py2.py3-none-any.whl" \
    && (pipdate || true) \
    && pip install --no-cache-dir \
        ipython \
    && find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        | xargs -rt apk add --no-cache --virtual .python-rundeps \
    && apk del .build-deps \
    && find /usr/local -depth \
        \( \
            \( -type d -a \( -name test -o -name tests \) \) \
        \) -exec rm -rf '{}' + \
    && cd / \
    && rm -rf /usr/src /usr/local/include \
    && find -name "*.pyc" -delete \
    && find -name "*.pyo" -delete \
    && find -name "*.whl" -delete \
    && chmod +x /entrypoint.sh

COPY config_local.py /usr/local/lib/python3.8/site-packages/pgadmin4/

VOLUME  ${HOME}

WORKDIR ${HOME}/app

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "python", "pgAdmin4.py" ]
