#!/bin/bash

. /usr/local/Reductor/etc/const
. $CONFIG

# удаляем сгенерированные в прошлый раз зоны
named_cleanup_start() {
    mkdir -p $NAMED_OUTPUT_DIR
    rm -f $ZONE_CONF.tmp
    rm -f $ZONE_DB.tmp
    rm -f $ZONE_CONF.process
}

# чистим после себя
named_cleanup_end() {
    mv -f $ZONE_CONF.tmp $ZONE_CONF
    mv -f $ZONE_DB.tmp $ZONE_DB

    rm -f $ZONE_CONF.tmp
    rm -f $ZONE_DB.tmp
    rm -f $ZONE_CONF.process
}

# с кириллическими доменами пока что проблема, вообще здесь избавляемся от дублирования из-за fqdn/www.
named_process_list() {
    sed 's/\.$//' | sed -e 's/^www\.//' | python -u $TMPL_DIR/idna_fix.py | sort -u
}

named_generate_zones() {
    while read domain; do
        echo 'zone "'${domain//_/-}'" { type master; file "/usr/local/etc/namedb/reductor.db"; };'
    done > $ZONE_CONF.tmp
    m4 -Udnl -D__domain__=${NS_GLOBAL:-denypage.ru} -D__ip__=${filter['dns_ip']} $TMPL_DIR/reductor_named_domain.tmplt >> $ZONE_DB.tmp
}

client_prepare_hook() {
    local TMPL_DIR=$HOOKDIR/named_tmpl

    local HTTPS_RESOLV_FILE=$LISTDIR/https.resolv
    [ -f $HTTPS_RESOLV_FILE ] || HTTPS_RESOLV_FILE=$TMPL_DIR/https.resolv.blank

    local NAMED_OUTPUT_DIR=/opt/named
    local ZONE_CONF=$NAMED_OUTPUT_DIR/reductor.conf
    local ZONE_DB=$NAMED_OUTPUT_DIR/reductor.db

    named_cleanup_start
    named_process_list < $HTTPS_RESOLV_FILE > $ZONE_CONF.process
    named_generate_zones < $ZONE_CONF.process
    named_cleanup_end
}

client_prepare_hook
