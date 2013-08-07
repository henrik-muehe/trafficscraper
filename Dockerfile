FROM base
MAINTAINER Henrik Mühe <henrik.muehe@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

# Fake upstart
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# Install mysql
RUN apt-get -y install mysql-server

# Install ssh
RUN apt-get -y install openssh-server
RUN mkdir /var/run/sshd

# Install node
RUN apt-get -y install software-properties-common python-software-properties python g++ make
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get -y install nodejs

# Install src and modules
ADD . /src
RUN cd /src ; make install
RUN cd /src ; make

# Install tmux
RUN apt-get -y install tmux

# Run
EXPOSE 8080
CMD ["/src/startup.sh"]
