average_entity_count = function (results_path) {
  library(data.table)
  library(dplyr)
  methods = list.dirs(results_path, recursive = F, full.names = T)
  for (method in methods){
    data_subdivision = list.dirs(method, recursive = T, full.names = T)[3]
    files = list.files(data_subdivision, "^count_entities", recursive = T, full.names = T)
    if (length(files) > 0){
      table = data.frame()
      for (file in files){
        file = fread(file, header = T, sep = "\t")
        table = rbind(table, file)
      }
      table = as.data.frame(table)
      table[is.na(table)] = 0
        
      for (i in 2:ncol(table)){
        table[,i] = as.numeric(table[,i])
      }
        
      average_table = table %>% 
        group_by(Var1) %>% 
        summarize(mean_exp_Freq = mean(exp_Freq),
                  mean_obt_Freq = mean(obt_Freq),
                  mean_obt_percentage = mean(obt_percentage))
      
      fwrite(average_table, paste0(data_subdivision, "/average_entity_count"), col.names = T, row.names = F, sep = "\t")
    }
  }
}

average_entity_count("../AvsA/results/ENdb/all/results/")
