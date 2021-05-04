FROM nginx:stable-alpine

RUN rm -rf /usr/share/nginx/html/* && \
    sed -i -r '/^user\s+nginx;$/d' /etc/nginx/nginx.conf && \
    chown 101:101 /var/cache/nginx /var/run

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY src /usr/share/nginx/html

# uid/gid 101 is nginx
USER 101:101

EXPOSE 8080
