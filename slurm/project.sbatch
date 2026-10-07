#!/bin/sh

# This SBATCH example assumes you have a binary called main 
# built at the git base folder of the project

#SBATCH -J "MNXB11 Project Team X"
#SBATCH --time=00:01:00
#SBATCH -A hep2023-1-6
#SBATCH --mem 1M

# Find and change directory to git base folder
GITROOT=$(git rev-parse --show-toplevel)

if [ -d $GITROOT ]; then
   cd $GITROOT
else
   echo "not a git repository, exiting..."
   exit 1
fi

# TODO move these to a wrapper script instead?
# Uncomment one of these lines to choose what to execute. Default is the 'main' binary file.
EXECUTABLE="./main"
#EXECUTABLE="root rootlogon.C"

# Execute main binary
exec $EXECUTABLE

if [ $? != 0 ]; then
   echo "main executable not found."
   echo "Did you compile the executable using g++?"
   echo "Did you want to run a ROOT script? Where is it located?"
   echo "Are you running in the container?"
   exit 1
fi

