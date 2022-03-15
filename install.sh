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
