
patchDir="$2/repository/components/patches/patch9999/"

set -e

echo -e "\n ===== Step 1. Building $1 =====\n\n"

mvn clean install -f $1/pom.xml

echo -e "\n\n ===== Step 2. Copying $1 =====\n"

if [ -e "$patchDir" ]
then
  echo -e "\n Patch directory ($patchDir) exists."
else
	mkdir $patchDir
	echo -e "\n Created patch directory ($patchDir)."
fi

echo -e "\n Sanity Check : Components to be copied"
find $1/target/ -maxdepth 1 -regex .*-.*\.jar | xargs -i echo " # . " {}

find $1/target/ -maxdepth 1 -regex .*-.*\.jar| xargs -i cp {} $patchDir
echo -e "\n Done !\n"
