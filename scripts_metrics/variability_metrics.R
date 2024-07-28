variability_metrics = function(nohup_path){
  library(data.table)
  library(dplyr)
  files = list.files(nohup_path, "^metrics$", recursive = T, full.names = T)
  table = data.frame()
  for (file in files){
    file = fread(file, header = T, sep = "|")
    table = rbind(table, file)
  }
  table = as.data.frame(table)
  table[table == "E"] = NA
  for (i in 2:ncol(table)){
    table[,i] = as.numeric(table[,i])
  }
  
  coef_var = function(x, na.rm = T) {
    (sd(x, na.rm=na.rm) / mean(x, na.rm=na.rm))*100
  }
  
  variability_table = table %>%
    group_by(method) %>% 
    summarize(var_hits1 = var(hits1),
              sd_hits1 = sd(hits1),
              cv_hits1 = coef_var(hits1),
              
              var_hits5 = var(hits5),
              sd_hits5 = sd(hits5),
              cv_hits5 = coef_var(hits5),
              
              var_hits10 = var(hits10),
              sd_hits10 = sd(hits10),
              cv_hits10 = coef_var(hits10),
              
              var_mr = var(mr),
              sd_mr = sd(mr),
              cv_mr = coef_var(mr),
              
              var_mrr = var(mrr),
              sd_mrr = sd(mrr),
              cv_mrr = coef_var(mrr),
              
              var_time = var(time),
              sd_time = sd(time),
              cv_time = coef_var(time)
              )
  
  fwrite(variability_table, paste0(nohup_path, "/variability_metrics"), col.names = T, row.names = F, sep = "|")
}

nohup_path = "../AvsA/metrics/ENdb/all/"
variability_metrics(nohup_path)
