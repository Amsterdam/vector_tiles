# Operating system image:
FROM ubuntu:16.04
MAINTAINER datapunt@amsterdam.nl

# Create  data directory
RUN mkdir -p data_tiles

RUN apt-get -qq update \
    && apt-get -qq --yes upgrade \
    && apt-get install -y cmake wget git ca-certificates build-essential \
        --no-install-recommends

### Tippecanoe!
RUN apt-get install -y libsqlite3-dev zlib1g-dev \
    && cd / \
    && git clone https://github.com/mapbox/tippecanoe.git tippecanoe \
    && cd tippecanoe \
    #  && git checkout tags/$TIPPECANOE_RELEASE \
    && cd /tippecanoe \
    && make \
    && make install \
    && cd / \
 #   && rm -rf tippecanoe \

#Tippecanoe now requires features from the 2011 C++ standard.
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    apt-get update -y \
    apt-get install -y g++-5 \
    export CXX=g++-5

ENTRYPOINT ["tippecanoe"]