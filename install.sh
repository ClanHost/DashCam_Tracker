sudo apt update -y
sudo apt upgrade -y
sudo apt install mc -y
sudo apt install htop -y
sudo apt install fping -y
sudo apt install gpsd -y
sudo apt install jq -y
sudo tailscale up
sudo apt install ffmpeg -y
sudo sed -i -e 's/GPSD_OPTIONS=""/GPSD_OPTIONS="\/dev\/ttyACM0"/g' /etc/default/gpsd
#sudo gpsd /dev/serial0 -F /var/run/gpsd.sock
#curl -fsSL https://tailscale.com/install.sh | sh
wget https://raw.githubusercontent.com/ClanHost/DashCam_Tracker/refs/heads/main/GPS.sh
wget https://raw.githubusercontent.com/ClanHost/DashCam_Tracker/refs/heads/main/DASHCAM.sh
chmod 777 GPS.sh
chmod 777 DASHCAM.sh


sudo touch  /etc/systemd/system/GPS.service
sudo touch  /etc/systemd/system/DASHCAM.service
sudo echo "
[Unit]
Description = GPS
Requires = systemd-user-sessions.service network.target sound.target
After = multi-user.target

[Service]
User = pi
Group = pi
Type = simple
ExecStart = /home/pi/GPS.sh
Restart = always
RestartSec = 5

[Install]
WantedBy = multi-user.target" > /etc/systemd/system/GPS.service

sudo systemctl enable GPS
sudo systemctl restart GPS
sudo echo "
[Unit]
Description = DASHCAM
Requires = systemd-user-sessions.service network.target sound.target
After = multi-user.target

[Service]
User = pi
Group = pi
Type = simple
ExecStart = /home/pi/DASHCAM.sh
Restart = always
RestartSec = 5

[Install]
WantedBy = multi-user.target" > /etc/systemd/system/DASHCAM.service

sudo systemctl enable DASHCAM
sudo systemctl restart DASHCAM

sudo reboot
