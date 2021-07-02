#!/bin/bash
set -Ceu

cat << EOS
Author: Shinji Iida
Date  : 2.7.2021
This script automates a system preparation (EM in VACCUM) by Gromacs.
    Usage:
        bash ${0} [PDB file]
EOS

inputPDBName=$1 
proteinName=`basename ${inputPDBName%.*}`

gmx pdb2gmx -f ${inputPDBName} -o ${proteinName}_processed.gro -water none

gmx editconf -f ${proteinName}_processed.gro \
             -o ${proteinName}_newbox.gro    \
             -box 999.9                      \
             -bt cubic                       \
             -c  #Center the molecules' center of mass.

echo "Energy minimisation"
gmx grompp -f templates/em1_vac.mdp \
           -c ${proteinName}_newbox.gro \
           -r ${proteinName}_newbox.gro \
           -p topol.top \
           -o em.tpr 
gmx mdrun -deffnm em
