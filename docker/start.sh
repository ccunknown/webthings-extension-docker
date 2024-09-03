#!/bin/bash

# Start Redis server in the background
redis-server &

# Start the main application
exec /init.sh
