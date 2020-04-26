FROM pataquets/ubuntu:bionic

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
      amule-daemon \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Create default configuration file and configure some defaults.
# Enable external connections (EC), password is 'amule' md5 hash.
RUN \
  amuled --log-stdout --reset-config && \
  sed -i 's/^AcceptExternalConnections=0$/AcceptExternalConnections=1/' \
    ~/.aMule/amule.conf && \
  sed -i 's/^ECPassword=$/ECPassword=ef7628c92bff39c0b3532d36a617cf09/' \
    ~/.aMule/amule.conf && \
  sed -i 's/^UPnPEnabled=0$/UPnPEnabled=1/' ~/.aMule/amule.conf && \
  nl ~/.aMule/amule.conf

# Configure amuleweb and write configuration file with some defaults.
RUN \
  amuleweb --verbose \
    --password amule \
    --allow-guest --guest-pass=guest \
    --admin-pass=admin \
    --enable-gzip \
    --write-config \
  && nl ~/.aMule/remote.conf

ENTRYPOINT [ "amuled", "--log-stdout" ]
