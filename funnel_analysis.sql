SELECT * FROM `teak-mix-343220.Sequal_practise_dataset.user_events` LIMIT 1000;

--DEFINE sales funnel and the differnt types of stages

WITH funnel_stages AS (
  SELECT 
    COUNT(DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS stage_1_view,
    COUNT(DISTINCT CASE WHEN event_type='add_to_cart' THEN user_id END) AS stage_2_cart,
    COUNT(DISTINCT CASE WHEN event_type='checkout_start' THEN user_id END) AS stage_3_checkout,
    COUNT(DISTINCT CASE WHEN event_type='payment_info' THEN user_id END) AS stage_4_payment,
    COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS stage_5_purchase
    FROM `teak-mix-343220.Sequal_practise_dataset.user_events`
    WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR))
  )
SELECT * FROM funnel_stages;

-- coversion rates through funnel analysis. 
WITH funnel_stages AS (
  SELECT 
    COUNT(DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS stage_1_view,
    COUNT(DISTINCT CASE WHEN event_type='add_to_cart' THEN user_id END) AS stage_2_cart,
    COUNT(DISTINCT CASE WHEN event_type='checkout_start' THEN user_id END) AS stage_3_checkout,
    COUNT(DISTINCT CASE WHEN event_type='payment_info' THEN user_id END) AS stage_4_payment,
    COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS stage_5_purchase
    FROM `teak-mix-343220.Sequal_practise_dataset.user_events`
    WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR))
  )

SELECT 
  stage_1_view,
  stage_2_cart,
  ROUND(stage_2_cart * 100 / stage_1_view,2) AS view_to_cart_rate,

  stage_3_checkout,
  ROUND(stage_3_checkout * 100 / stage_2_cart) AS cart_to_checkout_rate,

  stage_4_payment,
  ROUND(stage_4_payment * 100 / stage_3_checkout) AS checkout_to_payment_rate,

  stage_5_purchase,
  ROUND(stage_5_purchase * 100 / stage_4_payment) AS payment_to_purchase_rate,
  ROUND(stage_5_purchase * 100 / stage_1_view) AS overall_convertion_rate

FROM funnel_stages;

-- coversion rates through funnel analysis. 
WITH source_funnel AS (
  SELECT 
  traffic_source,
    COUNT(DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS views,
    COUNT(DISTINCT CASE WHEN event_type='add_to_cart' THEN user_id END) AS cart,
    COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS purchases

    FROM `teak-mix-343220.Sequal_practise_dataset.user_events` 
    WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR))
    GROUP BY traffic_source
  
  )

SELECT 
  traffic_source,
  views, 
  cart, 
  purchases,
  ROUND(cart * 100 / views) AS cart_conversions_rate,
  ROUND(purchases * 100 / views) AS purchases_conversions_rate,
  ROUND(purchases * 100 / cart) AS cart_to_purchases_conversions_rate

  FROM source_funnel
  ORDER BY purchases DESC;

-- time to conversion analysis. 

WITH user_journey AS (
  SELECT 
  user_id,
    MIN(CASE WHEN event_type='page_view' THEN event_date END) AS views_time,
    MIN( CASE WHEN event_type='add_to_cart' THEN event_date END) AS cart_time,
    MIN( CASE WHEN event_type='purchase' THEN event_date END) AS purchases_time

    FROM `teak-mix-343220.Sequal_practise_dataset.user_events` 
    WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR))
    GROUP BY user_id
    HAVING  MIN( CASE WHEN event_type='purchase' THEN event_date END) IS NOT NULL
  
  )
SELECT 
COUNT(*) AS converted_users,
ROUND(AVG(TIMESTAMP_DIFF(cart_time, views_time, MINUTE)) ,2) AS avg_view_to_cart_minutes,
ROUND(AVG(TIMESTAMP_DIFF(purchases_time, cart_time , MINUTE)) ,2) AS avg_cart_to_purchase_minutes,
ROUND(AVG(TIMESTAMP_DIFF(purchases_time, views_time, MINUTE)) ,2) AS avg_total_journey_minutes,
FROM user_journey;

-- revenue funnel analysis

WITH revenue_funnel AS (
  SELECT 
    COUNT(DISTINCT CASE WHEN event_type='page_view' THEN user_id END) AS total_visitors,
    COUNT(DISTINCT CASE WHEN event_type='purchase' THEN user_id END) AS total_buyers,
    SUM(CASE WHEN event_type='purchase' THEN amount END) AS total_revenue,
    COUNT(CASE WHEN event_type='purchase' THEN 1 END) AS total_orders,

    FROM `teak-mix-343220.Sequal_practise_dataset.user_events` 
    WHERE event_date >= TIMESTAMP(DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR))
  
  )
SELECT
  total_visitors,
  total_buyers,
  total_revenue,
  total_orders,
  total_revenue/total_orders AS avg_order_value,
  total_revenue/ total_buyers AS revenue_per_buyer,
  total_revenue/ total_visitors AS revenue_per_visitor

  FROM revenue_funnel




