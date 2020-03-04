# Credit : http://blog.hartshorne.net/2016/04/simulating-network-delay-on-osx.html

printf "\n"

# Prints the Usage message if no parameters are given.
if [ $# -eq 0 ]
  then
    printf "Usage : ./delay-connectivity.sh [reset]|[set in|out <from-ip> <to-ip> <port> <delay-in-milliseconds>]\n\n"
    printf "Eg. 1 : Setting 5 seconds delay to incoming traffic to port 8001 ==> ./delay-connectivity.sh set in any any 8001 5000\n"
    printf "Eg. 2 : Remove the delay rule ==> ./delay-connectivity.sh reset\n\n"
    exit 1
fi

command=$1


if [ $command == "set" ];
then
  if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] || [ -z "$6" ]
  then
    printf "Invalid arguments. Check usage.\n"
  else

    direction=$2
    from=$3
    to=$4
    port=$5
    delay=$6

    printf "Setting $6 milliseconds delay for {source-ip:$from, destination-ip:$to, destination-port:$port, direction:$direction} \n\n"
    # Add a temporary extra ruleset
    (cat /etc/pf.conf && echo "dummynet-anchor \"delay-simulation\"" && echo "anchor \"delay-simulation\"") | sudo pfctl -f -

    # Add a rule to the 'delay-simulation' set to send any traffic to passed port to dummynet pipe 1
    echo "dummynet $direction quick proto tcp from $from to $to port $port pipe 1" | sudo pfctl -a delay-simulation -f -

    # Add a rule to dummynet pipe 1 to delay every packet by given delay in milliseconds.
    sudo dnctl pipe 1 config delay $6
  fi
elif [ $command == "reset" ];
then
  printf "Resetting to /etc/pf.conf\n\n"
  sudo pfctl -f /etc/pf.conf
else
  printf "Invalid command. Check usage.\n"
fi

printf "\n"
