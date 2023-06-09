#!/usr/bin/env bash

servarr='Sonarr'

if [[ -z ${sonarr_eventtype} ]]; then
	sonarr_eventtype='no event'
fi

message=""

if [[ ! -z ${sonarr_series_title} ]]; then
	message+="${sonarr_series_title}"
	if [[ ! -z ${sonarr_episodefile_seasonnumber} ]]; then
		message+=" - S${sonarr_episodefile_seasonnumber}"
		if [[ ! -z ${sonarr_episodefile_episodenumbers} ]]; then
			message+="E${sonarr_episodefile_episodenumbers}"
		fi
	fi
	if [[ ! -z ${sonarr_episodefile_quality} ]]; then
		message+=" - ${sonarr_episodefile_quality}"
	fi
	if [[ ! -z ${sonarr_release_size} ]]; then
		message+=" - ${sonarr_release_size}"
	fi
elif [[ ! -z ${sonarr_health_issue_message} ]]; then
	message+="${sonarr_health_issue_message}"
elif [[ ! -z ${sonarr_update_message} ]]; then
	message+="${sonarr_update_message}"
fi

PATH=/usr/bin:/bin

XUSERS=($(who|grep -E "\(:[0-9](\.[0-9])*\)"|awk '{print $1$NF}'|sort -u))
for XUSER in "${XUSERS[@]}"; do
	NAME=(${XUSER/(/ })
	DISPLAY=${NAME[1]/)/}
	DBUS_ADDRESS=unix:path=/run/user/$(id -u ${NAME[0]})/bus
	sudo -u ${NAME[0]} DISPLAY=${DISPLAY} \
						DBUS_SESSION_BUS_ADDRESS=${DBUS_ADDRESS} \
						PATH=${PATH} \
						notify-send -a "${servarr}" -u 'normal' -i "/usr/lib/${servarr,,}/bin/UI/Content/Images/logo.svg" -- "${sonarr_eventtype}" "${message}"
done