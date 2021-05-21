#!/usr/bin/env bash

source ./global_funcs.sh
include ./line_reader.sh


LsInfoToArr FILES_DATA
Hashing FILES_DATA HASH_ARR "c"

