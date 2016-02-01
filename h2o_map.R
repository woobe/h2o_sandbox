# Lib
library(shiny)
library(leaflet)
library(RCurl)
library(ggmap)

# Joe's Googlesheet (temporary)
gs_url <- getURL("https://docs.google.com/spreadsheets/d/1Di0FGfCWZqR7y6kazwi_0wlTWFlaQZY4_q5lc0vCjQE/export?gid=0&format=csv")
d <- read.csv(textConnection(gs_url))

# Add <...> to URL (for pop-up message)
d$URL <- paste0('<b>', d$type, ' - ', d$whom,
                '</b>: <a href="', d$link,
                '" target="_blank" style="text-decoration: none">',
                d$title, '</a>')

# Use ggmap::geocode to get lon lat
lonlat <- data.frame(t(sapply(as.character(d$location), geocode)))
d$lon <- as.numeric(lonlat$lon)
d$lat <- as.numeric(lonlat$lat)

# H2O
address_h2o <- "2307 Leghorn St Mountain View, CA 94043"
geo_h2o <- geocode(address_h2o)
icon_h2o <- makeIcon(
  iconUrl = "https://avatars2.githubusercontent.com/u/1402695?v=3&s=200",
  iconWidth = 20, iconHeight = 20
)

# Heart icon
icon_heart <- makeIcon(
  iconUrl = "http://icons.iconarchive.com/icons/succodesign/love-is-in-the-web/512/heart-icon.png",
  iconWidth = 10, iconHeight = 10
)

# Create base map
m <-
  leaflet() %>%
  addTiles() %>%
  addProviderTiles("CartoDB.DarkMatterNoLabels") %>%
  setView(-100, 30, zoom = 2) %>%
  addMarkers(geo_h2o$lon, geo_h2o$lat,
             popup = '<a href="http://h2o.ai" target="_blank"  style="text-decoration: none">H2O.ai</a>',
             icon = icon_h2o)

# Add some love
m <- addMarkers(m, d$lon, d$lat, popup = d$URL, icon = icon_heart)

# Resize
m$sizingPolicy$defaultHeight <- '100%'

# So where is the love?
print(m)

