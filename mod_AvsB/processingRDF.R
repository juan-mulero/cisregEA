modAvsB_dataset_subdivision = function (source, target) {
  library(dplyr)
  
  #Preprocessing:
  preprocessing_RDF = function(set) {
    #Step 1
    set = set[,-4]
    set$V1 = gsub(">|<", "", set$V1)
    set$V2 = gsub(">|<", "", set$V2)
    set$V3 = gsub(">|<", "", set$V3)
    set$V3 = gsub("\" \\.", "", set$V3)
    set$V3 = gsub("\"", "", set$V3)
    indexes = grep("\\^", set$V3)
    set$V3[indexes] = gsub("\\^\\^http://www.w3.org/2001/XMLSchema#integer", "", set$V3[indexes])
    return(set)
  }
  
  source = preprocessing_RDF(source)
  target = preprocessing_RDF(target)
  
  
  ##Source file:
  #Object properties source
  object_properties_source = c("http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
                               "https://w3id.org/biolink/vocab/category",
                               "http://www.w3.org/2000/01/rdf-schema#subClassOf",
                               "https://w3id.org/linkml/is_a",
                               "http://purl.obolibrary.org/obo/BFO_0000050",
                               "http://purl.obolibrary.org/obo/RO_0002162",
                               "http://purl.obolibrary.org/obo/RO_0002331",
                               "http://purl.obolibrary.org/obo/RO_0002429",
                               "http://purl.obolibrary.org/obo/RO_0002436",
                               "http://purl.obolibrary.org/obo/TXPO_0003500",
                               "http://purl.org/dc/terms/hasVersion",
                               "http://schema.org/evidenceOrigin",
                               "http://semanticscience.org/resource/SIO_000253",
                               "http://semanticscience.org/resource/SIO_000772",
                               "http://www.w3.org/1999/02/22-rdf-syntax-ns#object",
                               "http://www.w3.org/1999/02/22-rdf-syntax-ns#subject",
                               "http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate",
                               "http://www.w3.org/2000/01/rdf-schema#isDefinedBy",
                               "http://www.w3.org/2004/02/skos/core#closeMatch",
                               "http://www.w3.org/2004/02/skos/core#exactMatch"
                               )
  indexes = which(source$V2 %in% object_properties_source)
  rel_triples_1 = source[indexes,]
  attr_triples_1 = source[-indexes,]

  
  #Entities
  source_entities = unique(source$V1[source$V2 %in% c("http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
                                                      "https://w3id.org/biolink/vocab/category")])
  ##Instances
  indexes = grep("#", source_entities)
  source_inst_entities = source_entities[indexes]

  ##Classes
  source_class_entities = source_entities[-indexes]

  
  ##Target file:
  #Object properties target
  object_properties_target = c("http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
                               "https://w3id.org/biolink/vocab/category",
                               "http://www.w3.org/2000/01/rdf-schema#subClassOf",
                               "https://w3id.org/linkml/is_a",
                               "http://purl.obolibrary.org/obo/BFO_0000050",
                               "http://purl.obolibrary.org/obo/RO_0002162",
                               "http://purl.obolibrary.org/obo/RO_0002331",
                               "http://purl.obolibrary.org/obo/RO_0002429",
                               "http://purl.obolibrary.org/obo/RO_0002436",
                               "http://purl.obolibrary.org/obo/TXPO_0003500",
                               "http://purl.org/dc/terms/hasVersion",
                               "http://schema.org/evidenceOrigin",
                               "http://semanticscience.org/resource/SIO_000253",
                               "http://semanticscience.org/resource/SIO_000772",
                               "http://www.w3.org/1999/02/22-rdf-syntax-ns#object",
                               "http://www.w3.org/1999/02/22-rdf-syntax-ns#subject",
                               "http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate",
                               "http://www.w3.org/2000/01/rdf-schema#isDefinedBy",
                               "http://www.w3.org/2004/02/skos/core#closeMatch",
                               "http://www.w3.org/2004/02/skos/core#exactMatch"
                               )
  indexes = which(target$V2 %in% object_properties_target)
  rel_triples_2 = target[indexes,]
  attr_triples_2 = target[-indexes,]

  
  #Entities
  target_entities = unique(target$V1[target$V2 %in% c("http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
                                                      "https://w3id.org/biolink/vocab/category")])
  ##Instances
  indexes = grep("#", target_entities)
  target_inst_entities = target_entities[indexes]

  ##Classes
  target_class_entities = target_entities[-indexes]
  
  
  ##Relations and splits
  source_indexes = which(source_entities %in% target_entities)
  test_links = data.frame(source_entities[source_indexes], source_entities[source_indexes])

  ent_links = data.frame(c(source_entities, target_entities), c(source_entities, target_entities))
  ent_links = ent_links[!duplicated(ent_links),]
  colnames(test_links) = colnames(ent_links) = c("V1", "V2")
  fwrite(ent_links, "./ent_links", col.names = F, row.names = F, sep = "\t", quote = F)
  
  train_links = anti_join(ent_links, test_links)
  files = list.files(folder)
  if (length(files) > 0) {
    for (i in 1:length(files)){
      sample = sample(1:nrow(train_links), 0.1*nrow(train_links), replace = F)
      valid_links = train_links[sample,]
      fwrite(valid_links, paste0("./", folder, "/", i, "/valid_links"), col.names = F, row.names = F, sep = "\t", quote = F)
      fwrite(train_links[-sample,], paste0("./", folder, "/", i, "/train_links"), col.names = F, row.names = F, sep = "\t", quote = F)
      fwrite(test_links, paste0("./", folder, "/", i, "/test_links"), col.names = F, row.names = F, sep = "\t", quote = F)
    }
  }

  ##Final sets:
  rel_triples = rbind(rel_triples_1, rel_triples_2)
  rel_triples = rel_triples[!duplicated(rel_triples),]
  fwrite(rel_triples, "./rel_triples_1", col.names = F, row.names = F, sep = "\t", quote = F)
  fwrite(rel_triples, "./rel_triples_2", col.names = F, row.names = F, sep = "\t", quote = F)
  
  attr_triples = rbind(attr_triples_1, attr_triples_2)
  attr_triples = attr_triples[!duplicated(attr_triples),]
  fwrite(attr_triples, "./attr_triples_1", col.names = F, row.names = F, sep = "\t", quote = F)
  fwrite(attr_triples, "./attr_triples_2", col.names = F, row.names = F, sep = "\t", quote = F)
}

#Reading:
library(data.table)
source = fread("../datasets/all/ENdb.nt", header = F, sep = ">", quote = "", fill = T)
target = fread("../datasets/all/DiseaseEnhancer.nt", header = F, sep = ">", quote = "", fill = T)
folder = "721_5fold"

modAvsB_dataset_subdivision(source, target, folder)
