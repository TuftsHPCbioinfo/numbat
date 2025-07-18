FROM rocker/tidyverse:4.5.0

RUN apt-get update --yes && apt-get install --yes build-essential \
  libcurl4-gnutls-dev libxml2-dev libssl-dev libbz2-dev zlib1g-dev \
  libfontconfig1-dev libharfbuzz-dev libfribidi-dev \
  libncurses5-dev libncursesw5-dev liblzma-dev libgit2-dev \
  libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
  libglpk-dev git autoconf gettext libtool automake  \
  samtools sudo

RUN cd /usr/bin && \
  wget https://github.com/samtools/htslib/releases/download/1.15.1/htslib-1.15.1.tar.bz2 && \
  tar -vxjf htslib-1.15.1.tar.bz2 && cd htslib-1.15.1 && make && sudo make install

RUN R -e 'chooseCRANmirror(ind=42); install.packages("BiocManager")'

RUN R -e 'chooseCRANmirror(ind=42); install.packages("ragg")'

RUN R -e 'chooseCRANmirror(ind=42); install.packages("pkgdown")'

RUN R -e 'chooseCRANmirror(ind=42); install.packages("devtools")'

RUN R -e 'devtools::install_github("YuLab-SMU/ggtree", dependencies=TRUE)'

RUN R -e 'devtools::install_github("kharchenkolab/numbat", dependencies=TRUE)'

RUN git clone https://github.com/kharchenkolab/numbat.git

RUN mkdir -p /tmp && chmod 777 /tmp

RUN chmod 777 /numbat/inst/bin/pileup_and_phase.R 


RUN mkdir data


RUN git clone https://github.com/single-cell-genetics/cellsnp-lite.git && cd cellsnp-lite && \
  autoreconf -iv && ./configure && make && sudo make install    

RUN wget -q https://storage.googleapis.com/broad-alkesgroup-public/Eagle/downloads/Eagle_v2.4.1.tar.gz && cd .. && tar -xvzf Eagle_v2.4.1.tar.gz && cd /Eagle_v2.4.1 && cp eagle /usr/bin


WORKDIR /numbat
