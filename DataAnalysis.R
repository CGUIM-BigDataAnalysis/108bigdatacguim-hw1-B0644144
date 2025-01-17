library(jsonlite)
library(dplyr)
library(rvest)
library(knitr)
###Q1
x104 <- read_csv("C:/Users/USER/Desktop/104.csv")
x107 <- read_csv("C:/Users/USER/Desktop/107.csv")
x104$大職業別<-gsub("工業及服務業部門","工業及服務業",x104$大職業別)
x104$大職業別<-gsub("工業部門","工業",x104$大職業別)
x104$大職業別<-gsub("服務業部門","服務業",x104$大職業別)
x104$大職業別<-gsub("	資訊及通訊傳播業","出版、影音製作、傳播及資通訊服務業",x104$大職業別)
x107$大職業別<-gsub("_","、",x107$大職業別)
x104$`大學-薪資`<-gsub("—",NA,x104$`大學-薪資`)
x107$`大學-薪資`<-gsub("—",NA,x107$`大學-薪資`)	
x107$`大學-薪資`<-gsub("…",NA,x107$`大學-薪資`)
x104$`大學-薪資`<-as.numeric(x104$`大學-薪資`)
x107$`大學-薪資`<-as.numeric(x107$`大學-薪資`)

###Q1.1
x104107 <- inner_join(x104, x107, by="大職業別") 
x104107$SalaryDiffer <- x104107$`大學-薪資.y`/x104107$`大學-薪資.x`
Prove<-
  data.frame(x104107$`大職業別`,x104107$`大學-薪資.x`,x104107$`大學-薪資.y`,x104107$SalaryDiffer) %>%
  arrange(desc(x104107$SalaryDiffer)) %>% 
  head(10)
names(Prove) <- c("大職業別","Salary104","Salary107","SalaryDiffer104")

###Q1.2
Prove2<-filter(x104107,SalaryDiffer>1.05) %>% arrange(desc(SalaryDiffer)) 
Prove2<-Prove2[,c(2,28)]
kable(Prove2)
nrow(Prove2)

###Q1.3
career <- as.character(Prove2$大職業別)
tmp <- strsplit(career, "-")
table <- table(unlist(lapply(tmp, "[", 1)))
df <- data.frame(table)
df <- arrange(df,desc(Freq))
kable(df)
#*****************************************************************************

###Q2.1
xx104 <- x104[,c(2,12)]
xx107 <- x107[,c(2,12)]
xx104107 <- inner_join(xx104,xx107, by="大職業別")
xx104107$`大學-女/男.x`<-gsub("—|…",NA,xx104107$`大學-女/男.x`)	
xx104107$`大學-女/男.y`<-gsub("—|…",NA,xx104107$`大學-女/男.y`)	
names(xx104107) <- c("大職業別","College104","College107")
xx104107$College104 <- as.numeric(xx104107$College104)
xx104107$College107 <- as.numeric(xx104107$College107)
#把na變成0
xx104107[is.na(xx104107)] <- 0

salary4<-filter(xx104107, College104 > 0,College104 < 100) %>% 
  arrange(College104) %>% 
  head(10) %>% 
  select(大職業別,College104)
kable(salary4)

salary7<-filter(xx104107,  College107 > 0, College107 < 100) %>% 
  arrange(College107) %>% 
  head(10) %>% 
  select(大職業別,College107)
kable(salary7)

###Q2.2
salaryf4<-filter(xx104107,College104 > 100) %>% 
  arrange(desc(College104)) %>% 
  head(10) %>% 
  select(大職業別,College104)
kable(salaryf4)

salaryf7<-filter(xx104107,College107 > 100) %>% 
  arrange(desc(College107)) %>% 
  head(10) %>% 
  select(大職業別,College107)
kable(salaryf7)

###Q3
xxxx107<-data.frame(大職業別=x107$大職業別,College107=x107$`大學-薪資`,Graduate107=x107$`研究所-薪資`)
xxxx107$College107<-gsub("—",NA,xxxx107$College107)
xxxx107$Graduate107<-gsub("—|…",NA,xxxx107$Graduate107)
xxxx107$Graduate107<-as.numeric(xxxx107$Graduate107)
xxxx107$College107<-as.numeric(xxxx107$College107)
xxxx107$proportion<-xxxx107$Graduate107/xxxx107$College107
arrange(xxxx107,desc(proportion)) %>% head(10) %>% knitr::kable()


###Q4
work<-xxxx107[grepl("金融及保險業",xxxx107$大職業別),]
knitr::kable(work)

###Q4.2
work$Differ<-work$Graduate107-work$College107
knitr::kable(work)
