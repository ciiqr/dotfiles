FROM ubuntu:18.04
WORKDIR /app

# install dependencies
RUN apt-get update
RUN apt-get install -y wget

# Copy files
COPY . ./

# `docker run` calls install
ENTRYPOINT ["/app/scripts/install"]

# TODO: move to readme
# TODO: likely don't need to mount /config twice
# TODO: use grains to find config dirs: sudo salt-call grains.get configDir --out newline_values_only
# docker build -t config-ubuntu .
# docker run -v /config:/config -v /config-private:/config-private -v /config:/app -t config-ubuntu
