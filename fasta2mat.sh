#!/bin/env bash
set -euo pipefail

# protein only

# 2017.9.5 by Shohei Nagata
# Multi FASTAを読み込ませると，sim, matを出力する.

FASTA_FILE=$1

if [[ ! -f ${FASTA_FILE} ]]; then
    echo "can't find ${FASTA_FILE}, exitting.."
    exit 1
fi

NAME_CORE=`basename ${FASTA_FILE} .fasta`
OUTDIR=out_${NAME_CORE}
mkdir -p ${OUTDIR}/{blastdb}


#########
# BLAST #
#########
makeblastdb -in ${FASTA_FILE} -out ${OUTDIR}/${NAME_CORE} -dbtype prot -hash_index -parse_seqids -max_file_sz 2GB

echo "BLAST.."
blastp -query ${FASTA_FILE} -db ${OUTDIR}/${NAME_CORE} -num_threads 16 -outfmt 7 -evalue 1e-5 -max_target_seqs 99999999 -out ${OUTDIR}/blast_${NAME_CORE}.txt

#作成途中

jobline "$0 ${NAME_CORE} done"
