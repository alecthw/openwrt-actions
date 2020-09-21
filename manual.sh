git clone -b dev-master https://github.com/Lienol/openwrt.git

find "user/common/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d 'openwrt' -p0 --forward"
find "user/lienol-master-x64/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d 'openwrt' -p0 --forward"

cd openwrt && ./scripts/feeds update -a
cd openwrt && ./scripts/feeds install -a

cp -r -f user/common/files/* openwrt/package/base-files/files/
cp -r -f user/lienol-master-x64/files/* openwrt/package/base-files/files/

/bin/bash "../user/common/custom.sh"
/bin/bash "../user/lienol-master-x64/custom.sh"

cp ../user/lienol-master-x64/config.diff .config




#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------




git clone https://github.com/coolsnowwolf/lede.git

find "user/common/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d 'lede' -p0 --forward"
find "user/lede-x64/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d 'lede' -p0 --forward"

cd lede && ./scripts/feeds update -a
cd lede && ./scripts/feeds install -a

cp -r -f user/common/files/* lede/package/base-files/files/
cp -r -f user/lede-x64/files/* lede/package/base-files/files/

/bin/bash "../user/common/custom.sh"
/bin/bash "../user/lede-x64/custom.sh"

cp ../user/lede-x64/config.diff .config




#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------




git clone https://github.com/coolsnowwolf/lede.git lede-device

find "user/common/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d 'lede-device' -p0 --forward"
find "user/lede-wrt1900acs/patches" -type f -name '*.patch' -print0 | sort -z | xargs -I % -t -0 -n 1 sh -c "cat '%'  | patch -d 'lede-device' -p0 --forward"

cd lede-device && ./scripts/feeds update -a
cd lede-device && ./scripts/feeds install -a

cp -r -f user/common/files/* lede-device/package/base-files/files/
cp -r -f user/lede-wrt1900acs/files/* lede-device/package/base-files/files/

/bin/bash "../user/common/custom.sh"
/bin/bash "../user/lede-wrt1900acs/custom.sh"

cp ../user/lede-wrt1900acs/config.diff .config


