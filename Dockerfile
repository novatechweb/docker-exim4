#
# exim4 Docker container
#
# Version 0.1

FROM debian:8
MAINTAINER Joseph Lutz <Joseph.Lutz@novatechweb.com>

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        exim4-daemon-heavy \
        openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && tar -cavf /demian.default.exim4.config.tar.gz -C /etc exim4 \
    && rm -rf /etc/exim4 /var/spool/exim4 /var/mail /var/log/exim4

# copy over files
COPY docker-entrypoint.sh /

# specify which network ports will be used
EXPOSE 25 465 587

# specify the volumes directly related to this image
VOLUME ["/etc/exim4", "/var/spool/exim4", "/var/mail/", "/var/log/exim4"]

# start the entrypoint script
WORKDIR /var/spool/exim4
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["exim4"]
