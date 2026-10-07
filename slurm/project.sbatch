#!/bin/sh

# This SBATCH example assumes you have a script that 
# takes care of preparing the environment for the 
# job. In this case I am reusing the startproject.sh
# script inside ../scripts

#SBATCH -J "MNXB11 Project Team X"
#SBATCH --time=00:01:00
#SBATCH -A hep2023-1-6
#SBATCH --mem 1M

../scripts/startproject.sh
