
if [ $# -eq 0 ]
  then
    printf "\nUsage : ./find-jar.sh [search-location] [class-name]\n"
    printf "\nExample : ./find-jar.sh repository/components/plugins/ IdentityMgtEventListener\n\n"
    exit 1
fi

# For each jar file in the given location ...
for f in $1/*.jar;
 # Check whether the given class file is there.
 do unzip -l $f | grep $2 &> /dev/null
  if [ $? == 0 ]; then
    printf "\t$f\n"
  fi
done
