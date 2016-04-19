#!/usr/bin/env bash

# script to test argument processing

function usage
{
  echo "usage: arg_test [[[-a ARG_A ] [-b ARG_B]] | [-h]]"
}

# set defaults:
ARG_A="a"
ARG_B="b"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --arg_a )    shift
                      ARG_A=$1
                      echo "arg a set to $ARG_A"
                      ;;
    -b | --arg_b )     shift
                      ARG_B=$1
                      echo "arg b set to $ARG_B"
                      ;;
    -h | --help )     usage
                      exit
                      ;;
    * )               usage
                      echo "could not process first argument: $1"
                      exit 1
  esac
  shift
done
