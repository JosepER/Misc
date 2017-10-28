#Identify characters in transcripts


## Start session ----

library(stringr)
library(rebus)
library(magrittr)
library(tidyverse)


##Spot character names in transcripts
  ###Transcriptions use names both in upper and lower case! 
  ### e.g. 
  ###* https://genius.com/Game-of-thrones-winter-is-coming-annotated
  ###* https://genius.com/Game-of-thrones-the-kingsroad-annotated

#Ideally, the pattern used should also be able to capture all names in characters scraped from wikipedia (i.e. object: characters.all).

#There are some transcripts that use \ n pattern, others that don't

#There are patterns of 'NAME (in valerian)' e.g:
#'CERSEI (sighs): Thank you so much for your kind words'.

#Names can have one or multiple words.

## TO DO: names can be preceeded by an interrogation mark in previous line. 


pattern.character.names <- rebus::or("\\.[[:alpha:]]+" %R% rebus::one_or_more(" [[:alpha:]]+") %R% ":",
"\n[[:alpha:]]+" %R% rebus::one_or_more(" [[:alpha:]]+") %R% ":",
"\n[[:alpha:]]+" %R% rebus::zero_or_more(" [[:alpha:]]+") %R% " \\(" %R% rebus::one_or_more(rebus::or("[[:alpha:]]","\\s")) %R% "\\):",
"\\.[[:alpha:]]+" %R% rebus::zero_or_more(" [[:alpha:]]+") %R% " \\(" %R% rebus::one_or_more(rebus::or("[[:alpha:]]","\\s")) %R% "\\):")



#Manually explore matched characters

episode.list.df %>% select(transcript) %>% filter(!is.na(transcript)) %>% purrr::transpose() %>%
map(function(x){str_view_all(x, pattern.character.names)})



#To do: Maybe use another script for this

str_view_all(episode.list.df$transcript[2], pattern.character.names)


characters.transcripts <- episode.list.df$transcript %>%
str_extract_all(pattern = pattern.character.names) %>%
unlist %>% str_replace_all(pattern = rebus::or(":", "\n", "\\.", 
"\\(" %R% rebus::one_or_more("[[:print:]]") %R% "\\)"), replacement = "") %>% 
unique %>% 
sort

rm(pattern.character.names)


#New:: Alternative pattern 
#this has to be changed to any character, including "-"

alternative.pattern <- rebus::or("\\.", "\\?") %R% "[[:alpha:]]+" %R% rebus::one_or_more(" [[:alpha:]]+") %R% ":"


characters.transcripts.alternative <- episode.list.df$transcript %>%
str_extract_all(pattern = alternative.pattern) %>%
unlist %>% str_replace_all(pattern = rebus::or(":", "\n", "\\.", "\\?", 
"\\(" %R% rebus::one_or_more("[[:print:]]") %R% "\\)"), replacement = "") %>% 
unique %>% 
sort


#All characters in transcripts to upper. This is not the final list and should be further cleaned! 

characters.transcripts %<>%
toupper() %>% 
str_trim(side = "right") %>%
unique

characters.transcripts




#TO DO: use str_View to manually check matches in transcripst
