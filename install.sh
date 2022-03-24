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

!!!apt install simple-obfs
setcap 'cap_net_bind_service=+ep' /usr/bin/ss-server
nano /etc/shadowsocks-libev/config.json
#"plugin":"obfs-server",
#"plugin_opts":"obfs=http;failover=204.79.197.200:80"
or
#"plugin":"obfs-local",
#"plugin_opts":"obfs=tls;failover=204.79.197.200:443"
systemctl restart shadowsocks-libev

passwd kali
systemctl restart sshd
systemctl enable sshd

apt install stunnel4
It is just a matter of editing file /etc/ssl/openssl.cnf changing last line
from:
CipherString = DEFAULT@SECLEVEL=2
to
CipherString = DEFAULT@SECLEVEL=1

mkdir /var/lib/stunnel4/certs
mkdir /var/lib/stunnel4/crls
touch /var/lib/stunnel4/stunnel.log
chown stunnel4:stunnel4 /var/lib/stunnel4/stunnel.log
nano /etc/stunnel/stunnel.conf
#[test]
#client = yes
#accept = 8989
#connect = mail.ru:443

openssl req -nodes -new -days 365 -newkey rsa:2048 -x509 -keyout serverkey.pem -out servercert.pem
mv serverkey.pem /etc/stunnel/
mv servercert.pem /etc/stunnel/
systemctl start stunnel4
systemctl enable stunnel4 
cd /etc/stunnel
openssl req -newkey rsa:2048 -nodes -x509 -days 3650 -subj "/CN=server" -out servcert.pem -keyout serverkey.pem




