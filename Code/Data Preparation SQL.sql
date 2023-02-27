create schema live_case;

USE SCHEMA live_case;
select count(*) from events_2021 order by date;

#1590
select * from events_2020 order by date;

drop table if exists events;
create table events as (
select * from events_2020
union
select * from events_2021
);

drop table if exists events_clean;
create table events_clean as
(
select `Date` as Date,
Headline as Headline,
URL as URL,
`Hit Sentence` as Hit_Sentence,
Source as Source,
Influencer as Influencer,
Country as Country,
Reach as Reach,
`Desktop Reach` as Desktop_Reach,
`Mobile Reach` as Mobile_Reach,
`Twitter Social Echo` as Twitter_Social_Echo,
`Facebook Social Echo` as Facebook_Social_Echo,
`Reddit Social Echo` as Reddit_Social_Echo,
AVE as AVE,
Sentiment as Sentiment,
`Key Phrases` as Key_Phrases,
`Input Name` as Input_Name,
Time as Time,
State as State,
City as City
from events
where reach<=10000000
and country="United States"
 );

drop table if exists events_clean_dedup;
create table events_clean_dedup as 
(SELECT distinct date as event_date,
Headline,
Influencer,
Reach,
Desktop_Reach,
Mobile_Reach,
Twitter_Social_Echo,
Facebook_Social_Echo,
Reddit_Social_Echo,
Sentiment,
Input_Name,
state,
city,
time,
b.`Media Type`
FROM live_case.events_clean ec
left join `media type mapping` b using (source)) ;


drop table if exists donations_clean;
create table donations_clean as
(
select `Date` as gift_date,
Amount as Amount,
`Gift ID` as Gift_ID,
`Payment Method` as Payment_Method,
`Gift Type` as Gift_Type,
Fund as Fund,
`Donor ID` as Donor_ID,
`Key Indicator` as Key_Indicator,
`Donor Zip Code` as Donor_Zip_Code,
Gf_Apls_1_01_ApAtrCat_2_01_Description as Gift_Description,
`Lifetime # of Gifts` as Lifetime_Gifts,
`First Gift Date` as First_Gift_Date,
`First Gift Amt` as First_Gift_Amt,
`Last Gift Date` as Last_Gift_Date,
`Last Gift Amt` as Last_Gift_Amt
 from donations
 );

drop table if exists donation_c_filtered;
create table donation_c_filtered as
(
select a.* , case when payment_method ='Credit Card' then date_sub(gift_date, INTERVAL 4 DAY ) 
				else gift_date end as gift_date_2
                from donations_clean a where 
                Gift_ID is not null and Key_Indicator="I"
                and gift_type <> 'Stock/Property'
);

create table donations_date_wise_summary as
(
select gift_date_2, sum(amount) as sum_amount , count(*) as count_donation from donation_c_filtered group by 1
);

drop table if exists don_event_5;
create table don_event_5 as 
(
	select a.* , b.*
	, datediff(gift_date_2, event_date) as donation_lag
	, 5-datediff(gift_date_2, event_date) as donation_lag_2
	from donations_date_wise_summary a
	left join
	events_clean_dedup b 
	on b.event_date between date_sub(a.gift_Date_2, INTERVAL 4 DAY) and a.gift_date_2
	where reach >0 
	# and a.Gift_ID = 'd9977daa'
	order by event_date desc
) ;#as t;

drop table if exists don_event_4;
create table don_event_4 as 
(
	select a.* , b.*
	, datediff(gift_date_2, event_date) as donation_lag
	, 5-datediff(gift_date_2, event_date) as donation_lag_2
	from donations_date_wise_summary a
	left join
	events_clean_dedup b 
	on b.event_date between date_sub(a.gift_Date_2, INTERVAL 3 DAY) and a.gift_date_2
	where reach >0 
	# and a.Gift_ID = 'd9977daa'
	order by event_date desc
) ;#as t;

