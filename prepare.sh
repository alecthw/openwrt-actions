#!/bin/bash

CUR_PATH=$(
    cd $(dirname $0)
    pwd
)
echo "Info: current path is $CUR_PATH"
cd ${CUR_PATH}

error() {
    local msg=$1
    local exit_code=$2

    echo "Error: $msg" >&2

    if [ -n "$exit_code" ]; then
        exit ${exit_code}
    fi
}

pre_build() {
    # clone code
    cd ${CUR_PATH}
    git clone ${REPO_URL} -b ${REPO_BRANCH} ${code_dir}

    # apply patches
    cd ${CUR_PATH}
    if [ -n "$(ls -A "user/common/patches" 2>/dev/null)" ]; then
        find "user/common/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d '$code_dir' -p0 --forward"
    fi
    if [ -n "$(ls -A "user/${target}/patches" 2>/dev/null)" ]; then
        find "user/${target}/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d '$code_dir' -p0 --forward"
    fi

    # feeds
    cd ${CUR_PATH}/${code_dir}
    ./scripts/feeds update -a && ./scripts/feeds install -a

    # apply files...
    cd ${CUR_PATH}
    if [ -n "$(ls -A "user/common/files" 2>/dev/null)" ]; then
        cp -r -f user/common/files/* ${code_dir}/package/base-files/files/
    fi
    if [ -n "$(ls -A "user/$target/files" 2>/dev/null)" ]; then
        cp -r -f user/${target}/files/* ${code_dir}/package/base-files/files/
    fi

    # apply custom.sh
    cd ${CUR_PATH}/${code_dir}
    if [ -f "../user/common/custom.sh" ]; then
        /bin/bash "../user/common/custom.sh"
    fi
    if [ -f "../user/$target/custom.sh" ]; then
        /bin/bash "../user/$target/custom.sh"
    fi

    # copy config
    cd ${CUR_PATH}/${code_dir}
    cp ../user/${target}/config.diff .config
    make defconfig

    # make download
    cd ${CUR_PATH}/${code_dir}
    make -j$(($(nproc) + 1)) download
}

pre_rebuild() {
    # upate code
    cd ${CUR_PATH}/${code_dir}
    git pull

    # update custom feeds
    if [ -d "$CUR_PATH/$code_dir/package/luci-app-jd-dailybonus" ]; then
        cd ${CUR_PATH}/${code_dir}/package/luci-app-jd-dailybonus && git pull
    fi
    if [ -d "$CUR_PATH/$code_dir/package/luci-app-serverchan" ]; then
        cd ${CUR_PATH}/${code_dir}/package/luci-app-serverchan && git pull
    fi
    if [ -d "$CUR_PATH/$code_dir/package/luci-app-smartdns" ]; then
        cd ${CUR_PATH}/${code_dir}/package/luci-app-smartdns && git pull
    fi

    # feeds
    cd ${CUR_PATH}/${code_dir}
    ./scripts/feeds update -a && ./scripts/feeds install -a

    # copy config
    cd ${CUR_PATH}/${code_dir}
    make defconfig

    # make download
    cd ${CUR_PATH}/${code_dir}
    make -j$(($(nproc) + 1)) download
}

target=$1

code_dir=""

case "$target" in
lienol-master-x64)
    code_dir="openwrt"
    ;;
lienol-1907-x64)
    code_dir="openwrt_1907"
    ;;
lede-x64)
    code_dir="lede"
    ;;
lede-newifi_d2 | lede-wrt1900acs)
    code_dir="lede_device"
    ;;
*)
    error "Unknow $target!" 2
    ;;
esac

# export env
source ${CUR_PATH}/user/${target}/settings.ini

# clone code
if [ ! -d "$CUR_PATH/$code_dir" ]; then
    pre_build
else
    pre_rebuild
fi
