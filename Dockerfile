From ubuntu:22.04

#COPY inittimezone /usr/local/bin/inittimezone

# Run inittimezone and install a few dependencies
RUN apt-get -qq update && \
    apt-get -qq -y install \
        build-essential \
        cmake \
        g++ \
        git \
        libboost-all-dev \
        wget \
        libdeal.ii-dev \
        vim \
        tree \
        lintian
        
# Get, unpack, build, and install yaml-cpp        
RUN mkdir software && cd software && \
    git clone https://github.com/jbeder/yaml-cpp.git && \
    cd yaml-cpp && mkdir build && cd build && \
    cmake -DYAML_BUILD_SHARED_LIBS=ON .. && make -j4 && make install

# Optional Task - Make package installed automatically inside the container

RUN git clone https://github.com/uygarkov/cpack-exercise-wt2223.git && \
	mkdir -p /mnt/cpack-exercise-wt2223/build/ && \
	cd /mnt/cpack-exercise-wt2223/build/ && \
	cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release .. && \
	make package && \
	apt install ./cpackexample_0.1.1_amd64.deb

    
# This is some strange Docker problem. Normally, you don't need to add /usr/local to these
ENV LIBRARY_PATH $LIBRARY_PATH:/usr/local/lib/
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib/
ENV PATH $PATH:/usr/local/bin/


CMD ["/bin/bash"]
