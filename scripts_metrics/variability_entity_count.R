variability_entity_count = function (results_path) {
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
      
      coef_var = function(x, na.rm = T) {
        (sd(x, na.rm=na.rm) / mean(x, na.rm=na.rm))*100
      }
      
      variability_table = table %>% 
        group_by(Var1) %>% 
        summarize(var_matches = var(obt_percentage),
                  sd_matches = sd(obt_percentage),
                  cv_matches = coef_var(obt_percentage)
                  )

      fwrite(variability_table, paste0(data_subdivision, "/variability_entity_count"), 
             col.names = T, row.names = F, sep = "\t")
    }
  }
}

variability_entity_count("../AvsA/results/ENdb/all/results/")
