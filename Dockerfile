FROM rekgrpth/gost
ADD config_local.py "${HOME}/src/"
ADD docker_entrypoint.sh /usr/local/bin/
ARG PGADMIN_VERSION=5.5
ARG PYTHON_VERSION=3.8
ENV GROUP=pgadmin \
    PGADMIN_PORT=5050 \
    PGADMIN_SETUP_EMAIL=container@pgadmin.org \
    PGADMIN_SETUP_PASSWORD=Conta1ner \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH="/usr/local/lib/python${PYTHON_VERSION}/site-packages/pgadmin4:/usr/local/lib/python${PYTHON_VERSION}:/usr/local/lib/python${PYTHON_VERSION}/lib-dynload:/usr/local/lib/python${PYTHON_VERSION}/site-packages" \
    USER=pgadmin
VOLUME "${HOME}"
RUN set -eux; \
    addgroup -S "${GROUP}"; \
    adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}"; \
    ln -s pip3 /usr/bin/pip; \
    ln -s pydoc3 /usr/bin/pydoc; \
    ln -s python3 /usr/bin/python; \
    ln -s python3-config /usr/bin/python-config; \
    apk add --no-cache --virtual .build-deps \
        cargo \
        g++ \
        gcc \
        gettext-dev \
        git \
        krb5-dev \
        libffi-dev \
        linux-headers \
        make \
        musl-dev \
        pcre2-dev \
        pcre-dev \
        postgresql-dev \
        py3-pip \
        py3-wheel \
        python3-dev \
        rust \
    ; \
    cd "${HOME}/src"; \
    pip install --no-cache-dir --ignore-installed --prefix /usr/local \
        python-pcre \
        setuptools \
        uwsgi \
    ; \
    pip install --no-cache-dir --ignore-installed --prefix /usr/local "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py3-none-any.whl"; \
#    pip install --no-cache-dir --ignore-installed --prefix /usr/local "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/snapshots/$(date +"%Y-%m-%d")/pgadmin4-${PGADMIN_VERSION}-py3-none-any.whl"; \
    cp -rf config_local.py "/usr/local/lib/python${PYTHON_VERSION}/site-packages/pgadmin4/"; \
    cd "${HOME}"; \
    apk add --no-cache --virtual .pgadmin-rundeps \
        postgresql-client \
        su-exec \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test ! -e "/usr/local/lib/$lib" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build-deps; \
    find / -type f -name "*.pyc" -delete; \
    find / -type f -name "*.a" -delete; \
    find / -type f -name "*.la" -delete; \
    rm -rf "/usr/local/lib/python${PYTHON_VERSION}/site-packages/pgadmin4/docs" "${HOME}" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    chmod +x /usr/local/bin/docker_entrypoint.sh; \
    echo done
