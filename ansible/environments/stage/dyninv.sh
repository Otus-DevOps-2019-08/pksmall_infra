#!/usr/bin/env bash
#
# fake dynamic inventory ansible
#

cd ../terraform/stage
export appip=$(terraform output app_external_ip)
export dbip=$(terraform output db_external_ip)
export dbintip=$(terraform output db_internal_ip)
export APPIP=`echo $appip | sed -e 's#[][",\\[ ]##g'`
export DBIP=`echo $dbip | sed -e 's#[][",\\[ ]##g'`
export DBINTIP=`echo $dbintip | sed -e 's#[][",\\[ ]##g'`

#echo $DBINTIP
cd ../../ansible/environments/stage
cat inventory.json | sed "s/APPIP/${APPIP}/" | sed "s/DBIP/${DBIP}/" | sed "s/DBINTIP/${DBINTIP}/"
