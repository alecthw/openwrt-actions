#!/bin/bash

CUR_PATH=$(
    cd $(dirname $0)
    pwd
)
echo "Info: Current path is $CUR_PATH"
cd ${CUR_PATH}
git pull

error() {
    local msg=$1
    local exit_code=$2

    echo "Error: $msg" >&2

    if [ -n "$exit_code" ]; then
        exit ${exit_code}
    fi
}

init_code_dir() {
    if [ ! -n "$target" ]; then
        error "Option --target argument is reuqired!"
    fi

    # export env
    source ${CUR_PATH}/user/${target}/settings.ini

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
    official-master-x64)
        code_dir="official"
        ;;
    lede-newifi_d2 | lede-wrt1900acs)
        code_dir="lede_device"
        ;;
    *)
        error "Unknow $target!" 2
        ;;
    esac
}

pre_build() {
    # clone code
    echo "Info: Clone code $REPO_URL $REPO_BRANCH..."
    cd ${CUR_PATH}
    git clone ${REPO_URL} -b ${REPO_BRANCH} ${code_dir}

    # apply patches
    echo "Info: Apply patches..."
    cd ${CUR_PATH}
    if [ -n "$(ls -A "user/common/patches" 2>/dev/null)" ]; then
        find "user/common/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d '$code_dir' -p0 --forward"
    fi
    if [ -n "$(ls -A "user/${target}/patches" 2>/dev/null)" ]; then
        find "user/${target}/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d '$code_dir' -p0 --forward"
    fi

    # feeds
    echo "Info: Update feeds..."
    cd ${CUR_PATH}/${code_dir}
    ./scripts/feeds update -a && ./scripts/feeds install -a

    # apply files...
    if [ "lede_device" != "${code_dir}" ]; then
        echo "Info: Apply files..."
        cd ${CUR_PATH}
        if [ -n "$(ls -A "user/common/files" 2>/dev/null)" ]; then
            cp -rf user/common/files/* ${code_dir}/package/base-files/files/
        fi
        if [ -n "$(ls -A "user/$target/files" 2>/dev/null)" ]; then
            cp -rf user/${target}/files/* ${code_dir}/package/base-files/files/
        fi
    fi

    # apply custom.sh
    echo "Info: Apply custom.sh..."
    cd ${CUR_PATH}/${code_dir}
    if [ -f "../user/common/custom.sh" ]; then
        /bin/bash "../user/common/custom.sh"
    fi
    if [ -f "../user/$target/custom.sh" ]; then
        /bin/bash "../user/$target/custom.sh"
    fi

    # copy config
    echo "Info: Copy config..."
    cd ${CUR_PATH}/${code_dir}
    cp -rf ../user/${target}/config.diff .config
    make defconfig
}

pre_rebuild() {
    # upate code
    echo "Info: Update code..."
    cd ${CUR_PATH}/${code_dir}
    git pull

    # update custom feeds
    if [ -d "$CUR_PATH/$code_dir/package/luci-app-jd-dailybonus" ]; then
        echo "Info: Update luci-app-jd-dailybonus..."
        cd ${CUR_PATH}/${code_dir}/package/luci-app-jd-dailybonus && git pull
    fi
    if [ -d "$CUR_PATH/$code_dir/package/luci-app-serverchan" ]; then
        echo "Info: Update luci-app-serverchan..."
        cd ${CUR_PATH}/${code_dir}/package/luci-app-serverchan && git pull
    fi
    if [ -d "$CUR_PATH/$code_dir/package/luci-app-smartdns" ]; then
        echo "Info: Update luci-app-smartdns..."
        cd ${CUR_PATH}/${code_dir}/package/luci-app-smartdns && git pull
    fi

    # feeds
    echo "Info: Update feeds..."
    cd ${CUR_PATH}/${code_dir}
    ./scripts/feeds update -a && ./scripts/feeds install -a

    # def config
    echo "Info: Defult config..."
    cd ${CUR_PATH}/${code_dir}
    make defconfig
}

do_prepare() {
    if [ ! -d "$CUR_PATH/$code_dir" ]; then
        pre_build
    else
        pre_rebuild
    fi
}

do_compile() {
    # make download
    cd ${CUR_PATH}/${code_dir}
    make -j$(($(nproc) + 1)) download

    # make
    cd ${CUR_PATH}/${code_dir}
    make -j$(($(nproc) + 1))
}

do_env() {
    sudo apt install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf
}

do_help() {
    cat <<EOF
Usage: bash $0 <command> [options]...

commands:
    help, h                display this help text
    env, e                 init environment, sudo apt install xxx
    prepare, p             update feeds and apply custom setings
    compile, c             make download and make

options:
    --target, -t           target to execute, it's a sub dir name in user

examples:
    bash localbuild.sh p -t lienol-master-x64
    bash localbuild.sh c -t lienol-master-x64
EOF
}

# return code
RET_VAL=0

mode=$1
shift

target=""
while [ -n "$*" ]; do
    arg=$1
    shift
    case "$arg" in
    --target | -t)
        [ -n "$1" ] || error "Option --target|-t requires an argument" 2
        target=$1
        shift
        ;;
    esac
done

code_dir=""

case "$mode" in
help | h)
    do_help
    ;;
env | e)
    do_env
    ;;
prepare | p)
    init_code_dir
    do_prepare
    ;;
compile | c)
    init_code_dir
    do_compile
    ;;
all | a)
    init_code_dir
    do_prepare
    do_compile
    ;;
*)
    error "Unknow or unspecified command $mode!"
    ;;
esac
