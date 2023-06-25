#build binary golang:1.20-alpine3.16
FROM golang:1.20-alpine as builder

# menginstall git + SSL ca certificates
# Git digunakan untuk mengambil dependency.
# Ca-certificates dibutuhkan untuk memanggil HTTPS endpoints.
RUN apk update && apk add --no-cache git ca-certificates tzdata && update-ca-certificates

WORKDIR $GOPATH/src/tutor/go
COPY . .

RUN echo $PWD && ls -la

# mengambil dependency.
# RUN go get -d -v
RUN go mod download
RUN go mod verify

#CMD go build
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -a -installsuffix cgo -o /go/bin/go .


# membuat binary
FROM alpine:3.16

RUN apk update

# Import dari builder.
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd

# Copy the executable.
COPY --from=builder /go/bin/go /go/bin/go
COPY --from=builder /go/src/tutor/go/config.json /go/bin/config.json

ENTRYPOINT ["/go/bin/go", "-conf", "/go/bin/config.json"]
