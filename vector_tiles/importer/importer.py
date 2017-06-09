from vector_tiles.settings import ENGINE_URL, DATABASES
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import logging
import subprocess


log = logging.getLogger(__name__)


def create_new_session():
    log.debug("DB URL:", ENGINE_URL)
    engine = create_engine(ENGINE_URL)
    return sessionmaker(bind=engine)()


def tables_from_schema(schema):
    return create_new_session().execute('SELECT table_name FROM information_schema.tables WHERE table_schema = \'{}\''.format(schema))


def materialized_views_from_schema(schema):
    return create_new_session().execute('set search_path=\'{}\';SELECT oid::regclass::text FROM pg_class WHERE relkind = \'m\';'.format(schema))


def ogr2ogr(schema, table):
    """
    ogr2ogr is very sensitive for the correct quotes
    :param schema:
    :param table:
    :return:
    """
    database=DATABASES['default']
    source = 'PG:"host={database} port={port} user=\'{user}\' dbname=\'{dbname}\' password=\'{password}\'"'.format(
        database=database['HOST'],
        port=database['PORT'],
        dbname=database['NAME'],
        user=database['USER'],
        password=database['PASSWORD'],
    )
    target = '/mnt/geojson/{schema}/{table}.geojson'.format(
        table=table,
        schema=schema
    )
    sql = '\'SELECT * FROM {schema}."{table}"\''.format(
        table=table,
        schema=schema
    )
    call = 'ogr2ogr -f GeoJSON {target} -s_srs EPSG:28992 -t_srs EPSG:4326 {source} -sql {sql}'.format(
        sql=sql,
        source=source,
        target=target,
    )
    log.debug(call,)
    subprocess.call(call, shell=True)


def run_import():
    import_schema('bgt', tables_from_schema('bgt'))
    import_schema('bgt', materialized_views_from_schema('bgt'))
    import_schema('kbk10', tables_from_schema('kbk10'))
    import_schema('kbk50', tables_from_schema('kbk50'))


def import_schema(schema, tables):
    for table in tables:
        log.debug('Processing schema {}, table {}', schema, table[0])
        log.debug(ogr2ogr(schema,table[0]))
