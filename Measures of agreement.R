
library(epiR)
# Aged 40-64 (FT: LLN as standard).
dat<-as.table(matrix(c(655.1,254.6,16.94,4702),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 65-95 (FTL LLN as standard).
dat<-as.table(matrix(c(356.6,484.9,0,1408),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 40-64 (LLN: FT as standard).
dat<-as.table(matrix(c(655.1,16.94,254.6,4702),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 65-95 (LLN: FT as standard).
dat<-as.table(matrix(c(356.6,0,484.9,1408),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 40-64 (BTS: LLN as standard).
dat<-as.table(matrix(c(341.2,64.84,330.8,4892),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 65-95 (BTS: LLN as standard).
dat<-as.table(matrix(c(261.5,167.7,95.04,1726),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 40-64 (LLN: BT as standard).
dat<-as.table(matrix(c(341.2,330.8,64.84,4892),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)

# Aged 65-95 (LLN: BT as standard).
dat<-as.table(matrix(c(261.5,95.04,167.7,1726),nrow=2, byrow=TRUE))
colnames(dat) <-c("Dis+","Dis-")
rownames(dat)<-c("Test+","Test-")
epi.tests(dat,digits=3,conf.level=0.95)
epi.kappa(dat,conf.level=0.95)
