# Para construir la imagen:
# docker build -t estadistica .
# Para ejecutar el docker:
# docker run -it -p 8888:8888 -v "$PWD":/mnt estadistica 

FROM r-base:latest

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        python \
        python-pip \
        curl \
        libssl-dev \
        libcurl4-openssl-dev \
        python-dev \       
        python-setuptools \ 
        && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install jupyter

RUN R -e "install.packages(c('repr','IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'), repos='https://cran.rstudio.com/')"
RUN R -e "install.packages(c('ggplot2','reshape2','entropy','quantmod'), repos='https://cran.rstudio.com/')"
RUN R -e "devtools::install_github('IRkernel/IRkernel')"
RUN R -e "IRkernel::installspec(user = FALSE)"


CMD /usr/local/bin/jupyter notebook --allow-root --notebook-dir=/mnt --ip="*" --NotebookApp.token=
