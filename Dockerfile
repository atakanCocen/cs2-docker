FROM mcr.microsoft.com/dotnet/sdk:8.0 as build

WORKDIR /build

COPY plugins/ plugins/
COPY scripts/build-plugins.sh .

RUN ./build-plugins.sh

FROM joedwards32/cs2:latest

ARG METAMOD_URL="https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1155-linux.tar.gz"
ARG CS_SHARP_URL="https://github.com/roflmuffin/CounterStrikeSharp/releases/download/v239/counterstrikesharp-with-runtime-build-239-linux-a695eec.zip"


# Set the visible name for your private server
ENV CS2_SERVERNAME="realsrvr"


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
COPY --from=build /build/target/* /tmp/plugins/


COPY hooks/* /etc/
COPY hooks/ephemeral/* /etc/
