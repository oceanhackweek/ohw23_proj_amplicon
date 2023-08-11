#!/bin/bash --login
#SBATCH --job-name=seq2taxa
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=12:00:00
#SBATCH --mem=64G
#SBATCH --output=seq2taxa-%j.e
#SBATCH --error=seq2taxa-%j.o
#SBATCH -A OD-219546

conda activate obitools

cd $SCRATCH3DIR

#This code will run the obitools wolves tutorial commands the chosen data
#Unzips the fastq file that was produced from the Illumina MiSeq run
gunzip EFMSRun372-Elib238_S1_L001_R1_001.fastq.gz

mv EFMSRun372-Elib238_S1_L001_R1_001.fastq INV2022_V09.fastq

#Demultiplex the data
ngsfilter -t INV2022_V09_ngsfilter.txt -u unidentified.fastq INV2022_V09.fastq > assigned.fastq

##Dereplicate reads into unique sequences
obiuniq -m sample assigned.fastq > assisned_unique.fasta

##Retain only sample ID and sequence counts in FASTA headers; renamed
obiannotate -k count -k merged_sample assisned_unique.fasta > $$ ; mv $$ assigned_unique_counts.fasta
#Retail sequences 150bp or longer and with counts of at least 2
obigrep -l 150 -p ‘count>=2’ assigned_unique_counts.fasta > assigned_unique_2_150.fasta

##Denoising; keep the head sequences that are sequences with no variants with a count ##greater than 5% of their own count (This step took 6.5 hours to do)
obiclean -s merged_sample -r 0.05 -H assigned_unique_2_150.fasta > assigned_unique_2_150_clean.fasta

#Assign sequences to taxa using the fish only database produced 20/9/2020 - used as a point of reference
#ecotag -d embl_last -R db_vnew.fasta assigned_unique_2_150_clean.fasta >  assigned_unique_2_150_clean_tag_10082023.fasta
ecotag -d embl_last -R db_vnew_fish_only.fasta assigned_unique_2_150_clean.fasta >  assigned_unique_2_150_clean_tag_FO.fasta

#Generate the final result table
obiannotate  --delete-tag=scientific_name_by_db --delete-tag=obiclean_samplecount  --delete-tag=obiclean_count --delete-tag=obiclean_singletoncount  --delete-tag=obiclean_cluster --delete-tag=obiclean_internalcount  --delete-tag=obiclean_head --delete-tag=taxid_by_db --delete-tag=obiclean_headcount  --delete-tag=id_status --delete-tag=rank_by_db --delete-tag=order_name assigned_unique_2_150_clean_tag_FO.fasta > assigned_unique_2_150_clean_tag_ann_FO.fasta


#Sort the sequences in order of count
obisort -k count -r assigned_unique_2_150_clean_tag_ann_FO.fasta >   assigned_unique_2_150_clean_tag_ann_sort_FO.fasta

#Create a tab-delimited file that can be open by excel or R 
obitab -o assigned_unique_2_150_clean_tag_ann_sort_FO.fasta > assigned_unique_2_150_clean_tag_ann_sort_FO.tab
