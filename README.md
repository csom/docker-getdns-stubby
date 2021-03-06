# docker-getdns-stubby (Updated using cmake to work with getdns v1.6.0+)
(Working on Raspberry Pi)

This Dockerfile is based on the blog post by Stéphan Bortzmeyer [Quad9, un résolveur DNS public, et avec sécurité](http://www.bortzmeyer.org/quad9.html/) 

The image is based on a [Debian Buster base image](https://hub.docker.com/_/debian/), what you get is a compiled-from-source [Getdns Stubby](https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby) and the provided `stubby.yml` gets you DNS over TLS via [Quad9](https://www.quad9.net/#/about) on 127.0.0.1 tcp port 8053 as per Stéphan Bortzmeyer post. 

This image will not get you a caching dns, just the dns over tls via Quad9 with Stubby.

## build the image

``docker build -t getdns-stubby . ``

## run the container

To run inside your own docker network to communicate between docker containers:
``docker run -d --name getdns-stubby --network ("Create new docker network")  --restart=unless-stopped --hostname=stubby  getdns-stubby``

To run with exposed port:
``docker run -d --name getdns-stubby -p 8053:8053 --restart=unless-stopped --hostname=stubby getdns-stubby``

## run with your own stubby config

You can of course change the included config file and write your own from scratch, to test Stubby with your own configuration. You are not limited to Quad9. 

# Official Getdns Dockerfile

Getdns includes an official and more complete [Dockerfile](https://github.com/getdnsapi/getdns/blob/master/src/tools/Dockerfile) maintained by [Melinda Shore](https://github.com/MelindaShore)
