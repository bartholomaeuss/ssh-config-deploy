#!/bin/bash

forward="no"
identity="id_rsa"

show_help(){
    echo "Deploy ssh config to $HOME/.ssh/config"
    echo "usage: $0 [-f] [-i] [-r] [-s] [-h]"
    echo "  -f  enable forwarding; by default disabled "
    echo "  -i  private key file name"
    echo "  -r  remote host name"
    echo "  -s  short remote host name"
    echo "  -h  show help"
    exit 0
}

main(){
    echo -e "$configuration" >> "$HOME/.ssh/config"
    if [ $? -ne 0 ]
    then
      exit 1
    fi
    echo "$remote successfully appended to $HOME/.ssh/config"
    exit 0
}

while getopts ":f:i:r:s:h" opt; do
  case $opt in
    f)
      forward="yes"
      ;;
    i)
      identity="$OPTARG"
      ;;
    r)
      remote="$OPTARG"
      ;;
    s)
      short="$OPTARG"
      ;;
    h)
      show_help
      ;;
    \?)
      echo "unknown option: -$OPTARG" >&2
      show_help
      ;;
    :)
      echo "option requires an argument -$OPTARG." >&2
      show_help
      ;;
  esac
done

if [ "$#" -le 0 ]
then
  echo "script requires an option"
  show_help
fi

if [ -z "$remote" ]
then
  echo "'-r' option is mandatory"
  show_help
fi

if [ -z "$short" ]
then
  echo "'-s' option is mandatory"
  show_help
fi

configuration="Host $short\n    hostname $remote\n    ForwardAgent $forward\n    IdentityFile ~/.ssh/$identity"

main
