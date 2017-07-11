if [ $# -eq 0 ]
  then
    printf "Usage : goto-mvn-repo  [groupId] [artifactId]\n"
    exit 1
fi
IFS='.' read -ra pathSegments <<< "$1"
groupPath=""
for i in "${pathSegments[@]}"; do
  groupPath=$groupPath/$i
done
artifactPath=$groupPath/$2
fullPath=https://maven.wso2.org/nexus/content/groups/wso2-public$artifactPath
google-chrome $fullPath
