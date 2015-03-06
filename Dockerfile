FROM ubuntu:14.04
MAINTAINER hussein.galal.ahmed.11@gmail.com
ENV DEBIAN_FRONTEND noninteractive

# Install Graphite
RUN apt-get -qq update
RUN apt-get install -yqq graphite-carbon graphite-web

# Add Graphite Web Configuration And Setup The DB
ADD conf/local_settings.py /etc/graphite/local_settings.py
ADD conf/initial_data.json /tmp/initial_data.json
RUN /usr/bin/graphite-manage syncdb --noinput
RUN /usr/bin/graphite-manage loaddata /tmp/initial_data.json
RUN chmod a+w /var/lib/graphite/graphite.db

# Configure Carbon Component
ADD conf/graphite-carbon /etc/default/graphite-carbon
ADD conf/carbon.conf /etc/carbon/carbon.conf

# Configure Storage Schema
ADD conf/storage-schemas.conf /etc/carbon/storage-schemas.conf

# Install Apache And mod-wsgi
RUN apt-get install -yqq apache2 libapache2-mod-wsgi
RUN cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available/
RUN a2dissite 000-default
RUN a2ensite apache2-graphite

EXPOSE 80

# RUN carbon_cache.py daemon 
RUN service carbon-cache start
ENTRYPOINT usr/sbin/apache2ctl -D FOREGROUND
