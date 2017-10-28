#Identify characters in transcripts


## Start session ----

rm(list = ls())

library(stringr)
library(rebus)
library(magrittr)
library(tidyverse)

## Load patterns from previous script ---- 

pattern.character.names  <- read_rds("interim_output/regex_pattern_identify_characters_transcripts.RDS")

alternative.pattern <- read_rds("interim_output/regex_alternative_pattern_identify_characters_transcripts.RDS")


## Load episode list

episode.list.df <- read_rds("interim_output/episode_list_transcripts.RDS")


#TO DO: use str_View to manually check matches in transcripst

if(!"transcripts_matched" %in% list.files("interim_output/")){

  dir.create("interim_output/transcripts_matched")
  
}
    
#try with purrr
  


  episode.list.df[1:5,] %>% 
  filter(!is.na(transcript)) %>% 
  mutate(id_episode = str_c(season, "episode" , episode_number, sep = "_"))  %>% 
  select(id_episode, transcript) %>%
  purrr::transpose() %>%
purrr:::map(function(x) {  
  
  temp.obj <- str_view_all(x$transcript, pattern.character.names) 
  
  sink(str_c("interim_output/transcripts_matched/", x$id_episode, "V4.html") )

  print(temp.obj)
  
  sink()
  close()
  
  }) 

# try with loop

  obj. <- list()
  
for(i in 1:nrow(episode.list.df[1:5,])){
  
  if(!is.na(episode.list.df[i,"transcript"])){
    
    next()
    
  }
  
  
  obj.[[i]] <- str_view_all(episode.list.df[i,"transcript"], pattern.character.names) 
  
}  
  
  
  
  str_view_all(episode.list.df[1,"transcript"], pattern.character.names) 
  
  str_view_all(episode.list.df[2,"transcript"], pattern.character.names) 
  
  
  episode.list.df %<>%
    filter(!is.na(transcript))
  
  obj. <- list()
  
  for(e in 1:10){
    
    if(is.na(episode.list.df[["transcript"]][e])){
      
      next()
      
    }
    
    obj.[[e]] <-  str_view_all(episode.list.df[e,"transcript"], pattern.character.names) 
    
    file. <- file(str_c("interim_output/transcripts_matched/", e, "V7.html") )
    
    sink(file. )
    
    print(obj.[[e]], type="html")  
    
    sink()
    close(file.)
    
    }
