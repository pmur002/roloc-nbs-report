
# Base image
FROM ubuntu:16.04
MAINTAINER Paul Murrell <paul@stat.auckland.ac.nz>

# add CRAN PPA
RUN apt-get update && apt-get install -y apt-transport-https
RUN echo 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial/' > /etc/apt/sources.list.d/cran.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# Install additional software
# R stuff
RUN apt-get update && apt-get install -y \
    xsltproc \
    r-base=3.4* \ 
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    bibtex2html \
    subversion 

# For building the report
RUN Rscript -e 'install.packages(c("knitr", "devtools"), repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("xml2", "1.1.1", repos="https://cran.rstudio.com/")'

# The main report package(s)
RUN Rscript -e 'library(devtools); install_github("pmur002/roloc@v0.1", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_github("pmur002/rolocISCCNBS@v0.1", repos="https://cran.rstudio.com/")'

# Packages used in the report
RUN Rscript -e 'library(devtools); install_github("pmur002/colorscience@v1.0.5", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("colorspace", "1.3-2", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("munsell", "0.4.3", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("aqp", "1.10", repos="https://cran.rstudio.com/")'
# Python package 'colour'
RUN apt-get update && apt-get install -y \
    python \
    python-pip
RUN pip install numpy
RUN pip install scipy
RUN pip install six
RUN pip install colour
RUN Rscript -e 'library(devtools); install_version("reticulate", "1.2", repos="https://cran.rstudio.com/")'
RUN Rscript -e 'library(devtools); install_version("pals", "1.4", repos="https://cran.rstudio.com/")'

# Set locale
RUN apt-get install -y locales && locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
