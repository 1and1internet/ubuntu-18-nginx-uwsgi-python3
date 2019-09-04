#!/usr/bin/env bash

tail -F /var/log/nginx/access.log /var/log/nginx/error.log || exit 0
