# -*- coding: utf-8 -*-

import os

DATA_DIR = '/home'
DEFAULT_SERVER = '0.0.0.0'
DEFAULT_SERVER_PORT = int(os.getenv('PGADMIN_PORT', 5050))
LOG_FILE = '/home/log/pgadmin4.log'
SESSION_DB_PATH = os.path.join(DATA_DIR, 'sessions')
SQLITE_PATH = os.path.join(DATA_DIR, 'config', 'pgadmin4.db')
STORAGE_DIR = os.path.join(DATA_DIR, 'storage')

DEFAULT_BINARY_PATHS = {
    "pg":   "/usr/bin",
    "ppas": "/usr/bin",
    "gpdb": "/usr/bin"
}
