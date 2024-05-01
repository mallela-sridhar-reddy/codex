-- 1. Demographic Insights (examples)
-- a. Who prefers energy drink more? (male/female/non-binary?)
SELECT Gender,count(Respondent_ID) as Total_Respondents 
FROM dim_repondents group by Gender 
order by Total_Respondents desc;

-- b. Which age group prefers energy drinks more?
SELECT Age,count(Respondent_ID) as Total_Respondents 
FROM dim_repondents group by Age 
order by Total_Respondents desc;

-- Which type of marketing reaches the most Youth (15-30)?
SELECT Marketing_channels,count(Response_ID) as Total_Respondents from
fact_survey_responses as fsr join dim_repondents as dr
on fsr.Respondent_ID = dr.Respondent_ID
 where Age in ("15-18", "19-30") group by Marketing_channels 
order by Total_Respondents desc;


-- 2. Consumer Preferences:
-- a. What are the preferred ingredients of energy drinks among respondents?
select Ingredients_expected,count(Response_ID) as Total_Respondents from
fact_survey_responses group by Ingredients_expected 
order by Total_Respondents desc;

-- b. What packaging preferences do respondents have for energy drinks?
select Packaging_preference,count(Response_ID) as Total_Respondents from
fact_survey_responses group by Packaging_preference 
order by Total_Respondents desc;



-- 3. Competition Analysis:
-- a. Who are the current market leaders?
select Current_brands as Current_brand_leaders,count(Response_ID) as Total_Respondents from
fact_survey_responses group by Current_brand_leaders 
order by Total_Respondents desc;

-- b. What are the primary reasons consumers prefer those brands over ours?
select Reasons_for_choosing_brands,count(Response_ID) as Total_Respondents from
fact_survey_responses group by Reasons_for_choosing_brands 
order by Total_Respondents desc;



-- 4. Marketing Channels and Brand Awareness:
-- a. Which marketing channel can be used to reach more customers?
SELECT Marketing_channels,count(Response_ID) as Total_Respondents from
fact_survey_responses group by Marketing_channels 
order by Total_Respondents desc;

-- b. How effective are different marketing strategies and channels in reaching our customers?
SELECT Marketing_channels,count(Response_ID) as Total_Respondents from
fact_survey_responses where Current_brands = "CodeX" group by Marketing_channels 
order by Total_Respondents desc;



-- 5. Brand Penetration:
-- a. What do people think about our brand? (overall rating)
SELECT Brand_perception,count(Response_ID) as Total_Respondents from
fact_survey_responses where Current_brands = "CodeX" group by Brand_perception 
order by Total_Respondents desc;

-- b. Which cities do we need to focus more on?
SELECT City,count(dr.Respondent_ID) as Total_Respondents from
dim_repondents as dr join dim_cities as dc
on dr.City_ID = dc.City_ID join
fact_survey_responses as fsr on fsr.Respondent_ID = dr.Respondent_ID
where Current_brands = "CodeX"
group by City 
order by Total_Respondents desc;




-- 6. Purchase Behavior:
-- a. Where do respondents prefer to purchase energy drinks?
SELECT Purchase_location,count(Response_ID) as Total_Respondents from
fact_survey_responses group by Purchase_location 
order by Total_Respondents desc;

-- b. What are the typical consumption situations for energy drinks among respondents?
SELECT Typical_consumption_situations,count(Response_ID) as Total_Respondents from
fact_survey_responses group by Typical_consumption_situations
order by Total_Respondents desc;

-- c. What factors influence respondents' purchase decisions, such as price range and limited edition packaging?
SELECT Limited_edition_packaging,count(Response_ID) as Total_Respondents from
fact_survey_responses group by Limited_edition_packaging
order by Total_Respondents desc;

SELECT Price_range,count(Response_ID) as Total_Respondents from
fact_survey_responses group by Price_range
order by Total_Respondents desc;



-- 7. Product Development
-- a. Which area of business should we focus more on our product development? (Branding/taste/availability)
SELECT Reasons_for_choosing_brands,count(Response_ID) as Total_Respondents from
fact_survey_responses 
where Current_brands = "CodeX"
group by Reasons_for_choosing_brands
order by Total_Respondents desc;




-- secondary insights
-- our performance compared to best performing brand
-- 25% vs 10% market share
-- a. What are the primary reasons consumers prefer that top brand vs ours?
with cte1 as (
select Reasons_for_choosing_brands,count(Response_ID) as Total_Respondents
from
fact_survey_responses
where Current_brands = "Cola-Coka"
 group by Reasons_for_choosing_brands  
order by Total_Respondents desc)
select *,Total_Respondents*100/sum(Total_Respondents) over () as percentage from cte1;


with cte1 as (
select Reasons_for_choosing_brands,count(Response_ID) as Total_Respondents
from
fact_survey_responses
where Current_brands = "CodeX"
 group by Reasons_for_choosing_brands  
order by Total_Respondents desc)
select *,Total_Respondents*100/sum(Total_Respondents) over () as percentage from cte1;


-- b. Which Tier cities do we need to focus more on?
SELECT Tier,count(dr.Respondent_ID) as Total_Respondents from
dim_repondents as dr join dim_cities as dc
on dr.City_ID = dc.City_ID join
fact_survey_responses as fsr on fsr.Respondent_ID = dr.Respondent_ID
group by Tier 
order by Total_Respondents desc;

-- c. consume frequency
SELECT Consume_frequency,count(Response_ID) as Total_Respondents from
fact_survey_responses
group by Consume_frequency
order by Total_Respondents desc;   

-- d. consume time
SELECT Consume_time,count(Response_ID) as Total_Respondents from
fact_survey_responses
group by Consume_time
order by Total_Respondents desc;   -- put these in office buildings

-- e. consume reason
SELECT Consume_reason,count(Response_ID) as Total_Respondents from
fact_survey_responses
group by Consume_reason
order by Total_Respondents desc;   -- not many people are buying for performance improvement so focus on that using sports celebrity

-- f. heard before
SELECT Current_brands,count(Heard_before) as Heard_before from
fact_survey_responses
where Heard_before = "Yes"
group by Current_brands
order by Heard_before desc;   -- only 5% vs 11% for cola-coka energy drink consumers have heard us before the survey

-- have tried before
SELECT Current_brands,count(*) as Tried_before from
fact_survey_responses
where Tried_before = "Yes"
group by Current_brands
order by Tried_before desc;   -- only 5% vs 11% for cola-coka energy drink consumers have tried our product before the survey

-- taste
SELECT Current_brands,avg(Taste_experience) as taste_rating from
fact_survey_responses
where Tried_before = "Yes"
group by Current_brands
order by taste_rating desc;    -- our product taste is 3.23 which is close to market average

-- reasons preventing trying
SELECT Reasons_preventing_trying,count(Response_ID) as count from
fact_survey_responses
group by Reasons_preventing_trying
order by count desc;              -- availability so supply chain, health marketing less sugar

-- improvements desired
SELECT Improvements_desired,count(Response_ID) as count from
fact_survey_responses
group by Improvements_desired
order by count desc;           -- reduced sugar content and more natural ingredients, more flavors   

-- ingredients expected 
SELECT Ingredients_expected,count(Response_ID) as count from
fact_survey_responses
group by Ingredients_expected
order by count desc;            -- more caffeine and vitamins

-- Packaging_preference
SELECT Packaging_preference,count(Response_ID) as count from
fact_survey_responses
group by Packaging_preference
order by count desc;            -- compact and portable cans with innovative design and eco-friendly