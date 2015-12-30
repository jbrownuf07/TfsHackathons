

library(RCurl)
require(jsonlite)

source('functions.R')

serverAddress <- 'https://vjs06p01f8.execute-api.us-east-1.amazonaws.com/xtopia'
id <- '91e4da90-7b35-4e41-b45f-8cada43a8d6d'

xics <- fromJSON(paste(serverAddress, 'clusters', id, sep = '/'))[[1]]
names(xics)
ggplot(data = xics, aes(x = RT, y = Intensity, group = 1)) + geom_line()

features <- fromJSON(paste(serverAddress, 'features', id, sep = '/'))[[1]]
class(features)
head(features)

p <- qplot(Width, data=features, geom="histogram")

ggplotly(p)

tmp <- fromJSON('https://vjs06p01f8.execute-api.us-east-1.amazonaws.com/xtopia/measurements')
head(tmp)

