#================================================================================================================================================================
# Option 1: Lightweight container image based on nginx:apline --> size ~ 24 MB
# Smaller images are more efficient in terms of buiding time, memory requirments, and security (less number of vulnerable components) 

FROM nginx:alpine
LABEL maintainer="Ali Alshawish <ali.alshawish@protonmail.com>"

# install prerequisites
# create non-root user/group first
RUN addgroup -S www-tmh \
  && adduser -S -D -H -s /sbin/nologin -G www-tmh www-tmh\
  && mkdir -p /opt/html \
  && apk --no-cache add curl
  # --no-cache replaces apk update && rm -rf /var/cache/apk/* to avoid caching index locally

# Configure server block to map requests to "/opt/html" directory and listen to a configurable port
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/webdefault.conf /etc/nginx/conf.d/default.conf

# Running nginx as non-root user 'www-tmh' requires changing ownership of the following:
RUN touch /var/run/nginx.pid && \
  chown -R www-tmh:www-tmh /var/run/nginx.pid && \
  chown -R www-tmh:www-tmh /var/cache/nginx && \
  chown -R www-tmh:www-tmh /etc/nginx

# Copy local static files to the container host folder
COPY html/index.html /opt/html/

# Specify a non-root user for the container to run as. An existing user such as "nginx" or "www-data" can be used, but
# we can also create a new group and user using `groupadd` and `useradd` as done above. 
USER www-tmh

# Substitue the container port `${CPORT}` used in default.conf with corresponding environment value passed at runtime using shell form for variable substitution 
CMD sed -i -e "s/\${CPORT}/$CPORT/" /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'

# #================================================================================================================================================================
# # Option 2: Container image based on Ubuntu --> size ~ 180 MB
# FROM ubuntu:latest
# #FROM nginx:latest
# LABEL maintainer="Ali Alshawish <ali.alshawish@protonmail.com>"

# # install prerequisites
# # create non-root user/group first
# RUN addgroup --system www-tmh \
#   && adduser --system --disabled-login --ingroup www-tmh --no-create-home www-tmh \
#   && apt update && apt install -y \
#   curl gettext-base nginx \
#   && rm -rf /var/lib/apt/lists/* \
#   && mkdir -p /opt/html

# # Configure server block to map requests to "/opt/html" directory and listen to a configurable port
# COPY config/nginx.conf /etc/nginx/nginx.conf
# COPY config/webdefault.conf /etc/nginx/conf.d/default.conf

# # Running nginx as non-root user 'www-data' requires changing ownership of the following:
# RUN touch /var/run/nginx.pid && \
#   chown -R www-tmh:www-tmh /var/run/nginx.pid && \
#   chown -R www-tmh:www-tmh /var/lib/nginx && \
#   chown -R www-tmh:www-tmh /var/log/nginx && \
#   chown -R www-tmh:www-tmh /etc/nginx

# # Copy local static files to the container host folder
# COPY config/index.html /opt/html/

# # Specify a non-root user for the container to run as. An existing user "www-data" is selected, but
# # we can also create a new group and user using `groupadd` and `useradd` 
# USER www-tmh
# # Substitue the container port `${CPORT}` used in default.conf with corresponding environment value passed at runtime 
# # Select one: two options are possible with `sed` or `envsubst`
# #1#CMD sed -i -e "s/\${CPORT}/$CPORT/" /etc/nginx/conf.d/default.conf && /usr/sbin/nginx -g 'daemon off;'
# #2#
# CMD envsubst < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/webdefault.conf && mv /etc/nginx/conf.d/webdefault.conf /etc/nginx/conf.d/default.conf && /usr/sbin/nginx -g 'daemon off;'

