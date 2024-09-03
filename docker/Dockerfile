FROM webthingsio/gateway:1.1.0

# Install Redis
USER root
RUN apt-get update || apt-get install -y redis-server && \
    sed -i '/appendfsync everysec/s/^/# /g' /etc/redis/redis.conf && \
    sed -i '/appendfsync no/s/^# //g' /etc/redis/redis.conf

# Configure Redis if needed (example: copy custom redis.conf)
# COPY redis.conf /etc/redis/redis.conf

# Initial addons directory.
USER node
WORKDIR /home/node
RUN mkdir extensions

# Install Lime extension
USER node
WORKDIR /home/node/extensions
RUN git clone https://github.com/ccunknown/lime-extension && \
    cd lime-extension && \
    rm -rf node_modules && \
    npm ci

# Install Turnip extension
USER node
WORKDIR /home/node/extensions
RUN git clone https://github.com/ccunknown/turnip-extension && \
    cd turnip-extension && \
    rm -rf node_modules && \
    npm ci

# Patch run-app.sh file.
#   Add command to create addons directory and copy extension to place.
COPY --chown=node:node run-app.sh /home/node/webthings/gateway/

# Patch default.js.
#   Change port and disable tunnel.
COPY --chown=node:node default.js /home/node/webthings/gateway/config/

# Ensure Redis runs in the background when the container starts
# This can be achieved by running Redis in the background before starting the main application
COPY --chown=node:node ./start.sh /
# RUN chmod +x /usr/local/bin/start.sh

# Change to root user and restore entrypoint
USER root
ENTRYPOINT ["/start.sh"]

