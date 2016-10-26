FROM mikemorris89/mm-rbase

MAINTAINER Mike Morris "Mike.Morris89@gmail.com"

RUN aptitude install -y -t unstable
RUN aptitude install -y -t sudo
RUN aptitude install -y -t gdebi-core
RUN aptitude install -y -t pandoc
RUN aptitude install -y -t pandoc-citeproc
RUN aptitude install -y -t libcurl4-gnutls-dev
RUN aptitude install -y -t libcairo2-dev/unstable
RUN aptitude install -y -t libxt-dev

RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/VERSION -O "version.txt" && \
	VERSION=$(cat version.txt) && \
	wget --no-verbose "https://s3.amazon.com/rstudio-shiny-server-os-build/ubibtu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb

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
