#!/bin/bash
##############################################################################
# Copyright (c) 2016-19, Lawrence Livermore National Security, LLC and Umpire
# project contributors. See the COPYRIGHT file for details.
#
# SPDX-License-Identifier: (MIT)
##############################################################################
replay_tests_dir=$1
tools_dir=$2
testprogram=$replay_tests_dir/replay_tests
replayprogram=$tools_dir/replay

#
# The following program will generate a CSV file of Umpire activity that
# may be replayed.
#
UMPIRE_REPLAY=On $testprogram
if [ $? -ne 0 ]; then
    echo "Failed: Unable to run $testprogram"
    exit 1
fi

#
# Now replay from the activity captured in the replay_test1.csv file
#
$replayprogram -i umpire.*.0.replay -t replay.out
if [ $? -ne 0 ]; then
    echo "Failed: Unable to run $replayprogram"
    exit 1
fi

#
# Now, compare the results being careful to allow for different object
# references (everything else should be the same).
#
diff replay.out $replay_tests_dir/test_output.good
if [ $? -ne 0 ]; then
    /bin/rm -f replay.out umpire*replay umpire*log
    echo "Diff failed"
    exit 1
fi

/bin/rm -f replay.out umpire*replay umpire*log
exit 0
