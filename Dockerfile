FROM mikemorris89/mm-rbase

MAINTAINER Mike Morris "Mike.Morris89@gmail.com"
RUN echo "force rebuild 001.000"
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
RUN echo "LANG=en_US.UTF-8" >> /etc/default/locale
RUN sh -c "echo 'LC_ALL=en_US.UTF-8\nLANG=en_US.UTF-8' >> /etc/environment"

RUN apt-get update -y
RUN apt-get install -y -t unstable 
RUN apt-get update -y
RUN apt-get install -y sudo 
RUN apt-get install -y gdebi-core 
RUN apt-get install -y pandoc 
RUN apt-get install -y pandoc-citeproc  
RUN apt-get install -y libcurl4-gnutls-dev 
RUN apt-get install -y libcairo2-dev/unstable 
RUN apt-get install -y libxt-dev

RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
	VERSION=$(cat version.txt) && \
	wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb

RUN gdebi -n ss-latest.deb

RUN rm -f version txt ss-latest.deb

RUN R -e "install.packages('shiny', dep=T, repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('rmarkdown', dep=T, repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('shinyjs', dep=T, repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('shinydashboard', dep=T, repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('data.table', dep=T, repos='https://cran.rstudio.com/')"
RUN R -e "install.packages('plotly', dep=T, repos='https://cran.rstudio.com/')"


EXPOSE 3838

VOLUME /srv/shiny-server

RUN chown -R shiny /srv/shiny-server/

COPY shiny-server.sh /usr/bin/shiny-server.sh
COPY shiny-server.sh /etc/service/shiny-server/run
RUN chmod +x /etc/service/shiny-server/run

RUN touch /var/log/shiny-server.log
RUN chown shiny /var/log/shiny-server.log
RUN chown -R shiny /var/log/shiny-server/


CMD ["/usr/bin/shiny-server.sh"]
