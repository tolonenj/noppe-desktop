FROM debian:bookworm

COPY --chmod=500 ./install_desktop.sh /install_desktop.sh

RUN /install_desktop.sh
RUN rm /install_desktop.sh

COPY --chmod=500 ./init /init

EXPOSE 8787

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/init"]
