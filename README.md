# cisreg EntityAlignment

## Introduction
Study of the performance of 20 entity alignment methods in the gene regulation domain, with a special focus on cis-regulatory modules, (CRM) modeled by the [cisreg](https://github.com/juan-mulero/cisreg.git) schema used in [BioGateway](http://ssb4.nt.ntnu.no:23122/sparql). 

The following picture represent the schema used to model the information from different biological databases about enhancers and their relations with other entities. The colored boxes specify the different subgraphs or subdomains: enhancer sequences (crm graph - orange on the top), and their relations with other biological entities of interest, such as target genes (crm2gene graph - yellow on the bottom), transcription factors (crm2tfac graph - brown on the right), and phenotypes (crm2phen graph - red on the left). The blue classes constitute the central entities of each graph, while the green classes are biological classes of interest that were not modeled in detail because they are already present in the BioGateway KG, schema that is interoperable with this one.
![Schema](./Figures/schema.png)

The twenty methods used are: AlignE, AliNet, AttrE, BootEA, BootEA-RotatE, GCN-Align, HolE, IMUSE, IPTranE, JAPE, MtransE, ProjE, RDGCN, RSN4EA, RotatE, SimplE, TransD, TransH, TransR.

Different use cases were studied. Alignments of identical graphs ([AvsA](./AvsA/)) and alignments of different graphs at various levels: at attribute level ([AvsA'](./AvsA'/)), at edge level ([AvsB](./AvsB/) and [mod_AvsB](./mod_AvsB/)), and at attribute and edge level ([A'vsB'](./A'vsB'/)).

Each graph contains, in the form of RDF triples, the information belonging to different manually curated databases about enhancer sequences (the most studied type of CRM). The databases used as a sample, and corresponding to each of the aligned graphs, are:
- [ENdb](http://www.licpathway.net/ENdb/index.php)
- [EnDisease](https://health.tsinghua.edu.cn/jianglab/endisease/)
- [DiseaseEnhancer](http://biocc.hrbmu.edu.cn/DiseaseEnhancer/)
- [VISTA](https://enhancer.lbl.gov/)
- [RefSeq](https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/)

Since the [databases](./datasets.rar) contain different types of biological entities that can be modeled in different graphs, a study of the performance of the methods using all domains or graphs (all), and different subdomains (crm, crm2gene, crm2phen and crm2tfac) was also carried out.


## Workflow
To carry out the experiments, a standardised workflow based on the [cisreg](https://github.com/juan-mulero/cisreg.git) and [OpenEA](https://github.com/nju-websoft/OpenEA.git) packages was followed.

![Workflow](./Figures/Pipeline.png)

1. **Step 1 - Preproccesing**: The original databases are pre-processed using [dataset-specific codes](https://github.com/juan-mulero/cisreg/tree/main/Rcodes) to standardize the automatic generation of RDF files.
2. **Step 2 - RDF data generation**: [Generation of RDF files](https://github.com/juan-mulero/cisreg/tree/main/cisreg) that will constitute the different graphs. These files have been included in ['datasets'](./datasets.rar).
3. **Step 3 - Data preparation of entity characteristics**: Preparation of the input data. Three kinds of files for each pairwise alignment: one file for the attributes of the entities of each graph, one file for the relationships, and other for the entities. The 'processingRDF.R' codes used are stored in the folders for each use case tested ([AvsA](./AvsA/), [AvsA'](./AvsA'/), [AvsB](./AvsB/), [mod_AvsB](./mod_AvsB/), [A'vsB'](./A'vsB'/)).
4. **Step 4 - Training data preparation**: It is also part of the preparation of the input data. The alignment methods require a previous training based on a seed alignment. Therefore, the entity file (ent_links), where the entities of both graphs are linked, is randomly divided into three subsets for training, testing and validation in a ratio 7:2:1 respectively. This task is performed through the 'randomPairs.py' code included in each use case. When this file is not present, the subdivision is part of the previous preprocessing process due to a reduced number of common entities that prevents that this subdivision ratio is effective.
5. **Step 5 - Entity alignment**: Pairwise alignment using the previously generated input files and the different methods indicated above. The [OpenEA](https://github.com/nju-websoft/OpenEA.git) package was used for this run. Each alignment was done in duplicate for greater statistical significance
6. **Step 6 - Evaluation of results**: We analyze the results of the metrics returned by the entity alignments to identify the best performing methods, with a special focus on the hits@1 and execution time values, and we count the number of aligned entities per biological entity type to identify the performance per entity type. The codes corresponding to the generation of statistics are stored in the [scripts_metrics](./scripts_metrics/) folder.


## Results
Nearly 3000 executions are reported. The results are organized according to the type of alignment performed ([AvsA](./AvsA/), [AvsA'](./AvsA'/), [AvsB](./AvsB/), [mod_AvsB](./mod_AvsB/), [A'vsB'](./A'vsB'/)). 

Within each of these folders or type of alignment, the results corresponding to the alignment metrics are organized in the 'metric.rar' file, by graphs used in pairwise alignment (example: ENdb-EnDisease), domains used (ex: crm), and sample/replicate (ex: 1). 

The results corresponding to the performance of the alignment methods by type of biological entity follow a similar file structure. These are found in the 'results.rar' files and include an additional subdivision by alignment method used (example: AttrE). 

The files are zipped due to the high number of files included and for easier storage. Note that only the results used for the evaluation are included, also for space reasons.



