# Set base base image for following commands
FROM alpine:3.17.0

# Set environment variables
ENV LC_ALL C.UTF-8

# Update all packages
# Install BIND 9
RUN apk -U --no-cache upgrade                           \
    && apk add --no-cache dnsdist                       \
    && rm -rf /var/cache/apk/*

# Create custom configuration directory
RUN mkdir -p /etc/dnsdist/conf.d

# Copy default configuration
COPY ./conf/dnsdist.conf /etc/dnsdist/dnsdist.conf

# Adapt permissions
RUN chown -R dnsdist:dnsdist /etc/dnsdist               \
    && chmod 755 /etc/dnsdist /etc/dnsdist/conf.d       \
    && chmod 644 /etc/dnsdist/dnsdist.conf

# Create mount points with the specified names and mark them as holding externally mounted volumes
VOLUME [ "/etc/dnsdist/conf.d" ]

# Expose dnsport 53/tcp and 53/udp
# Expose console port 5199/tcp
# Expose webserver port 8083/tcp
EXPOSE 53/tcp 53/udp 5199/tcp 8083/tcp

# Change the default directory
WORKDIR /etc/dnsdist

# Specify a entrypoint. CMD parsed will be apended
ENTRYPOINT [ "/usr/bin/dnsdist", "--config", "/etc/dnsdist/dnsdist.conf", "--uid", "dnsdist", "--gid", "dnsdist" ]
CMD [ "--disable-syslog", "--supervised" ]
