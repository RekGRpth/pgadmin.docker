FROM alpine

MAINTAINER RekGRpth

ADD entrypoint.sh /

ENV HOME=/data \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=pgadmin \
    GROUP=pgadmin \
    PYTHONIOENCODING=UTF-8 \
    PGADMIN_PORT=5050 \
    PGADMIN_SETUP_EMAIL=container@pgadmin.org \
    PGADMIN_SETUP_PASSWORD=Conta1ner \
    PGADMIN_VERSION=3.6

RUN apk add --no-cache \
        alpine-sdk \
        libffi-dev \
        linux-headers \
        postgresql-dev \
        postgresql-client \
        py3-psycopg2 \
        python3 \
        python3-dev \
        shadow \
        su-exec \
        tzdata \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py2.py3-none-any.whl" \
    && pip3 install --no-cache-dir \
        pipdate \
    && (pipdate || true) \
    && apk del \
        alpine-sdk \
        libffi-dev \
        linux-headers \
        postgresql-dev \
        python3-dev \
    && find -name "*.pyc" -delete \
    && ln -fs python3 /usr/bin/python \
    && mkdir -p "${HOME}" "${HOME}/config" "${HOME}/storage" "${HOME}/log" "${HOME}/app" "${HOME}/sessions" \
    && groupadd --system "${GROUP}" \
    && useradd --system --gid "${GROUP}" --home-dir "${HOME}" --shell /sbin/nologin "${USER}" \
    && chown -R "${USER}":"${GROUP}" "${HOME}" \
    && chmod +x /entrypoint.sh \
    && usermod --home "${HOME}" "${USER}"

COPY config_local.py /usr/lib/python3.6/site-packages/pgadmin4/

VOLUME  ${HOME}

WORKDIR ${HOME}/app

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "python", "pgAdmin4.py" ]
