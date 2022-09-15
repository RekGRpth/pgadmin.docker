FROM ghcr.io/rekgrpth/gost.docker:latest
ADD bin /usr/local/bin
ARG DOCKER_PYTHON_VERSION=3.10
ENV GROUP=pgadmin \
    PGADMIN_SETUP_EMAIL=container@pgadmin.org \
    PGADMIN_SETUP_PASSWORD=Conta1ner \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH="/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages/pgadmin4:/usr/local/lib/python$DOCKER_PYTHON_VERSION:/usr/local/lib/python$DOCKER_PYTHON_VERSION/lib-dynload:/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages" \
    USER=pgadmin
RUN set -eux; \
    chmod +x /usr/local/bin/*.sh; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    addgroup -S "$GROUP"; \
    adduser -S -D -G "$GROUP" -H -h "$HOME" -s /sbin/nologin "$USER"; \
    apk add --no-cache --virtual .build \
        g++ \
        gcc \
        git \
        libffi-dev \
        libjpeg-turbo-dev \
        libpq-dev \
        linux-headers \
        make \
        musl-dev \
        openjpeg-dev \
        pcre2-dev \
        pcre-dev \
        py3-alembic \
        py3-authlib \
        py3-bcrypt \
        py3-blinker \
        py3-brotli \
        py3-certifi \
        py3-chardet \
        py3-cryptography \
        py3-dateutil \
        py3-dnspython \
        py3-email-validator \
        py3-flask-babel \
        py3-flask-login \
        py3-flask-wtf \
        py3-greenlet \
        py3-idna \
        py3-ldap3 \
        py3-mako \
        py3-otp \
        py3-paramiko \
        py3-passlib \
        py3-pillow \
        py3-pip \
        py3-psutil \
        py3-psycopg2 \
        py3-pynacl \
        py3-qrcode \
        py3-requests \
        py3-setuptools \
        py3-simplejson \
        py3-sqlalchemy \
        py3-sqlparse \
        py3-tz \
        py3-urllib3 \
        py3-werkzeug \
        py3-wheel \
        py3-wtforms \
        python3-dev \
        zlib-dev \
    ; \
    cd "$HOME"; \
    pip install --no-cache-dir --ignore-installed --prefix /usr/local \
        Flask-Login \
    ; \
    pip install --no-cache-dir --prefix /usr/local \
        pgadmin4 \
    ; \
    cd /; \
    apk add --no-cache --virtual .pgadmin \
        postgresql-client \
        py3-alembic \
        py3-authlib \
        py3-bcrypt \
        py3-blinker \
        py3-brotli \
        py3-certifi \
        py3-chardet \
        py3-cryptography \
        py3-dateutil \
        py3-dnspython \
        py3-email-validator \
        py3-flask-babel \
        py3-flask-login \
        py3-flask-wtf \
        py3-greenlet \
        py3-idna \
        py3-ldap3 \
        py3-mako \
        py3-otp \
        py3-paramiko \
        py3-passlib \
        py3-pillow \
        py3-psutil \
        py3-psycopg2 \
        py3-pynacl \
        py3-qrcode \
        py3-requests \
        py3-setuptools \
        py3-simplejson \
        py3-sqlalchemy \
        py3-sqlparse \
        py3-tz \
        py3-urllib3 \
        py3-werkzeug \
        py3-wtforms \
        uwsgi-python3 \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | grep -v "^$" | grep -v -e libcrypto | sort -u | while read -r lib; do test -z "$(find /usr/local/lib -name "$lib")" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    rm -rf "/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages/pgadmin4/docs"; \
    find /usr -type f -name "*.la" -delete; \
    find /usr -type f -name "*.pyc" -delete; \
    mkdir -p "$HOME"; \
    chown -R "$USER":"$GROUP" "$HOME"; \
    echo done
ADD config_local.py "/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages/pgadmin4/"
