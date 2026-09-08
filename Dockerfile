FROM dpage/pgadmin4
USER root
RUN set -eux; \
    usermod -u 1000 pgadmin; \
    echo done
USER pgadmin
