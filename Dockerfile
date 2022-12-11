# Set base base image for following commands
FROM alpine:3.17.0

# Set environment variables
ENV LC_ALL C.UTF-8

# Update all packages
# Install BIND 9
RUN apk -U --no-cache upgrade                                                   \
    && apk add --no-cache dnsdist                                       \
    && rm -rf /var/cache/apk/*

# Create custom configuration directory
RUN mkdir -p /etc/dnsdist/conf.d

# Copy default configuration
COPY ./conf/dnsdist.conf /etc/dnsdist/dnsdist.conf

# Adapt permissions
RUN chown -R dnsdist:dnsdist /etc/dnsdist \
    && chmod 755 /etc/dnsdist /etc/dnsdist/conf.d   \
    && chmod 644 /etc/dnsdist/dnsdist.conf

# Create mount points with the specified names and mark them as holding externally mounted volumes
VOLUME [ "/etc/dnsdist/conf.d" ]

# Change to user dnsdist
USER dnsdist

# Expose custom dnsport 5353, as we can't access port 53 as a non priviledged user
# Expose console port 5199/tcp
# Expose webserver port 8083/tcp
EXPOSE 5353/tcp 5353/udp 5199/tcp 8083/tcp

# Change the default directory
WORKDIR /etc/dnsdist

# Specify a entrypoint. CMD parsed will be apended
ENTRYPOINT [ "/usr/bin/dnsdist", "--config", "/etc/dnsdist/dnsdist.conf" ]
CMD [ "--disable-syslog", "--supervised" ]
