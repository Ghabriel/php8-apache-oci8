###########################################
# CONTAINER: APACHE + PHP + OCI8
###########################################
FROM php:8.1.1-apache

RUN apt-get update \
    && apt-get install -y unzip libaio1 \
    && apt-get clean -y

ADD ./oracle/instantclient-basiclite-linux.x64-12.2.0.1.0.zip /tmp/
ADD ./oracle/instantclient-sdk-linux.x64-12.2.0.1.0.zip /tmp/

RUN unzip /tmp/instantclient-basiclite-linux.x64-12.2.0.1.0.zip -d /usr/local/ \
    && unzip /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /usr/local/

# install oci8
RUN ln -s /usr/local/instantclient_12_2 /usr/local/instantclient \
    && ln -s /usr/local/instantclient/libclntsh.so.12.1 /usr/local/instantclient/libclntsh.so \
    && echo 'instantclient,/usr/local/instantclient' | pecl install oci8

ENV LD_LIBRARY_PATH /usr/local/instantclient_12_2/

COPY ./conf/php.ini /usr/local/etc/php/

EXPOSE 80 443
