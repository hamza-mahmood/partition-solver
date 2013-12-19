#!/bin/sh

INSTANCE=$1

glpsol --model partition.mod --data $INSTANCE 
