FROM centos:7

# Inspired by instructions at https://wiki.galaxyproject.org/Admin/GetGalaxy



########################################
# Dependency: Python 2.6 or 2.7
########################################
# Currently, Python 2.7.5 is default version
RUN python --version



########################################
# Dependency: Make, GCC
########################################
# GNU Make, gcc to compile and install tool dependencies
RUN yum install -y gcc make



########################################
# Install: Galaxy Project
########################################
ENV GALAXY_VERSION	16.01
ENV GALAXY_PATH		/opt/galaxy-${GALAXY_VERSION}
ENV PATH		$GALAXY_PATH:$PATH

RUN curl https://codeload.github.com/galaxyproject/galaxy/tar.gz/v${GALAXY_VERSION} -o galaxy.tar.gz  && \
    tar -xzf galaxy.tar.gz  && \
    rm -f galaxy.tar.gz  && \
    mv galaxy-${GALAXY_VERSION} /opt/



########################################
# Configure
########################################
# Starting the server for the first time will download/create the dependent Python eggs, configuration files, etc.
RUN run.sh --daemon
# FIXME: should not run in daemon mode here. How to install all dependencies without starting the server ???

# Add configuration file so that server starts on port 80 and listen on all IPs by default
COPY ./galaxy.ini $GALAXY_PATH/config/



####################
# PORTS
####################
EXPOSE 80


ENTRYPOINT ["run.sh"]
