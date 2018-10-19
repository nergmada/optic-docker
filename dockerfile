FROM ubuntu
LABEL maintainer="Adam Green"
LABEL maintaineremail="adam.green@kcl.ac.uk"
#Update the ubuntu package manager
RUN apt-get update
#Install flex and bison (dependencies of VAL)
RUN apt-get install -y flex
RUN apt-get install -y bison

#Install build tools, including Cmake, gcc and g++
RUN apt-get install -y cmake
RUN apt-get install -y gcc
RUN apt-get install -y g++

#Install python2.7 and linux it to regular python (VAL is not compatible with 3.6)
RUN apt-get install -y python2.7
RUN ln -s /usr/bin/python2.7 /bin/python

#Make a /home/rwrite directory, add all the files outside the docker container
RUN mkdir /home/rewrite
ADD . /home/rewrite 
RUN cd /home/rewrite && mkdir build

#Tell CMake to configure the cache files
RUN cd /home/rewrite/build && cmake --DCMAKE_CXX_COMPILER="/usr/bin/g++" ..
#Tell CMake to build
RUN cd /home/rewrite/build && cmake --build . --target rewrite-no-lp

CMD ["/home/rewrite/build/rewrite-no-lp","domain","problem"]