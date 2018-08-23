# Predicting Dengue Fever Cases with Environmental Data

Group Members: Madison Hobbs and Jennifer Havens    

Madison ~ Project Manager 

Jenn ~ Task Manager 

both ~ Facilitators

Dengue Fever is a life-threatening mosquito-borne illness that affects many people worldwide, particularly in South America and Southeast Asia. We wish to build a model to predict dengue fever cases based on changes in environmental conditions such as precipitation, vegetation, temperature, and more. How do different variables contribute to dengue fever prediction, which are the most significant, and do these factors and their predictive importance vary from location to location? Long term goals would be to be able to prepare communities in threatening circumstances. 

We are accessing our data on drivendata.org, a data competition site. All files are given in .csv format. The data is collected by the CDC, NOAA, and U.S. Department of Commerce. The data is in tidy format.
Variables: List, and briefly describe, each variable that you plan to incorporate. If you can, be specific about units, scale, etc.

Part of our analysis is determining which variables to include. The total range of variables we have to choose from are:
	
ndvi_ne (dimensionless; stands for normalized difference vegetation index, northeast of city). We also havendvi_nw, ndvi_se, and ndvi_sw.

The rest are: city (San Juan, PR and Iquitos, Perú), year, weekofyear (integers), week_start_date (year-month-day), precipitation_amt (mm), reanalysis_air_temp (k), reanalysis_avg_temp(k), reanalysis_dew_point_temp (k), reanalysis_max_air_temp (k), reanalysis_min_air_temp(k), reanalysis_precip_amt_kg_per (m^2)	reanalysis_relative_humidity_percent (%), reanalysis_sat_precip_amt (mm), reanalysis_specific_humidity (g/kg), reanalysis_tdtr (k), station_avg_temp (c),	station_diur_temp_rng (c), station_max_temp (c), station_min_temp (c), station_precip (mm)

Our end product includes a Shiny app to display predicted cases (using our model) based on user-given input. 
