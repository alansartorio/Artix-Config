file=/etc/init.d/agetty.tty1

echo "agetty_options=\"--autologin $USER --noclear\"
$(cat $file)" | sudo tee $file