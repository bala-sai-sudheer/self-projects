FROM php:8.2-apache
# Install required PHP extensions
RUN docker-php-ext-install mysqli
# Enable Apache rewrite
RUN a2enmod rewrite
# Set working directory
WORKDIR /var/www/html
# Create upload directory (inside container)
RUN mkdir -p /var/www/html/assets/uploads
# Expose Apache port
EXPOSE 80
# Start Apache (permissions handled by compose command)
CMD ["apache2-foreground"]
