file=/etc/init.d/agetty.tty1

echo "agetty_options=\"--autologin alan --noclear\"
$(cat $file)" > $file