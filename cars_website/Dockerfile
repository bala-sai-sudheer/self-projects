FROM nginx:stable-alpine-perl
MAINTAINER Sudheer <sudheer@gmail.com>
LABEL Luxury Car Website
COPY index.html /usr/share/nginx/html/
COPY style.css /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
