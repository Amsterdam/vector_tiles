#!/bin/sh

set -e
set -u

DIR="$(dirname $0)"

dc() {
	docker-compose -p vector_tiles -f ${DIR}/docker-compose.yml $*
}

trap 'dc kill ; dc rm -f' EXIT

# start database
dc up -d --build database
sleep 10

# create dirs
mkdir -p /tmp/bgt
mkdir -p /tmp/kbk10
mkdir -p /tmp/kbk50

# import basiskaart db
dc exec database update-db.sh basiskaart

# generate geojson
dc run --rm importer

# generate tiles - bgt
dc run --rm tippecanoe \
	--force \
	--no-tile-size-limit \
	--no-feature-limit \
	--no-line-simplification \
	--no-polygon-splitting  \
	--no-tiny-polygon-reduction \
	--preserve-input-order \
	--output-to-directory=/data_tiles/bgt_tiles_zip2 \
	-z21 -Z17 \
	--named-layer=water:/data_tiles/bgt/waterdeel_vlak0.geojson \
	--named-layer=terrein0:/data_tiles/bgt/terreindeel_vlak0.geojson \
	--named-layer=overbruggingsdeel:/data_tiles/bgt/BGT_ODL_overbruggingsdeel.geojson \
	--named-layer=wegdeel_vlak0:/data_tiles/bgt/wegdeel_vlak0.geojson \
	--named-layer=inrichtingselement_vlak0:/data_tiles/bgt/inrichtingselement_vlak0.geojson\
	--named-layer=spoor_lijn0:/data_tiles/bgt/spoor_lijn0.geojson\
	--named-layer=gebouwen0:/data_tiles/bgt/gebouw_vlak0.geojson \
	--named-layer=wegdeel_vlak_1:/data_tiles/bgt/wegdeel_vlak_1.geojson \
	--named-layer=terrein1:/data_tiles/bgt/terreindeel_vlak1.geojson \
	--named-layer=wegdeel_vlak1:/data_tiles/bgt/wegdeel_vlak1.geojson \
	--named-layer=inrichtingselement_vlak1:/data_tiles/bgt/inrichtingselement_vlak1.geojson \
	--named-layer=gebouwen1:/data_tiles/bgt/gebouw_vlak1.geojson \
	--named-layer=terrein2:/data_tiles/bgt/terreindeel_vlak2.geojson \
	--named-layer=wegdeel_vlak2:/data_tiles/bgt/wegdeel_vlak2.geojson \
	--named-layer=inrichtingselement_vlak2:/data_tiles/bgt/inrichtingselement_vlak2.geojson \
	--named-layer=gebouwen2:/data_tiles/bgt/gebouw_vlak2.geojson \
	--named-layer=terrein3:/data_tiles/bgt/terreindeel_vlak3.geojson \
	--named-layer=wegdeel_vlak3:/data_tiles/bgt/wegdeel_vlak3.geojson \
	--named-layer=gebouwen3:/data_tiles/bgt/gebouw_vlak3.geojson \
	--named-layer=terrein4:/data_tiles/bgt/terreindeel_vlak4.geojson \
	--named-layer=gebouwen4:/data_tiles/bgt/gebouw_vlak4.geojson \
	--named-layer=spoor_lijn_2:/data_tiles/bgt/spoor_lijn_2.geojson \
	--named-layer=spoor_lijn_1:/data_tiles/bgt/spoor_lijn_1.geojson

