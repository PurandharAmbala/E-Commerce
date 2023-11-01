FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    php php-mysql php-json php-gd php-mbstring php-zip php-curl \
    php8.1-xml php8.1-zip php8.1-gd php8.1-intl php8.1-pdo \
    apache2 mysql-server git vim composer
RUN rm /var/www/html/index.html
RUN git clone https://github.com/vijaybobbili31/E-Commerce.git /var/www/html/E-Commerce
RUN service mysql start && \
    mysql -u root -e "CREATE DATABASE ecommerce_marolix;" && \
    mysql -u root ecommerce_marolix < /var/www/html/E-Commerce/database/database/ecommerce_marolix.sql
RUN mv /var/www/html/E-Commerce/E-commerce-7June/.env.example /var/www/html/E-Commerce/E-commerce-7June/.env && \
    cd /var/www/html/E-Commerce/E-commerce-7June && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    mv composer.phar /usr/local/bin/composer
RUN cd /var/www/html/E-Commerce/E-commerce-7June && \
    composer update
RUN apt-get install -y php-curl php-mysqli php-zip php-gd php8.1-xml
RUN a2enmod rewrite && \
    service apache2 restart
RUN cd /var/www/html/E-Commerce/E-commerce-7June && \
    php artisan key:generate
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
