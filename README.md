
# Note : The write up has LINKS. Use the HTML because they will be more visible there!

Project Proposal

Group Members: Madison Hobbs and Jennifer Havens
Jenn ~ Task Manager                                                                            
Madison ~ Project Manager                                                                                  
both ~ Facilitators

Director of Research ~ Shared role. We will both discuss often what literature we should be searching for and reading, and will take an equal role in reading, then frequently sharing our findings. We'll both be in charge of citations (using Jabref!)

Director of Computation ~ Shared role. Madison will be in charge of making code elegant, clear, computationally efficient. Jenn will be in charge of increasing performance and modularity in the code. Madison will take a lead role on the Shiny app development, and Jenn will take a supporting role. 

Reporter ~ Shared role. We will both take notes, bring them together, and both work on the written report. Jenn will be in charge of bringing the written report to reviewers. 

2. Title: Predicting Dengue Fever Cases with Environmental Data
3. Purpose: Describe the general topic/phenomenon you want to explore, as well some carefully considered questions that you hope to address. You should make an argument motivating your work. Why should someone be interested in what you are doing? What do you hope people will learn from your project.
Dengue Fever is a life-threatening mosquito-borne illness that affects many people worldwide, particularly in South America and Southeast Asia. We wish to build a model to predict dengue fever cases based on changes in environmental conditions such as precipitation, vegetation, temperature, and more. How do different variables contribute to dengue fever prediction, which are the most significant, and do these factors and their predictive importance vary from location to location? Long term goals would be to be able to prepare communities in threatening circumstances. 

4. Data: As best you can, describe where you will find your data, and what kind of data it is. Will you be working with spatial data in shapefiles? Will you be accessing an API to a live data source? Be as specific as you can, listing URLs and file formats if possible.

We are accessing our data on drivendata.org, a data competition site. All files are given in .csv format. The data is collected by the CDC, NOAA, and U.S. Department of Commerce. The data is in tidy format.
Variables: List, and briefly describe, each variable that you plan to incorporate. If you can, be specific about units, scale, etc.
Part of our analysis is determining which variables to include. The total range of variables we have to choose from are:
	
ndvi_ne (dimensionless; stands for normalized difference vegetation index, northeast of city). We also havendvi_nw, ndvi_se, and ndvi_sw.	
And the rest are: city (San Juan, PR and Iquitos, Perú), year, weekofyear (integers), week_start_date (year-month-day), precipitation_amt (mm), reanalysis_air_temp (k), reanalysis_avg_temp(k), reanalysis_dew_point_temp (k), reanalysis_max_air_temp (k), reanalysis_min_air_temp(k), reanalysis_precip_amt_kg_per (m^2)	reanalysis_relative_humidity_percent (%), reanalysis_sat_precip_amt (mm), reanalysis_specific_humidity (g/kg), reanalysis_tdtr (k), station_avg_temp (c),	station_diur_temp_rng (c), station_max_temp (c), station_min_temp (c), station_precip (mm)
End Product: Describe what you hope to deliver as a final product. Will it be a Shiny application that will be posted on the Internet? Will it be a GoogleMaps mash-up? Will it be an package that provides an API to a live data source (e.g., twitteR)? Will it be a method that draws some statistical conclusions? Will it be a predictive model that forecasts future values of some quantity?
Our end product will include a Shiny app to display predicted cases (using our model) based on user-given input. Also including relevant interactive visualizations. 
Reach goal: connect to live data from San Juan and Iquitos and create API to that live data source, using our model to predict Dengue cases. 

Update

Have you already collected, or do you have access to, all of the data that you will need in order to complete your project? If not, please estimate the percentage of the data that you have, describe any issues that you are having, and what your plan is for getting the rest of the data.
---> Yes! We have the data.

What is the single biggest unresolved issue you are having? Please describe it briefly, and what your plan is for resolving this issue.
---> Which model type will we use? We will come together and discuss what models make more sense for our data (do we suspect a linear relationship? Do we expect a nonlinear relationship?). In that discussion we'll refer to literature we've each read about other people predicting dengue cases (or other diseases) from environmental variables. We'll come up with a handful of models to try that way. Then, we can try a few different models and see which performs best.

What are the elements from outside of the course, if any, that you plan to incorporate into your project?
---> Jenn's background in biology can help us reason about the biological forces at play. We'll both be reading as much scientific material as we can too to give us context and incorporate domain knowledge into our model and its interpretation.

---> Shiny App (kind of outside the course, kind of inside it).

---> How to connect to an API!

You all seem to be in great shape.  Keep me posted and let me know if/when you have any questions.  Thanks for the update!
