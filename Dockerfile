FROM joedwards32/cs2:latest

ENV SRCDS_TOKEN=""
ENV CS2_SERVERNAME="realsrvr"
ENV CS2_CHEATS=0
ENV CS2_SERVER_HIBERNATE=0
ENV CS2_IP=""
ENV CS2_PORT=27015
ENV CS2_RCON_PORT=""
ENV CS2_LAN="0"  
ENV CS2_RCONPW="changeme"
ENV CS2_PW="changeme"
ENV CS2_MAXPLAYERS=10
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