
if [ $# -eq 0 ]
  then
    printf "Usage : find-jar [location] [class-name] [See \$3 below]\n"
    printf "Implentation : find \$1 -regex .*\.jar | xargs -n 1 unzip -l | grep -B \$3 \$2 | grep Archive:.*\.jar\n\n"
    exit 1 
fi

find $1 -regex .*\.jar | xargs -n 1 unzip -l | grep -B $3 $2 | grep Archive:.*\.jar
