# syntax=docker/dockerfile:1
FROM golang:1.18-alpine
WORKDIR /app
COPY go.mod ./
COPY go.sum ./
RUN go mod download
COPY *.go ./
RUN go build -o /wireproxy-docker
EXPOSE 23944
CMD [ "/wireproxy-docker" ]