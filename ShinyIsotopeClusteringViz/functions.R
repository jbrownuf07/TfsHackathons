

getPeaksFromServer <- function(id) {
  # peaks <- fromJSON('https://vjs06p01f8.execute-api.us-east-1.amazonaws.com/xtopia/demopeaks/91e4da90-7b35-4e41-b45f-8cada43a8d6d')
  peaks <- fromJSON(cat('https://vjs06p01f8.execute-api.us-east-1.amazonaws.com/xtopia/features/', id, sep = ''))
  peaks
}
