FROM nginx:stable

COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN sed -i -r '/^user\s+nginx;$/d' /etc/nginx/nginx.conf

VOLUME /usr/share/nginx/html

EXPOSE 8080
