#!/bin/bash
/usr/local/bin/gunicorn --workers 4 --worker-class gevent --log-config logging.conf --timeout 120 -b :8000 gapp:app