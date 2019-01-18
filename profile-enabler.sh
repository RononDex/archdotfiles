#!/bin/sh

# --------------------------------------------
# Script to install / enable a profile
# --------------------------------------------

# Define some constants
RED='\033[0;31m'
GREEN='\033[1;32m'
PURPLE='\033[1;35m'
NC='\033[0m' # No Color
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
profilesFolder="$scriptDir/profiles/"

# Welcome message
echo
echo "--------------------------------------------"
echo "   Tino's Profile enabler"
echo "--------------------------------------------"
echo

# List available profiles
echo "Available profiles: "
echo

i=1
for d in $profilesFolder* ; do
    echo "      $i) $(basename $d)"
    profiles+=("$d")
    i=$((i+1))
done

# Let user select a profile
echo
echo -n "Select profile number: "
read selectedProfile

re='^[0-9]+$'
if ! [[ $selectedProfile =~ $re ]] ; then
   echo -n "$RED"
   echo "error: Not a number$NC" >&2; exit -1;
fi

echo