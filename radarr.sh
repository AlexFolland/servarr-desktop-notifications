#!/usr/bin/env bash

tool='Radarr'

if [[ -z ${radarr_eventtype} ]]; then
	radarr_eventtype='no event'
fi

message=""

if [[ ! -z ${radarr_movie_title} ]]; then
	if [[ ! -z ${radarr_movie_year} ]]; then
		message+="${radarr_movie_year} - "
	fi
	message+="${radarr_movie_title}"
	if [[ ! -z ${radarr_movie_quality} ]]; then
		message+=" - ${radarr_movie_quality}"
	fi
	if [[ ! -z ${radarr_release_size} ]]; then
		message+=" - ${radarr_release_size}"
	fi
elif [[ ! -z ${radarr_health_issue_message} ]]; then
	message+="${radarr_health_issue_message}"
elif [[ ! -z ${radarr_update_message} ]]; then
	message+="${radarr_update_message}"
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
						notify-send -a "${tool}" -u 'normal' -i "/usr/lib/${tool,,}/bin/UI/Content/Images/logo.svg" -- "${radarr_eventtype}" "${message}"
done