#!/bin/bash

if [ ! -f configuration.json ]; then
    echo "No configuration file found"
    exit 1
fi

while :; do
    for row in $(jq -r '.[] | @base64' configuration.json); do

        row=$(echo "$row" | base64 -d)
        url=$(echo "$row" | jq -r '.source.url')
        options=$(echo "$row" | jq -r '.source.curlOptions')
        if [ "$options" == "null" ]; then
            options=""
        fi
        url_encode=$(url-encode "$url")

        # https://github.com/koalaman/shellcheck/wiki/SC2086#exceptions
        # shellcheck disable=SC2086
        data=$(curl -Ls $options "$url")

        if [ "$data" != "$(cat "data/$url_encode")" ]; then

            echo "Differences found for $url"

            url=$(echo "$row" | jq -r '.target.url')
            options=$(echo "$row" | jq -r '.target.curlOptions')
            if [ "$options" == "null" ]; then
                options=""
            fi

            # shellcheck disable=SC2086
            response=$(curl --write-out '%{http_code}' --output /dev/null -Ls $options "$url")
            if [ "$response" -eq 200 ]; then
                echo "$data" > "data/$url_encode"
                echo "Succeed to call $url"
            else
                echo "Fail to call $url"
            fi
        else
            echo "No differences found for $url"
        fi
    done

    sleep "$SLEEP_TIME"
done