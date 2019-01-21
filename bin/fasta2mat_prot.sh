#!/bin/sh
set -euo pipefail

# for amino acid sequence only

# 2017.9.5 by Shohei Nagata
# Multi FASTAを読み込ませると，sim, matを出力する.

# 9.12
# 既に作成されていたblastp_makesim_args_v3.shを組み込む形で。。。。あったんかいェ....。

# 10.19
# xiangライブラリ内に移行。合わせてblast2sim.pyコマンドがpathに入ってるかの判定でエラー表示を出すように。

# 2018.5.21
# TODO
# - 引数入れてないと問答無用でエラーが出るのを修正
# - BLAST結果のファイルがすでにある場合はBLASTを書け直さない。(DB作成済みの場合と，同じE-valueでのBLAST実行済みの場合の2つ)

# 2019.1.12
# remove -parse_seqids option in makeblastdb
# makeblastdbとblast，すでにファイルが有る場合はスキップするように。

#SCRIPT_BLAST_TO_SIM=blast2sim.py

FASTA_FILE=$1
EVALUE=$2
SEQIDENT=$3

if [[ ! -f ${FASTA_FILE} ]]; then
    echo "can't find ${FASTA_FILE}, exitting.."
    exit 1
fi

if [ ! $(which blast2sim.py) ];then
    echo "can't find blast2sim.py in your path, exitting.."
    exit 1
fi

if [ "$2" = "" ]; then
    EVALUE=1e-5
fi

if [ "$3" = "" ]; then
    SEQIDENT=0
fi

NAME_CORE=`basename ${FASTA_FILE} .fasta`
NAME_CORE=`basename ${NAME_CORE} .faa`
NAME_CORE=`basename ${NAME_CORE} .fa`
OUTDIR=out_${NAME_CORE}
mkdir -p ${OUTDIR}


#########
# BLAST #
#########
if [[ ! -f ${OUTDIR}/${NAME_CORE}.phd || ! -f ${OUTDIR}/${NAME_CORE}.00.phd ]]; then
    echo "making BLAST Database.."
    makeblastdb -in ${FASTA_FILE} -out ${OUTDIR}/${NAME_CORE} -dbtype prot -hash_index -max_file_sz 2GB
else
    echo "SKIP, file already exists: making BLAST Database.."
fi

BLAST_OUT_FILE_NAME=blastp_bestHSP_${EVALUE}_${NAME_CORE}.txt

if [[ ! -f ${OUTDIR}/${BLAST_OUT_FILE_NAME} ]]; then
    echo "BLAST.."
    blastp -query ${FASTA_FILE} -db ${OUTDIR}/${NAME_CORE} -max_hsps 1 -num_threads 32 -outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore' -evalue ${EVALUE} -max_target_seqs 99999999 -out ${OUTDIR}/${BLAST_OUT_FILE_NAME}
else
    echo "SKIP, file already exists: BLAST.."
fi

###################
# create sim file #
###################

#-max_hsps 1 オプションと，-outfmt 6により不要に
#grep -v "#" ${OUTDIR}/${BLAST_OUT_FILE_NAME} | LC_ALL=C sort -k 1,2 -u > ${OUTDIR}/mbs_${BLAST_OUT_FILE_NAME}

echo "creating sim files.."
blast2sim.py -s ${SEQIDENT} -i ${OUTDIR}/${BLAST_OUT_FILE_NAME} > ${OUTDIR}/sim_pi${SEQIDENT}_${BLAST_OUT_FILE_NAME}

###
jobline "$0 ${NAME_CORE} done"
