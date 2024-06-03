#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/oldhunterr/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/oldhunterr/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
   _____
  / ___/____  ____  ____  __________
  \__ \/ __ \/ __ \/ __ `/ ___/ ___/
 ___/ / /_/ / / / / /_/ / /  / /
/____/\____/_/ /_/\__,_/_/  /_/

    ____            __               
   / __ \____ _____/ /___  __________
  / /_/ / __ `/ __  / __ `/ ___/ ___/
 / _, _/ /_/ / /_/ / /_/ / /  / /    
/_/ |_|\__,_/\__,_/\__,_/_/  /_/     

    ____                     __               
   / __ \_________ _      __/ /___  __________
  / /_/ / ___/ __ \ | /| / / / __ `/ ___/ ___/
 / ____/ /  / /_/ / |/ |/ / / /_/ / /  / /    
/_/   /_/   \____/|__/|__/_/\__,_/_/  /_/     
             
    ____             __    ____       __         _     __   ______                           __     _________            __
   / __ \___  ____  / /   / __ \___  / /_  _____(_)___/ /  /_  __/___  _____________  ____  / /_   / ____/ (_)__  ____  / /_
  / /_/ / _ \/ __ `/ /___/ / / / _ \/ __ \/ ___/ / __  /    / / / __ \/ ___/ ___/ _ \/ __ \/ __/  / /   / / / _ \/ __ \/ __/
 / _, _/  __/ /_/ / /___/ /_/ /  __/ /_/ / /  / / /_/ /    / / / /_/ / /  / /  /  __/ / / / /_   / /___/ / /  __/ / / / /_
/_/ |_|\___/\__,_/_/   /_____/\___/_.___/_/  /_/\__,_/    /_/  \____/_/  /_/   \___/_/ /_/\__/   \____/_/_/\___/_/ /_/\__/

       __           __        __  __ 
      / /___ ______/ /_____  / /_/ /_
 __  / / __ `/ ___/ //_/ _ \/ __/ __/
/ /_/ / /_/ / /__/ ,< /  __/ /_/ /_  
\____/\__,_/\___/_/|_|\___/\__/\__/  

all in one test one
EOF
}
header_info
echo -e "Loading..."
APP="Testo"
var_disk="8"
var_cpu="4"
var_ram="2048"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/Sonarr ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating $APP v4"
systemctl stop sonarr.service
wget -q -O SonarrV4.tar.gz 'https://services.sonarr.tv/v1/download/main/latest?version=4&os=linux&arch=x64'
tar -xzf SonarrV4.tar.gz
rm -rf /opt/Sonarr
mv Sonarr /opt
rm -rf SonarrV4.tar.gz
systemctl start sonarr.service
msg_ok "Updated $APP v4"
exit
}

start
build_container
description

msg_info "Starting Installation of Sonarr and Radarr"

msg_ok "Completed Successfully!\n"
echo -e "Sonarr should be reachable by going to the following URL:
         ${BL}http://${IP}:8989${CL} \n"
echo -e "Radarr should be reachable by going to the following URL:
         ${BL}http://${IP}:7878${CL} \n"
echo -e "Prowlarr should be reachable by going to the following URL:
         ${BL}http://${IP}:9696${CL} \n"
echo -e "Jackett should be reachable by going to the following URL:
         ${BL}http://${IP}:9117${CL} \n"
echo -e "Rdt-Client should be reachable by going to the following URL:
         ${BL}http://${IP}:6500${CL} \n"             
