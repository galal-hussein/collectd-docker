echo "127.0.1.1 localhost rancher" >> /etc/hosts
service collectd start
service fcgiwrap start
sleep 5
/usr/sbin/nginx
