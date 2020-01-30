export JAVA_HOME=`/usr/libexec/java_home -v $1`
printf "\n"
java -version
printf "\n WARN : Use '. switch-jdk.sh' to make the env var effective in the current shell\n\n"
