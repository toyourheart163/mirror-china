#!/bin/bash

set -x

s1=$1
s2=$2
ZSHRC=~/.zshrc
PUB=PUB_HOSTED_URL
PUB_HOSTED_URL="export PUB_HOSTED_URL=https://pub.flutter-cn.io"
function usage() {
   echo mirror -h for help
   echo """set mirror:
$ mirror pip 
         npm 
         pub
         list # list config
unset mirror:
$ mirror pip unset"""
}
[ $# = 0 ] && usage

function set_url() {
    case $s1 in
        '-h' ) usage;;
        'pip' )
            pipconf=~/.config/pip/pip.conf
            pipdir=~/.config/pip
            if ! [ -d $pipdir ] || ! [ -d ~/.pip ]; then
                mkdir $pipdir
                echo """[global]
index-url=https://pypi.tuna.tsinghua.edu.cn/simple""" > $pipconf
            elif [ -f $pipconf ] || [ -f ~/.pip/pip.conf ]; then
                pip config set global.index-url\
                https://pypi.tuna.tsinghua.edu.cn/simple
            fi
            ;;
        'npm' ) npm config set registry https://registry.npm.taobao.org;;
        'yarn' ) yarn config set registry https://registry.npm.taobao.org;;
        'pub' ) 
          echo set pub
          if [ "$(grep $PUB $ZSHRC)" = "" ]; then
            echo $PUB_HOSTED_URL >> $ZSHRC && grep 'PUB' $ZSHRC
          elif [ "$(grep '^export PUB_HOSTED_URL=' ${ZSHRC})" != "" ]; then
            echo uncomment
            sed "@^#.*$PUB @s@^#@@" -i $ZSHRC && grep $PUB $ZSHRC
          fi
          ;;
        * ) usage;;
    esac
}

function get_url() {
    case $s1 in
        'pip' ) pip config get global.index-url;;
        'npm' ) npm config get registry;;
        'yarn' ) yarn config get registry;;
        'pub' ) 
          echo $PUB_HOSTED_URL
          grep $PUB $ZSHRC;;
        * ) usage;;
    esac
}
function unset_url() {
    case $s1 in
        'pip' ) pip config unset global.index-url;;
        'npm' ) npm config delete registry;;
        'yarn' ) yarn config delete registry;;
        'pub' ) 
          if [ "$(grep '^export PUB' $ZSHRC)" != "" ]; then
            # comment
            echo unset pub && grep $PUB $ZSHRC
            sed "/export $PUB/ s/^#*/#/" -i $ZSHRC && grep $PUB $ZSHRC
          fi
          ;;
        * ) usage;;
    esac
}

case $2 in
  "" )
    case $1 in
      -h ) usage;;
      list ) 
        s2="!get"
        array=( pip pub npm yarn )
        for package_manage in ${array[@]}
        do
            s1=$package_manage
            echo $package_manage
            get_url
        done;;
      * )  set_url;;
    esac   
    ;;
  set ) set_url;;
  unset | n ) unset_url;;
  get ) get_url;;
  * ) usage;;
esac

# vim: ts=4 sw=4 tw=0 et :
