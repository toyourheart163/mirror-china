#!/bin/bash

set -e

s1=$1
s2=$2
ZSHRC=~/.zshrc
PUB=PUB_HOSTED_URL
PUB_HOSTED_URL="export PUB_HOSTED_URL=https://pub.flutter-io.cn"

function usage() {
  echo mirror -h for help
  echo """set mirror:
$ mirror pip 
         npm 
         pub
         list # list config
unset mirror:
$ mirror pip unset
get mirror:
$ mirror pip get"""
}
[ $# = 0 ] && usage

function set_url() {
  case $s1 in
    pip)
      pipdir=~/.config/pip
      if ! [ -d $pipdir ] || ! [ -d ~/.pip ]; then
        mkdir $pipdir
      fi
      pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
      ;;
    yarn | npm) $s1 config set registry https://registry.npm.taobao.org ;;
    pub)
      echo set pub
      if [ "$(grep $PUB $ZSHRC)" = "" ]; then
        echo $PUB_HOSTED_URL >> $ZSHRC && grep 'PUB' $ZSHRC
      elif [ "$(grep '^export PUB_HOSTED_URL=' ${ZSHRC})" != "" ]; then
        echo uncomment
        sed "@^#.*$PUB @s@^#@@" -i $ZSHRC && grep $PUB $ZSHRC
      fi
      ;;
    *) usage ;;
  esac
}

function get_url() {
  case $s1 in
    pip) pip config get global.index-url ;;
    yarn | npm) $s1 config get registry ;;
    pub)
      echo $PUB_HOSTED_URL
      grep $PUB $ZSHRC
      ;;
    *) usage ;;
  esac
}

function unset_url() {
  case $s1 in
    pip) pip config unset global.index-url ;;
    npm | yarn) $s1 config delete registry ;;
    pub)
      if [ "$(grep '^export PUB' $ZSHRC)" != "" ]; then
        # comment
        echo unset pub && grep $PUB $ZSHRC
        sed "/export $PUB/ s/^#*/#/" -i $ZSHRC && grep $PUB $ZSHRC
      fi
      ;;
    *) usage ;;
  esac
}

case $2 in
  "")
    case $1 in
      -h|--help) usage ;;
      list)
        s2="get"
        array=(pip pub npm yarn)
        for package_manage in ${array[@]}; do
          s1=$package_manage
          echo $package_manage
          get_url
        done
        ;;
      *) set_url ;;
    esac
    ;;
  set) set_url ;;
  unset | n | no) unset_url ;;
  get) get_url ;;
  *) usage ;;
esac
