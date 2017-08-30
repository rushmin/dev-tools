if [ $# -eq 0 ]
  then
    printf "Usage : apply-patches username password WSO2-CARBON-PATCH-4.4.0-0001 [WSO2-CARBON-PATCH-4.4.0-0002 ...]\n"
    exit 1
fi

username=$1
shift
password=$1
shift

rm -r tmp-patches
rm all-readme.txt

for patchName in $@;
do
IFS='-' read -ra patchNameSegments <<< "$patchName"

patchId=${patchNameSegments[4]}
kernelVersion=${patchNameSegments[3]}

if [ "$kernelVersion"  = "4.2.0" ]
then
  patchUrl="https://svn.wso2.com/wso2/custom/projects/projects/carbon/turing/patches/patch$patchId/$patchName.zip";
else
  patchUrl="https://svn.wso2.com/wso2/custom/projects/projects/carbon/wilkes/patches/patch$patchId/$patchName.zip"
fi

wget --directory-prefix=tmp-patches --http-user=$username --http-password=$password $patchUrl
unzip tmp-patches/$patchName.zip -d tmp-patches
cp -r tmp-patches/$patchName/patch$patchId repository/components/patches

irs=`ls -l tmp-patches/$patchName --time-style="long-iso" $MYDIR | egrep '^d' | awk '{print $8}'`

reviewNeeded=false

for dir in $dirs
do
echo $dir
if [ "$dir" != "patch$patchId" ]; then
reviewNeeded=true;
break;
fi
done

if [ $reviewNeeded = true ]; then
echo "<<< [review needed] ==> $patchName" >> all-readme.txt
else
echo "<<< [patching done] ==> $patchName" >> all-readme.txt
fi

echo "" >> all-readme.txt
tree -L 1 tmp-patches/$patchName >> all-readme.txt
echo "" >> all-readme.txt
cat tmp-patches/$patchName/README.txt >> all-readme.txt
echo ">>>" >> all-readme.txt
echo "" >> all-readme.txt
printf "\n\n ==== Done : $patchName ====\n\n"

done