# generate tiles - kbk10
dc run --rm tippecanoe \
    --force \
	--no-tile-size-limit \
	--no-feature-limit \
	--no-line-simplification \
	--no-polygon-splitting  \
	--no-tiny-polygon-reduction \
	--preserve-input-order \
	--output-to-directory=/data_tiles/kbk10_tiles_zip2 \
	-z16 -Z14 \
	--named-layer=water:/data_tiles/kbk10/WDL_breed_water.geojson \
	--named-layer=haven:/data_tiles/kbk10/WDL_haven.geojson \
	--named-layer=terein_aanlegsteiger:/data_tiles/kbk10/TRN_aanlegsteiger.geojson \
	--named-layer=terein_basaltblokken_steenglooiing:/data_tiles/kbk10/TRN_basaltblokken_steenglooiing.geojson \
	--named-layer=terein_grasland:/data_tiles/kbk10/TRN_grasland.geojson \
	--named-layer=terein_akkerland:/data_tiles/kbk10/TRN_akkerland.geojson \
	--named-layer=terein_overig:/data_tiles/kbk10/TRN_overig.geojson \
	--named-layer=terein_bedrijfsterrein:/data_tiles/kbk10/TRN_bedrijfsterrein.geojson \
	--named-layer=terein_openbaar_groen:/data_tiles/kbk10/TRN_openbaar_groen.geojson \
	--named-layer=terein_zand:/data_tiles/kbk10/TRN_zand.geojson \
	--named-layer=startbaan_landingsbaan:/data_tiles/kbk10/WGL_startbaan_landingsbaan.geojson \
	--named-layer=terein_spoorbaanlichaam:/data_tiles/kbk10/TRN_spoorbaanlichaam.geojson \
	--named-layer=terein_bos-loofbos:/data_tiles/kbk10/TRN_bos-loofbos.geojson \
	--named-layer=terein_bos-naaldbos:/data_tiles/kbk10/TRN_bos-naaldbos.geojson \
	--named-layer=terein_bos-gemengd_bos:/data_tiles/kbk10/TRN_bos-gemengd_bos.geojson \
	--named-layer=terein_bos-griend:/data_tiles/kbk10/TRN_bos-griend.geojson \
	--named-layer=terein_boomgaard:/data_tiles/kbk10/TRN_boomgaard.geojson \
	--named-layer=terein_boomkwekerij:/data_tiles/kbk10/TRN_boomkwekerij.geojson \
	--named-layer=terein_dodenakker:/data_tiles/kbk10/TRN_dodenakker.geojson \
	--named-layer=terein_dodenakker_met_bos:/data_tiles/kbk10/TRN_dodenakker_met_bos.geojson \
	--named-layer=terein_fruitkwekerij:/data_tiles/kbk10/TRN_fruitkwekerij.geojson \
	--named-layer=gebouwen_overdekt:/data_tiles/kbk10/GBW_overdekt.geojson \
	--named-layer=gebouwen:/data_tiles/kbk10/GBW_gebouw.geojson \
	--named-layer=gebouwen_hoogbouw:/data_tiles/kbk10/GBW_hoogbouw.geojson \
	--named-layer=gebouwen_kassen:/data_tiles/kbk10/GBW_kas_warenhuis.geojson \
	--named-layer=terein_binnentuin:/data_tiles/kbk10/TRN_binnentuin.geojson \
	--named-layer=waterbassin:/data_tiles/kbk10/WDL_waterbassin.geojson \
	--named-layer=water_breed:/data_tiles/kbk10/WDL_smal_water_3_tot_6m.geojson \
	--named-layer=water_smal:/data_tiles/kbk10/WDL_smal_water_tot_3m.geojson \
	--named-layer=tunnelcontour:/data_tiles/kbk10/KRT_tunnelcontour.geojson \
	--named-layer=aanlegsteiger_smal:/data_tiles/kbk10/IRT_aanlegsteiger_smal.geojson \
	--named-layer=weg_smalle_weg:/data_tiles/kbk10/WGL_smalle_weg.geojson \
	--named-layer=SBL_metro_overdekt:/data_tiles/kbk10/SBL_metro_overdekt.geojson \
	--named-layer=SBL_tram_overdekt:/data_tiles/kbk10/SBL_tram_overdekt.geojson \
	--named-layer=SBL_trein_overdekt_1sp:/data_tiles/kbk10/SBL_trein_overdekt_1sp.geojson \
	--named-layer=SBL_trein_overdekt_nsp:/data_tiles/kbk10/SBL_trein_overdekt_nsp.geojson \
	--named-layer=SBL_metro_nietoverdekt_1sp:/data_tiles/kbk10/SBL_metro_nietoverdekt_1sp.geojson \
	--named-layer=SBL_metro_nietoverdekt_nsp:/data_tiles/kbk10/SBL_metro_nietoverdekt_nsp.geojson \
	--named-layer=SBL_tram_nietoverdekt:/data_tiles/kbk10/SBL_tram_nietoverdekt.geojson \
	--named-layer=SBL_trein_ongeelektrificeerd:/data_tiles/kbk10/SBL_trein_ongeelektrificeerd.geojson \
	--named-layer=SBL_trein_nietoverdekt_1sp:/data_tiles/kbk10/SBL_trein_nietoverdekt_1sp.geojson \
	--named-layer=SBL_trein_nietoverdekt_nsp:/data_tiles/kbk10/SBL_trein_nietoverdekt_nsp.geojson \
	--named-layer=weg_hartlijn:/data_tiles/kbk10/WGL_hartlijn.geojson

