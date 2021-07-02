#!/bin/bash
#============ PBS Options ============
#QSUB -q gr10458b
#QSUB -ug gr10458
#QSUB -A p=36:c=1:t=1
#QSUB -W 24:00
##QSUB -J 1
#============ Shell Script ============
set -Ceu
cat << EOS
Author: Shinji Iida
Date  : 2.7.2021

This script exexutes NVT simulation in vacuum.
    Usage:
        bash ${0} [run id] 
EOS
id="1" #${PBS_ARRAY_INDEX}

cp templates/nvt_vac.mdp nvt_vac_${id}.mdp
echo "NVT in vaccum are being executed..."
gmx grompp -f nvt_vac_${id}.mdp  \
           -c em.gro            \
           -p topol.top         \
           -o nvt_vac_${id}.tpr 

gmx mdrun -deffnm nvt_vac_${id}
