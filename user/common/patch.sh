#!/bin/bash

target=$1
echo "Execute common patch.sh ${target}"

array=(${target//-/ })
source=${array[0]}
echo "Source: ${source}"

do_remove_lede_n2n() {
    echo "Remove n2n in lede"
    rm -rf package/lean/luci-app-n2n_v2
    rm -rf package/lean/n2n_v2
}

case "${source}" in
lienol)
    echo "do lienol"
    ;;
lede)
    echo "do lede"
    do_remove_lede_n2n
    ;;
*)
    echo "Unknow ${source}!"
    ;;
esac
