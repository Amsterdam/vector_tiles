from vector_tiles.settings import ENGINE_URL
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import subprocess



def create_new_session():
    engine = create_engine(ENGINE_URL)
    return sessionmaker(bind=engine)()


def tables_from_schema(schema):
    return create_new_session().execute('SELECT table_name FROM information_schema.tables WHERE table_schema = \'{}\''.format(schema))


def ogr2ogr(schema, table):
    call='ogr2ogr -f GeoJSON /tmp/{table}.geojson -s_srs EPSG:28992 -t_srs EPSG:4326 PG:"host=database port=5432 user=\'basiskaart\' dbname=\'basiskaart\' password=\'insecure\'" -sql \'SELECT * FROM {schema}."{table}"\''.format(
        schema=schema,
        table=table
    )
    print(call,)
    subprocess.call(call, shell=True)

def run_import():
    tables = tables_from_schema('bgt')
    for table in tables:
        print(table[0])
        print(ogr2ogr('bgt',table[0]))

