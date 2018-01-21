
if [ $# -eq 0 ]
  then
    printf "Usage : wso2-dev-patch [component-path] [wso2-server-root]\n"
    exit 1
fi

componentHome=$1
shift
serverRoot=$1
shift

if [ -z "$serverRoot" ]
  then
    serverRoot=.
fi

patchDir="$serverRoot/repository/components/patches/patch9999/"

set -e

echo -e "\n ===== Step 1. Building $componentHome =====\n\n"

mvn clean install -f $componentHome/pom.xml "$@"

echo -e "\n\n ===== Step 2. Copying $componentHome =====\n"

if [ -e "$patchDir" ]
then
  echo -e "\n Patch directory ($patchDir) exists."
else
	mkdir $patchDir
	echo -e "\n Created patch directory ($patchDir)."
fi

echo -e "\n Sanity Check : Components to be copied"
find $componentHome/target/ -maxdepth 1 -regex .*-.*\.jar | xargs -I {} basename {}

find $componentHome/target/ -maxdepth 1 -regex .*-.*\.jar| xargs -I {} cp {} $patchDir
echo -e "\n Done !\n"
