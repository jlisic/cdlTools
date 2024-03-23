#'U.S. Census 2010 FIPS Data
#'
#'U.S. Census 2010 FIPS Data containing county names, state and county FIPS codes, 
#'and state abbreviations.
#' 
#' @format A data frame with 3235 rows and 5 variables.
#' \describe{
#' \item{State}{State two letter abbreviation}
#' \item{State.ANSI}{State FIPS code}
#' \item{County.ANSI}{County FIPS code}
#' \item{County.Name}{County Name}
#' \item{ANSI.Cl}{FIPS class code}
#' }
#' @source \url{https://www2.census.gov/geo/docs/reference/codes/files/national_county.txt}
"census2010FIPS"

#'U.S. Census 2010 State FIPS Data
#'
#'U.S. Census 2010 State FIPS Data containing names, FIPS codes, and abbreviations.
#' 
#' \describe{
#' \item{STATE}{State two letter abbreviation}
#' \item{STATENAME}{State name}
#' \item{STATEFP}{State FIPS code}
#' }
#' @source \url{https://www2.census.gov/geo/docs/reference/codes/files/national_county.txt}
"stateNames"

#'CDL corn classes
#'
#'An array of CDL enumerations that contain corn.  The corn enumeration contains: 
#' \itemize{
#' \item 1 - Corn
#' \item 225 - Double Crop, Winter Wheat and Corn
#' \item 226 - Double Crop, Oats and Corn
#' \item 237 - Double Crop, Barley and Corn 
#' \item 241 - Double Crop, Corn and Soybeans
#' \item 251 - Non-Irrigated Corn
#' }
#'
#' @source \url{https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php}
"corn"

#'CDL cotton classes
#'
#'An array of CDL enumerations that contain cotton.  The cotton enumeration contains: 
#' \itemize{
#' \item 2 - Cotton
#' \item 232 - Double Crop, Lettuce and Cotton
#' \item 238 - Double Crop, Winter Wheat and Cotton
#' \item 239 - Double Crop, Soybeans and Cotton
#' }
#'
#' @source \url{https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php}
"cotton"

#'CDL cultivated classes
#'
#'An array of CDL enumerations of cultivated land cover.  Not all cultivated 
#'enumerations have labels as of this time, and are reserved for future land cover
#'classes.  The cultivated enumeration contains:
#' \itemize{
#' \item 1 - Corn 
#' \item 2 - Cotton 
#' \item 3 - Rice 
#' \item 4 - Sorghum 
#' \item 5 - Soybeans 
#' \item 6 - Sunflower 
#' \item 7 - 7 
#' \item 8 - 8 
#' \item 9 - 9 
#' \item 10 - Peanuts 
#' \item 11 - Tobacco 
#' \item 12 - Sweet Corn 
#' \item 13 - Pop or Ornamental Corn 
#' \item 14 - Mint 
#' \item 15 - 15 
#' \item 16 - 16 
#' \item 17 - 17 
#' \item 18 - 18 
#' \item 19 - 19 
#' \item 20 - 20 
#' \item 21 - Barley 
#' \item 22 - Durum Wheat 
#' \item 23 - Spring Wheat 
#' \item 24 - Winter Wheat 
#' \item 25 - Other Small Grains 
#' \item 26 - Double Crop Winter Wheat and Soybeans 
#' \item 27 - Rye 
#' \item 28 - Oats 
#' \item 29 - Millet 
#' \item 30 - Speltz 
#' \item 31 - Canola 
#' \item 32 - Flaxseed 
#' \item 33 - Safflower 
#' \item 34 - Rape Seed 
#' \item 35 - Mustard 
#' \item 36 - Alfalfa 
#' \item 38 - Camelina 
#' \item 39 - Buckwheat 
#' \item 40 - 40 
#' \item 41 - Sugarbeets 
#' \item 42 - Dry Beans 
#' \item 43 - Potatoes 
#' \item 44 - Other Crops 
#' \item 45 - Sugarcane 
#' \item 46 - Sweet Potatoes 
#' \item 47 - Misc Vegs and Fruits 
#' \item 48 - Watermelons 
#' \item 49 - Onions 
#' \item 50 - Cucumbers 
#' \item 51 - Chick Peas 
#' \item 52 - Lentils 
#' \item 53 - Peas 
#' \item 54 - Tomatoes 
#' \item 55 - Caneberries 
#' \item 56 - Hops 
#' \item 57 - Herbs 
#' \item 58 - Clover or Wildflowers 
#' \item 61 - Fallow or Idle Cropland 
#' \item 66 - Cherries 
#' \item 67 - Peaches 
#' \item 68 - Apples 
#' \item 69 - Grapes 
#' \item 71 - Other Tree Crops 
#' \item 72 - Citrus 
#' \item 73 - 73 
#' \item 74 - Pecans 
#' \item 75 - Almonds 
#' \item 76 - Walnuts 
#' \item 77 - Pears 
#' \item 78 - 78 
#' \item 79 - 79 
#' \item 80 - 80 
#' \item 96 - 96 
#' \item 196 - 196 
#' \item 197 - 197 
#' \item 198 - 198 
#' \item 199 - 199 
#' \item 200 - 200 
#' \item 201 - 201 
#' \item 202 - 202 
#' \item 203 - 203 
#' \item 204 - Pistachios 
#' \item 205 - Triticale 
#' \item 206 - Carrots 
#' \item 207 - Asparagus 
#' \item 208 - Garlic 
#' \item 209 - Cantaloupes 
#' \item 210 - Prunes 
#' \item 211 - Olives 
#' \item 212 - Oranges 
#' \item 213 - Honeydew Melons 
#' \item 214 - Broccoli 
#' \item 215 - 215 
#' \item 216 - Peppers 
#' \item 217 - Pomegranates 
#' \item 218 - Nectarines 
#' \item 219 - Greens 
#' \item 220 - Plums 
#' \item 221 - Strawberries 
#' \item 222 - Squash 
#' \item 223 - Apricots 
#' \item 224 - Vetch 
#' \item 225 - Double Crop Winter Wheat and Corn 
#' \item 226 - Double Crop Oats and Corn 
#' \item 227 - Lettuce 
#' \item 228 - 228 
#' \item 229 - Pumpkins 
#' \item 230 - Double Crop Lettuce and Durum Wheat 
#' \item 231 - Double Crop Lettuce and Cantaloupe 
#' \item 232 - Double Crop Lettuce and Cotton 
#' \item 233 - Double Crop Lettuce and Barley 
#' \item 234 - Double Crop Durum Wheat and Sorghum 
#' \item 235 - Double Crop Barley and Sorghum 
#' \item 236 - Double Crop Winter Wheat and Sorghum 
#' \item 237 - Double Crop Barley and Corn 
#' \item 238 - Double Crop Winter Wheat and Cotton 
#' \item 239 - Double Crop Soybeans and Cotton 
#' \item 240 - Double Crop Soybeans and Oats 
#' \item 241 - Double Crop Corn and Soybeans 
#' \item 242 - Blueberries 
#' \item 243 - Cabbage 
#' \item 244 - Cauliflower 
#' \item 245 - Celery 
#' \item 246 - Radishes 
#' \item 247 - Turnips 
#' \item 248 - Eggplants 
#' \item 249 - Gourds 
#' \item 250 - Cranberries 
#' \item 251 - Non-Irrigated Corn 
#' \item 252 - Non-Irrigated Soybeans 
#' \item 253 - Non-Irrigated Winter Wheat 
#' \item 254 - Double Crop Barley and Soybeans 
#' \item 255 - Non-Irrigated Double Crop Winter Wheat and Soybeans 
#' }
#'
#' @source \url{https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php}
"cultivated"


