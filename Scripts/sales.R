library(ggplot2)
library(dplyr)
library(data.table)
training <- fread('Data/sales_train.csv',stringsAsFactors = F)
items <- fread('Data/items.csv',stringsAsFactors = F)
categories <- fread('Data/item_categories.csv',stringsAsFactors = F)
shops <- fread('Data/shops.csv',stringsAsFactors = F)

items <- merge(items,categories,by = 'item_category_id')
training$date <- as.Date(training$date,'%d.%m.%Y')
training <- merge(training,items,by = 'item_id')
training <- merge(training,shops,by='shop_id')
training$year <- format(training$date,'%Y')
training$month <- format(training$date,'%m')
training$amount <- training$item_price * training$item_cnt_day


shop_monthly_sales <- training %>%
  group_by(year,month,shop_id,item_id)%>%
  summarise(item_cnt_month = sum(item_cnt_day))

training<- training%>%
  left_join(shop_monthly_sales,by = c('year','month','shop_id','item_id'))

x <- 10


