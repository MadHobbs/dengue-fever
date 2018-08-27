# Predicting Dengue Fever Cases with Environmental Data

This was a project I did for Computational Statistics with Dr. Jo Hardin at Pomona College in collaboration with Jennifer Havens, Harvey Mudd grad. 

# Motivation

Dengue Fever is a life-threatening mosquito-borne illness that affects many people worldwide, particularly in South America and Southeast Asia. We wish to build a model to predict dengue fever cases based on changes in environmental conditions such as precipitation, vegetation, temperature, and more. How do different variables contribute to dengue fever prediction, which are the most significant, and do these factors and their predictive importance vary from location to location? Long term goals would be to be able to prepare communities in threatening circumstances. 

Our end product included a rudimentary [Shiny app](https://mhobbs.shinyapps.io/Dengue_Fever_Prediction/) to display predicted cases (using our model) based on user-given input. Although the UI could be better, the underlying code is pretty cool. It runs our best models for San Juan and Iquitos under the hood and allows the user to either input their own predictor values or simply use any date they wish and scrape that day's environmental data from the NOAA API. The app then outputs the number of dengue fever cases we predict will occur in that week under those particular weather conditions.  
