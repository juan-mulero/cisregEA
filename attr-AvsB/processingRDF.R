AvsAmod_dataset_subdivision = function (source, target) {
  #Preprocessing:
  preprocessing_RDF = function(set) {
    #Step 1
    set = set[,-4]
    set$V1 = gsub(">|<", "", set$V1)
    set$V2 = gsub(">|<", "", set$V2)
    set$V3 = gsub(">|<", "", set$V3)
    set$V3 = gsub("\" \\.", "", set$V3)
    set$V3 = gsub("\"", "", set$V3)
    set$V3 = gsub("\\^\\^http://www.w3.org/2001/XMLSchema#integer", "", set$V3)
    return(set)
  }
  
  source = preprocessing_RDF(source)
  target = preprocessing_RDF(target)
  
  #Object properties
  object_properties = c("http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
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

  #Entities
  entities = c("http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
               "https://w3id.org/biolink/vocab/category")

  #Source file:
  indexes = which(source$V2 %in% object_properties)
  rel_triples_1 = source[indexes,]
  rel_triples_1 = rel_triples_1[!duplicated(rel_triples_1),]
  fwrite(rel_triples_1, "./rel_triples_1", col.names = F, row.names = F, sep = "\t", quote = F)
  attr_triples_1 = source[-indexes,]
  attr_triples_1 = attr_triples_1[!duplicated(attr_triples_1),]
  fwrite(attr_triples_1, "./attr_triples_1", col.names = F, row.names = F, sep = "\t", quote = F)
  
  ##Entities
  source_entities = unique(source$V1[source$V2 %in% entities])

  ##Instances
  indexes = grep("#", source_entities)
  source_inst_entities = source_entities[indexes]
  
  ##Classes
  source_class_entities = source_entities[-indexes]
  
  
  #Target file:
  indexes = which(target$V2 %in% object_properties)
  rel_triples_2 = target[indexes,]
  rel_triples_2 = rel_triples_2[!duplicated(rel_triples_2),]
  fwrite(rel_triples_2, "./rel_triples_2", col.names = F, row.names = F, sep = "\t", quote = F)
  attr_triples_2 = target[-indexes,]
  attr_triples_2 = attr_triples_2[!duplicated(attr_triples_2),]
  fwrite(attr_triples_2, "./attr_triples_2", col.names = F, row.names = F, sep = "\t", quote = F)
  
  #Entities
  target_entities = unique(target$V1[target$V2 %in% entities])
  
  ##Instances
  indexes = grep("#", target_entities)
  target_inst_entities = target_entities[indexes]
  
  ##Classes
  target_class_entities = target_entities[-indexes]
  
  ##Relations
  ent_links = data.frame(source_class_entities, target_class_entities)
  colnames(ent_links) = c("V1", "V2")
  ent_links = rbind(ent_links, data.frame(V1 = source_inst_entities, V2 = target_inst_entities))
  ent_links = ent_links[!duplicated(ent_links),]
  fwrite(ent_links, "./ent_links", col.names = F, row.names = F, sep = "\t", quote = F)
}

#Reading:
library(data.table)
source = fread("../datasets/diffIDs/equal_db/source/all/ENdb.nt", header = F, sep = ">", quote = "", fill = T)
source = source[!duplicated(source),]
target = fread("../datasets/diffIDs/equal_db/target/all/ENdb.nt", header = F, sep = ">", quote = "", fill = T)
target = target[!duplicated(target),]

AvsAmod_dataset_subdivision(source, target)
