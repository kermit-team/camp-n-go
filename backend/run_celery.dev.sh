#!/bin/sh
celery -A server beat -l info --scheduler celery.beat.Scheduler
