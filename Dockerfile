# Build Stage
FROM fuzzers/aflplusplus:3.12c as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git make

## Add source code to the build stage.
WORKDIR /
RUN git clone https://github.com/capuanob/epub2txt2.git
WORKDIR /epub2txt2
RUN git checkout mayhem

## Build
WORKDIR build
RUN make -j$(nproc)

## Generate test corpus
RUN mkdir /tests && cp corpus/* > /tests/

ENTRYPOINT ["afl-fuzz", "-i", "/tests", "-o", "/out"]
CMD ["/epub2txt2/epub2txt", "@@"]
