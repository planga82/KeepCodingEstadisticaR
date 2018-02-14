#!/bin/bash

apt-get update
apt-get install -y r-base-core curl libssl-dev libcurl4-openssl-dev net-tools python2.7 python-pip python-dev
pip install --upgrade pip
pip install jupyter

R -e "install.packages(c('repr','IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'), repos='https://cran.rstudio.com/')"
R -e "install.packages(c('ggplot2','reshape2','entropy','quantmod'), repos='https://cran.rstudio.com/')"
R -e "devtools::install_github('IRkernel/IRkernel')"
R -e "IRkernel::installspec(user = FALSE)"

mkdir -p /usr/lib/systemd/system/
cat >/usr/lib/systemd/system/jupyter.service <<EOL
     [Unit]
     Description=Jupyter Notebook

     [Service]
     Type=simple
     PIDFile=/run/jupyter.pid
     # Step 1 and Step 2 details are here..
     # # ------------------------------------
     ExecStart=/usr/local/bin/jupyter notebook --notebook-dir=/vagrant --ip="*" --NotebookApp.token=
     User=vagrant
     Group=vagrant
     WorkingDirectory=/vagrant
     Restart=always
     RestartSec=10
     #KillMode=mixed
   
     [Install]
     WantedBy=multi-user.target
EOL
systemctl enable jupyter.service
systemctl daemon-reload
systemctl restart jupyter.service

