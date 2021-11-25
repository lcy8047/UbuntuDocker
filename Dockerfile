FROM ubuntu:20.04
LABEL maintainer="lcy8047@gmail.com"

# 한글 설정
ENV LC_ALL=C.UTF-8

# 패키지 설치 중 상호작용 방지
ARG DEBIAN_FRONTEND=noninteractive

# 32bit 바이너리실행을 위해
RUN dpkg --add-architecture i386

# update
RUN apt-get -y update

# vim & vimrc
RUN apt-get -y install vim gcc
ADD ./files/home/.vimrc /root/

# 기타 툴
RUN apt-get -y install wget net-tools netcat zip curl nasm qemu

# flex & bison
RUN apt-get -y install flex bison

# run 32bit binary
RUN apt-get -y install libc6:i386 libncurses5:i386 libstdc++6:i386

# bashrc
ADD ./files/home/.bashrc /root/

# libraries
RUN apt-get -y install  build-essential \
                        gcc-multilib \
                        libssl-dev \
                        libffi-dev \
                        libncurses5-dev \
                        libncursesw5-dev

# git
RUN apt-get -y install git

# python2
RUN apt-get -y install python2
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
RUN python2 get-pip.py
RUN rm -f get-pip.py
RUN python2 -m pip install --upgrade pip

# python3
RUN apt-get -y install python3 python3-pip python3-dev
RUN python3 -m pip install --upgrade pip

###############################
#         for pwnable         #
###############################

# pwntool
RUN python2 -m pip install --upgrade pwntools
RUN python3 -m pip install --upgrade pwntools

# 바이너리 분석을 위한 gdb, gdb-peda, pwngdb
# gdb와 peda 구분 실행을 위해 설정추가
RUN apt-get -y install gdb
RUN git clone https://github.com/longld/peda.git ~/peda
RUN git clone https://github.com/scwuaptx/Pwngdb.git ~/Pwngdb
ADD ./files/bin/gdb-peda /bin/
ADD ./files/home/.gdbinit /root/

# 32bit 바이너리 heapinfo를 위해
RUN apt-get -y install libc6-dbg libc6-dbg:i386

# oneshot gadget
RUN apt-get -y install ruby
RUN gem install one_gadget