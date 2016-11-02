head -10000 ~/zeamxie/bismark_map/bedgraph_file/BSR1/bedgraph.CpG_OB_chr1 > test_BSR1_CpG_OT.res
awk '$1=="chr1"'  ~/zeamxie/bismark_map/bedgraph_file/BSR2/bed.CpG_OT_BSR2.txt |head -10000 > test_BSR2_CpG_OT.res
awk '$1=="chr1"'  ~/zeamxie/bismark_map/bedgraph_file/BSR3/bedgraph_CpG_OT_BSR3.srt |head -10000 > test_BSR3_CpG_OT.res

awk '$1=="chr1"'  ~/zeamxie/bismark_map/bedgraph_file/BSR5/bed.CpG_OT_endo.txt |head -10000 > test_BSR5_CpG_OT.res

awk '$1=="chr1"' ~/zeamxie/bismark_map/bedgraph_file/BSR6/bedgraph_CpG_OT_BSR6_srt | head -10000 > test_BSR6_CpG_OT.res

awk '$1=="chr1"' ~/zeamxie/bismark_map/bedgraph_file/BSR7/bedgraph_CpG_OB_BSR7_srt.txt | head -10000 > test_BSR7_CpG_OT.res