#'CDL durum wheat classes
#'
#'An array of CDL enumerations that contain durum wheat.  The durum wheat enumeration contains: 
#' \itemize{
#' \item 22 - Durum Wheat 
#' \item 230 - Double Crop Lettuce and Durum Wheat
#' \item 234 - Double Crop Durum Wheat and Sorghum 
#' }
#'
#' @source \url{https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php}
"durumWheat"

#'CDL nothing class
#'
#'An array of CDL enumerations that contain the nothing class.  The nothing enumeration contains: 
#' \itemize{
#' \item 0 - Background 
#' }
#'
#' @source \url{https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php}
"nothing"

#'CDL pasture classes
#'
#'An array of CDL enumerations that contain pasture.  The pasture enumeration contains: 
#' \itemize{
#' \item 37 - Other Hay/Non Alfalfa 
#' \item 38 - Camelina 
#' \item 39 - Buckwheat 
#' \item 62 - Pasture/Grass 
#' \item 171 - Grassland Herbaceous 
#' }
#'
#' @source \url{https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php}
"pasture"


#'CDL soybeans classes
#'
#'An array of CDL enumerations that contain soybeans.  The soybeans enumeration contains: 
#' \itemize{
#' \item 5 - Soybeans 
#' \item 26 - Double Crop Winter Wheat and Soybeans 
#' \item 239 - Double Crop Soybeans and Cotton 
#' \item 240 - Double Crop Soybeans and Oats 
#' \item 241 - Double Crop Corn and Soybeans 
#' \item 252 - Non-Irrigated Soybeans 
#' \item 254 - Double Crop Barley and Soybeans 
#' \item 254 - Double Crop Barley and Soybeans 
#' \item 255 - Non-Irrigated Double Crop Winter Wheat and Soybeans 
#' }
#'
#' @source \url{https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php}
"soybeans"


#'CDL spring wheat classes
#'
#'An array of CDL enumerations that contain spring wheat.  The spring wheat enumeration contains: 
#' \itemize{
#' \item 23 - Spring Wheat 
#' }
#'
#' @source \url{https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php}
"springWheat"


#'CDL water classes
#'
#'An array of CDL enumerations that contain water.  The water enumeration contains: 
#' \itemize{
#' \item 83 - Water 
#' \item 111 - Open Water 
#' }
#'
#' @source \url{https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php}
"water"


#'CDL winter wheat classes
#'
#'An array of CDL enumerations that contain winter wheat.  The winter wheat enumeration contains: 
#' \itemize{
#' \item 24 - Winter Wheat 
#' \item 26 - Double Crop Winter Wheat and Soybeans 
#' \item 225 - Double Crop Winter Wheat and Corn 
#' \item 236 - Double Crop Winter Wheat and Sorghum 
#' \item 238 - Double Crop Winter Wheat and Cotton 
#' \item 253 - Non-Irrigated Winter Wheat 
#' \item 255 - Non-Irrigated Double Crop Winter Wheat and Soybeans 
#' }
#'
#' @source \url{https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php}
"winterWheat"


#' The default projection of CDL data
#' 
#'The proj4 string used for all CDL data.
#'  "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 
#'   +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0"
#' 
#' @source \url{https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php}
"projCDL"

#'Enumerated CDL classes
#' 
#'A list of enumerated CDL classes and class descriptions.
#'
#' @source \url{https://www.nass.usda.gov/Research_and_Science/Cropland/metadata/meta.php}
"varNamesCDL"
