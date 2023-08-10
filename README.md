# OHW23 Amplicon

### Assessing fish biodiversity through eDNA assays

The purpose of this project is to analyse a dataset of 16S amplicon sequencing to assess fish biodiversity. Our goal is to run one or more bioinformatics pipelines, perform simple ecological analyses, and compare results. A driving question to this project is: does using different bioinformatics protocols make a difference in the biological conclusions?

**Team members**
- Cindy Bessey
- Vini Salazar
- ???

Steps:
- Demultiplex Illumina sequencing data (using `obitools/ngsfilter`).
- Create a custom reference database using only fish species from the OBITools reference database (see the [Wolves tutorial](https://pythonhosted.org/OBITools/wolves.html) for more information).
- Run different bioinformatics pipelines
  - [x] [nf-core/ampliseq](https://nf-co.re/ampliseq/)
  - [ ] [OBITools](https://pythonhosted.org/OBITools/welcome.html)
  - [ ] [Tourmaline](https://github.com/aomlomics/tourmaline)
  
References:
- Berry, Tina E., et al. "DNA metabarcoding for diet analysis and biodiversity: A case study using the endangered Australian sea lion (Neophoca cinerea)." *Ecology and Evolution* 7.14 (2017): 5435-5453.
- Kumar, Girish, et al. "Comparing eDNA metabarcoding primers for assessing fish communities in a biodiverse estuary." *PLoS one* 17.6 (2022): e0266720.
