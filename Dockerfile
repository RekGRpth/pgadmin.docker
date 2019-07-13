FROM rekgrpth/gost
ENV GROUP=uwsgi \
    PGADMIN_PORT=5050 \
    PGADMIN_SETUP_EMAIL=container@pgadmin.org \
    PGADMIN_SETUP_PASSWORD=Conta1ner \
    PGADMIN_VERSION=4.10 \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH=/usr/local/lib/python3.7/site-packages/pgadmin4:/usr/local/lib/python3.7:/usr/local/lib/python3.7/lib-dynload:/usr/local/lib/python3.7/site-packages \
    USER=uwsgi
COPY config_local.py /usr/local/lib/python3.7/site-packages/pgadmin4/
WORKDIR "${HOME}/app"
ADD entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "uwsgi", "--ini", "/data/pgadmin.ini" ]
RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}" \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        gettext-dev \
        libffi-dev \
        linux-headers \
        make \
        musl-dev \
        pcre-dev \
        postgresql-dev \
        python3-dev \
    && ln -s pip3 /usr/bin/pip \
    && ln -s pydoc3 /usr/bin/pydoc \
    && ln -s python3 /usr/bin/python \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --prefix /usr/local \
        uwsgi \
    && pip install --no-cache-dir --prefix /usr/local "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py2.py3-none-any.whl" \
    && apk add --no-cache --virtual .pgadmin-rundeps \
        postgresql-client \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }') \
    && apk del --no-cache .build-deps \
    && chmod +x /entrypoint.sh
