library(readr)
library(tidyverse)

setwd("~/Desktop/test of diversity saturation/FD/1")

temp = list.files(pattern="*.csv")
for (i in 1:length(temp)) assign(temp[i], read.csv(temp[i]))

mypath="~/Desktop/test of diversity saturation/FD/1"
multmerge = function(mypath){
  filenames=list.files(path=mypath, full.names=TRUE)
  datalist = lapply(filenames, function(x){read.csv(file=x,header=T)})
  Reduce(function(x,y) {merge(x,y,all = TRUE)}, datalist)
}

full_data = multmerge("~/Desktop/test of diversity saturation/FD/1/merged.csv")



mymergeddata_1 = multmerge("~/Desktop/test of diversity saturation/FD/1/")
