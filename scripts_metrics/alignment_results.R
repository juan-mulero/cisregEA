alignment_results = function(result_path){
  methods = list.dirs(result_path, recursive = F)
  if (length(methods) > 0) {
    for (i in 1:length(methods)){
      alignment_results = list.files(methods[i], "alignment_results_12", recursive = T, full.names = T)
      if (length(alignment_results)>0){
        for (j in 1:length(alignment_results)){
          align_path = gsub("alignment_results_12", "", alignment_results[j])
          alignment_result = fread(alignment_results[j], header = F, sep = "\t")
          kg1_ent_ids = fread(paste0(align_path, "kg1_ent_ids"), header = F, sep = "\t")
          colnames(kg1_ent_ids) = c("kg1", "V1")
          alignment_result = merge(alignment_result, kg1_ent_ids, by = "V1", all.x = T)
          rm(kg1_ent_ids)
          
          kg2_ent_ids = fread(paste0(align_path, "kg2_ent_ids"), header = F, sep = "\t")
          colnames(kg2_ent_ids) = c("kg2", "V2")
          alignment_result = merge(alignment_result, kg2_ent_ids, by = "V2", all.x = T)
          alignment_result = alignment_result[,3:4]
          
          fwrite(alignment_result, paste0(align_path, "aligned_entities"), col.names = F, row.names = F, sep = "\t", quote = F)
        }
      }
    }
  }
}


alignment_results("../AvsA/results/ENdb/all/results/")
