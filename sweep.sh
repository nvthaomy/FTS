#!/bin/bash
#PBS -l nodes=1:ppn=2
#PBS -l walltime=700:00:00
#PBS -V
#PBS -N opcFTS
#PBS -M my@ucsb.edu
#PBS -m ae


cd $PBS_O_WORKDIR

export PATH="/home/mnguyen/miniconda3/envs/py2/bin/:$PATH"
export PYTHONPATH=/home/mnguyen/bin/scripts/:$PYTHONPATH

Ext=Uext0_
ms=(0.001 0.006 0.01 0.56 1 2 3 4 5 6)
length=${#ms[@]}
ffFile=nacl_ff.dat
templateIn=template0_nacl_CL.in
templateOut=template_nacl_CL.in

C1=33.56
P=285.9924138
includeideal=true
ntsteps=50
numBlocks=500
python srel2fts.py $ffFile $templateIn $templateOut
for ((i=0;i<$length;i++)); do
    m=${ms[$i]}
    mydir=${m}m
    mkdir $mydir
    echo === $m mNaCl  ===
#    cp template* $mydir
    cp run.template $mydir/run.sh
    cp $templateOut $mydir/
    sed -i "s/__jobName__/$Ext${m}m/g" $mydir/run.sh
    sed -i "s/__m__/${m}/g" $mydir/run.sh
    sed -i "s/__C1__/$C1/g" $mydir/run.sh
    sed -i "s/__P__/${P}/g" $mydir/run.sh
    sed -i "s/__includeideal__/${includeideal}/g" $mydir/run.sh
    sed -i "s/__template__/${templateOut}/g" $mydir/run.sh
    sed -i "s/__ntsteps__/${ntsteps}/g" $mydir/run.sh
    sed -i "s/__numBlocks__/${numBlocks}/g" $mydir/run.sh
    cd $mydir
    qsub run.sh
    cd ..
done

