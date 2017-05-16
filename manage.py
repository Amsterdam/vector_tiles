#!/usr/bin/env python
import sys
from vector_tiles.importer import importer

if __name__ == "__main__":
    if 'run_import' in sys.argv:
           importer.run_import()
    else:
        print("Usage: python manage.py run_import")

