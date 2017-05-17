# vector_tiles

## Setup env
	virtualenv -p /usr/local/bin/python3 ~/venv/vector_tiles
    source ~/venv/vector_tiles/bin/activate
    
## Start generating the geojson

    docker-compose up -d --build 

## start generating the vector tiles using tippecanoe

    see import.sh
    