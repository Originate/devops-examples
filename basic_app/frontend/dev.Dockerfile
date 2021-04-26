FROM nginx:stable

RUN rm -rf /usr/share/nginx/html/* && \
    sed -i -r '/^user\s+nginx;$/d' /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

VOLUME /usr/share/nginx/html

EXPOSE 8080
