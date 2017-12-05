##
##
## This script prints the source location for the given JAR file.
## It assumes that the JAR file was built from maven, therefore contains a pom.xml file.
## The 'scm' tag of the pom file (and parent pom files if needed) is used to get the source location.
##
## Usage : ./find-source <jar-file-location>
##
##


# Searches for the SCM information of the POM file for given artifact identity.
tryWithParent()
{
  groupId=$1
  artifactId=$2
  version=$3

  # Contructs the repo location for the group id. e.g. a.b.c ==> a/b/c
  IFS='.' read -ra pathSegments <<< "$groupId"
  groupPath=""
  for i in "${pathSegments[@]}"; do
    groupPath=$groupPath/$i
  done
  pomFilePath=$groupPath/$artifactId/$version/$artifactId-$version.pom
  fullPath=https://maven.wso2.org/nexus/content/groups/wso2-public$pomFilePath

  printf "DEBUG : POM URL : $fullPath\n"

  # Fetch the content of the POM file from the constructed URL.
  output=$(wget $fullPath -q -O -)

  scmURL=$(echo $output | xmllint --xpath "/*[local-name()='project']/*[local-name()='scm']/*[local-name()='url']/text()" -)

  if [ -z "$scmURL" ]
  then
        printf "DEBUG : Couldn't find SCM information. Trying the parent pom.\n"
        groupId=$(echo $output | xmllint --xpath "/*[local-name()='project']/*[local-name()='parent']/*[local-name()='groupId']/text()" -)
        artifactId=$(echo $output | xmllint --xpath "/*[local-name()='project']/*[local-name()='parent']/*[local-name()='artifactId']/text()" -)
        version=$(echo $output | xmllint --xpath "/*[local-name()='project']/*[local-name()='parent']/*[local-name()='version']/text()" -)

        if [ -z "$groupId" ]
        then
          printf "ERROR : Couldn't find SCM information in the POM hierarchy. Terminating.\n"
          exit 0;
        fi

        tryWithParent $groupId $artifactId $version
  else
        scmTag=$(echo $output | xmllint --xpath "/*[local-name()='project']/*[local-name()='scm']/*[local-name()='tag']/text()" -)

        sourceLocation=$scmURL/tree/$scmTag
        sourceLocation=${sourceLocation//\.git/}

        printf "\nSource Location - $sourceLocation\n\n"
  fi
}

# Prints the Usage message if no parameters are given.
if [ $# -eq 0 ]
  then
    printf "Usage : ./find-source <jar-file-location>\n"
    exit 1
fi

# Check whether there is SCM inforation in the pom.xml in the JAR file itself.
scmURL=$(unzip -c $1 **/pom.xml | tail -n +3 | xmllint --xpath "/*[local-name()='project']/*[local-name()='scm']/*[local-name()='url']/text()" -)

# If not, try the parent pom.
if [ -z "$scmURL" ]
then
      printf "DEBUG : Couldn't find SCM information in the pom file of the JAR. Trying the parent pom.\n"
      groupId=$(unzip -c $1 **/pom.xml | tail -n +3 | xmllint --xpath "/*[local-name()='project']/*[local-name()='parent']/*[local-name()='groupId']/text()" -)
      artifactId=$(unzip -c $1 **/pom.xml | tail -n +3 | xmllint --xpath "/*[local-name()='project']/*[local-name()='parent']/*[local-name()='artifactId']/text()" -)
      version=$(unzip -c $1 **/pom.xml | tail -n +3 | xmllint --xpath "/*[local-name()='project']/*[local-name()='parent']/*[local-name()='version']/text()" -)

      if [ -z "$groupId" ]
      then
        printf "ERROR : Parent is not present. Terminating.\n"
        exit 0;
      fi

      tryWithParent $groupId $artifactId $version
else
  scmTag=$(unzip -c $1 **/pom.xml | tail -n +3 | xmllint --xpath "/*[local-name()='project']/*[local-name()='scm']/*[local-name()='tag']/text()" -)

  sourceLocation=$scmURL/tree/$scmTag
  sourceLocation=${sourceLocation//\.git/}

  printf "\nSource Location - $sourceLocation\n\n"
fi
