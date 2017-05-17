
# Stap 1
Maak een lijst met alle aanwezege tabellen

	psql -c "\dt bgt." -d database -U user -W -h host -p port
	psql -c "\dt kbk10." -d database -U user -W -h host -p port
	psql -c "\dt kbk50." -d database -U user -W -h host -p port


# Stap 2 ogr2ogr
Alle tabellen exporteren naar GeoJSON met ogr2ogr. (views van bgt)

Voorbeeld:

	ogr2ogr -f GeoJSON WDL_breed_water.geojson -s_srs EPSG:28992 -t_srs EPSG:4326 PG:"host=localhost port=55432 user=basiskaart_amsterdam dbname=basiskaart_amsterdam password=basiskaart_amsterdam" -sql 'SELECT * FROM kbk10."WDL_breed_water"'

# Stap 3 tippecanoe
Alle GeoJSON bestanden (alle tabellen van de lijst), OP VOLGORDE, met tippecanoe naar vector tiles zetten.

3x doen 
1. KBK50 -z14 -Z11
2. KBK10 -z16 -Z15
3. BGT   -z21 -Z17

Daarna alle tile folders bij elkaar zetten. ( of meteen in datastore met ftp)

Gebruik volgende tippecanoe specs: 
	--force
	--no-tile-size-limit
	--no-feature-limit
	--no-line-simplification
	--no-polygon-splitting
	--detect-shared-borders
	--no-tiny-polygon-reduction
	--preserve-input-order
	--output-to-directory=/data_tiles/kbk10_tiles
	-z16 -Z14
	--named-layer=

Voorbeeld:
	docker run --rm -v `pwd`/data_tiles:/data_tiles niene/tippecanoe \
	--force \
	--no-tile-size-limit \
	--no-feature-limit \
	--no-line-simplification \
	--no-polygon-splitting  \
	--no-tiny-polygon-reduction \
	--preserve-input-order \
	--output-to-directory=/data_tiles/kbk50_tiles_zip2 \
	-z13 -Z8 \
	--named-layer=WDL_wateroppervlak:/data_tiles/kbk50/WDL_wateroppervlak.geojson \
	--named-layer=TRN_agrarisch:/data_tiles/kbk50/TRN_agrarisch.geojson \
	--named-layer=TRN_overig:/data_tiles/kbk50/TRN_overig.geojson \
	--named-layer=TRN_zand:/data_tiles/kbk50/TRN_zand.geojson \
	--named-layer=GBW_bebouwing:/data_tiles/kbk50/GBW_bebouwing.geojson \
	--named-layer=TRN_bedrijfsterrein_dienstverlening:/data_tiles/kbk50/TRN_bedrijfsterrein_dienstverlening.geojson \
	--named-layer=GBW_kassen:/data_tiles/kbk50/GBW_kassen.geojson \
	--named-layer=TRN_bos_groen_sport:/data_tiles/kbk50/TRN_bos_groen_sport.geojson \
	--named-layer=WDL_brede_waterloop:/data_tiles/kbk50/WDL_brede_waterloop.geojson \
	--named-layer=WDL_smalle_waterloop:/data_tiles/kbk50/WDL_smalle_waterloop.geojson \
	--named-layer=WGL_straat_in_tunnel:/data_tiles/kbk50/WGL_straat_in_tunnel.geojson 
	--named-layer=WGL_hoofdweg_in_tunnel:/data_tiles/kbk50/WGL_hoofdweg_in_tunnel.geojson \
	--named-layer=WGL_regionale_weg_in_tunnel:/data_tiles/kbk50/WGL_regionale_weg_in_tunnel.geojson \
	--named-layer=WGL_autosnelweg_in_tunnel:/data_tiles/kbk50/WGL_autosnelweg_in_tunnel.geojson \
	--named-layer=WGL_straat:/data_tiles/kbk50/WGL_straat.geojson \
	--named-layer=WGL_hoofdweg:/data_tiles/kbk50/WGL_hoofdweg.geojson \
	--named-layer=WGL_regionale_weg:/data_tiles/kbk50/WGL_regionale_weg.geojson \
	--named-layer=SBL_metro_sneltram_in_tunnel:/data_tiles/kbk50/SBL_metro_sneltram_in_tunnel.geojson \
	--named-layer=SBL_trein_in_tunnel:/data_tiles/kbk50/SBL_trein_in_tunnel.geojson \
	--named-layer=SBL_metro_sneltram:/data_tiles/kbk50/SBL_metro_sneltram.geojson \
	--named-layer=SBL_trein_ongeelektrificeerd:/data_tiles/kbk50/SBL_trein_ongeelektrificeerd.geojson \
	--named-layer=SBL_trein:/data_tiles/kbk50/SBL_trein.geojson \
	--named-layer=WGL_autosnelweg:/data_tiles/kbk50/WGL_autosnelweg.geojson 