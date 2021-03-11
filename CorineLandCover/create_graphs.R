library(arcgisbinding)
library(ggplot2)
library(dplyr)
library(data.table)

options(scipen = 99999)

arc.check_product()

setwd("C:\\Users\\elisk\\Desktop\\FAKTAOKLIMATU\\CORINE_LandCover\\01_DataPerep")
## ?arc.open
fc_clc <- arc.open("CLC_Merged_Years.gdb/CLC_CR_Kraj")
fc_kraje <- arc.open("Misc.gdb/Kraje")

dt_clc <- as.data.table(arc.select(fc_clc, c("clc_legend_LABEL2", "KOD_KRAJ","YEAR", "Shape_Area")))
dt_kraje <- as.data.table(arc.select(fc_kraje, c("KOD_KRAJ", "KOD_CZNUTS3", "NAZ_CZNUTS3")))

clc_all <- merge(dt_clc, dt_kraje, by="KOD_KRAJ", all=TRUE)

clc_praha <- clc_all[KOD_KRAJ=="3018",]

clc_praha_perc <- clc_praha  %>%
  group_by(YEAR, clc_legend_LABEL2) %>%
  summarise(n = sum(Shape_Area)) %>%
  mutate(percentage = n / sum(n))

# Plot
ggplot(clc_praha_perc, aes(x=YEAR, y=percentage, fill=clc_legend_LABEL2)) + 
  geom_area()


