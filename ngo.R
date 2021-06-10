# To scrape from NitiAgog website Darpan page for the list of NGOs and combine them into one database.
library(readr)
library(xml2)
library(httr)
library(rvest)
library(data.table)
library(tidyr)
library(stringr)
library(janitor)
library(magrittr)
library(htmlTable)
library(gt)
library(urltools)
library(purrr)

u <- "https://ngodarpan.gov.in/index.php/home/statewise_ngo/6395/29/"

# scrape one page at a time; p is page number
rpage <- function(p){
 url <- paste0(u,p)   
 r1 <- xml2::read_html(url)
 html_nodes(r1,css = "td") %>% html_text()
}

# pass one response at a time
proc <- function(resp,rows,cols){
        split(resp,rep(seq_len(rows),each=cols))
}

# pass thr entire list of character vectors to convert to a data.table
pulltab <- function(x){
        map(x,~data.table(sn=.x[1],name=.x[2],regn=.x[3],addr=.x[4],sectors=.x[5])) %>% 
        rbindlist
}

# this code combines all functions in one and extracts pages from the webpage and outputs a data.table
getpages <- function(p=1:10,rows=10,cols=5,fname="rushali01.txt"){
    names(p) <- p
    dt <- p %>% map(rpage) %>% map(proc,rows,cols) %>% map(pulltab) %>% rbindlist(idcol = "page")
    fwrite(dt,fname)
    return(dt)
}


