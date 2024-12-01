#!/bin/sh
find server/ -type d -exec find {} -name "*.py" \; | entr -n -r celery -A server worker -l info --concurrency=1 -n "$1" -Q "$2"
