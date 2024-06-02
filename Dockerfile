FROM joedwards32/cs2:latest

# Game Server Token from https://steamcommunity.com/dev/managegameservers
ENV SRCDS_TOKEN=""

# Set the visible name for your private server
ENV CS2_SERVERNAME="realsrvr"

# 0 - disable cheats, 1 - enable cheats
ENV CS2_CHEATS=0

# Put server in a low CPU state when there are no players. 
# 0 - hibernation disabled, 1 - hibernation enabled
# n.b. hibernation has been observed to trigger server crashes
ENV CS2_SERVER_HIBERNATE=0

# CS2 server listening IP address, 0.0.0.0 - all IP addresses on the local machine, empty - IP identified automatically
ENV CS2_IP=""

# CS2 server listen port tcp_udp
ENV CS2_PORT=27015

# Optional, use a simple TCP proxy to have RCON listen on an alternative port.
# Useful for services like AWS Fargate which do not support mixed protocol ports.
ENV CS2_RCON_PORT=""

# 0 - LAN mode disabled, 1 - LAN Mode enabled
ENV CS2_LAN="0"  

# RCON password
ENV CS2_RCONPW="changeme"

# CS2 server password
ENV CS2_PW="changeme"

# Max players allowed on the server
ENV CS2_MAXPLAYERS=10

# Optional additional arguments to pass into cs2
ENV CS2_ADDITIONAL_ARGS=""

# Game Modes
ENV CS2_GAMEALIAS=""
ENV CS2_GAMETYPE=0
ENV CS2_GAMEMODE=1
ENV CS2_MAPGROUP="mg_active"
ENV CS2_STARTMAP="de_inferno"

# Bots
ENV CS2_BOT_DIFFICULTY=""
ENV CS2_BOT_QUOTA=""
ENV CS2_BOT_QUOTA_MODE=""

# Logs
ENV CS2_LOG="on"
ENV CS2_LOG_MONEY=0
ENV CS2_LOG_DETAIL=0
ENV CS2_LOG_ITEMS=0

# run counter strike sharp
RUN cd /home/steam/cs2-dedicated; \
wget https://mms.alliedmods.net/mmsdrop/2.0/mmsource-2.0.0-git1293-linux.tar.gz; \
dir -s;\
mkdir -p -v game/csgo/addons;\
dir -s;

# unzip
#RUN cd /Steam/cs2-dedicated && tar -xzf test_app.tar.gz && rm test_app.tar.gz
# store in necessary folder