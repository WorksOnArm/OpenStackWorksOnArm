#!/bin/bash
#
# usage: ./MasterTest.sh > MasterTest.out 2>&1
#

while `true`
do
  echo UserPerfTest
  time ./UserPerfTest.sh
  sleep 30
  echo ImagePerfTest
  time ./ImagePerfTest.sh
  sleep 30
  echo ComputePerfTest
  time ./ComputePerfTest.sh
  sleep 30
done

