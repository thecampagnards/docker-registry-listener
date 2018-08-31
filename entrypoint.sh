#!/bin/sh

if [ ! -f configuration.json ]; then
    echo "No configuration file found"
    exit 1
fi

while :; do
    for row in $(jq -r '.[] | @base64' configuration.json); do

        url=$(echo "$row" | base64 -d | jq -r '.tagUrl')
        encode=$(url-encode "$url")

        data=$(curl -L -s "$url")

        if [ "$data" != "$(cat data/"$encode".json)" ]; then

            echo "Diff for $url"

            url=$(echo "$row" | base64 -d | jq -r '.apiToCall.url')
            options=$(echo "$row" | base64 -d | jq -r '.apiToCall.curlOptions')
            request_type=$(echo "$row" | base64 -d | jq -r '.apiToCall.requestType')

            # https://github.com/koalaman/shellcheck/wiki/SC2086#exceptions
            # shellcheck disable=SC2086
            curl -sL -X "$request_type" $options "$url"
            if [ 0 -eq $? ]; then
                echo "$data" > "data/$encode.json"
            else
                echo "Fail to call $url"
            fi
        else
            echo "No diff for $url"
        fi
    done

    sleep "$SLEEP_TIME"
done