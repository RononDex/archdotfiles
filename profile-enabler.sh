#!/bin/sh
cd "$(dirname "$0")"

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
read selectedProfile

# Let user select a profile
echo

re='^[0-9]+$'
if ! [[ $selectedProfile =~ $re ]] ; then
   echo -n "$RED"
   echo "error: Not a number$NC" >&2;
   exit -1;
fi

# Copy defaults
echo
echo "Copying default files...."

cp -r defaults/ ~/

# Copy profile files
echo
echo "Copying profile files..."
mkdir -p ~/.profile;
cp -r ${profiles[$selectedProfile-1]} ~/.profile/

# Run default profile-installer
echo
bash ./default-profile-install.sh

# Run profile specific profile installer if it exists
echo
ProfileInstallScriptPath=${profiles[$selectedProfile -1]}/profile-enabler.sh
if [ -f "$ProfileInstallScriptPath" ]; then
   bash $ProfileInstallScriptPath
fi

echo
echo "DONE!"