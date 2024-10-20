FROM golang:1.23-bookworm

WORKDIR /app

COPY . .

RUN go mod download

RUN go build -o /cir

# Tells Docker which network port your container listens on
EXPOSE 9222

# Specifies the executable command that runs when the container starts
CMD ["/cir"]