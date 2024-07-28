count_entities = function(table_entities, rel_triples){
  table_entities = merge(table_entities[,1], rel_triples, by = "V1", all.x = T)
  properties = c("http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
                 "https://w3id.org/biolink/vocab/category",
                 "http://www.w3.org/2000/01/rdf-schema#subClassOf",
                 "https://w3id.org/linkml/is_a"
  )
  table_entities = table_entities[which(table_entities$V2 %in% properties),]
  
  indexes = which(table_entities$V2 %in% c("http://www.w3.org/2000/01/rdf-schema#subClassOf",
                                        "https://w3id.org/linkml/is_a",
                                        "https://w3id.org/biolink/vocab/category"))
  subclass_category = table_entities[indexes,]
  table_subclass_category = data.frame(table(subclass_category$V3))
  indexes = which(table_subclass_category$Var1 %in% c("https://w3id.org/biolink/vocab/Genome",
                                                        "https://w3id.org/biolink/vocab/GenomicSequenceLocalization",
                                                        "https://w3id.org/biolink/vocab/InformationResource",
                                                        "https://w3id.org/biolink/vocab/EntityToDiseaseAssociationMixin"))
  if (length(indexes) > 0) {table_subclass_category = table_subclass_category[-indexes,]}
  if (nrow(table_subclass_category) > 0){table_subclass_category$Var1 = paste("Subclass of", table_subclass_category$Var1)}
  table = table_subclass_category

  indexes = which(table_entities$V1 %in% subclass_category$V1)
  if (length(indexes) > 0) {table_entities = table_entities[-indexes,]}
  
  indexes = which(table_entities$V2 == "http://www.w3.org/1999/02/22-rdf-syntax-ns#type" & 
                    table_entities$V3 == "http://www.w3.org/2002/07/owl#Class")
  if (length(indexes) > 0) {
    table_classes = data.frame(table(table_entities$V1[indexes]))
    table_classes$Var1 = paste("Class", table_classes$Var1)
    table_entities = table_entities[-indexes,]
    table = rbind(table_classes, table)
  }
  
  if (nrow(table_entities) > 0) {
    inst_classes = table_entities[table_entities$V2 == "http://www.w3.org/1999/02/22-rdf-syntax-ns#type",]
    inst_classes = inst_classes[,-2]
    rel_triples = rel_triples[rel_triples$V2 == "http://www.w3.org/2000/01/rdf-schema#subClassOf",-2]
    colnames(rel_triples) = c("V3", "V5")
    inst_classes = merge(inst_classes, rel_triples, by = "V3", all.x = T)
    inst_classes = data.frame(table(inst_classes$V5))
    if (nrow(inst_classes) != 0){
      inst_classes$Var1 = paste("instances of", inst_classes$Var1)
      table = rbind(table, inst_classes)
    }
  }
  return(table)
}

align_ent2count_table = function (results_path){
  library(data.table)
  library(dplyr)
  dataset_subdivision_path = gsub("/results", "", results_path)
  methods = list.dirs(results_path, full.names = T, recursive = F)
  if (length(methods) > 0) {
    for (i in 1:length(methods)){
      files = list.files(methods[i], pattern = "aligned_entities", recursive = T, full.names = T)
      if (length(files) > 0) {
        for (j in 1:length(files)){
          aligned_entities = fread(files[j], header = F, sep = "\t")
          split_path = unlist(strsplit(files[j], "/"))
          split_path = paste(split_path[(length(split_path)-3):(length(split_path)-2)], collapse = "/")
          test_links = fread(paste0(dataset_subdivision_path, "/", split_path, "/test_links"), header = F, sep = "\t")
          aligned_entities = inner_join(aligned_entities, test_links)
          rel_triples = fread(paste0(dataset_subdivision_path, "/rel_triples_1"), header = F, sep = "\t")
  
          table_expected_entities = count_entities(test_links, rel_triples)
          colnames(table_expected_entities)[2] = "exp_Freq"
          if (nrow(aligned_entities) == 0){
            table_count_entities = cbind(table_expected_entities, obt_Freq = 0, obt_percentage = 0)
          } else {
            table_obtained_entities = count_entities(aligned_entities, rel_triples)
            colnames(table_obtained_entities)[2] = "obt_Freq"
            table_count_entities = merge(table_expected_entities, table_obtained_entities, by = "Var1", all.x = T)
            table_count_entities$obt_percentage = (table_count_entities$obt_Freq*100)/table_count_entities$exp_Freq
            table_count_entities[is.na(table_count_entities)] = 0
          }
          
          save_path = gsub("aligned_entities", "count_entities", files[j])
          fwrite(table_count_entities, save_path, col.names = T, row.names = F, sep = "\t", quote = F)
        }
      }
    }
  }
}

align_ent2count_table("../AvsA/results/ENdb/all/results/")
