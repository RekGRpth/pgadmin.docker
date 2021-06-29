FROM rekgrpth/gost
ADD docker_entrypoint.sh /usr/local/bin/
ENV PYTHON_VERSION 3.8
COPY config_local.py /usr/local/lib/python${PYTHON_VERSION}/site-packages/pgadmin4/
ENV GROUP=pgadmin \
    PGADMIN_PORT=5050 \
    PGADMIN_SETUP_EMAIL=container@pgadmin.org \
    PGADMIN_SETUP_PASSWORD=Conta1ner \
    PGADMIN_VERSION=5.3 \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH=/usr/local/lib/python${PYTHON_VERSION}/site-packages/pgadmin4:/usr/local/lib/python${PYTHON_VERSION}:/usr/local/lib/python${PYTHON_VERSION}/lib-dynload:/usr/local/lib/python${PYTHON_VERSION}/site-packages \
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
        krb5-dev \
        libffi-dev \
        linux-headers \
        make \
        musl-dev \
        pcre2-dev \
        pcre-dev \
        postgresql-dev \
        py3-pip \
        python3-dev \
        rust \
    ; \
    pip install --no-cache-dir --ignore-installed --prefix /usr/local \
        python-pcre \
        setuptools \
        uwsgi \
    ; \
    pip install --no-cache-dir --ignore-installed --prefix /usr/local "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${PGADMIN_VERSION}/pip/pgadmin4-${PGADMIN_VERSION}-py3-none-any.whl"; \
#    pip install --no-cache-dir --ignore-installed --prefix /usr/local "https://ftp.postgresql.org/pub/pgadmin/pgadmin4/snapshots/$(date +"%Y-%m-%d")/pgadmin4-${PGADMIN_VERSION}-py3-none-any.whl"; \
    (strip /usr/local/bin/* /usr/local/lib/*.so || true); \
    apk add --no-cache --virtual .pgadmin-rundeps \
        postgresql-client \
        su-exec \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test ! -e "/usr/local/lib/$lib" && echo "so:$lib"; done) \
    ; \
    apk del --no-cache .build-deps; \
    rm -rf /usr/local/lib/python${PYTHON_VERSION}/site-packages/pgadmin4/docs /usr/src /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find / -name "*.pyc" -delete; \
    chmod +x /usr/local/bin/docker_entrypoint.sh
