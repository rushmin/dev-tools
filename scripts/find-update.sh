
if [ $# -eq 0 ]
 then
   printf "\nPrints the WSO2 updates which contain the given JAR file. The local WUM updates repo is used for searching.\n"
   printf "The local WUM updates repo is used for searching.\n"
   printf "If a WSO2 product home is given, the updates are further filtered and prints the updates in the given product local copy which contains the given JAR file.\n"
   printf "\nUsage : \n\t./find-update.sh <update-location> <jar-name> [product-home]\n"
   printf "\nArguements :\n"
   printf "\t• update-location - Location where the update archive files reside. e.g. ~/.wum-wso2/updates/wilkes/4.4.0\n"
   printf "\t• jar-name - JAR file name to be looked-up for\n"
   printf "\t• product-home (optional) - Home directory of the WSO2 product. When this argument is present the searched updates will be filtered against the updates in the product.\n"
   printf "\nExample : \n\t./find-update.sh ~/.wum-wso2/updates/wilkes/4.4.0/ org.wso2.carbon.user.mgt_5.7.5.jar ~/wso2is-5.3.0\n\n"
   exit 1
fi

# Regex to match the update files.
regex="$1.*WSO2-CARBON-UPDATE-4.4.0-([0-9]{4})\.zip"

# For each update archive file in the updates directory ...
for f in $1/*.zip;
 # Check whether the given jar file is there.
 do unzip -l $f | grep $2 &> /dev/null
  if [ $? -eq 0 ]
  then
    echo 'DEBUG :  '$2' is available in '$f
    if ! [ -z "$3" ] # If the product home is given, filter the update against the updates in the product.
    then
      if [[ $f =~ $regex ]]
      then
          updateNumber="${BASH_REMATCH[1]}"
          found=false
          for report in $3/updates/wum/*;
          do
            if grep -q "\- \"$updateNumber\"" "$report"; then
              echo 'INFO : FOUND - '$f
              found=true
              break
            fi
          done
          if [ "$found" = false ] ; then
              echo 'DEBUG : Filtered - '$f
          fi
      fi
    else
        echo 'INFO : FOUND - '$f
    fi
  fi
done
