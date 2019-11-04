FROM centos:7
MAINTAINER Mats Rynge "rynge@isi.edu"

RUN yum -y upgrade
RUN yum -y install epel-release yum-plugin-priorities

# osg repo
RUN yum -y install http://repo.opensciencegrid.org/osg/3.5/osg-3.5-el7-release-latest.rpm
   
# pegasus repo 
RUN echo -e "# Pegasus\n[Pegasus]\nname=Pegasus\nbaseurl=http://download.pegasus.isi.edu/wms/download/rhel/7/\$basearch/\ngpgcheck=0\nenabled=1\npriority=50" >/etc/yum.repos.d/pegasus.repo

# well rounded basic system to support a wide range of user jobs
RUN yum -y groups mark convert \
    && yum -y grouplist \
    && yum -y groupinstall "Compatibility Libraries" \
                           "Development Tools" \
                           "Scientific Support"

RUN yum -y install \
           astropy-tools \
           bc \
           binutils \
           binutils-devel \
           cmake \
           coreutils \
           curl \
           davix-devel \
           dcap-devel \
           doxygen \
           dpm-devel \
           fontconfig \
           gcc \
           gcc-c++ \
           gcc-gfortran \
           git \
           glew-devel \
           glib2-devel \
           glib2-devel \
           glib-devel \
           globus-gass-copy-devel \
           graphviz \
           gsl-devel \
           gtest-devel \
           java-1.8.0-openjdk \
           java-1.8.0-openjdk-devel \
           json-c-devel \
           lfc-devel \
           libattr-devel \
           libgfortran \
           libGLU \
           libgomp \
           libicu \
           libquadmath \
           libssh2-devel \
           libtool \
           libtool-ltdl \
           libtool-ltdl-devel \
           libuuid-devel \
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
           nano \
           numpy \
           octave \
           octave-devel \
           openldap-devel \
           openssh \
           openssh-server \
           openssl098e \
           osg-wn-client \
           p7zip \
           p7zip-plugins \
           python-astropy \
           python-devel \
           R-devel \
           redhat-lsb \
           redhat-lsb-core \
           rsync \
           scipy \
           srm-ifce-devel \
           stashcache-client \
           subversion \
           tcl-devel \
           tcsh \
           time \
           tk-devel \
           vim \
           wget \
           xrootd-client-devel \
           zlib-devel \
           which

# osg
RUN yum -y install osg-ca-certs osg-wn-client \
    && rm -f /etc/grid-security/certificates/*.r0

# htcondor - include so we can chirp
RUN yum -y install condor

# pegasus
RUN yum -y install pegasus

# Cleaning caches to reduce size of image
RUN yum clean all

# required directories
RUN for MNTPOINT in \
        /cvmfs \
        /hadoop \
        /hdfs \
        /lizard \
        /mnt/hadoop \
        /mnt/hdfs \
        /xenon \
        /scratch \
        /spt \
        /stash2 \
    ; do \
        mkdir -p $MNTPOINT ; \
    done

# make sure we have a way to bind host provided libraries
# see https://github.com/singularityware/singularity/issues/611
RUN mkdir -p /host-libs /etc/OpenCL/vendors

# some extra singularity stuff
COPY .singularity.d /.singularity.d
RUN cd / && \
    ln -s .singularity.d/actions/exec .exec && \
    ln -s .singularity.d/actions/run .run && \
    ln -s .singularity.d/actions/test .shell && \
    ln -s .singularity.d/runscript singularity

# build info
RUN echo "Timestamp:" `date --utc` |  tee /image-build-info.txt


