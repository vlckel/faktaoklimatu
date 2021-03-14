library(arcgisbinding)
library(ggplot2)
library(dplyr)
library(data.table)

options(scipen = 99999)
memory.limit(1000000) #mozna to neprezije, mozna jo

arc.check_product()


### CLC European Countries ####

setwd("C:\\Users\\elisk\\Desktop\\FAKTAOKLIMATU\\CORINE_LandCover\\01_DataPerep\\CLC_Europe_Countries.gdb")

clc_classes_path <- "C:\\Users\\elisk\\Desktop\\FAKTAOKLIMATU\\CORINE_LandCover\\01_DataPerep\\clc_classes.csv"
clc_classes <- read.csv(clc_classes_path, header = TRUE) 

# get feature classes for CLC EUrope
fc_clc_1990 <- arc.open("CLC_Europe_1990_intersect_dissolve")
fc_clc_2000 <- arc.open("CLC_Europe_2000_intersect_dissolve")
fc_clc_2006 <- arc.open("CLC_Europe_2006_intersect_dissolve")
fc_clc_2012 <- arc.open("CLC_Europe_2012_intersect_dissolve")
fc_clc_2018 <- arc.open("CLC_Europe_2018_intersect_dissolve")


# convert attribute tables from ArcObejt into data.frame (CLC EUROPE)
clc_1990 <- arc.select(fc_clc_1990, c("CLC_Code", "NAME_ENGL", "Shape_Area"))
clc_1990$YEAR <- 1990
clc_2000 <- arc.select(fc_clc_2000, c("CLC_Code", "NAME_ENGL", "Shape_Area"))
clc_2000$YEAR <- 2000
clc_2006 <- arc.select(fc_clc_2006, c("CLC_Code", "NAME_ENGL", "Shape_Area" ))
clc_2006$YEAR <- 2006
clc_2012 <- arc.select(fc_clc_2012, c("CLC_Code", "NAME_ENGL", "Shape_Area"))
clc_2012$YEAR <- 2012
clc_2018 <- arc.select(fc_clc_2018, c("CLC_Code", "NAME_ENGL", "Shape_Area"))
clc_2018$YEAR <- 2018

# merge roky together 
clc_allyears <- rbind(clc_1990, clc_2000, clc_2006, clc_2012, clc_2018)

# cross join - to have all classes everywhere
code_unique <- unique(clc_allyears$CLC_Code)
name_unique <- unique(clc_allyears$NAME_ENGL)
year_unique <- unique(clc_allyears$YEAR)

CJ <- CJ(code_unique,name_unique,year_unique)

# merge with the code description (legend from CLC)
CJ_classes <- merge(CJ, clc_classes[,c("LABEL1","LABEL2", "CLC_CODE")], by.x="code_unique",by.y="CLC_CODE", all.x=TRUE)

# give me some space
rm(CJ)

# merge original tables and get rid of null values
CLC_ALL_Base <- merge(CJ_classes, clc_allyears, by.x=c("code_unique","name_unique", "year_unique"),by.y=c("CLC_Code", "NAME_ENGL", "YEAR"), all.x=TRUE)
CLC_ALL_Base[is.na(CLC_ALL_Base)] <- 0

# calculate percentage for the graph
CLC_ALL_Percentage <- CLC_ALL_Base  %>%
  group_by(year_unique,name_unique, LABEL2) %>%
  summarise(n = sum(Shape_Area)) %>%
  mutate(percentage = n / sum(n))

# create graphs (per country)
CLC_ALL_Percentage %>%
  ggplot(aes(x = year_unique, y=percentage, fill=LABEL2 )) +
  geom_area(alpha=0.9 , size=0.1, colour="black")+
  facet_wrap(vars(name_unique), ncol = 3) +
  xlab("Rok") + ylab("Procento") + labs(fill = "Trída CLC")
 # +scale_fill_brewer(palette="Set3")


#### CLC CR ####
# get the feature class for CLC CR
fc_clc_cr_kraj <- arc.open("C:\\Users\\elisk\\Desktop\\FAKTAOKLIMATU\\CORINE_LandCover\\01_DataPerep\\CLC_Merged_Years.gdb\\CLC_CR_Kraj")
fc_clc_cr_orp <- arc.open("C:\\Users\\elisk\\Desktop\\FAKTAOKLIMATU\\CORINE_LandCover\\01_DataPerep\\CLC_Merged_Years.gdb\\CLC_CR_ORP")

# get czech regions
fc_kraje <- arc.open("C:\\Users\\elisk\\Desktop\\FAKTAOKLIMATU\\CORINE_LandCover\\01_DataPerep\\Misc.gdb\\Kraje")
kraje <- arc.select(fc_kraje, c("KOD_KRAJ", "NAZ_CZNUTS3"))

# convert attribute tables from ArcObject into data.frame (CLC CL)
clc_cr_kraj <- arc.select(fc_clc_cr_kraj, c("clc_legend_LABEL2", "KOD_KRAJ", "YEAR", "Shape_Area"))

# merge tables to get jména kraju
clc_cr_kraj <- merge(clc_cr_kraj, kraje, by="KOD_KRAJ", all.x = TRUE)

# calculate percentage for the graph
CLC_CR_Percentage <- clc_cr_kraj  %>%
  group_by(YEAR,NAZ_CZNUTS3, clc_legend_LABEL2) %>%
  summarise(n = sum(Shape_Area)) %>%
  mutate(percentage = n / sum(n))
CLC_CR <- as.data.table(CLC_CR_Percentage)

# create graphs for CR (per region)
# ten graf nefunguje. zkusit ulozit do csv a nacist znovu?
# jo to pomohlo. achjo....
path <- "C:\\Users\\elisk\\Desktop\\FAKTAOKLIMATU\\CORINE_LandCover\\04_Scripts"
write.csv(CLC_CR, file = paste0(path,"CLC_CR_kraje.csv"))

CLC_CR_FIN <- read.csv(paste0(path,"CLC_CR_kraje.csv"), fill = TRUE, header = TRUE)
CLC_CR_FIN  %>%
  ggplot(aes(x = YEAR, y=percentage, fill=clc_legend_LABEL2)) +
  geom_area(alpha=0.9 , size=0.1, colour="black")+
  facet_wrap(vars(NAZ_CZNUTS3), ncol = 2) +
  xlab("Rok") + ylab("Procento") + labs(fill = "Trída CLC") +
  scale_fill_brewer(palette="Set3")



#write.csv(CLC_ALL_Base, file = "CLC_Europe_all.csv")




