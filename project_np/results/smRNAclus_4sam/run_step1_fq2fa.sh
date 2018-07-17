perl ../scripts/smRNA_fq2fa.pl ../siRNA/clean_data/BN1_40_clean.fq  BN1_40_clean.fa >  BN1_40_clean.stat &
perl ../scripts/smRNA_fq2fa.pl ../siRNA/clean_data/BN1_39_clean.fq  BN1_39_clean.fa >  BN1_39_clean.stat &
perl ../scripts/smRNA_fq2fa.pl ../siRNA/clean_data/BN1_38_clean.fq  BN1_38_clean.fa >  BN1_38_clean.stat  
#perl ../scripts/smRNA_fq2fa.pl ../siRNA/clean_data/BN1_37_clean.fq  BN1_37_clean.fa >  BN1_37_clean.stat
#../siRNA/clean_data/BN1_37_clean.fq  ../siRNA/clean_data/BN1_38_clean.fq  ../siRNA/clean_data/BN1_39_clean.fq  ../siRNA/clean_data/BN1_40_clean.fq

paste *stat

