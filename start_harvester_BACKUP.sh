#!/bin/bash -x
cd ~
cd chia-blockchain
. ./activate
chia start harvester -r
