#!//usr/bin/env bash

set -xe

start_addr="0x6002"
parameters="--optimize 4 -H 2048 --explicit --strict --org $start_addr --expect-warnings 999999"

create_start_file() {
  header_size="0x3A"
  palette_size=16
  externs_size=$((13*2))
  size=$(wc -c < "$bin")
  dest=${filename}_LABELS.ASM
  addr=$(($size + $start_addr))
  echo DDB_HEADER EQU $addr > $dest
  addr=$(($addr + $header_size))
  echo START_PALETTE EQU $addr >> $dest
  addr=$(($addr + $palette_size))
  echo VECT_EXTERN EQU $addr >> $dest
  addr=$(($addr + 2))
  echo VECT_SFX EQU $addr >> $dest
  addr=$(($addr + 2))
  echo VECT_INT EQU $addr >> $dest
  addr=$(($addr + 2))
  for i in {0..9}
  do
    echo "VECT_$i EQU $addr" >> $dest
    addr=$(($addr + 2))
  done
  echo START_DDB EQU $addr >> $dest
  cat $map | sed -e 's,\.,_,g' -re 's,(....): (.*),\2 EQU $\1,' >> $dest
  echo >> $dest
}

do_bin() {
  code=$1
  shift
  filename=$1
  bin=$filename.BIN
  map=$filename.map
  shift
  test -e $bin || zxbc -o $bin --mmap $map $parameters "$@" ZXDAAD128.bas
  create_start_file
  echo $code built
}

do_bin TAPE-EN-42  ZXD128_TAPE_EN_C42   -D LANG_EN -D FONT42
do_bin TAPE-ES-42  ZXD128_TAPE_ES_C42   -D LANG_ES -D FONT42
do_bin PLUS3-EN-42 ZXD128_PLUS3_EN_C42  -D LANG_EN -D FONT42 -D PLUS3
do_bin PLUS3-ES-42 ZXD128_PLUS3_ES_C42  -D LANG_ES -D FONT42 -D PLUS3
do_bin TAPE-EN-32  ZXD128_TAPE_EN_C32   -D LANG_EN -D FONT32
do_bin TAPE-ES-32  ZXD128_TAPE_ES_C32   -D LANG_ES -D FONT32
do_bin PLUS3-EN-32 ZXD128_PLUS3_EN_C32  -D LANG_EN -D FONT32 -D PLUS3
do_bin PLUS3-ES-32 ZXD128_PLUS3_ES_C32  -D LANG_ES -D FONT32 -D PLUS3

python3 build_drb128.py
sjasmplus asm/loader.asm --sym=asm/loader.sym
sjasmplus asm/loaderplus3.asm --sym=asm/loaderplus3.sym
python3 build_DaadMaker128.py
python3 build_DaadMakerPlus3.py