# generate tiles - kbk50
dc run --rm tippecanoe \
	--force \
	--no-tile-size-limit \
	--no-feature-limit \
	--no-line-simplification \
	--no-polygon-splitting  \
	--no-tiny-polygon-reduction \
	--preserve-input-order \
	--output-to-directory=/data_tiles/kbk50_tiles_zip2 \
	-z13 -Z8 \
	--named-layer=water:/data_tiles/kbk50/WDL_wateroppervlak.geojson \
	--named-layer=terein_agrarisch:/data_tiles/kbk50/TRN_agrarisch.geojson \
	--named-layer=terein_overig:/data_tiles/kbk50/TRN_overig.geojson \
	--named-layer=terein_zand:/data_tiles/kbk50/TRN_zand.geojson \
	--named-layer=gebouwen:/data_tiles/kbk50/GBW_bebouwing.geojson \
	--named-layer=terein_bedrijfsterrein_dienstverlening:/data_tiles/kbk50/TRN_bedrijfsterrein_dienstverlening.geojson \
	--named-layer=gebouwen_kassen:/data_tiles/kbk50/GBW_kassen.geojson \
	--named-layer=terein_bos_groen_sport:/data_tiles/kbk50/TRN_bos_groen_sport.geojson \
	--named-layer=water_breed:/data_tiles/kbk50/WDL_brede_waterloop.geojson \
	--named-layer=water_smal:/data_tiles/kbk50/WDL_smalle_waterloop.geojson \
	--named-layer=weg_straat_in_tunnel:/data_tiles/kbk50/WGL_straat_in_tunnel.geojson \
	--named-layer=weg_hoofdweg_in_tunnel:/data_tiles/kbk50/WGL_hoofdweg_in_tunnel.geojson \
	--named-layer=weg_regionale_weg_in_tunnel:/data_tiles/kbk50/WGL_regionale_weg_in_tunnel.geojson \
	--named-layer=weg_autosnelweg_in_tunnel:/data_tiles/kbk50/WGL_autosnelweg_in_tunnel.geojson \
	--named-layer=weg_straat:/data_tiles/kbk50/WGL_straat.geojson \
	--named-layer=weg_hoofdweg:/data_tiles/kbk50/WGL_hoofdweg.geojson \
	--named-layer=weg_regionale_weg:/data_tiles/kbk50/WGL_regionale_weg.geojson \
	--named-layer=SBL_metro_sneltram_in_tunnel:/data_tiles/kbk50/SBL_metro_sneltram_in_tunnel.geojson \
	--named-layer=SBL_trein_in_tunnel:/data_tiles/kbk50/SBL_trein_in_tunnel.geojson \
	--named-layer=SBL_metro_sneltram:/data_tiles/kbk50/SBL_metro_sneltram.geojson \
	--named-layer=SBL_trein_ongeelektrificeerd:/data_tiles/kbk50/SBL_trein_ongeelektrificeerd.geojson \
	--named-layer=SBL_trein:/data_tiles/kbk50/SBL_trein.geojson \
	--named-layer=weg_autosnelweg:/data_tiles/kbk50/WGL_autosnelweg.geojson