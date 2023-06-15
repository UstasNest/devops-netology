FROM centos:7

WORKDIR /tmp
RUN yum -y update && \
    yum install mc make gcc openssl-devel libffi-devel bzip2-devel gcc wget tar perl \
                epel-release zlib-devel bzip2 readline-devel sqlite sqlite-devel  tk-devel  xz-devel -y

RUN wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz --no-check-certificate && \
    tar -xvf openssl-1.1.1g.tar.gz && rm -f openssl-1.1.1g.tar.gz && \
    cd openssl-1.1.1g && ./config --prefix=/usr --openssldir=/usr && make && make install && \
    rm -rf openssl-1.1.1g

RUN wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz && \
    tar -xvf Python-3.10.4.tgz && rm -f Python-3.10.4.tgz && \
    cd Python-3.10.4 && ./configure --enable-optimizations --with-openssl=/usr && make install && \
    rm -rf Python-3.10.4
RUN rm -rf /tmp/* && yum clean all && rm -rf /var/cache/yum

WORKDIR /opt

RUN mkdir python_api
COPY requirements.txt requirements.txt
RUN python3 -m pip install -r requirements.txt

COPY python-api.py /opt/python_api/python-api.py
CMD ["python3","/opt/python_api/python-api.py"]

EXPOSE 5290
