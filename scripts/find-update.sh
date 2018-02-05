
if [ $# -eq 0 ]
 then
   printf "Usage : find-update <update-location> <jar-name>\n"
   exit 1
fi

for f in $1/*.zip;
 do unzip -l $f | grep $2 &> /dev/null
  if [ $? == 0 ]; then
    echo $f
  fi
done
