FROM godarch/void
WORKDIR /app

# update repo cache
RUN xbps-install -Sy

# enable repos
RUN xbps-install -Sy void-repo-nonfree

# install dependencies
RUN xbps-install -Sy curl

# Copy files
COPY . ./

# `docker run` calls install
ENTRYPOINT ["/app/scripts/install"]
# ENTRYPOINT ["/bin/bash"]

# TODO: move to readme
# TODO: likely don't need to mount /config twice
# TODO: use grains to find config dirs: sudo salt-call grains.get configDir --out newline_values_only
# docker build -t config-void -f tests/void/Dockerfile .
# docker run -v /config:/config -v /config-private:/config-private -v /config:/app -t config-void
# docker run -t config-void

# % figure out void from install script same way as bootstrap
#     https://github.com/saltstack/salt-bootstrap/blob/develop/bootstrap-salt.sh#L1055
