FROM rekgrpth/gost
ADD entrypoint.sh /
COPY config_local.py /usr/local/lib/python3.8/site-packages/pgadmin4/
ENV GROUP=pgadmin \
    PGADMIN_PORT=5050 \
    PGADMIN_SETUP_EMAIL=container@pgadmin.org \
    PGADMIN_SETUP_PASSWORD=Conta1ner \
    PGADMIN_VERSION=4.16 \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH=/usr/local/lib/python3.8/site-packages/pgadmin4:/usr/local/lib/python3.8:/usr/local/lib/python3.8/lib-dynload:/usr/local/lib/python3.8/site-packages \
    USER=pgadmin
VOLUME "${HOME}"
RUN set -ex \
    && addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}" \
    && ln -s pip3 /usr/bin/pip \
    && ln -s pydoc3 /usr/bin/pydoc \
    && ln -s python3 /usr/bin/python \
    && ln -s python3-config /usr/bin/python-config \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        gettext-dev \
        libffi-dev \
        linux-headers \
        make \
        musl-dev \
        pcre2-dev \
        pcre-dev \
        postgresql-dev \
        python3-dev \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --prefix /usr/local \
        python-pcre \
        uwsgi \
    && pip install --no-cache-dir --prefix /usr/local "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py2.py3-none-any.whl" \
    && (strip /usr/local/bin/* /usr/local/lib/*.so || true) \
    && apk add --no-cache --virtual .pgadmin-rundeps \
        postgresql-client \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }') \
    && apk del --no-cache .build-deps \
    && rm -rf /usr/local/lib/python3.8/site-packages/pgadmin4/docs \
    && chmod +x /entrypoint.sh
