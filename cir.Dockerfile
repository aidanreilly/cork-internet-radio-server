FROM golang:1.23-bookworm

WORKDIR /app

COPY . .

RUN go mod download

RUN go build -o cir

EXPOSE 9222

CMD ["/cir"]