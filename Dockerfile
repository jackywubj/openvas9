FROM kalilinux/kali-linux-docker
RUN echo "deb http://mirrors.aliyun.com/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
echo "deb-src http://mirrors.aliyun.com/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list
RUN echo  "[global]" > /etc/pip.conf && \
echo  "trusted-host=mirrors.aliyun.com" >> /etc/pip.conf && \
echo  "index-url=http://mirrors.aliyun.com/pypi/simple" >> /etc/pip.conf
RUN apt-get update && apt-get install -y openvas curl
RUN openvas-setup > /opt/openvas-setup.log
RUN apt-get install -y redis && \
    sed -i -e 's/port 0/port 6379/' /etc/redis/redis.conf && \
    openvasmd --user=admin --new-password=admin1234
ADD start_openvas.sh /start_openvas.sh
EXPOSE 9392 9390 80
WORKDIR  /root
ENV LANG=en_US.UTF-8
ENTRYPOINT ["/start_openvas.sh"]
