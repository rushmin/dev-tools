printf "\n\n===== Token Generation - Password Grant =====\n\n"

printf "\nApplication key ?\n"
read applicationKey

printf "\nApplication secret ?\n"
read applicationSecret

printf "\nResource owner's username ?\n"
read username

printf "\nResource owner's password ?\n"
read password

printf "\nToken endpoint ?\n"
read endpoint

authorizationToken=`echo -n "$applicationKey:$applicationSecret" | base64`

printf "\n\n"

curl -k -X POST -H "Authorization: Basic $authorizationToken" -k -d "grant_type=password&username=$username&password=$password" -H "Content-Type:application/x-www-form-urlencoded" $endpoint

printf "\n\n"
