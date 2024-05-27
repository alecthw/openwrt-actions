#!/bin/bash

CUR_PATH=$(
    cd $(dirname $0)
    pwd
)
echo "Info: Current path is ${CUR_PATH}"
cd ${CUR_PATH}
git pull

error() {
    local msg=$1
    local exit_code=$2

    echo "Error: ${msg}" >&2

    if [ -n "${exit_code}" ]; then
        exit ${exit_code}
    fi
}

force_pull() {
    local branch=$(git branch | grep "*")
    local currBranch=${branch:2}
    echo "Info: Current branch is ${currBranch}"
    git fetch --all
    git reset --hard origin/${currBranch}
}

init_code_dir() {
    if [ ! -n "${target}" ]; then
        error "Option --target argument is reuqired!"
    fi

    echo "Info: Current target is ${target}"

    # export env
    source ${CUR_PATH}/user/${target}/settings.ini

    # init code dir
    target_array=(${target//-/ })
    build_source=${target_array[0]}
    build_type=${target_array[1]}
    code_dir="${build_source}_${build_type}"

    echo "Info: Current code_dir is ${code_dir}"
}

clean_package() {
    if [ -d "${CUR_PATH}/${code_dir}/build_dir" ]; then
        echo "Info: Clean package $1"
        make $1/clean
    fi
}

do_prepare() {
    # clone/update code
    cd ${CUR_PATH}

    if [ ! -d "${CUR_PATH}/${code_dir}" ]; then
        echo "Info: Clone code ${REPO_URL} ${REPO_BRANCH}..."
        git clone --depth=1 --single-branch -b ${REPO_BRANCH} ${REPO_URL} ${code_dir}
    else
        cd ${CUR_PATH}/${code_dir}

        # clean package build which has bee changed by script
        echo "Info: Clean build has custom config..."
        clean_package package/base-files

        # clean feeds
        echo "Info: Clean feeds..."
        ./scripts/feeds clean -a

        # clean tmp
        rm -rf tmp .config

        # clean code
        echo "Info: Clean custom package..."
        git clean -fd

        echo "Info: Update code..."
        force_pull
    fi

    # --------------------- Apply private
    # apply private if exist
    echo "Info: Apply private..."
    cd ${CUR_PATH}
    if [ -n "../archive" ]; then
        rm -rf app_config
        cp -rf ../archive/home/defconfig app_config
        rm -rf user/${target}/files/etc/config
        rm -rf user/${target}/files/etc/AdGuardHome
    fi

    # --------------------- Apply patches
    # apply patches
    echo "Info: Apply patches..."
    cd ${CUR_PATH}
    if [ -n "$(ls -A "user/common/patches" 2>/dev/null)" ]; then
        find "user/common/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d '${code_dir}' -p0 --forward"
    fi
    if [ -n "$(ls -A "user/${target}/patches" 2>/dev/null)" ]; then
        find "user/${target}/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d '${code_dir}' -p0 --forward"
    fi

    # --------------------- Update feeds
    echo "Info: Update feeds..."
    cd ${CUR_PATH}/${code_dir}
    ./scripts/feeds update -a

    # --------------------- Copy custom files
    # apply files...
    echo "Info: Apply files..."
    cd ${CUR_PATH}
    mkdir -p ${code_dir}/files
    if [ -n "$(ls -A "user/common/files" 2>/dev/null)" ]; then
        cp -af user/common/files/* ${code_dir}/files/
    fi
    if [ -n "$(ls -A "user/${target}/files" 2>/dev/null)" ]; then
        cp -af user/${target}/files/* ${code_dir}/files/
    fi

    # --------------------- Load custom script
    # apply custom.sh
    echo "Info: Apply custom.sh..."
    cd ${CUR_PATH}/${code_dir}
    if [ -f "../user/common/custom.sh" ]; then
        /bin/bash "../user/common/custom.sh" ${target}
    fi
    if [ -f "../user/${target}/custom.sh" ]; then
        /bin/bash "../user/${target}/custom.sh"
    fi

    # --------------------- Install feeds
    echo "Info: Update feeds..."
    cd ${CUR_PATH}/${code_dir}
    ./scripts/feeds install -a

    # --------------------- Load custom configuration
    echo "Apply app_config.sh"
    cd ${CUR_PATH}/${code_dir}
    if [ -f "../app_config.sh" ]; then
        /bin/bash "../app_config.sh" ${target}
    fi

    # --------------------- Copy build config
    cd ${CUR_PATH}/${code_dir}
    cp -af ../user/${target}/${CONFIG_FILE} .config
    # apply private if exist
    if [ -f "../app_config/${target}.diff" ]; then
        cp ../app_config/${target}.diff .config
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
    sudo apt install ack antlr3 aria2 asciidoc autoconf automake autopoint binutils bison build-essential bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python2.7 python3 python3-pip python3-pyelftools libpython3-dev qemu-utils rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev
}

do_help() {
    cat <<EOF
Usage: bash $0 <command> [options]...

commands:
    help, h                display this help text
    env, e                 init environment, sudo apt install xxx
    prepare, p             update feeds and apply custom setings
    compile, c             make download and make
    all, a                 do prepare and compile

options:
    --target, -t           target to execute, it's a sub dir name in user

examples:
    bash localbuild.sh p -t lede-common-x86-amd64
    bash localbuild.sh c -t lede-common-x86-amd64
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
    case "${arg}" in
    --target | -t)
        [ -n "$1" ] || error "Option --target|-t requires an argument" 2
        target=$1
        shift
        ;;
    esac
done

code_dir=""

case "${mode}" in
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
    error "Unknow or unspecified command ${mode}!"
    ;;
esac
