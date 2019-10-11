#!/usr/bin/env bash
#
# fake dynamic inventory ansible
#

cd ../terraform/stage
appip=$(terraform output app_external_ip)
dbip=$(terraform output db_external_ip)
APPIP=`echo $appip | sed -e 's#[][",\\[ ]##g'`
DBIP=`echo $dbip | sed -e 's#[][",\\[ ]##g'`

cd ../../ansible/
cat inventory.json | sed "s/APPIP/${APPIP}/" | sed "s/DBIP/${DBIP}/"
