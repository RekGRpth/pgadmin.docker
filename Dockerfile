FROM rekgrpth/uwsgi
ADD entrypoint.sh /
COPY config_local.py /usr/local/lib/python3.7/site-packages/pgadmin4/
ENV PGADMIN_PORT=5050 \
    PGADMIN_SETUP_EMAIL=container@pgadmin.org \
    PGADMIN_SETUP_PASSWORD=Conta1ner \
    PGADMIN_VERSION=4.10 \
    PYTHONPATH=/usr/local/lib/python3.7/site-packages/pgadmin4:/usr/local/lib/python3.7:/usr/local/lib/python3.7/lib-dynload:/usr/local/lib/python3.7/site-packages
VOLUME "${HOME}"
RUN set -ex \
    && apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        gettext-dev \
        libffi-dev \
        linux-headers \
        make \
        musl-dev \
        pcre-dev \
        postgresql-dev \
        py3-cffi \
        py3-cparser \
        py3-setuptools \
        python3-dev \
    && apk add --no-cache \
        py3-babel \
        py3-bcrypt \
        py3-blinker \
        py3-dateutil \
        py3-flask \
        py3-flask-babel \
        py3-flask-login \
        py3-flask-wtf \
        py3-mako \
        py3-paramiko \
        py3-passlib \
        py3-psutil \
        py3-psycopg2 \
        py3-simplejson \
        py3-sqlalchemy \
        py3-sqlparse \
        py3-tz \
    && pip install --no-cache-dir --prefix /usr/local "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py2.py3-none-any.whl" \
    && apk add --no-cache --virtual .pgadmin-rundeps \
        postgresql-client \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }') \
    && apk del --no-cache .build-deps \
    && rm -rf /usr/local/lib/python3.7/site-packages/pgadmin4/docs \
    && chmod +x /entrypoint.sh
