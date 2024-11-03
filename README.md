# broadcast

A simple Go server that broadcasts any data/stream via http. Read more about it [on my blog](http://schollz.com/blog/radio/). The code was written based of [schollz/duct](http://github.com/schollz/duct), which is a fork of of [patchbay-pub](http://github.com/patchbay-pub/patchbay-simple-server).

## Usage

### Sending data

You can POST data. 

```
curl -k -X POST --data-binary "@/home/aireilly/Pictures/cracker.png" http://localhost:9222/cracker.png
```

The image will be available at `http://localhost:9222/cracker.png`.


### Streaming audio

You can POST an audio stream to the server for any number of clients to consume it. For example, you can `curl` a local music stream and then POST it:

```cmd
curl http://stream-relay-geo.ntslive.net/stream | curl -k -H "Transfer-Encoding: chunked" -X POST -T -  'http://localhost:9222/test.mp3?stream=true'
```

This stream is now accessible at `localhost:9222/test.mp3`. The `?stream=true` flag is important to tell the server to start reading bytes right away, even if there is no listener. It has the benefit of immediately sending data to *all listeners* so that you can have multiple connections on that will all receive the data. 

## Advertising the stream

Another useful flag for streaming is `advertise=true` which will advertise the stream on the main page.

```cmd
curl http://stream-relay-geo.ntslive.net/stream | curl -k -H "Transfer-Encoding: chunked" -X POST -T - 'localhost:9222/test.mp3?stream=true&advertise=true'
```

## Archiving the live stream

```cmd
curl http://stream-relay-geo.ntslive.net/stream | curl -k -H "Transfer-Encoding: chunked" -X POST -T -  'localhost:9222/test.mp3?archive=true'
```

## Installing directly from source

First install Go, then:

```cmd
go install -v github.com/aidanreilly/cork-internet-radio-server@latest

#launch the executable
$HOME/go/bin/cork-internet-radio-server
[info]  2024/10/22 14:03:40 running on port 9222
```

## Build locally

```cmd
go mod tidy
go mod download
go build -o cir
```

## Build and push containers to docker.io

cir
```cmd
podman login docker.io

podman build -t oootini/cork-internet-radio-server:latest-arm64 -f cir.Dockerfile --platform linux/arm64
podman push oootini/cork-internet-radio-server:latest-arm64

podman build -t oootini/cork-internet-radio-server:latest-amd64 -f cir.Dockerfile --platform linux/amd64
podman push oootini/cork-internet-radio-server:latest-amd64
```

Configure a reverse proxy
```cmd
podman build -t oootini/nginx-reverse-proxy:latest-arm64 -f nginx-reverse-proxy.Dockerfile --platform linux/arm64
podman push oootini/nginx-reverse-proxy:latest-arm64
```

Build an icecast2 server
```cmd
podman build -t oootini/icecast2:latest-arm64 -f icecast2.Dockerfile --platform linux/arm64
podman push oootini/icecast2:latest-arm64

podman build -t oootini/icecast2:latest-amd64 -f icecast2.Dockerfile --platform linux/amd64
podman push oootini/icecast2:latest-amd64
```

```cmd
podman run --name icecast2 -d --restart=always \
--publish 9222:9222 \
--replace \
--privileged \
--volume "$(pwd)/icecast.xml:/etc/icecast2/icecast.xml:Z" \
oootini/icecast2:latest-arm64
```

Server is up on http://192.168.1.60:8000/admin/stats

Test the stream:
```cmd
ffmpeg -re -stream_loop -1 -i ./windows-95-startup.mp3 -f mp3 icecast://source:password@192.168.1.201:8000/radio
```

Stream is up:
```
http://192.168.1.201:8000/radio
```

## License

MIT