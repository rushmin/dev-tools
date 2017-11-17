if [ $# -eq 0 ]
  then
    printf "Usage : ./build-and-deploy-ids-samples.sh <product-is-git-home> <tomcat-home>\n"
    exit 1
fi

printf "\n\nBuilding and deploying travelocity\n=======\n\n"

printf "Building ... \n\n"
mvn clean install -f $1/modules/samples/sso/pom.xml

printf "\nRemoving existing depoyment ... \n\n"
rm -rv $2/webapps/travelocity.com*

printf "\nCopying new webapp depoyment ... \n\n"
cp -v $1/modules/samples/sso/sso-agent-sample/target/travelocity.com.war $2/webapps

printf "\n\nBuilding and deploying playground\n=======\n\n"

printf "Building ... \n\n"
mvn clean install -f $1/modules/samples/oauth2/playground2/pom.xml

printf "\nRemoving existing depoyment ... \n\n"
rm -rv $2/webapps/playground2*

printf "\nCopying new webapp depoyment ... \n\n"
cp -v $1/modules/samples/oauth2/playground2/target/playground2.war $2/webapps
