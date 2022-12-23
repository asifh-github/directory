library(tidyverse)

# 1
# read data skipping meta lines
data <- read_tsv("MLLT3_small.vcf", comment="##")
data

# 2
# spec(): prints col specifications
spec(data)
# change cols REF n ALT vars to read as factors
data <- read_tsv("MLLT3_small.vcf", comment="##",
                 col_types=cols(
                   `#CHROM` = col_double(),
                    POS = col_double(),
                    ID = col_character(),
                    REF = col_factor(),
                    ALT = col_factor(),
                    QUAL = col_double(),
                    FILTER = col_character(),
                    INFO = col_character(),
                    FORMAT = col_character(),
                    HG00096 = col_character(),
                    HG00097 = col_character(),
                    HG00099 = col_character(),
                    HG00100 = col_character(),
                    HG00101 = col_character(),
                    HG00102 = col_character(),
                    HG00103 = col_character(),
                    HG00105 = col_character(),
                    HG00106 = col_character(),
                    HG00107 = col_character(),
                    HG00108 = col_character(),
                    HG00109 = col_character(),
                    HG00110 = col_character()
                   )
                 )
data

# 3
# rename the first col to 'CHROM'
names(data)
names(data[1])
rename(data, "CHROM"=names(data[1]))
