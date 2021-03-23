# build stage
FROM golang:alpine AS builder
ENV GO111MODULE=on
ENV GOPROXY=direct
ENV GOPRIVATE=github.com/tonalfitness
# WORKDIR /app
# COPY ./ ./
# add credentials on build
ARG GITHUB_TOKEN
# add git info
ARG REPO
ARG BRANCH
ARG COMMIT
ARG TEST
# download from git
RUN apk --no-cache add git gcc musl-dev
    # && git config --global url."https://${GITHUB_TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com/" \
    # && git clone https://github.com/omid-tonal/${REPO}.git
COPY  . .
WORKDIR hello_service
# build 
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /hello_service main.go

# final stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates

COPY --from=builder /hello_service ./

EXPOSE  8080

ENTRYPOINT ["./hello_service"]
