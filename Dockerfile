FROM ubuntu:16.04

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    ipython \
    vim \
    net-tools \
    iputils-ping \
    libffi-dev \
    libssl-dev \
    python-dev \
    python3-dev \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    radare2 \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file \
    bison --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    angr

RUN pip install --upgrade setuptools && \
    pip install --no-cache-dir \
    ropgadget \
    pwntools \
    zio \
    smmap2 \
    z3-solver \
    apscheduler && \
    pip install --upgrade pwntools

RUN wget https://raw.githubusercontent.com/inaz2/roputils/master/roputils.py && \
    mv roputils.py /usr/lib/python2.7/

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

RUN git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg && chmod +x setup.sh && ./setup.sh

RUN git clone https://github.com/scwuaptx/Pwngdb.git /root/Pwngdb && \
    cd /root/Pwngdb && cat /root/Pwngdb/.gdbinit  >> /root/.gdbinit && \
    sed -i "s?source ~/peda/peda.py?# source ~/peda/peda.py?g" /root/.gdbinit

RUN git clone https://github.com/niklasb/libc-database.git libc-database && \
    cd libc-database && ./get || echo "/libc-database/" > ~/.libcdb_path

RUN git clone https://github.com/matrix1001/welpwn && \
    cd welpwn && python setup.py install

RUN git clone https://github.com/lieanu/LibcSearcher && \
    cd LibcSearcher && python setup.py develop

RUN git clone https://github.com/matrix1001/heapinspect

WORKDIR /ctf/work/

COPY --from=skysider/glibc_builder64:2.19 /glibc/2.19/64 /glibc/2.19/64
COPY --from=skysider/glibc_builder32:2.19 /glibc/2.19/32 /glibc/2.19/32

COPY --from=skysider/glibc_builder64:2.23 /glibc/2.23/64 /glibc/2.23/64
COPY --from=skysider/glibc_builder32:2.23 /glibc/2.23/32 /glibc/2.23/32

COPY --from=skysider/glibc_builder64:2.24 /glibc/2.24/64 /glibc/2.24/64
COPY --from=skysider/glibc_builder32:2.24 /glibc/2.24/32 /glibc/2.24/32

COPY --from=skysider/glibc_builder64:2.28 /glibc/2.28/64 /glibc/2.28/64
COPY --from=skysider/glibc_builder32:2.28 /glibc/2.28/32 /glibc/2.28/32

COPY --from=skysider/glibc_builder64:2.29 /glibc/2.29/64 /glibc/2.29/64
COPY --from=skysider/glibc_builder32:2.29 /glibc/2.29/32 /glibc/2.29/32

COPY linux_server linux_server64  /ctf/

CMD ["sleep", "infinity"]
