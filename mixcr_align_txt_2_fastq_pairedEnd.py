#!/usr/bin/python

import docopt, sys
import os
import subprocess

import argparse

def main():
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('--input', dest='input', action="store",
                        help='the input alignments.txt file')
    parser.add_argument('--nreads', dest='nreads', action="store",
                        help='a integer indicating the number of reads to downsample from IG reads (file1) to add to the background genome')
    parser.add_argument('--seed', dest='seed', action="store",
                        help='random integer to set the seed for each simulation')
    parser.add_argument('--skip', dest='skip', action="store",
                        help='Will export <nreads> after skipping the first <skip> records. Skipping earlier records is often useful because the first sequences in a fastq file may have lower than average read quality.')


    #parse arguments
    args = parser.parse_args()
    input = args.input
    N = args.nreads
    seed = "-s"+str(args.seed)
    skip = int(args.skip)
    out = os.path.basename(input).split(".alignments.txt")[0]
    out_1 = out+"_pe1.all.fq"
    out_2 = out+"_pe2.all.fq"
    downs1 = out+"."+str(N) + "_pe1.downsampled.fq"
    downs2 = out+"."+str(N) + "_pe2.downsampled.fq"
    
    #open files 
    a = open(input, "r")
    fastq1 = open(out_1, "w")
    fastq2 = open(out_2, "w")

    #Write FASTQ files
    title = a.readline()
    all = 0; written = 0; errorlines = 0
    skip_first = 0
    for line in a:
        skip_first += 1
        if skip_first > skip:
            line = line.strip().split("\t")
            all += 1
            try:
                (seq1,seq2) = line[1].split(",")
                (qual1,qual2) = line[2].split(",")
                (descr1, descr2) = (line[3], line[4])
                fastq1.write("@" + descr1 + "\n")
                fastq1.write(seq1+"\n")
                fastq1.write("+\n")
                fastq1.write(qual1+"\n")
                fastq2.write("@" + descr2 + "\n")
                fastq2.write(seq2+"\n")
                fastq2.write("+\n")
                fastq2.write(qual2+"\n")
                written += 1
            except:
                #lines are not paired
                errorlines += 1
                continue

    sys.stderr.write("lines skipped: " + str(skip)+ "\n")
    sys.stderr.write("lines skipped due to error: " + str(errorlines)+ "\n")
    sys.stderr.write("lines written: " + str(written) + "\n")  
    assert(written + errorlines == all)  
    a.close()
    fastq1.close()
    fastq2.close()

    #Choose randomly    
    #using the same random seed to keep pairing
    command = "/opt/seqtk/seqtk sample %s %s %s > %s" %(seed, out_1, N, downs1)
    sys.stderr.write(command + "\n")
    subprocess.check_call(command, shell=True)

    command = "/opt/seqtk/seqtk sample %s %s %s > %s" %(seed, out_2, N, downs2)
    sys.stderr.write(command + "\n")
    subprocess.check_call(command, shell=True)    
    
    #gzip
    x = [out_1, out_2, downs1, downs2]
    for f in x:
        command = "gzip %s" %f
        sys.stderr.write(command + "\n")
        subprocess.check_call(command, shell=True)
    
    sys.stderr.flush()  
  
if __name__ == '__main__':
    main()