#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/oldhunterr/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y sqlite3
msg_ok "Installed Dependencies"

msg_info "Installing Radarr"
mkdir -p /var/lib/radarr/
chmod 775 /var/lib/radarr/
$STD wget --content-disposition 'https://radarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64'
$STD tar -xvzf Radarr.master.*.tar.gz
mv Radarr /opt
chmod 775 /opt/Radarr
msg_ok "Installed Radarr"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/radarr.service
[Unit]
Description=Radarr Daemon
After=syslog.target network.target
[Service]
UMask=0002
Type=simple
ExecStart=/opt/Radarr/Radarr -nobrowser -data=/var/lib/radarr/
TimeoutStopSec=20
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
systemctl -q daemon-reload
systemctl enable --now -q radarr
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
rm -rf Radarr.master.*.tar.gz
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"





#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/oldhunterr/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y sqlite3
msg_ok "Installed Dependencies"

msg_info "Installing Sonarr v4"
mkdir -p /var/lib/sonarr/
chmod 775 /var/lib/sonarr/
wget -q -O SonarrV4.tar.gz 'https://services.sonarr.tv/v1/download/main/latest?version=4&os=linux&arch=x64'
tar -xzf SonarrV4.tar.gz
mv Sonarr /opt
rm -rf SonarrV4.tar.gz

msg_ok "Installed Sonarr v4"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/sonarr.service
[Unit]
Description=Sonarr Daemon
After=syslog.target network.target
[Service]
Type=simple
ExecStart=/opt/Sonarr/Sonarr -nobrowser -data=/var/lib/sonarr/
TimeoutStopSec=20
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now sonarr.service
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"


#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/oldhunterr/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y sqlite3
msg_ok "Installed Dependencies"

msg_info "Installing Prowlarr"
mkdir -p /var/lib/prowlarr/
chmod 775 /var/lib/prowlarr/
$STD wget --content-disposition 'https://prowlarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64'
$STD tar -xvzf Prowlarr.master.*.tar.gz
mv Prowlarr /opt
chmod 775 /opt/Prowlarr
msg_ok "Installed Prowlarr"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/prowlarr.service
[Unit]
Description=Prowlarr Daemon
After=syslog.target network.target
[Service]
UMask=0002
Type=simple
ExecStart=/opt/Prowlarr/Prowlarr -nobrowser -data=/var/lib/prowlarr/
TimeoutStopSec=20
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
systemctl -q daemon-reload
systemctl enable --now -q prowlarr
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
rm -rf Prowlarr.master.*.tar.gz
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"

#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/oldhunterr/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
$STD apt-get install -y unzip
msg_ok "Installed Dependencies"

msg_info "Installing ASP.NET Core Runtime"
wget -q https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb
$STD dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
$STD apt-get update
$STD apt-get install -y dotnet-sdk-8.0
msg_ok "Installed ASP.NET Core Runtime"

msg_info "Installing rdtclient"
wget -q https://github.com/rogerfar/rdt-client/releases/latest/download/RealDebridClient.zip
unzip -qq RealDebridClient.zip -d /opt/rdtc
rm RealDebridClient.zip
cd /opt/rdtc
mkdir -p data/{db,downloads}
sed -i 's#/data/db/#/opt/rdtc&#g' /opt/rdtc/appsettings.json
msg_ok "Installed rdtclient"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/rdtc.service
[Unit]
Description=RdtClient Service

[Service]
WorkingDirectory=/opt/rdtc
ExecStart=/usr/bin/dotnet RdtClient.Web.dll
SyslogIdentifier=RdtClient
User=root

[Install]
WantedBy=multi-user.target
EOF
$STD systemctl enable -q --now rdtc
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"


#!/usr/bin/env bash

# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/oldhunterr/Proxmox/raw/main/LICENSE

source /dev/stdin <<< "$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD apt-get install -y curl
$STD apt-get install -y sudo
$STD apt-get install -y mc
msg_ok "Installed Dependencies"

msg_info "Installing Jackett"
RELEASE=$(wget -q https://github.com/Jackett/Jackett/releases/latest -O - | grep "title>Release" | cut -d " " -f 4)
wget -q https://github.com/Jackett/Jackett/releases/download/$RELEASE/Jackett.Binaries.LinuxAMDx64.tar.gz
tar -xzf Jackett.Binaries.LinuxAMDx64.tar.gz -C /opt
rm -rf Jackett.Binaries.LinuxAMDx64.tar.gz
msg_ok "Installed Jackett"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/jackett.service
[Unit]
Description=Jackett Daemon
After=network.target
[Service]
SyslogIdentifier=jackett
Restart=always
RestartSec=5
Type=simple
WorkingDirectory=/opt/Jackett
ExecStart=/bin/sh /opt/Jackett/jackett_launcher.sh
TimeoutStopSec=30
Environment="DisableRootWarning=true"
[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now jackett.service
msg_ok "Created Service"

motd_ssh
customize

msg_info "Cleaning up"
$STD apt-get -y autoremove
$STD apt-get -y autoclean
msg_ok "Cleaned"
