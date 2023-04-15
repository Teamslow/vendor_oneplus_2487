#! /vendor/bin/sh

target="$1"
serialno="$2"

btsoc=""

#ifdef OPLUS_FEATURE_WIFI_BDF
#bingham.fang@CONNECTIVITY.WIFI.HARDWARE.BDF, 2021/09/01, remove BDF from persist patition
#
if [ -s /mnt/vendor/persist/bdwlan.elf ]; then
    rm /mnt/vendor/persist/bdwlan.elf
    sync
    echo "remove persist bdf"
fi

#endif /* OPLUS_FEATURE_WIFI_BDF */

#ifdef OPLUS_FEATURE_WIFI_LOG
#yuquan.fei@CONNECTIVITY.WIFI.BASIC.LOG , 2021/07/30, add for wifi log
if [ -s /odm/etc/wifi/cnss_diag.conf ] ; then
    cp /odm/etc/wifi/cnss_diag.conf /mnt/vendor/persist/wlan/cnss_diag.conf
    chmod 666 /mnt/vendor/persist/wlan/cnss_diag.conf
    sync
fi

if [ -s /odm/etc/wifi/cnss_diag_always_on.conf ] ; then
    cp /odm/etc/wifi/cnss_diag_always_on.conf /mnt/vendor/persist/wlan/cnss_diag_always_on.conf
    chmod 666 /mnt/vendor/persist/wlan/cnss_diag_always_on.conf
    sync
fi
#endif /* OPLUS_FEATURE_WIFI_LOG */

#LiJunlong@CONNECTIVITY.WIFI.NETWORK.1065227,2020/08/07
reg_info=`getprop ro.vendor.oplus.euex.country`
testvalue=`getprop persist.vendor.oplus.engineer.test`
if [ "${testvalue}" = "3" ] || [ "${testvalue}" = "0" ] || [ "${testvalue}" = "1" ]; then
    sourceFile=/odm/vendor/etc/wifi/WCNSS_qcom_cfg_roam.ini
    echo "export disable roam file dir config"
elif [ "w${reg_info}" = "wUA" ]; then
    sourceFile=/odm/vendor/etc/wifi/WCNSS_qcom_cfg_ua.ini
    echo "export UA file dir config"
else
    sourceFile=/odm/vendor/etc/wifi/WCNSS_qcom_cfg.ini
    echo "export default file dir config"
fi

targetFile=/mnt/vendor/persist/wlan/WCNSS_qcom_cfg.ini

#Yuan.Huang@PSW.CN.Wifi.Network.internet.1065227, 2016/11/09,
#Add for make WCNSS_qcom_cfg.ini Rom-update.
if [ -s "$sourceFile" ]; then
	system_version=`head -1 "$sourceFile" | grep OplusVersion | cut -d= -f2`
	if [ "${system_version}x" = "x" ]; then
		system_version=1
	fi
else
	system_version=1
fi

#LiJunlong@CONNECTIVITY.WIFI.NETWORK,1065227,2020/07/29,Add for rus ini
if [ -s /mnt/vendor/persist/wlan/qca_cld/WCNSS_qcom_cfg.ini ]; then
    cp  /mnt/vendor/persist/wlan/qca_cld/WCNSS_qcom_cfg.ini \
        $targetFile
    sync
    chown system:wifi $targetFile
    chmod 666 $targetFile
    rm -rf /mnt/vendor/persist/wlan/qca_cld
fi

if [ -s "$targetFile" ]; then
	persist_version=`head -1 "$targetFile" | grep OplusVersion | cut -d= -f2`
	if [ "${persist_version}x" = "x" ]; then
		persist_version=0
	fi
else
	persist_version=0
fi


if [ ! -s "$targetFile" -o $system_version -gt $persist_version ]; then
    cp $sourceFile  $targetFile
    sync
    chown system:wifi $targetFile
    chmod 666 $targetFile
fi

persistini=`cat "$targetFile" | grep -v "#" | grep -wc "END"`
if [ x"$persistini" = x"0" ]; then
    cp $sourceFile  $targetFile
    sync
    chown system:wifi $targetFile
    chmod 666 $targetFile
    echo "ini check"
fi

if [ "${testvalue}" = "0" ] || [ "${testvalue}" = "1" ] || [ "${testvalue}" = "2" ] || [ "${testvalue}" = "3" ]; then
    cp $sourceFile  $targetFile
    sync
    chown system:wifi $targetFile
    chmod 666 $targetFile
fi
#endif /* OPLUS_FEATURE_WIFI_POWER */
