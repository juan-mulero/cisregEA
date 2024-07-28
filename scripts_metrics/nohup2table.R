nohup2table = function(nohup_path){
  library(data.table)
  samples = list.dirs(nohup_path, recursive = F)
  for (sample in samples){
    files = list.files(sample)
    indexes = grep("nohup", files)
    if (length(indexes) > 0){
      files = files[indexes]
      table = data.frame()
      for (i in 1:length(files)){
        try(
          {
          file = read.delim(paste0(sample, "/", files[i]), sep = "\n", header = F)
          method = file[2,1]
          index = grep("accurate results: hits", file$V1)
          if (length(index) > 0) {
            results = file$V1[index]
            results = unlist(strsplit(results, "="))
            results = results[-1]
            results = unlist(strsplit(results, " "))
            indexes = which(results %in% c("", "[", "]%,", "mr", "mrr", "time", "s"))
            results = results[-indexes]
            results = results[-c(4,6)]
            results = gsub(",|\\[", "", results)
        
            index = grep("Total run time", file$V1)
            time = file$V1[index]
            time = unlist(strsplit(time, " = "))[2]
            time = unlist(strsplit(time, " "))[1]
          } else {
            results = rep("E", 5)
            time = "E"
          }
          table = rbind(table, c(method, results, time))
          colnames(table) = c("method", "hits1", "hits5", "hits10", "mr", "mrr", "time")
          }, silent = T
        )
      }
      write.table(table, paste0(sample, "/metrics"), col.names = T, row.names = F, sep = "|", quote = F)
    }
  }
}

nohup_path = "../AvsA/metrics/ENdb/all/"
nohup2table(nohup_path)
