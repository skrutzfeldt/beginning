
#install the tidyverse, a group of 
#install.packages("tidyverse")
library(tidyverse)

tidyverse::tidyverse_packages()

#You'll have to change the locations of the read_csv formula
quality <- read_csv("J:/Media/Analytics/Code Base/Rcode/demo/quality.csv")
wine_metrics <- read_csv("J:/Media/Analytics/Code Base/Rcode/demo/wine_metrics.csv")

#rename incoming files as a best practice
temp_quality = quality
temp_wine_metrics = wine_metrics


#join on two values
wine_full = left_join(x = temp_quality, y = temp_wine_metrics, by= c("Vineyard","Wine"))




#Get working directory, then set it to our destination file
getwd()
setwd("C:/Users/samuel.krutzfeldt/Desktop/Scratchwork")

#write our file
write_csv(wine_full, "wine_full.csv")


#this is where we ended
############################





