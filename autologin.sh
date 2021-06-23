file=/etc/init.d/agetty.tty1

sed "/^description=.*/a agetty_options=\"--autologin $USER --noclear\"" $file | sudo tee $file