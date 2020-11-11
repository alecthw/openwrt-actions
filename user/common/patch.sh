#!/bin/bash

target=$1
echo "Execute common patch.sh ${target}"

array=(${target//-/ })
source=${array[0]}
echo "Source: ${source}"

do_common() {
    echo ""
}

do_lienol_common() {
    echo ""
}

do_lede_common() {
    rm -rf package/lean/luci-app-n2n_v2
    rm -rf package/lean/n2n_v2
}

# excute begin
do_common

case "${source}" in
lienol)
    echo "do lienol"
    do_lienol_common
    ;;
lede)
    echo "do lede"
    do_lede_common
    ;;
*)
    echo "Unknow ${source}!"
    ;;
esac
