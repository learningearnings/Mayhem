#!/bin/bash
RAKETASK=$1
shift
rakeargs=$@
rake import:$RAKETASK[${rakeargs// /-}] --trace
