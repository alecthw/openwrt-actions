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

force_pull() {
    branch=`git branch | grep "*"`
    currBranch=${branch:2}
    echo "Info: Current branch is $currBranch"
    git fetch --all
    git reset --hard origin/${currBranch}
}

init_code_dir() {
    if [ ! -n "$target" ]; then
        error "Option --target argument is reuqired!"
    fi

    echo "Info: Current target is $target"

    # export env
    source ${CUR_PATH}/user/${target}/settings.ini

    case "$target" in
    lienol-main-x64)
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

    echo "Info: Current code_dir is $code_dir"
}

do_prepare() {
    # clone/update code
    cd ${CUR_PATH}

    if [ ! -d "$CUR_PATH/$code_dir" ]; then
        echo "Info: Clone code $REPO_URL $REPO_BRANCH..."
        git clone ${REPO_URL} -b ${REPO_BRANCH} ${code_dir}
    else
        cd ${CUR_PATH}/${code_dir}

        echo "Info: Update code..."
        force_pull

        echo "Info: Clean feeds..."
        ./scripts/feeds clean -a

        echo "Info: Clean custom package..."
        git clean -fd
        rm -rf package/luci-app-jd-dailybonus
        rm -rf package/luci-app-serverchan
        rm -rf package/luci-app-smartdns
        rm -rf package/n2n
    fi

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
    cd ${CUR_PATH}/${code_dir}
    if [ ! -f ".config" ]; then
        echo "Info: Copy config..."
        cp -rf ../user/${target}/config.diff .config
    fi
    echo "Info: Make defconfig..."
    make defconfig
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

do_personal_config() {
    # get config dir
    CONFIG_PATH=""
    if [ -d "$CUR_PATH/defconfig" ]; then
        CONFIG_PATH=$CUR_PATH/defconfig
    elif [ -d "$CUR_PATH/../archive/home/defconfig" ]; then
        CONFIG_PATH=$CUR_PATH/../archive/home/defconfig
    else
        echo "Warn: No default config exist"
        return
    fi
    echo "Info: Config path is $CONFIG_PATH..."

    # work dir
    cd ${CUR_PATH}/${code_dir}

    # network
    if [ -f "package/default-settings/files/zzz-default-settings" ]; then
        echo "Info: Custom config network"
        bash $CONFIG_PATH/network.sh           package/default-settings/files/zzz-default-settings
    fi
    if [ -f "package/lean/default-settings/files/zzz-default-settings" ]; then
        echo "Info: Custom config network lean"
        bash $CONFIG_PATH/network.sh           package/lean/default-settings/files/zzz-default-settings
    fi

    # hosts
    cp -f $CONFIG_PATH/etc/hosts    package/base-files/files/etc/hosts

    # firewall
    sed -i "/'lan'/a\	list   network		'n2n0'"              package/network/config/firewall/files/firewall.config
    sed -i "/'wan6'/a\	list   network		'iptv'"              package/network/config/firewall/files/firewall.config
    sed -i "/input		REJECT/c\	option input		ACCEPT"  package/network/config/firewall/files/firewall.config
    cp -f $CONFIG_PATH/etc/firewall.user                         package/network/config/firewall/files/firewall.user

    # adbyby
    if [ -d "package/lean/luci-app-adbyby-plus" ]; then
        echo "Info: Custom config adbyby"
        cp -f $CONFIG_PATH/etc/config/adbyby           package/lean/luci-app-adbyby-plus/root/etc/config/adbyby
    fi

    # n2n_v2
    if [ -d "package/feeds/n2n/n2n_v2" ]; then
        echo "Info: Custom config openclash"
        cp -f $CONFIG_PATH/etc/config/n2n_v2        package/feeds/n2n/n2n_v2/files/n2n_v2.config
    fi
    if [ -d "package/n2n/n2n_v2" ]; then
        echo "Info: Custom config openclash"
        cp -f $CONFIG_PATH/etc/config/n2n_v2        package/n2n/n2n_v2/files/n2n_v2.config
    fi

    # passwall
    if [ -d "package/feeds/diy1/luci-app-passwall" ]; then
        echo "Info: Custom config passwall"
        cp -f $CONFIG_PATH/etc/config/passwall         package/feeds/diy1/luci-app-passwall/root/etc/config/passwall
        cp -f $CONFIG_PATH/usr/share/passwall/rules/*  package/feeds/diy1/luci-app-passwall/root/usr/share/passwall/rules/
    fi

    # smartdns
    if [ -d "package/feeds/luci/luci-app-smartdns" ]; then
        echo "Info: Custom config smartdns"
        mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/config
        mkdir -p package/feeds/luci/luci-app-smartdns/root/etc/smartdns
        cp -f $CONFIG_PATH/etc/config/smartdns         package/feeds/luci/luci-app-smartdns/root/etc/config/smartdns
        cp -f $CONFIG_PATH/etc/smartdns/custom.conf    package/feeds/luci/luci-app-smartdns/root/etc/smartdns/custom.conf 
    fi

    # udpxy
    if [ -d "package/feeds/packages/udpxy" ]; then
        echo "Info: Custom config udpxy"
        cp -f $CONFIG_PATH/etc/config/udpxy            package/feeds/packages/udpxy/files/udpxy.conf
    fi

    # vlmcsd
    if [ -d "package/lean/luci-app-vlmcsd" ]; then
        echo "Info: Custom config vlmcsd"
        cp -f $CONFIG_PATH/etc/config/vlmcsd           package/lean/luci-app-vlmcsd/root/etc/config/vlmcsd
    fi

    # openclash
    if [ -d "package/feeds/openclash/luci-app-openclash" ]; then
        echo "Info: Custom config openclash"
        cp -f $CONFIG_PATH/etc/config/openclash        package/feeds/openclash/luci-app-openclash/root/etc/config/openclash
    fi
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
def | d)
    init_code_dir
    do_personal_config
    ;;
*)
    error "Unknow or unspecified command $mode!"
    ;;
esac
