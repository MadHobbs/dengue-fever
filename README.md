# Predicting Dengue Fever Cases with Environmental Data

This was a project I did in Fall 2017 for my Computational Statistics class with Dr. Jo Hardin at Pomona College in collaboration with Jennifer Havens, Harvey Mudd grad. 

# Motivation

Dengue Fever is a life-threatening mosquito-borne illness that affects many people worldwide, particularly in South America and Southeast Asia. 

Most work around predicting dengue fever outbreaks centers around using time series models without leveraging machine learning approaches. We wanted to see how well we could engineer random forest regression models to predict the number dengue fever cases in a week by using only environmental data. This would offer communities a simpler way to predict and prepare for outbreaks of the deadly disease simply by using readily available weather data, rather than having to rely on disease outbreak data which can take months or a year to compile. 

# What We Did

We built models (one for Iquitos, Perú and the other for San Juan, PR, USA) to predict dengue fever cases based on changes in environmental conditions such as precipitation, vegetation, temperature, and more. We ended up producing impressivley high-performing models (San Juan: RMSE = 27.5; Iquitos: RMSE = 3.87). 

# Results

Our end product included a rudimentary [Shiny app](https://mhobbs.shinyapps.io/Dengue_Fever_Prediction/) to display predicted cases (using our model) based on user-given input. Although the UI could be better, the underlying code is pretty cool. It runs our best models for San Juan and Iquitos under the hood and allows the user to either input their own predictor values or simply use any date they wish and scrape that day's environmental data from the NOAA API. The app then outputs the number of dengue fever cases we predict will occur in that week under those particular weather conditions.  
