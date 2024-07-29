FROM golang:latest as plugins

WORKDIR /build

RUN go install github.com/hadley31/cs2pm@latest

COPY cs2pm.yaml .

RUN cs2pm install

FROM mcr.microsoft.com/dotnet/sdk:8.0 as build

WORKDIR /build

COPY plugins/ plugins/
COPY scripts/build-plugins.sh .

RUN ./build-plugins.sh

FROM joedwards32/cs2:latest

ARG METAMOD_URL="https://mms.alliedmods.net/mmsdrop/2.0/mmsource-2.0.0-git1293-linux.tar.gz"
ARG CS_SHARP_URL="https://github.com/roflmuffin/CounterStrikeSharp/releases/download/v248/counterstrikesharp-with-runtime-build-248-linux-1806919.zip"


# Download Metamod
# -x tells tar to extract the zip
# -z tells tar to use gzip
# -C tells tar to where to extract the zip to
RUN curl -Lo /tmp/metamod.tar.gz $METAMOD_URL


# Download CounterStrikeSharp
# -L tells curl to follow redirects
# -o tells curl to output to the specified file
RUN curl -Lo /tmp/counterstrikesharp.zip $CS_SHARP_URL


# Copy the server-data plugin to temporary directory to be copied in the pre.sh hook
COPY --from=build /build/target/* /tmp/addons/counterstrikesharp/plugins/
COPY --from=plugins /build/addons/ /tmp/addons/


COPY hooks/* /etc/
COPY hooks/ephemeral/* /etc/
