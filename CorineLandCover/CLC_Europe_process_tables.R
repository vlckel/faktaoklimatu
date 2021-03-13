library(arcgisbinding)
library(ggplot2)
library(dplyr)
library(data.table)

options(scipen = 99999)

arc.check_product()

setwd("C:\\Users\\elisk\\Desktop\\FAKTAOKLIMATU\\CORINE_LandCover\\01_DataPerep\\CLC_Europe_Countries.gdb")

clc_classes_path <- "C:\\Users\\elisk\\Desktop\\FAKTAOKLIMATU\\CORINE_LandCover\\01_DataPerep\\clc_classes.csv"
clc_classes <- read.csv(clc_classes_path, header = TRUE) 

fc_clc_1990 <- arc.open("CLC_Europe_1990_intersect_dissolve")
fc_clc_2000 <- arc.open("CLC_Europe_2000_intersect_dissolve")
fc_clc_2006 <- arc.open("CLC_Europe_2006_intersect_dissolve")
fc_clc_2012 <- arc.open("CLC_Europe_2012_intersect_dissolve")
fc_clc_2018 <- arc.open("CLC_Europe_2018_intersect_dissolve")


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

clc_allyears <- rbind(clc_1990, clc_2000, clc_2006, clc_2012, clc_2018)

code_unique <- unique(clc_allyears$CLC_Code)
name_unique <- unique(clc_allyears$NAME_ENGL)
year_unique <- unique(clc_allyears$YEAR)

CJ <- CJ(code_unique,name_unique,year_unique)
CJ_classes <- merge(CJ, clc_classes[,c("LABEL1","LABEL2", "CLC_CODE")], by.x="code_unique",by.y="CLC_CODE", all.x=TRUE)

rm(CJ)


CLC_ALL_Base <- merge(CJ_classes, clc_allyears, by.x=c("code_unique","name_unique", "year_unique"),by.y=c("CLC_Code", "NAME_ENGL", "YEAR"), all.x=TRUE)
CLC_ALL_Base[is.na(CLC_ALL_Base)] <- 0




#write.csv(CLC_ALL_Base, file = "CLC_Europe_all.csv")




