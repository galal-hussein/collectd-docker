FROM ubuntu:14.04
MAINTAINER hussein.galal.ahmed.11@gmail.com
ENV DEBIAN_FRONTEND noninteractive

# Install nginx, collectd, and other dependencies 
RUN apt-get -qq update
RUN apt-get install -yqq nginx wget collectd perl libconfig-general-perl librrds-perl libregexp-common-perl collectd-core libhtml-parser-perl librrd2-dev libsnmp-dev spawn-fcgi fcgiwrap

# Add nginx configuration 
ADD conf/nginx-collectd.conf /etc/nginx/sites-available/
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/nginx-collectd.conf /etc/nginx/sites-enabled/nginx-collectd
ADD conf/nginx.conf /etc/nginx/nginx.conf

# Add the run script
ADD run.sh /tmp/run.sh


# Install Graphs Scripts
RUN cd /tmp/ && wget http://collectd.org/files/collectd-5.4.2.tar.gz
RUN cd /tmp/ && tar -xvf collectd-5.4.2.tar.gz
RUN mkdir -p /var/www/
RUN cp -r /tmp/collectd-5.4.2/contrib/collection3 /var/www/graphs
RUN mkdir -p /usr/lib/cgi-bin
RUN chown -R www-data:www-data /var/www/graphs
WORKDIR /tmp/collectd-5.4.2

EXPOSE 80 
ENTRYPOINT ["/bin/bash","/tmp/run.sh"]
