view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [product_details*]

  dimension: id {
    primary_key: yes
    hidden:  yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    hidden: yes
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension_group: shipping_days {
    type: duration
    description: "Calculates duration of shipping an item in days"
    intervals: [day]
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: is_returned {
    type:  yesno
    description: "Calculates whether order was returned or not"
    sql:  UPPER(${status}) = 'RETURNED' ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  # measure: count {
  #   type: count
  #   hidden: yes
  #   drill_fields: [detail*]
  # }

  measure: count {
    type: count
    label: "Order Items Count"
  }

  measure: total_sale_price {
    type: sum
    label: "Total Sale Price"
    description: "Calculates total sales from items sold"
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Revenues"
  }

  measure: avg_sale_price {
    type: average
    label: "Average Sale Price"
    description: "Calculates average sales price of items sold"
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Revenues"
  }

  measure: cumul_total_sales {
    type: running_total
    label: "Cumulative Total Sales"
    description: "Calculates cumulative total sales from items sold"
    sql: ${sale_price} ;;
    value_format_name: usd
    group_label: "Revenues"
  }

  measure: total_gross_revenue {
    type: sum
    label: "Total Gross Revenue"
    description: "Total revenue from completed sales, excluding cancelled and returned orders"
    filters: [status: "-Returned, -Cancelled"]
    sql: ${sale_price};;
    value_format_name: usd
    group_label: "Revenues"
  }

  measure: total_gross_margin_amount {
    type: number
    label: "Total Gross Margin Amount"
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    sql: ${total_gross_revenue} - ${inventory_items.total_cost};;
    value_format_name: usd
    group_label: "Margins"
  }

  measure: average_gross_margin {
    type: number
    label: "Average Gross Margin"
    description: "Average difference between the total revenue from completed sales and the cost of the goods that were sold"
    sql: ${total_gross_revenue} - ${inventory_items.total_cost};;
    value_format_name: usd
    group_label: "Margins"
  }

  measure: gross_margin_ratio {
    type: number
    label: "Gross Margin %"
    description: "Total Gross Margin Amount / Total Gross Revenue"
    sql: ${total_gross_margin_amount} / ${total_gross_revenue};;
    value_format_name: percent_2
    group_label: "Margins"
  }

  measure: number_of_items_returned {
    type: count_distinct
    label: "Number of Items Returned"
    description: "Number of items that were returned by dissatisfied customers"
    filters: [status: "Returned"]
    sql: ${inventory_item_id};;
    group_label: "Products Returned"
  }

  measure: item_return_rate{
    type: number
    label: "Item Return Ratio"
    description: "Number of items returned / total number of items sold"
    sql: ${number_of_items_returned} / ${count};;
    value_format_name: percent_2
    group_label: "Products Returned"
  }

  measure: customers_returning_items{
    type: count_distinct
    label: "Number of Customers Returning Items"
    description: "Number of customers who have returned an item at some point"
    filters: [status: "Returned"]
    sql: ${user_id};;
    group_label: "Products Returned"
  }

  measure: returning_customers_pct{
    type: number
    label: "% of Customers with Returns"
    description: "Number of Customer Returning Items / total number of customers"
    sql: ${customers_returning_items} / NULLIF(${users.count}, 0);;
    value_format_name: percent_2
    group_label: "Products Returned"
  }

  measure: average_spend_per_customer{
    type: number
    label: "Average Spend per Customer"
    description: "Total Sale Price / total number of customers"
    sql: ${total_sale_price} / ${users.count};;
    value_format_name: usd
    group_label: "Revenues"
  }


  # Set of fields for Customer explore

  set: behavior {
    fields: [
      average_spend_per_customer,
      customers_returning_items,
      returning_customers_pct
      ]
  }


  # ----- Sets of fields for drilling ------
  set: product_details {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.product_category,
      inventory_items.product_department,
      inventory_items.product_distribution_center_id
    ]
  }
}
