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
#        uwsgi-python3 \
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
    PGADMIN_PORT=5050 \
    PGADMIN_SETUP_EMAIL=container@pgadmin.org \
    PGADMIN_SETUP_PASSWORD=Conta1ner

RUN mkdir -p "${HOME}" \
    && groupadd --system "${GROUP}" \
    && useradd --system --gid "${GROUP}" --home-dir "${HOME}" --shell /sbin/nologin "${USER}" \
    && chown -R "${USER}":"${GROUP}" "${HOME}"

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh && usermod --home "${HOME}" "${USER}"
ENTRYPOINT ["/entrypoint.sh"]

VOLUME  ${HOME}
WORKDIR ${HOME}/app

CMD [ "python3", "pgAdmin4.py" ]
