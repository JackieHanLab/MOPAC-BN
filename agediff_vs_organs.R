# --- Environment Setup ---
# Clear global environment and set working directory
rm(list = ls())
setwd('./proteomic_aging/BN')

# Load dataset: expected format is a dataframe 
# 'df' (n_samples * n_organs)
load('./agediff_bn.RData')
# This file contains a dataframe
# n_people * n_organ

# BN
library(bnlearn)

set.seed(1234)
str.diff = boot.strength(df, 
                         R = 500, # sampling times
                         algorithm = 'hc')

str_diff <- str.diff

plot(str_diff$strength, # Strength: the frequency of the connection appearing across 500 bootstrap replicates
     str_diff$direction, # Direction: the proportion of bootstrap samples where the arc points in a specific direction, given that the arc exists.
     type = 'p')
abline(h=0.5,v=attr(str_diff, 'threshold'), 
       col='red')

# --- Structural Equation Modeling (SEM) ---
oac <- str_diff[
  str_diff$strength >= attr(str_diff, 'threshold') & str_diff$direction > 0.5,
]

library(lavaan)

# Construct the model structure based on the BN results
oac.model <- c()
for(organ in unique(oac$to)){
  tmp <- paste0(oac[oac$to==organ,]$from,
                collapse = ' + ')
  tmp <- paste0(c(organ, tmp),
                collapse = ' ~ ')
  oac.model <- c(oac.model,
                 tmp)
}
oac.model <- paste0(oac.model,
                    collapse = '\n')

fit <- sem(oac.model, 
           data = df)

# goodness-of-fit measures
fm <- data.frame(fitmeasures(fit, 
                             fit.measures = 'all',
                             baseline.model = NULL))
fitmeasures(fit, c('cfi','rmsea'))

# abstract the coefficient
fitcoeff <- summary(fit, fit.measure = TRUE)
fitcoeff <- fitcoeff$pe
fitcoeff <- fitcoeff[fitcoeff$lhs!=fitcoeff$rhs,]
fitcoeff <- fitcoeff[fitcoeff$op!='~~',]

colnames(fitcoeff)[c(1,3)] <- c('To','From')
fitcoeff$padj <- p.adjust(fitcoeff$pvalue,
                          method = 'fdr')

directed_link <- fitcoeff[,c('From','To','est','padj')]
