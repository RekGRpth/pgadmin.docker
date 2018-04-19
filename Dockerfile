FROM alpine

MAINTAINER RekGRpth

ENV PGADMIN_VERSION=3.0

RUN apk add --no-cache \
        alpine-sdk \
        postgresql \
        postgresql-dev \
        py3-argparse \
        py3-babel \
        py3-click \
        py3-crypto \
        py3-dateutil \
        py3-flask \
        py3-itsdangerous \
        py3-jinja2 \
        py3-mako \
        py3-markupsafe \
        py3-pbr \
        py3-psycopg2 \
        py3-simplejson \
        py3-six \
        py3-sqlalchemy \
        py3-sqlparse \
        py3-tz \
        py3-werkzeug \
        py3-wtforms \
        python3 \
        python3-dev \
        shadow \
        su-exec \
        tzdata \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
        py3-blinker \
    && cp /usr/bin/psql /usr/bin/pg_dump /usr/bin/pg_dumpall /usr/bin/pg_restore /usr/local/bin/ \
    && pip3 install --no-cache-dir --upgrade pip \
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
