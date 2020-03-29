#!/bin/sh -e
TD=$(mktemp -d)

THEO_MB_AS_LIST="https://bgpdb.ciscodude.net/api/asns/province/mb"
curl -s "${THEO_MB_AS_LIST}" > "${TD}/aslist-raw"
cut -d\| -f1 "${TD}"/aslist-raw > "${TD}/aslist"
#Manually add some ASes, per https://github.com/mbnog/mkbgpmap/blob/master/mkbgpmap.sh
printf '16395\n55073\n30028\n6939\n6327' >> "${TD}/aslist"

for ASN in $(cat "${TD}/aslist"); do
        (
        curl -s "http://lg.les.net/cgi-bin/bgplg?cmd=show+ip+bgp+source-as&req=${ASN}" > "${TD}/$ASN.prefixes-raw"
        awk '$1 ~ /^I/ && $2 ~ /^[[:xdigit:]\/:]+/ {print $2,0,";"}' "${TD}/${ASN}.prefixes-raw" > "${TD}/$ASN.prefixes"
        ) &
        #sleep 1  # don't piss off the MBIX maintainers :-)
done
wait
cat "${TD}"/*.prefixes > "${TD}/all-prefixes"
sort -n "${TD}/all-prefixes" > "${TD}/all-prefixes-sorted"
uniq "${TD}/all-prefixes-sorted" > /etc/nginx/manitoba-y-ish-prefixes
rm -rf "${TD}"
systemctl reload nginx
