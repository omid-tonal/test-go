# build stage
FROM golang:alpine AS builder
ENV GO111MODULE=on
ENV GOPROXY=direct
ENV GOSUMDB=off
# add credentials on build
ARG GITHUB_TOKEN
ARG BRANCH
ARG COMMIT
RUN apk --no-cache add git gcc musl-dev \
    && git config --global url."https://${GITHUB_TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/" \
    && git clone --depth 1 --single-branch -b ${BRANCH}  https://github.com/omid-tonal/test-go.git
WORKDIR ${REPO}/hello_service
RUN git checkout ${COMMIT}
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /hello_service main.go

# final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates

COPY --from=builder /hello_service ./

EXPOSE  8092

ENTRYPOINT ["./hello_service"]
