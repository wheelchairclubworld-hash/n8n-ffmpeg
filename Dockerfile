# Bake fully-static ffmpeg into n8n image (base-distro agnostic).
# n8nio/n8n:latest no longer ships apk, so we copy a STATIC ffmpeg that needs no libs.
FROM alpine:3.22 AS ff
RUN apk add --no-cache curl xz \
 && curl -sL "https://github.com/wheelchairclubworld-hash/n8n-ffmpeg/releases/download/ffmpeg-7.0.2/ffmpeg-release-amd64-static.tar.xz" -o /tmp/ff.tar.xz \
 && cd /tmp && tar -xf ff.tar.xz \
 && cp ffmpeg-*-amd64-static/ffmpeg ffmpeg-*-amd64-static/ffprobe /usr/local/bin/ \
 && chmod +x /usr/local/bin/ffmpeg /usr/local/bin/ffprobe

FROM n8nio/n8n:latest
USER root
COPY --from=ff /usr/local/bin/ffmpeg /usr/local/bin/ffmpeg
COPY --from=ff /usr/local/bin/ffprobe /usr/local/bin/ffprobe
RUN /usr/local/bin/ffmpeg -version
USER node
