#!/usr/bin/env bash

set -e

docker pull marcelocorreia/cowsay

if [[ "$(cat ${HOME}/.bash_profile | grep "supercow")" = "" ]];then
    echo alias supercow="docker run --rm marcelocorreia/cowsay" >> ${HOME}/.bash_profile
fi
