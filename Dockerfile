FROM alpine

MAINTAINER RekGRpth

ENV PGADMIN_VERSION=2.1

RUN apk add --no-cache \
        alpine-sdk \
        postgresql \
        postgresql-dev \
        py3-psycopg2 \
        python3 \
        python3-dev \
        shadow \
        su-exec \
        tzdata \
    && cp /usr/bin/psql /usr/bin/pg_dump /usr/bin/pg_dumpall /usr/bin/pg_restore /usr/local/bin/ \
    && pip3 install --no-cache-dir "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py2.py3-none-any.whl" \
    && apk del \
        alpine-sdk \
        postgresql \
        postgresql-dev \
        python3-dev \
    && find -name "*.pyc" -delete

ENV HOME=/data \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=pgadmin \
    GROUP=pgadmin \
    PYTHONIOENCODING=UTF-8 \
    PGADMIN_PORT=5050 \
    PGADMIN_SETUP_EMAIL=container@pgadmin.org \
    PGADMIN_SETUP_PASSWORD=Conta1ner

RUN mkdir -p "${HOME}" "${HOME}/config" "${HOME}/storage" "${HOME}/log" "${HOME}/app" "${HOME}/sessions" \
    && groupadd --system "${GROUP}" \
    && useradd --system --gid "${GROUP}" --home-dir "${HOME}" --shell /sbin/nologin "${USER}" \
    && chown -R "${USER}":"${GROUP}" "${HOME}"

COPY config_local.py /usr/lib/python3.6/site-packages/pgadmin4/

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh && usermod --home "${HOME}" "${USER}"
ENTRYPOINT ["/entrypoint.sh"]

VOLUME  ${HOME}
WORKDIR ${HOME}/app

CMD [ "python3", "pgAdmin4.py" ]
