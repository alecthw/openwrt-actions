#!/bin/bash

# $1: source dir
# $2: target dir
copy_s() {
    if [ -f $1 ]; then
        echo "Info: $1 is a file"
        mkdir -p ${2%/*}
        cp -af $1 $2
    elif [ -d $1 ]; then
        echo "Info: $1 is a directory"
        mkdir -p $2
        cp -af $1/* $2/
    else
        echo "Warning: $1 not exist"
    fi
}

# $1: url
# $2: target dir
dl_svn() {
    tmp_dir=$(mktemp -d)

    svn co -q $1 $tmp_dir/tmp

    if [ $? == 0 ]; then
        echo "Info: Svn download success: $1"
        rm -rf $tmp_dir/tmp/.svn

        mkdir -p $2
        mv -f $tmp_dir/tmp/* $2/
    else
        echo "Error: Svn download fail: $1"
    fi

    rm -rf $tmp_dir
}

# $1: git url
# $2: target dir
# $3: branch
dl_git() {
    tmp_dir=$(mktemp -d)

    if [ -z $3 ]; then
        git clone -q --depth=1 $1 $tmp_dir/tmp
    else
        git clone -q --depth=1 -b $3 $1 $tmp_dir/tmp
    fi

    if [ $? == 0 ]; then
        echo "Info: Git download success: $1"
        rm -rf $tmp_dir/tmp/.git

        mkdir -p $2
        mv -f $tmp_dir/tmp/* $2/
    else
        echo "Error: Git download fail: $1"
    fi

    rm -rf $tmp_dir
}

# $1: git url
# $2: target dir
# $3: sub dir
# $4: branch
dl_git_sub() {
    tmp_dir=$(mktemp -d)

    if [ -z $4 ]; then
        git clone -q --depth=1 $1 $tmp_dir/tmp
    else
        git clone -q --depth=1 -b $4 $1 $tmp_dir/tmp
    fi

    if [ $? == 0 ]; then
        echo "Info: Git-sub download success: $1/tree/$4/$3"
        rm -rf $tmp_dir/tmp/.git

        src_dir=$tmp_dir/tmp

        if [ -n $3 ]; then
            src_dir=$tmp_dir/tmp/$3
        fi

        if [ -e $src_dir ]; then
            mkdir -p $2
            mv -f $src_dir/* $2/
        else
            echo "Error: Git-sub copy fail not exist: $src_dir"
        fi
    else
        echo "Error: Git-sub download fail: $1/tree/$4/$3"
    fi

    rm -rf $tmp_dir
}

# $1: url
# $2: target file
dl_curl() {
    tmp_dir=$(mktemp -d)

    curl -skL --retry 3 --connect-timeout 3 -o $tmp_dir/tmp $1

    if [ $? == 0 ]; then
        echo "Info: Curl Download success: $1"
        rm -rf $tmp_dir/.git

        mkdir -p ${2%/*}
        mv -f $tmp_dir/tmp $2
    else
        echo "Error: Download fail: $1"
    fi

    rm -rf $tmp_dir
}
