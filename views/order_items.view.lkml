view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
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
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
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
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_sale_price {
    type: sum
    description: "Calculates total sales from items sold"
    sql: ${sale_price} ;;
    value_format_name: usd
    label: "Total Sale Price"
    group_label: "Price metrics"
  }

  measure: avg_sale_price {
    type: average
    description: "Calculates average sales price of items sold"
    sql: ${sale_price} ;;
    value_format_name: usd
    label: "Average Sale Price"
    group_label: "Price metrics"
  }

  measure: cumul_total_sales {
    type: running_total
    description: "Calculates cumulative total sales from items sold"
    sql: ${sale_price} ;;
    value_format_name: usd
    label: "Cumulative Total Sales"
    group_label: "Revenue metrics"
  }

  measure: total_gross_revenue {
    type: sum
    description: "Calculates total revenue from completed sales (excluding cancelled and returned orders)"
    sql: ${sale_price} & ${is_returned} = 'False' ;;
    value_format_name: usd
    label: "Total Gross Revenue"
    group_label: "Revenue metrics"
  }

  measure: total_cost {
    type: sum
    description: "Total cost of items sold from inventory"
    sql: ${inventory_items.cost};;
    value_format_name: usd
    label: "Total Cost"
    group_label: "Cost metrics"
  }

  measure: average_cost {
    type: average
    description: "Total cost of items sold from inventory"
    sql: ${inventory_items.cost} ;;
    value_format_name: usd
    label: "Average Cost"
    group_label: "Cost metrics"
  }

  measure: total_gross_margin {
    type: sum
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    sql: (${sale_price} & ${is_returned} = 'False') - ${inventory_items.cost};;
    value_format_name: usd
    label: "Total Gross Margin Amount"
    group_label: "Margin metrics"
  }

  measure: average_gross_margin {
    type: average
    description: "Average difference between the total revenue from completed sales and the cost of the goods that were sold"
    sql: (${sale_price} & ${is_returned} = 'False') - ${inventory_items.cost};;
    value_format_name: usd
    label: "Average Gross Margin"
    group_label: "Margin metrics"
  }

  measure: gross_margin_ratio {
    type: number
    description: "Total Gross Margin Amount / Total Gross Revenue"
    sql: ${total_gross_margin} / ${total_gross_revenue};;
    value_format_name: percent_2
    label: "Gross Margin %"
    group_label: "Margin metrics"
  }

  measure: items_returned {
    type: sum
    description: "Number of items that were returned by dissatisfied customers"
    sql: ${is_returned} = 'True';;
    value_format_name: decimal_0
    label: "Number of Items Returned"
    group_label: "Product return metrics"
  }

  measure: item_return_rate{
    type: number
    description: "Number of items returned / total number of items sold"
    sql: ${items_returned} / COUNT(${inventory_item_id});;
    value_format_name: percent_2
    label: "Item Return Ratio"
    group_label: "Product return metrics"
  }

  measure: returning_customers{
    type: sum_distinct
    description: "Number of Customers who have returned an item at some point"
    sql: ${users.id} & ${is_returned} = 'True';;
    value_format_name: decimal_0
    label: "Number of Customers Returning Items"
    group_label: "Product return metrics"
  }

  measure: returning_customers_pct{
    type: number
    description: "Number of Customer Returning Items / total number of customers"
    sql: ${returning_customers} / COUNT(${users.id});;
    value_format_name: percent_2
    label: "% of Customers with Returns"
    group_label: "Product return metrics"
  }

  measure: average_spend_per_customer{
    type: number
    description: "Total Sale Price / total number of customers"
    sql: ${total_sale_price} / COUNT(${users.id});;
    value_format_name: usd
    label: "Average Spend per Customer"
    group_label: "Revenue metrics"
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.id,
      users.first_name
    ]
  }
}
