# http://cyberhelp.sesync.org/basic-Shiny-lesson/2016/07/26/#data
  
library(shiny)
runExample("01_hello")
?new.folder
wd <- ("../BrightShiny/sandbox/")
setwd(wd)

species <- read.csv("../BrightShiny/sandbox/portal-teachingdb-master/species.csv", stringsAsFactors = FALSE)
head(species)


### 
# Once you have made an app, there are several ways to share it with others. 
# It is important to make sure that everything the app needs to run (data and packages) 
# will be loaded into the R session.
# 
# Host them all on gitHub and then call... 
# email or copy app.R, or ui.R and server.R, and all required data files
# use functions in the shiny package to run app from files hosted on the web. 
# 
# For example, the files and data for the shiny app we are building are located in 
# a Github repository and can be run from RStudio using the code  
shiny::runGitHub("khondula/csi-app", "khondula") # ask Kelly how to deplot my own version of this... 



