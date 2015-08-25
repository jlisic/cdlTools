# This is a listing of CDL values and their associated titles
# some lists for aggregated crops
# and a function to map the labels to a list of integers
#
#####################################################################
# Last update:  August 1, 2012
# By Jonathan Lisic
#
# Original Author, Jonathan Lisic
#####################################################################



#####################################################################
#  This is a listing of CDL values and their associated titles
#####################################################################

cdl.varNames <- c(
#Attribute Domain Values and Definitions: NO DATA, BACKGROUND 0
0,"Background",
#Attribute Domain Values and Definitions: CROPS 1-20,
1,"Corn",
2,"Cotton",
3,"Rice",
4,"Sorghum",
5,"Soybeans",
6,"Sunflower",
10,"Peanuts",
11,"Tobacco",
12,"Sweet Corn",
13,"Pop or Orn Corn",
14,"Mint",
#Attribute Domain Values and Definitions: GRAINS,HAY,SEEDS 21-40,
21,"Barley",
22,"Durum Wheat",
23,"Spring Wheat",
24,"Winter Wheat",
25,"Other Small Grains",
26,"Dbl Crop WinWht/Soybeans",
27,"Rye",
28,"Oats",
29,"Millet",
30,"Speltz",
31,"Canola",
32,"Flaxseed",
33,"Safflower",
34,"Rape Seed",
35,"Mustard",
36,"Alfalfa",
37,"Other Hay/Non Alfalfa",
38,"Camelina",
39,"Buckwheat",
#Attribute Domain Values and Definitions: CROPS 41-60,
41,"Sugarbeets",
42,"Dry Beans",
43,"Potatoes",
44,"Other Crops",
45,"Sugarcane",
46,"Sweet Potatoes",
47,"Misc Vegs & Fruits",
48,"Watermelons",
49,"Onions",
50,"Cucumbers",
51,"Chick Peas",
52,"Lentils",
53,"Peas",
54,"Tomatoes",
55,"Caneberries",
56,"Hops",
57,"Herbs",
58,"Clover/Wildflowers",
59,"Sod/Grass Seed",
60,"Switchgrass",
#Attribute Domain Values and Definitions: NON-CROP 61-65,
61,"Fallow/Idle Cropland",
62,"Pasture/Grass",
63,"Forest",
64,"Shrubland",
65,"Barren",
#Attribute Domain Values and Definitions: CROPS 66-80,
66,"Cherries",
67,"Peaches",
68,"Apples",
69,"Grapes",
70,"Christmas Trees",
71,"Other Tree Crops",
72,"Citrus",
74,"Pecans",
75,"Almonds",
76,"Walnuts",
77,"Pears",
#Attribute Domain Values and Definitions: OTHER 81-109,
81,"Clouds/No Data",
82,"Developed",
83,"Water",
87,"Wetlands",
88,"Nonag/Undefined",
92,"Aquaculture",
#Attribute Domain Values and Definitions: NLCD-DERIVED CLASSES 110-195,
111,"Open Water",
112,"Perennial Ice/Snow",
121,"Developed/Open Space",
122,"Developed/Low Intensity",
123,"Developed/Med Intensity",
124,"Developed/High Intensity",
131,"Barren",
141,"Deciduous Forest",
142,"Evergreen Forest",
143,"Mixed Forest",
152,"Shrubland",
171,"Grassland Herbaceous",
176,"Grass/Pasture",
181,"Pasture/Hay",
190,"Woody Wetlands",
195,"Herbaceous Wetlands",
#Attribute Domain Values and Definitions: CROPS 195-255,
204,"Pistachios",
205,"Triticale",
206,"Carrots",
207,"Asparagus",
208,"Garlic",
209,"Cantaloupes",
210,"Prunes",
211,"Olives",
212,"Oranges",
213,"Honeydew Melons",
214,"Broccoli",
216,"Peppers",
217,"Pomegranates",
218,"Nectarines",
219,"Greens",
220,"Plums",
221,"Strawberries",
222,"Squash",
223,"Apricots",
224,"Vetch",
225,"Dbl Crop WinWht/Corn",
226,"Dbl Crop Oats/Corn",
227,"Lettuce",
229,"Pumpkins",
230,"Dbl Crop Lettuce/Durum Wht",
231,"Dbl Crop Lettuce/Cantaloupe",
232,"Dbl Crop Lettuce/Cotton",
233,"Dbl Crop Lettuce/Barley",
234,"Dbl Crop Durum Wht/Sorghum",
235,"Dbl Crop Barley/Sorghum",
236,"Dbl Crop WinWht/Sorghum",
237,"Dbl Crop Barley/Corn",
238,"Dbl Crop WinWht/Cotton",
239,"Dbl Crop Soybeans/Cotton",
240,"Dbl Crop Soybeans/Oats",
241,"Dbl Crop Corn/Soybeans",
242,"Blueberries",
243,"Cabbage",
244,"Cauliflower",
245,"Celery",
246,"Radishes",
247,"Turnips",
248,"Eggplants",
249,"Gourds",
250,"Cranberries",
251,"Non-Irrigated Corn",
252,"Non-Irrigated Soybeans",
253,"Non-Irrigated Winter Wheat",
254,"Dbl Crop Barley/Soybeans",
255,"Non-Irrigated Dbl. Crop Winter Wheat Soybeans"
)
 
#Attribute Domain Values and Definitions: NO DATA, BACKGROUND 0
#Attribute Domain Values and Definitions: CROPS 1-20
#Attribute Domain Values and Definitions: GRAINS,HAY,SEEDS 21-40
#Attribute Domain Values and Definitions: CROPS 41-60
#Attribute Domain Values and Definitions: NON-CROP 61-65
#Attribute Domain Values and Definitions: CROPS 66-80
#Attribute Domain Values and Definitions: OTHER 81-109
#Attribute Domain Values and Definitions: NLCD-DERIVED CLASSES 110-195
#Attribute Domain Values and Definitions: CROPS 196-255


#####################################################################
#  A set of lists of common, useful aggregations 
#####################################################################
cultivated  <- c( 1:36,38:58,61,66:69,71:80,96,196:255) 
corn        <- c(1,225,226,237,241,251)
soybeans    <- c(5,26,239,240,241,254,252,254,255)
winterWheat <- c(24,26,225,236,238,253,255)
springWheat <- c(23)
durumWheat  <- c(22,230,234)
cotton      <- c(232,2,238,239)
pasture     <- c(171,62,37,38,39)
water       <- c(83,111)
background  <- 0


#####################################################################
#  This is the cropscape default projection 
#####################################################################

cdl.proj <- '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0'

