average_metrics = function(nohup_path){
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

  average_table = table %>% 
    group_by(method) %>% 
    summarize(mean_hits1 = mean(hits1),
              mean_hits5 = mean(hits5),
              mean_hits10 = mean(hits10),
              mean_mr = mean(mr),
              mean_mrr = mean(mrr),
              mean_time = mean(time))
  
  fwrite(average_table, paste0(nohup_path, "/average_metrics"), col.names = T, row.names = F, sep = "|")
}

nohup_path = "../AvsA/metrics/ENdb/all/"
average_metrics(nohup_path)
