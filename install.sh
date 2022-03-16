#download kali 2022.1
sudo su
apt install tor obfs4proxy
curl ifconfig.me

nano /etc/tor/torrc
#add 
#UseBridges 1
#ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy
#Bridge obfs4 185.220.101.103:52103 092D75D78FCBCD4487512FF09D077302B9EA5965 cert=p9L6+25s8bnfkye1ZxFeAE4mAGY7DH4Gaj7dxngIIzP9BtqrHHwZXdjMK0RVIQ34C7aqZw iat-mode=

systemctl restart tor
journalctl -b --no-pager /usr/bin/tor
#test tor
curl --socks5 127.0.0.1:9050 ifconfig.me
proxychains4 curl ifconfig.me
systemctl enable tor   

apt install shadowsocks-libev
nano /etc/shadowsocks-libev/config.json
#{
#    "server":["::0", "0.0.0.0"],
#    "mode":"tcp_and_udp",
#    "server_port":8388,
#    "local_port":1111,
#    "password":"password",
#    "timeout":600,
#    "method":"aes-128-gcm",
#    "nameserver":"8.8.8.8"
#}


proxychains ss-server -c /etc/shadowsocks-libev/config.json
nano /lib/systemd/system/shadowsocks-libev.service
#edit add proxychains before /usr/.....
systemctl daemon-reload 
systemctl start shadowsocks-libev
systemctl enable shadowsocks-libev

passwd kali
systemctl restart sshd
systemctl enable sshd

apt install stunnel4
sudo mkdir /var/lib/stunnel4/certs
sudo mkdir /var/lib/stunnel4/crls
touch /var/lib/stunnel4/stunnel.log
chown stunnel4:stunnel4 /var/lib/stunnel4/stunnel.log
nano /etc/stunnel/stunnel.conf
###

openssl req -nodes -new -days 365 -newkey rsa:1024 -x509 -keyout serverkey.pem -out servercert.pem
mv serverkey.pem /etc/stunnel/
mv servercert.pem /etc/stunnel/






