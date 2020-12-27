#! bash

# set -x

s1=$1
s2=$2
ZSHRC=~/.zshrc
function usage() {
   echo mirror -h for help
   echo """set mirror:
         $ mirror pip 
                  npm 
                  pub
                  list # list config
unset mirror:
         $ mirror pip unset
                  """
}

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
        'pub' ) echo "export PUB_HOSTED_URL=https://pub.flutter-cn.io" >> $ZSHRC && grep 'PUB_HOSTED_URL' $ZSHRC;;
        * ) usage;;
    esac
}

function get_url() {
    case $s1 in
        'pip' ) pip config get global.index-url;;
        'npm' ) npm config get registry;;
        'yarn' ) yarn config get registry;;
        'pub' ) echo $PUB_HOSTED_URL;;
        * ) usage;;
    esac
}
function unset_url() {
    case $s1 in
        'pip' ) pip config unset global.index-url;;
        'npm' ) npm config delete registry;;
        'yarn' ) yarn config delete registry;;
        'pub' ) echo """PUB_HOSTED_URL=$PUB_HOSTED_URL 
            go to ~/.zshrc and remove PUB_HOSTED_URL
            unset PUB_HOSTED_URL"""
            unset PUB_HOSTED_URL
            echo PUB_HOSTED_URL=$PUB_HOSTED_URL;;
        * ) usage;;
    esac
}

if [ "$s2" = "" ]; then
    if [ "$s1" = "-h" ] || [ "$s1" = "" ]; then
        usage
    elif [ "$s1" = "list" ]; then
        s2="get"
        for package_manage in pip npm yarn pub
        do
            s1=$package_manage
            echo $package_manage
            get_url
        done
    else
        set_url
    fi
elif [ "$s2" = "set" ]; then
    set_url
elif [ "$s2" = "unset" ] || [ "$s2" = "n" ]; then
    unset_url
elif [ "$s2" = "get" ]; then
    get_url
else
	usage
fi
