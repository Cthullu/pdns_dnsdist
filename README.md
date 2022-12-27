# cthullu/pdns_dnsdist

This repository contains the Dockerfile to build a small container image based on Alpine
Linux which provides PowerDNS dnsdist. This is one of the images whith the goal to provide
a container with minimal footprint.

There is a `Dockerfile` which creates an image based on an Alpine Linux point release (the
one which will be published at quay.io) and a separate `Dockerfile-edge` which uses the
Alpine Linux upstream repository `edge` as package base.

## Change starting with release 1.7.3-b1

Starting from release `1.7.3-b1` the image will no longer switch to the dnsdist system-user
and execute the PowerDNS dnsdist server unpriviledged. Instead, the server will be started
as root and the priviledges of PowerDNS dnsdist are dropped after parsing the configuration
and initializing the server process.

This also effects the exposed ports, which changed from `5353/tcp` and `5353/udp` to
`53/tcp` and `53/udp`.

## Get te image

The latest iamge can be pulled from quay.io:

    docker pull quay.io/cthullu/pdns_dnsdist
