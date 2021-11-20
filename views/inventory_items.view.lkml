view: inventory_items {
  sql_table_name: "PUBLIC"."INVENTORY_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden:  yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}."COST" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  # dimension: product_brand {
  #   type: string
  #   sql: ${TABLE}."PRODUCT_BRAND" ;;
  # }

  dimension: product_brand {
    type: string
    sql: ${TABLE}."PRODUCT_BRAND" ;;
    link: {
      label: "{{ value }}'s info"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "http://google.com/favicon.ico"
      }
    link: {
      label: "{{ value }}'s Facebook results"
      url: "http://www.google.com/search?q={{ value }} facebook"
      icon_url: "https://upload.wikimedia.org/wikipedia/commons/f/fb/Facebook_icon_2013.svg"
    }
    drill_fields: [product_category, product_name, product_sku]
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}."PRODUCT_CATEGORY" ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}."PRODUCT_DEPARTMENT" ;;
  }

  dimension: product_distribution_center_id {
    type: number
    hidden: yes
    sql: ${TABLE}."PRODUCT_DISTRIBUTION_CENTER_ID" ;;
  }

  dimension: product_id {
    type: number
    hidden: yes
    sql: ${TABLE}."PRODUCT_ID" ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}."PRODUCT_NAME" ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}."PRODUCT_RETAIL_PRICE" ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}."PRODUCT_SKU" ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}."SOLD_AT" ;;
  }

  # measure: count {
  #   type: count
  #   hidden:  yes
  #   drill_fields: [id, product_name, products.name, products.id, order_items.count]
  # }

  measure: count {
    type: count
    label: "Inventory Items Count"
  }

  measure: total_cost {
    type: sum
    label: "Total Cost"
    description: "Total cost of items sold from inventory"
    sql: ${cost} ;;
    group_label: "Costs"
  }

  measure: average_cost {
    type:  average
    label: "Average Cost"
    description: "Total cost of items sold from inventory"
    sql: ${cost} ;;
    group_label: "Costs"
  }

}
