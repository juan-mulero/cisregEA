# cisreg EntityAlignment

## Introduction
Study of the performance of 20 entity alignment methods in the gene regulation domain, with a special focus on cis-regulatory modules, (CRM) modeled by the [cisreg](https://github.com/juan-mulero/cisreg.git) schema used in [BioGateway](http://ssb4.nt.ntnu.no:23122/sparql). 

![Schema](./Figures/schema.png)

The twenty methods used are:
- AlignE
- AliNet
- AttrE
- BootEA
- BootEA-RotatE
- GCN-Align
- HolE
- IMUSE
- IPTranE
- JAPE
- MtransE
- ProjE
- RDGCN
- RSN4EA
- RotatE
- SimplE
- TransD
- TransH
- TransR

Different use cases were studied. Alignments of identical graphs ([AvsA]()) and alignments of different graphs at various levels: at attribute level ([AvsA']()), at edge level ([AvsB]() and [mod_AvsB]()), and at attribute and edge level ([A'vsB']()).

Each graph contains, in the form of RDF triples, the information belonging to different manually curated databases about enhancer sequences (the most studied type of CRM). The databases used as a sample, and corresponding to each of the aligned graphs, are:
- [ENdb](http://www.licpathway.net/ENdb/index.php)
- [EnDisease](https://health.tsinghua.edu.cn/jianglab/endisease/)
- [DiseaseEnhancer](http://biocc.hrbmu.edu.cn/DiseaseEnhancer/)
- [VISTA](https://enhancer.lbl.gov/)
- [RefSeq](https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/)

Since the [databases]() contain different types of biological entities that can be modeled in different graphs, a study of the performance of the methods using all domains or graphs (all), and different subdomains (crm, crm2gene, crm2phen and crm2tfac) was also carried out.


## Workflow
To carry out the experiments, a standardised workflow based on the [cisreg](https://github.com/juan-mulero/cisreg.git) and [OpenEA](https://github.com/nju-websoft/OpenEA.git) packages was followed.

![Workflow](./Figures/Pipeline.png)

1. **Step 1 - Preproccesing**: The original databases are pre-processed using [dataset-specific codes](https://github.com/juan-mulero/cisreg/tree/main/Rcodes) to standardize the automatic generation of RDF files.
2. **Step 2 - RDF data generation**: [Generation of RDF files](https://github.com/juan-mulero/cisreg/tree/main/cisreg) that will constitute the different graphs. 
3. **Step 3 - Data preparation of entity characteristics**: Preparation of the input data. Three kinds of files for each pairwise alignment: one file for the attributes of the entities of each graph, one file for the relationships, and other for the entities. 