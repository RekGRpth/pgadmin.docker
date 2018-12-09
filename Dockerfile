FROM rekgrpth/python

MAINTAINER RekGRpth

ADD entrypoint.sh /

ENV GROUP=pgadmin \
    HOME=/data \
    LANG=ru_RU.UTF-8 \
    PGADMIN_PORT=5050 \
    PGADMIN_SETUP_EMAIL=container@pgadmin.org \
    PGADMIN_SETUP_PASSWORD=Conta1ner \
    PGADMIN_VERSION=3.6 \
    PYTHONIOENCODING=UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=pgadmin

RUN addgroup -S "${GROUP}" \
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
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py2.py3-none-any.whl" \
    && pip install --no-cache-dir \
        uwsgi \
    && apk add --no-cache --virtual .pgadmin-rundeps \
        $( scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        ) \
        ca-certificates \
        postgresql-client \
        shadow \
        su-exec \
        tzdata \
    && apk del --no-cache .build-deps \
    && find -name "*.pyc" -delete \
    && find -name "*.pyo" -delete \
    && find -name "*.whl" -delete \
    && chmod +x /entrypoint.sh \
    && rm -rf /root/.cache

COPY config_local.py /usr/local/lib/python3.7/site-packages/pgadmin4/

VOLUME "${HOME}"

WORKDIR "${HOME}/app"

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "python", "pgAdmin4.py" ]
