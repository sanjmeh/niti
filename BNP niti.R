
library(rvest)
library(dplyr)
#link =  "https://ngodarpan.gov.in/index.php/home/statewise_ngo/6406/29/1?"

niti=data.frame()

for (page_result in seq (from = 120, to =200, by= 1))
  {
  link = paste0 ("https://ngodarpan.gov.in/index.php/home/statewise_ngo/6406/29/",page_result)
  page= read_html(link)
  name= page%>% html_nodes(".Tax a")%>% html_text()
  number= page%>% html_nodes("td:nth-child(3)")%>% html_text()
  address=page%>% html_nodes("td:nth-child(4)")%>% html_text()
  sector = page%>% html_nodes("td:nth-child(5)") %>% html_text()  
  
  niti = rbind(niti,data.frame(name,number,address,sector, stringsAsFactors = FALSE)) 
  
  print(paste("page:",page_result))

  }

write.csv(niti,"niti2.csv")

                       

                      
