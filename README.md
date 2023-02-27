# Donations-From-Media-Channels  
Identifying the impact of earned media on gift donations.

# Business Goal  
Second Harvest Heartland is one of the largest food banks in the US. Second Harvest Heartland wanted to know what media channels (website, print, radio, and tv) drove the largest donations from individuals.  

# Business Impact  
<img width="1033" alt="image" src="https://user-images.githubusercontent.com/125685678/221711284-ddd0d8b4-684e-4970-aab6-66340f25203e.png">  
I identified that websites contributed the most donations for Second Harvest Heartland. Further, I determined that the top 7 website channels contribute over 50% of the gift donations driven through this channel. For the other media channels, evening media mentions drove more donations, on average, than morning media mentions. Also, weekend news mentions drove more donations than weekday media mentions.   

Therefore, Second Harvest Heartland's limited resources (the media team's time to pursue journalists and the executive's time to do interviews) can be put to the best use. Second Harvest Heartland is better off pursuing website interviews over tv interviews and building relationships with evening newscasters.  

# Overview of the Process  
<img width="1123" alt="image" src="https://user-images.githubusercontent.com/125685678/221711368-e90fb9e9-da3b-4519-ae5a-c52d9b6a4e64.png">

The analysis can be broken down into four steps.  
1. Data Preparation - I was given two datasets (individual donations and media mentions) at different granularities. So, I joined the gift data with the earned media by attributing donations to each media mention.  
<img width="997" alt="image" src="https://user-images.githubusercontent.com/125685678/221711724-976f0264-a39f-47ce-b662-50a23529dda2.png">

2. Exploratory Data Analysis: Engineering features include media channel, paid campaign overlap, time of day, holiday flags, and day of the week. Using univariate analysis, I derived insights based on the number of mentions and average dollar donation.  
<img width="1126" alt="image" src="https://user-images.githubusercontent.com/125685678/221711471-a3a7ea24-850a-4d1f-a674-6056fa4f05ca.png">

3. Modeling Building and Interpretation - Built multiple linear regression model using features selected based on univariate analysis. Evaluation of regression performance and feature importance was also done during this step.   
4. Recommendations - Based on my analysis, I recommend what media channels Second Harvest Heartland should focus on and which features contribute the most to donations.  

#### Key Notes and Phrases  
- Earned media refers to publicity gained through promotional efforts. For example, a news outlet is doing a spotlight on a non-profit. The non-profit does not pay for earned media.  
- A media mention is every time Second Harvest Heartland is mentioned in the news.  
