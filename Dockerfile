FROM php:7.2-apache
MAINTAINER Ken Williams <kwillia@gmail.com>

RUN	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get -y upgrade && \
	apt-get -y install git curl libpng-dev mariadb-client && \
	apt-get -y install libmcrypt-dev && \
	pecl install mcrypt-1.0.1 && \
	docker-php-ext-install mysqli pdo pdo_mysql && \
	docker-php-ext-install gd && \
	mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
	echo 'extension=mcrypt.so' >> "$PHP_INI_DIR/php.ini" && \
	cd /var/www/ && \
	rm -f html/index.html && \
	git clone https://github.com/s3inlc/hashtopolis.git && \
	mv hashtopolis/src/* html/ && \
	#mv /var/www/html/inc /var/www && \
	#mkdir /var/www/html/inc && \
	mkdir -p /var/www/html/inc/utils/locks && \
	chown -R www-data:www-data /var/www/html && \
	echo "ServerName Hashtopolis" > /etc/apache2/conf-enabled/serverName.conf && \
	rm -rf /var/lib/apt-get /var/lib/dpkg /var/cache/apt-get /usr/share/doc /usr/share/man /usr/share/info

# need to increase the php max file upload size
#upload
RUN echo "file_uploads = On\n" \
         "memory_limit = 1024M\n" \
         "upload_max_filesize = 1024M\n" \
         "post_max_size = 1024M\n" \
         "max_execution_time = 600\n" \
         > /usr/local/etc/php/conf.d/uploads.ini
WORKDIR /var/www/html

COPY start_hashtopolis.sh /usr/local/bin
RUN chmod u+x /usr/local/bin/start_hashtopolis.sh
RUN rm -rf /var/www/html/install

EXPOSE 80
#CMD ["apache2-foreground"]
CMD ["start_hashtopolis.sh"]
