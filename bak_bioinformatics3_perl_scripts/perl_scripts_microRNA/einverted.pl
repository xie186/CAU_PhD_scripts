#!/usr/bin/perl -w
open F,"$ARGV[0]";
open G,"+>>$ARGV[1]";
open R,"+>>$ARGV[2]";
while(<F>) {
  chomp;
  $fir=$_;
  $seq=<F>;
  chomp($seq);
open P,"+>out";
  print P "$fir\n$seq\n";
open O,"+>out_einverted";
open I,"+>out_einverted.fa";
  system "/home/bioinformatics2/software/EMBOSS-6.4.0/emboss/einverted -sequence out -gap 20 -threshold 60 -match 5 -mismatch -4 -maxrepeat 500 -outfile out_einverted -outseq out_einverted.fa";
  close O;
  close I;
  open O,"out_einverted";
  while(<O>) {
  chomp;
  print G "$_\n";
}
  open I,"out_einverted.fa";
  while(<I>) {
  chomp;
  print R "$_\n";
}

}  
