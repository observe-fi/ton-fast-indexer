FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive


RUN apt-get update
RUN apt-get install -y build-essential git cmake ninja-build zlib1g-dev libsecp256k1-dev libmicrohttpd-dev libsodium-dev

RUN apt install -y lsb-release wget software-properties-common gnupg
RUN apt-get install -y wget
        
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 16 all

RUN git clone --recurse-submodules https://github.com/ton-blockchain/ton
WORKDIR ton

RUN cp assembly/native/build-ubuntu-shared.sh .
RUN chmod +x build-ubuntu-shared.sh

RUN apt install -y ccache pkg-config libjemalloc-dev liblz4-dev
RUN ./build-ubuntu-shared.sh  


# Configure SSH
RUN apt-get install rsync gdb -y
RUN apt-get update && apt-get install -y openssh-server sudo
RUN mkdir /var/run/sshd
RUN echo 'root:aWkoRcrdHzBhRQ' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
