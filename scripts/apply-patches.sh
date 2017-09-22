if [ $# -eq 0 ]
  then
    printf "Usage : apply-patches username password 4.2.0|4.4.0 patch1000 [patch1001 patch1002]\n"
    exit 1
fi

username=$1
shift
password=$1
shift
kernelVersion=$1
shift

rm -r tmp-patches
rm patch-log.txt

for patchName in $@;
do

patchId=`echo "$patchName" | cut -c6-10`

if [ "$kernelVersion"  = "4.2.0" ]
then
  patchFullName="WSO2-CARBON-PATCH-4.2.0-$patchId"
  patchUrl="https://svn.wso2.com/wso2/custom/projects/projects/carbon/turing/patches/patch$patchId/$patchFullName.zip";
else
  patchFullName="WSO2-CARBON-PATCH-4.4.0-$patchId"
  patchUrl="https://svn.wso2.com/wso2/custom/projects/projects/carbon/wilkes/patches/patch$patchId/$patchFullName.zip"
fi

wget --directory-prefix=tmp-patches --http-user=$username --http-password=$password $patchUrl
unzip tmp-patches/$patchFullName.zip -d tmp-patches
cp -r tmp-patches/$patchFullName/patch$patchId repository/components/patches

dirs=`ls -l tmp-patches/$patchFullName --time-style="long-iso" $MYDIR | egrep '^d' | awk '{print $8}'`

reviewNeeded=false

for dir in $dirs
do
if [ "$dir" != "patch$patchId" ]; then
reviewNeeded=true;
break;
fi
done

if [ $reviewNeeded = true ]; then
echo "<<< [review needed] ==> $patchFullName" >> patch-log.txt
else
echo "<<< [patching done] ==> $patchFullName" >> patch-log.txt
fi

echo "" >> patch-log.txt
tree -L 1 tmp-patches/$patchFullName >> patch-log.txt
echo "" >> patch-log.txt
printf "\n\n-------------- START :: README --------------\n\n" >> patch-log.txt
cat tmp-patches/$patchFullName/README.txt >> patch-log.txt
printf "\n\n-------------- END :: README --------------\n\n" >> patch-log.txt
echo ">>>" >> patch-log.txt
echo "" >> patch-log.txt
printf "\n\n ==== Done : $patchFullName ====\n\n"

done
