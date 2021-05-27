echo "#### STEP 1 : UPDATE ####"
sudo apt-get update && sudo apt-get upgrade

echo "#### STEP 2 : ZSH ####"
sudo apt-get install curl zsh -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "#### STEP 3 : ON-SCREEN KEYBOARD ####"
sudo apt install matchbox-keyboard -y
sudo cat << END > /usr/bin/toggle-keyboard.sh  
#!/bin/bash
PID="$(pidof matchbox-keyboard)"
if [  "$PID" != ""  ]; then
  kill $PID
else
 matchbox-keyboard &
fi
END
sudo chmod +x /usr/bin/toggle-keyboard.sh
sudo cat << END > /usr/share/raspi-ui-overrides/applications/toggle-keyboard.desktop
[Desktop Entry]
Name=Toggle Virtual Keyboard
Comment=Toggle Virtual Keyboard
Exec=/usr/bin/toggle-keyboard.sh
Type=Application
Icon=matchbox-keyboard.png
Categories=Panel;Utility;MB
X-MB-INPUT-MECHANISM=True
END
cp /etc/xdg/lxpanel/LXDE-pi/panels/panel /home/pi/.config/lxpanel/LXDE-pi/panels/panel
cat << END >> /home/pi/.config/lxpanel/LXDE-pi/panels/panel
Plugin {
  type=launchbar
  Config {
    Button {
      id=toggle-keyboard.desktop
    }
  }
}
END

echo "#### STEP 4 : CREATING AP ####"
sudo apt-get install hostapd dnsmasq -y
git clone https://github.com/oblique/create_ap
cd create_ap
make install
head

echo "#### STEP 5 : WRITING AP TO STARTUP ####"
temp_str=`head -n -1 /etc/rc.local`
sudo cat << END >> /etc/rc.local
$temp_str
create_ap wlan1 wlan0 RPI-IoT-Router huehuehue &
exit 0
END

echo "#### DONE! ####"
echo "
Try to run : 
 create_ap wlan1 wlan0 RPI-IoT-Router huehuehue
README https://github.com/oblique/create_ap"

