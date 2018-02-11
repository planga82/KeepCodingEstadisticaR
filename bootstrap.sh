#!/bin/bash

apt-get update
apt-get install -y r-base jupyter-notebook curl libssl-dev libcurl4-openssl-dev net-tools
ln -s /usr/bin/jupyter-notebook /usr/bin/jupyter
R -e "install.packages(c('repr','IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'), repos='https://cran.rstudio.com/')"
R -e "install.packages(c('ggplot','reshape2','entropy'), repos='https://cran.rstudio.com/')"
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
     ExecStart=/usr/bin/jupyter-notebook --config=/vagrant --ip=0.0.0.0
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

