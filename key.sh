#!/bim/bash
set -e
eval "$(jq -r '@sh "export do_token=\(.do_token) "')"


curl -X GET \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $do_token" \
     "https://api.digitalocean.com/v2/account/keys?per_page=200" | jq '.ssh_keys[] | select(.name == "REBRAIN.SSH.PUB.KEY")' | jq 'del(.id)'
