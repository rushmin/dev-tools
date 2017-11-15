if [ $# -eq 0 ]
  then
    printf "Usage : ./build-and-deploy-travelocity.sh <product-is-git-home> <tomcat-home>"
    exit 1
fi

mvn clean install -f $1/modules/samples/sso/pom.xml

rm -rv $2/webapps/travelocity.com*

cp -v $1/modules/samples/sso/sso-agent-sample/target/travelocity.com.war $2/webapps
