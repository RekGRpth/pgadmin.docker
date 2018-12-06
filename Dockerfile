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
    && apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache --virtual .pgadmin-build-deps \
        alpine-sdk \
        gettext-dev \
        libffi-dev \
        linux-headers \
        pcre-dev \
        postgresql-dev \
#        postgresql-client \
#        py3-psycopg2 \
#        python3 \
#        python3-dev \
#        shadow \
#        su-exec \
#        tzdata \
#    && pip install --upgrade pip \
    && pip install --no-cache-dir "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py2.py3-none-any.whl" \
    && pip install --no-cache-dir \
        uwsgi \
#    && (pipdate || true) \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
            | tr ',' '\n' \
            | sort -u \
            | grep -v libtcl \
            | grep -v libtk \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --no-cache --virtual .pgadmin-rundeps \
        $runDeps \
        postgresql-client \
        shadow \
        su-exec \
        tzdata \
    && apk del --no-cache .pgadmin-build-deps \
    && find -name "*.pyc" -delete \
    && find -name "*.pyo" -delete \
    && find -name "*.whl" -delete \
#    && ln -fs python3 /usr/bin/python \
#    && mkdir -p "${HOME}" "${HOME}/config" "${HOME}/storage" "${HOME}/log" "${HOME}/app" "${HOME}/sessions" \
#    && groupadd --system "${GROUP}" \
#    && useradd --system --gid "${GROUP}" --home-dir "${HOME}" --shell /sbin/nologin "${USER}" \
#    && chown -R "${USER}":"${GROUP}" "${HOME}" \
    && chmod +x /entrypoint.sh
#    && usermod --home "${HOME}" "${USER}"

COPY config_local.py /usr/local/lib/python3.7/site-packages/pgadmin4/

VOLUME  "${HOME}"

WORKDIR "${HOME}/app"

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "python", "pgAdmin4.py" ]
