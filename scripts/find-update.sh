
if [ $# -eq 0 ]
 then
   printf "\nUsage : find-update <update-location> <jar-name> [product-home]\n"
   printf "\nArguements\n"
   printf "\tupdate-location - Location where the update archive files reside. e.g. ~/.wum-wso2/updates/wilkes/4.4.0\n"
   printf "\tjar-name - JAR file name to be looked-up for\n"
   printf "\tproduct-home - Home directory of the WSO2 product. When this argument is present the searched updates will be filtered against the updates in the product.\n\n"
   exit 1
fi

# Regex to match the update files.
regex="$1.*WSO2-CARBON-UPDATE-4.4.0-([0-9]{4})\.zip"

# For each update archive file in the updates directory ...
for f in $1/*.zip;
 # Check whether the given jar file is there.
 do unzip -l $f | grep $2 &> /dev/null
  if [ $? == 0 ]; then
    if ! [ -z "$3" ] # If the product home is given, filter the update against the updates in the product.
    then
      if [[ $f =~ $regex ]]
      then
          updateNumber="${BASH_REMATCH[1]}"
          found=false
          for report in $3/updates/wum/*;
          do
            if grep -q "\- \"$updateNumber\"" "$report"; then
              echo 'FOUND - '$f
              found=true
              break
            fi
          done
          if [ "$found" = false ] ; then
              echo 'DEBUG : Filtered - '$f
          fi
      fi
    else
        echo 'FOUND - '$f
    fi
  fi
done
