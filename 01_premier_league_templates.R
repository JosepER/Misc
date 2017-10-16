
rm(list = ls())

library(stringr)
library(magrittr)
library(tidyverse)


# Import data

premier.league.data <- read_csv("raw_input/epldata_final.csv")

if(!"epldata_final.RDS" %in% list.files("raw_input")){

premier.league.data %>%
  write_rds("raw_input/epldata_final.RDS")
  
}

# Filter one club

premier.league.data %<>% 
  mutate(club = club %>% str_replace_all(pattern = "\\+", replacement = "_") )

vector.clubs <- premier.league.data %$% club %>% unique()
  

vector.clubs <- vector.clubs[!vector.clubs %in% "Brighton_and_Hove"]

for(i in vector.clubs){
  
  print(i)

team.name <- i

one.club <- premier.league.data[premier.league.data$club == team.name,]


one.club %>%
  write_rds("interim_output/premier_teams/team.RDS")

# Render script

rmarkdown::render("02_template_team_analysis.Rmd",
                  output_file = str_c("output/team_reports/02_template_team_test_report_",
                                      team.name,
                                      ".html"))

}
