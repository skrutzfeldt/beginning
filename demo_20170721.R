
install.packages("tidyverse")
library(tidyverse)


#You'll have to change the locations of the read_csv formula
#quality <- read_csv("J:/Media/Analytics/Code Base/Rcode/demo/quality.csv")
#wine_metrics <- read_csv("J:/Media/Analytics/Code Base/Rcode/demo/wine_metrics.csv")
wine_metrics = read_csv("C:/Users/samuel.krutzfeldt/Desktop/wine_metrics.csv")
quality =read_csv("C:/Users/samuel.krutzfeldt/Desktop/quality.csv")


#rename incoming files as a best practice
temp_quality = quality
temp_wine_metrics = wine_metrics

View(temp_quality)
View(temp_wine_metrics)


#join on two values
wine_full = left_join(x = temp_quality, y = temp_wine_metrics, by= c("Vineyard","Wine"))

View(wine_full)



#create a new variable - we overwrite the wine_full table with itself to create a 
#mutated version of the table with the variable that we want
wine_full = mutate(.data = wine_full, pct_alcohol = alcohol/100)


#more than 1 variable can be made at a time. Any function that works
#elsewhere in R will run inside of the mutate function
wine_full = mutate(.data = wine_full,
                   bottle_alcohol = 750 * pct_alcohol,
                   counting = 1)


str(wine_full)
names(wine_full)

#This formula won't work - the names of the variables have some spaces in them.
wine_full = mutate( wine_full, f_to_v_acidity = fixed acidity / volatile acidity)


#let's look at the names
names(wine_full)

#The spaces in R mean that it sees fixed and acidity as two different variables.
#We need to change the  names of the columns on the tabel to get rid of the spaces



#fixing names of variables Option #1 - find and replace the spaces with an underscore
names(wine_full) = paste(gsub(pattern = " ",replacement = "_",x =names(wine_full)))
names(wine_full)



#fixing names of variabels Option #2, manually copy the names of the table and paste
#over the names with no spaces
names(wine_full) = paste(c("Vineyard","Wine","quality","color","citric_acid","residual_sugar","chlorides","free_sulfur_dioxide","total_sulfur_dioxide","density","pH","sulphates","alcohol"))


names(wine_full)


#let's try it now
wine_full = mutate(.data = wine_full, f_to_v_acidity = fixed_acidity / volatile_acidity)



#ggplot2 is the graphing library, if tidyverse isn't loading, try just ggplot2
graph1 = ggplot(data = wine_full, aes(x = quality))

#ggplot2 creates blank canvasses that need layers added to it. 
#graph1 here will load, but without instructions of what kind of graph it needs to be
#it stays blank
graph1


#by adding a geom_bar() function, we are telling it to be a bar graph
graph1 + geom_bar()


#seeing the breakdown of the different levels of quality, some ifelse functions
#make quality bucketing variables to allow for better organization
wine_full = mutate(wine_full,
                   quality_l = ifelse(test = quality <5, yes = 1, no =0),
                   quality_m = ifelse(test = quality>=5 & quality <=6, yes = 1, no=0),
                   quality_h = ifelse(test = quality>6 ,yes = 1,no =0),
                   quality_bucket = ifelse(test = quality>6, yes = "high", no = ifelse(test = quality>3,yes = "medium", no = "low")))

#the variable "quality_bucket" has an ifelse function as the result of an ifelse function
#these layered logic variables come in handy when trying to break down complicated relationships between variables


#start with a geom_point, then add f_to_v_acidity
a = ggplot(data = wine_full, aes(x = fixed_acidity, y = volatile_acidity, color = f_to_v_acidity))
a+ geom_point()+
  scale_color_continuous(low = "chartreuse", high = "goldenrod")+
  geom_smooth(color = "salmon")+
  theme_dark()+
  ggtitle("Acidity Relationships")+
  xlab("Fixed Acidity")+
  ylab("Volatile Acidity")

#colors can be found at this website
#http://sape.inf.usi.ch/quick-reference/ggplot2/colour
#or just google ggplot2 color names




#ggplot is a very useful graphing tool - it works in layers
#the following is an example about how each layer can change the graph and its story
b = ggplot(wine_full, aes(x = quality, y = alcohol, color = color, size = sulphates))
b + geom_point()

b + geom_point()+
  geom_jitter(alpha = .25)

b + geom_point()+
  geom_jitter(alpha = .25)+
  facet_wrap(~color)

b + geom_point()+
  geom_jitter(alpha = .25)+
  facet_wrap(~color)+
  geom_abline(intercept = mean(wine_full$alcohol), slope = 0)

b + geom_point()+
  geom_jitter(alpha = .25)+
  facet_wrap(~color)+
  geom_abline(intercept = mean(wine_full$alcohol), slope = 0)+
  scale_color_manual(values = c("maroon","antiquewhite"))



b + geom_point()+
  geom_jitter(alpha = .25)+
  facet_wrap(~color)+
  geom_abline(intercept = mean(wine_full$alcohol), slope = 0)+
  scale_color_manual(values = c("maroon","antiquewhite"))+
  theme_dark()

b + geom_point()+
  geom_jitter(alpha = .25)+
  facet_wrap(~color)+
  geom_abline(intercept = mean(wine_full$alcohol), slope = 0)+
  scale_color_manual(values = c("maroon","antiquewhite"))+
  theme_dark()+
  geom_density2d(size = 1, color = "black", alpha = .5)



#Get working directory, then set it to our destination file
getwd()

#write our file
#write_csv(wine_full, "wine_full.csv")

############################

#make some graphs