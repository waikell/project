# Pull Base Image
FROM zhicwu/java:8

# Set Maintainer Details
MAINTAINER Waikell Microservices - waikell/pentaho-crond

# Set Environment Variables
ENV PDI_VERSION=8.2 PDI_BUILD=8.2.0.0-342 PDI_PATCH=8.2.0.0 PDI_USER=pentaho KETTLE_HOME=/data-integration

# Install Required Packages, Configure Crons and Add User
RUN apt-get update \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& useradd -md $KETTLE_HOME -s /bin/bash $PDI_USER

# Download Pentaho Data Integration Community Edition and Unpack
RUN wget --progress=dot:giga https://nchc.dl.sourceforge.net/project/pentaho/Pentaho%208.2/client-tools/pdi-ce-8.2.0.0-342.zip \
	&& unzip -q *.zip \
	&& rm -f *.zip

# Switch Directory
WORKDIR $KETTLE_HOME

RUN mkdir $KETTLE_HOME/jobs \
    && mkdir $KETTLE_HOME/drivers

# Add Entry Point and Templates
COPY dockerentrypoint.sh $KETTLE_HOME/docker-entrypoint.sh

#move to apt-gets to maintain a pattern
RUN apt-get update && apt-get install -y dos2unix && apt-get install -y libwebkitgtk-1.0-0

RUN chmod +x docker-entrypoint.sh

RUN dos2unix $KETTLE_HOME/docker-entrypoint.sh

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

ENTRYPOINT ["/data-integration/docker-entrypoint.sh"]
