FROM ghcr.io/rekgrpth/gost.docker
ADD config_local.py "${HOME}/src/"
ADD docker_entrypoint.sh /usr/local/bin/
ARG PGADMIN_VERSION=6.3
ARG PYTHON_VERSION=3.9
ENV GROUP=pgadmin \
    PGADMIN_PORT=5050 \
    PGADMIN_SETUP_EMAIL=container@pgadmin.org \
    PGADMIN_SETUP_PASSWORD=Conta1ner \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH="/usr/local/lib/python${PYTHON_VERSION}/site-packages/pgadmin4:/usr/local/lib/python${PYTHON_VERSION}:/usr/local/lib/python${PYTHON_VERSION}/lib-dynload:/usr/local/lib/python${PYTHON_VERSION}/site-packages" \
    USER=pgadmin
RUN set -eux; \
    addgroup -S "${GROUP}"; \
    adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}"; \
    ln -s pip3 /usr/bin/pip; \
    ln -s pydoc3 /usr/bin/pydoc; \
    ln -s python3 /usr/bin/python; \
    ln -s python3-config /usr/bin/python-config; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    apk add --no-cache --virtual .build-deps \
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
        py3-wheel \
        py3-wtforms \
        python3-dev \
        zlib-dev \
    ; \
    cd "${HOME}"; \
    pip install --no-cache-dir --prefix /usr/local "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py3-none-any.whl"; \
#    pip install --no-cache-dir --ignore-installed --prefix /usr/local "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/snapshots/$(date +"%Y-%m-%d")/pgadmin4-${PGADMIN_VERSION}-py3-none-any.whl"; \
    cp -rf "${HOME}/src/config_local.py" "/usr/local/lib/python${PYTHON_VERSION}/site-packages/pgadmin4/"; \
    cd /; \
    apk add --no-cache --virtual .pgadmin-rundeps \
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
        py3-wtforms \
        su-exec \
        uwsgi-python3 \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test ! -e "/usr/local/lib/$lib" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build-deps; \
    find /usr -type f -name "*.pyc" -delete; \
    find /usr -type f -name "*.a" -delete; \
    find /usr -type f -name "*.la" -delete; \
    rm -rf "/usr/local/lib/python${PYTHON_VERSION}/site-packages/pgadmin4/docs" "${HOME}" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    chmod +x /usr/local/bin/docker_entrypoint.sh; \
    echo done
