FROM alpine:3.21

RUN apk add fzf

# 1. Grab their public key
RUN wget -O /etc/apk/keys/packages@orb.net.rsa.pub https://pkgs.orb.net/stable/alpine/orb.pub

# 2. Add their repo URL
RUN echo "https://pkgs.orb.net/stable/alpine" >> /etc/apk/repositories

# 3. Update and install
RUN apk update
RUN apk add orb
