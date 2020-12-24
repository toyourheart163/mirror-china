#! bash

# set -x

s1=$1
s2=$2
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
    case $1 in
        '-h' ) usage;;
        'pip' )
            pip config set global.index-url\
		    https://pypi.una.singhua.edu.cn/simple;;
        'npm' ) npm config set registry https://registry.npm.taobao.org;;
        'yarn' ) yarn config set registry https://registry.npm.taobao.org;;
        'pub' ) echo "export PUB_HOSTED_URL=https://pub.flutter-cn.io" >> ~/.zshrc && grep 'PUB_HOSTED_URL' ~/.zshrc;;
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

if [ "$s2" = "set" ]; then
    set_url
elif [ "$s2" = "unset" ] || [ "$s2" = "n" ]; then
    unset_url
elif [ "$s2" = "get" ]; then
    get_url
elif [ "$s1" = "list" ]; then
    s2="get"
    for package_manage in pip npm yarn pub
    do
        s1=$package_manage
        echo $package_manage
        get_url
    done
else
	usage
fi
