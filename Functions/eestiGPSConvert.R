##Example!##
> str(crashData)
Classes ‘data.table’ and 'data.frame':	109834 obs. of  8 variables:
 $ Juhtumi nr         : chr  "R_1268104" "R_1267917" "R_1267671" "R_1271491" ...
 $ Kuupäev            : chr  "reede, 30. september 2016" "reede, 30. september 2016" "reede, 30. september 2016" "reede, 30. september 2016" ...
 $ Kellaaeg           : chr  "17:35.00" "Määramata" "9:30.00" "20:00.00" ...
 $ Situatsiooni tüüp  : chr  "Määramata" "Liiklusõnnetused teel ja ristmikul: Tagant otsasõit: Tagant otsasõit ees liikuvale või peatunud sõidukile" "Liiklusõnnetused teel ja ristmikul: Tagant otsasõit: Tagant otsasõit ees liikuvale või peatunud sõidukile" "Ühesõidukiõnnetused Muud: Teelt väljasõit" ...
 $ Kahju liik         : chr  "asjakahju" "" "" "isikukahju" ...
 $ Kahju suurus (euro): int  600 0 0 417 199 2000 1094 2000 1000 1203 ...
 $ Y koordinaat       : int  546151 678875 542168 690452 737393 541028 634707 553068 542622 541384 ...
 $ X koordinaat       : int  6585134 6415268 6587487 6570166 6589728 6589927 6581075 6585185 6588725 6588972 ...
 - attr(*, ".internal.selfref")=<externalptr> 



###########

eestiGPSConvert(crashData,crashData$X.koordinaat,crashData$Y.koordinaat)

This will return a new data.frame with Lat and Lon in the universally accepted form. It also assume that X and Y coordinate column are in int format.

str(gpsDataNewCoordinates)
'data.frame':	109834 obs. of  10 variables:
 $ Lon                : num  24.8 27 24.7 27.3 28.2 ...
 $ Lat                : num  59.4 57.8 59.4 59.2 59.4 ...
 $ Juhtumi nr         : chr  "R_1268104" "R_1267917" "R_1267671" "R_1271491" ...
 $ Kuupäev            : chr  "reede, 30. september 2016" "reede, 30. september 2016" "reede, 30. september 2016" "reede, 30. september 2016" ...
 $ Kellaaeg           : chr  "17:35.00" "Määramata" "9:30.00" "20:00.00" ...
 $ Situatsiooni tüüp  : chr  "Määramata" "Liiklusõnnetused teel ja ristmikul: Tagant otsasõit: Tagant otsasõit ees liikuvale või peatunud sõidukile" "Liiklusõnnetused teel ja ristmikul: Tagant otsasõit: Tagant otsasõit ees liikuvale või peatunud sõidukile" "Ühesõidukiõnnetused Muud: Teelt väljasõit" ...
 $ Kahju liik         : chr  "asjakahju" "" "" "isikukahju" ...
 $ Kahju suurus (euro): int  600 0 0 417 199 2000 1094 2000 1000 1203 ...
 $ Y koordinaat       : num  546151 678875 542168 690452 737393 ...
 $ X koordinaat       : num  6585134 6415268 6587487 6570166 6589728 ...
########

##Required Libraries
library(sp)
library(magrittr)
library(data.table)

eestiGPSConvert <- function(data_csv, X_COORD_COLUMN_NAME, Y_COORD_COLUMN_NAME){
  
  WGS84_PROJ <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
  LEST_PROJ <- CRS("+init=epsg:3301")
  
  gpsFixedData <- data.table(data_csv)
  
  X_COORD_COLUMN_NAME <- as.factor(X_COORD_COLUMN_NAME)
  Y_COORD_COLUMN_NAME <- as.factor(Y_COORD_COLUMN_NAME)
  
  X_COORD_COLUMN_NAME <- as.numeric(as.character(X_COORD_COLUMN_NAME))
  Y_COORD_COLUMN_NAME <- as.numeric(as.character(Y_COORD_COLUMN_NAME))
  
  dataFrame <-data.table(cbind(X_COORD_COLUMN_NAME,Y_COORD_COLUMN_NAME))
  
  xy_wgs84 <- SpatialPointsDataFrame(dataFrame[,.(Y_COORD_COLUMN_NAME,X_COORD_COLUMN_NAME)],gpsFixedData,proj4string = LEST_PROJ)%>% spTransform(WGS84_PROJ)
  xy_coord <- as.data.frame(xy_wgs84@coords)
  xy_data <- xy_wgs84@data
  
  names(xy_coord)[1] <- paste("Lon")
  names(xy_coord)[2] <- paste("Lat")
  
 gpsDataNewCoordinates <- cbind(xy_coord, xy_data)
 
}
