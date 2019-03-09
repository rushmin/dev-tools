if [ $# -ne 4 ]
  then
    printf "\nUsage : run-load-test.sh <label> <script-file> <properties-file> <reports-root-directory>\n\n"
    printf "Example : load-test-runner.sh \"is-530-with-fix\" \"client-credentials-grant/client-credential.jmx\" \"client-credentials-grant/is530-load-test.properties\" \"../reports\"\n\n"
    exit 1
fi

timstamp=`date +"%s"`

label=$1
scriptFile=$2
propertiesFile=$3
reportsRootDirectory=$4

reportDirectory=$reportsRootDirectory/$timstamp

mkdir -p $reportDirectory


printf "\nStarted : '$label ($scriptFile)' with the properties '$propertiesFile'\n\n"
printf "Reports are stored in  $reportDirectory\n\n"

printf "Title : '$label'\n\n" >> $reportDirectory/report
printf "Test properties ($propertiesFile)\n\n" >> $reportDirectory/report
cat $propertiesFile >> $reportDirectory/report

cp $scriptFile $reportDirectory

printf "\n\nJmeter Output\n\n" >> $reportDirectory/report

nohup jmeter -n -t $scriptFile --jmeterlogfile $reportDirectory/jmeter.log --propfile $propertiesFile -JsummaryDirectory "$reportDirectory" >> $reportDirectory/report 2> $reportDirectory/error.log < /dev/null&