drop table if exists don_event_3;
create table don_event_3 as 
(
	select a.* , b.*
	, datediff(gift_date_2, event_date) as donation_lag
	, 5-datediff(gift_date_2, event_date) as donation_lag_2
	from donations_date_wise_summary a
	left join
	events_clean_dedup b 
	on b.event_date between date_sub(a.gift_Date_2, INTERVAL 2 DAY) and a.gift_date_2
	where reach >0 
	# and a.Gift_ID = 'd9977daa'
	order by event_date desc
) ;#as t;

drop table if exists don_event_2;
create table don_event_2 as 
(
	select a.* , b.*
	, datediff(gift_date_2, event_date) as donation_lag
	, 5-datediff(gift_date_2, event_date) as donation_lag_2
	from donations_date_wise_summary a
	left join
	events_clean_dedup b 
	on b.event_date between date_sub(a.gift_Date_2, INTERVAL 1 DAY) and a.gift_date_2
	where reach >0 
	# and a.Gift_ID = 'd9977daa'
	order by event_date desc
) ;#as t;

drop table if exists don_event_1;
create table don_event_1 as 
(
	select a.* , b.*
	, datediff(gift_date_2, event_date) as donation_lag
	, 5-datediff(gift_date_2, event_date) as donation_lag_2
	from donations_date_wise_summary a
	left join
	events_clean_dedup b 
	on b.event_date between date_sub(a.gift_Date_2, INTERVAL 0 DAY) and a.gift_date_2
	where reach >0 
	# and a.Gift_ID = 'd9977daa'
	order by event_date desc
) ;#as t;

drop table if exists don_event_expo_5;
create table don_event_expo_5 as
(
	select d.*,sum(atribution) over (partition by gift_date_2 
	rows between unbounded preceding and unbounded following ) as sum_attribution,
	
	sum_amount * atribution / (sum(atribution) over (partition by gift_date_2 
	rows between unbounded preceding and unbounded following )) as sum_amount_attribution
	
	from 
	(	select c.* , ( sum_donation_lag2 / power(2,power_exp) )  as atrib_factor, (reach*( sum_donation_lag2 / power(2,power_exp) ) )/ sum_reach as atribution
		from
		(
			select a.* , 
			sum(donation_lag_2) over (partition by gift_date_2 
			order by donation_lag_2 desc rows between unbounded preceding and unbounded following ) as sum_donation_lag2 ,
            
			sum(reach) over (partition by gift_date_2,donation_lag_2 
			rows between unbounded preceding and unbounded following ) as sum_reach,
            
			dense_rank() over (partition by gift_date_2 order by donation_lag_2 desc) as power_exp
			from don_event_5 a
		) c
	)d
);

drop table don_event_expo_5_2;
create table don_event_expo_5_2 as
(
SELECT *,
weekday(event_date) as wkday, case when influencer ="" then 0 else 1 end as influencer_flag,
case when (event_date>='2020-11-15' and event_date<='2021-01-07')
or (event_date>='2021-11-15' and event_date<='2022-01-07') then 1 else 0 end as holiday_flag
FROM live_case.don_event_expo_5);

drop table don_event_expo_5_3;
create table don_event_expo_5_3 as
(SELECT a.*, case when b.pc_flag is null then 0 else b.pc_flag end as pc_flag
from don_event_expo_5_2 a
left join shh_campaign_by_date b
on a.event_date=b.paid_campaign_date);


drop table don_event_expo_5_4;
create table don_event_expo_5_4 as
(select event_date,	
Headline,	
Influencer,	
Reach,	
Sentiment,	
Twitter_Social_Echo,
Facebook_Social_Echo,
`Media Type` as media_type,	
wkday,	
influencer_flag,	
holiday_flag,	
pc_flag,
state,
case when state = "Minnesota" then 1 else 0 end as minnesota_flag,
city,
time,	
sum(sum_amount_attribution) as sum_amount_attribution
from 
don_event_expo_5_3
group by
event_date,	
Headline,	
Influencer,	
Reach,	
Sentiment,	
Twitter_Social_Echo,
Facebook_Social_Echo,
`Media Type`,	
wkday,	
influencer_flag,	
holiday_flag,	
pc_flag,
state,
minnesota_flag,
city,
time);
