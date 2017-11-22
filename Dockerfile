FROM centos:7
MAINTAINER Mats Rynge "rynge@isi.edu"

RUN yum -y upgrade
RUN yum -y install epel-release yum-plugin-priorities

# osg repo
RUN yum -y install http://repo.grid.iu.edu/osg/3.4/osg-3.4-el7-release-latest.rpm
   
# pegasus repo 
RUN echo -e "# Pegasus\n[Pegasus]\nname=Pegasus\nbaseurl=http://download.pegasus.isi.edu/wms/download/rhel/7/\$basearch/\ngpgcheck=0\nenabled=1\npriority=50" >/etc/yum.repos.d/pegasus.repo

# well rounded basic system to support a wide range of user jobs
RUN yum -y groups mark convert \
    && yum -y grouplist \
    && yum -y groupinstall "Compatibility Libraries" \
                           "Development Tools" \
                           "Scientific Support"

RUN yum -y install \
           redhat-lsb \
           astropy-tools \
           bc \
           binutils \
           binutils-devel \
           coreutils \
           curl \
           fontconfig \
           gcc \
           gcc-c++ \
           gcc-gfortran \
           git \
           glew-devel \
           glib2-devel \
           glib-devel \
           graphviz \
           gsl-devel \
           java-1.8.0-openjdk \
           java-1.8.0-openjdk-devel \
           libgfortran \
           libGLU \
           libgomp \
           libicu \
           libquadmath \
           libtool \
           libtool-ltdl \
           libtool-ltdl-devel \
           libX11-devel \
           libXaw-devel \
           libXext-devel \
           libXft-devel \
           libxml2 \
           libxml2-devel \
           libXmu-devel \
           libXpm \
           libXpm-devel \
           libXt \
           mesa-libGL-devel \
           numpy \
           octave \
           octave-devel \
           osg-wn-client \
           openssl098e \
           p7zip \
           p7zip-plugins \
           python-astropy \
           python-devel \
           R-devel \
           redhat-lsb-core \
           rsync \
           scipy \
           subversion \
           tcl-devel \
           tcsh \
           time \
           tk-devel \
           wget \
           which \
    
# osg
# use CA certs from CVMFS
RUN yum -y install osg-ca-certs osg-wn-client \
    && mv /etc/grid-security/certificates /etc/grid-security/certificates.osg-ca-certs \
    && ln -f -s /cvmfs/oasis.opensciencegrid.org/mis/certificates /etc/grid-security/certificates

# htcondor - include so we can chirp
RUN yum -y install condor

# pegasus
RUN yum -y install pegasus

# required directories
RUN mkdir -p /cvmfs

# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
RUN mkdir -p /host-libs /etc/OpenCL/vendors

# verification
RUN ls -l /etc/grid-security/

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

