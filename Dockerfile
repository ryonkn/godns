# build container
FROM golang:1.10 as build
ADD . /go/src/godns
RUN go get github.com/BurntSushi/toml && \
    go get github.com/bradfitz/gomemcache/memcache && \
    go get github.com/hoisie/redis && \
    go get github.com/miekg/dns && \
    go get golang.org/x/net/publicsuffix
RUN CGO_ENABLED=0 go install godns

# runtime container
FROM scratch
COPY --from=build /go/bin/godns /godns
ADD ./godns.conf /godns.conf
ADD ./resolv.conf /resolv.conf
EXPOSE 53:53/udp
CMD ["/godns", "-c", "/godns.conf"]
