ARG BUILD_FROM=alpine:latest

FROM $BUILD_FROM

RUN apk --update --no-cache add bash nfs-utils && \
                                                  \
    # remove the default config files
    rm -v /etc/idmapd.conf /etc/exports

# http://wiki.linux-nfs.org/wiki/index.php/Nfsv4_configuration
RUN mkdir -p /var/lib/nfs/rpc_pipefs                                                     && \
    mkdir -p /var/lib/nfs/v4recovery                                                     && \
    echo "rpc_pipefs  /var/lib/nfs/rpc_pipefs  rpc_pipefs  defaults  0  0" >> /etc/fstab && \
    echo "nfsd        /proc/fs/nfsd            nfsd        defaults  0  0" >> /etc/fstab

EXPOSE 2049

RUN apk --update add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev git bash;
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git; \
 cd s3fs-fuse; \
 ./autogen.sh; \
 ./configure --prefix=/usr; \
 make; \
 make install; \
 rm -rf /var/cache/apk/*;

# setup entrypoint
COPY ./entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]





















