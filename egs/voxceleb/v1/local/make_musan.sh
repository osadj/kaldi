#!/bin/bash
# Copyright 2015   David Snyder
# Apache 2.0.
#
# Copy of egs/sre16/v1/local/make_musan.sh (commit e3fb7c4a0da4167f8c94b80f4d3cc5ab4d0e22e8), 
# modified so that the sample rate can be specified as in input argument. 
#
# This script, called by ../run.sh, creates the MUSAN
# data directory. The required dataset is freely available at
#   http://www.openslr.org/17/

set -e
in_dir=$1
data_dir=$2
use_vocals='Y'
sample_rate=16000

if [ ! -z "$3" ]; then
  sample_rate=$3
fi
echo $sample_rate
mkdir -p local/musan.tmp

echo "Preparing ${data_dir}/musan..."
mkdir -p ${data_dir}/musan
local/make_musan.py ${in_dir} ${data_dir}/musan ${use_vocals} $sample_rate

utils/fix_data_dir.sh ${data_dir}/musan

grep "music" ${data_dir}/musan/utt2spk > local/musan.tmp/utt2spk_music
grep "speech" ${data_dir}/musan/utt2spk > local/musan.tmp/utt2spk_speech
grep "noise" ${data_dir}/musan/utt2spk > local/musan.tmp/utt2spk_noise
utils/subset_data_dir.sh --utt-list local/musan.tmp/utt2spk_music \
  ${data_dir}/musan ${data_dir}/musan_music
utils/subset_data_dir.sh --utt-list local/musan.tmp/utt2spk_speech \
  ${data_dir}/musan ${data_dir}/musan_speech
utils/subset_data_dir.sh --utt-list local/musan.tmp/utt2spk_noise \
  ${data_dir}/musan ${data_dir}/musan_noise

utils/fix_data_dir.sh ${data_dir}/musan_music
utils/fix_data_dir.sh ${data_dir}/musan_speech
utils/fix_data_dir.sh ${data_dir}/musan_noise

rm -rf local/musan.tmp
