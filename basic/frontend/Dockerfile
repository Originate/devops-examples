FROM nginx:stable-alpine

COPY src /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN sed -i -r '/^user\s+nginx;$/d' /etc/nginx/nginx.conf

# uid/gid 101 is nginx
# USER 101:101

EXPOSE 8080
