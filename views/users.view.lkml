view: users {
  sql_table_name: "PUBLIC"."USERS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}."AGE" ;;
    group_label: "Personal info"
  }

  dimension: age_tier {
    type: tier
    description: "Calculates age groups"
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    style:  integer
    sql: ${age} ;;
    group_label: "Personal info"
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
    group_label: "Geography"
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
    group_label: "Geography"
  }

  dimension: city_state {
    type: string
    description: "Combines city and state into a single field"
    sql: ${city} || ' ' || ${state} ;;
    group_label: "Geography"
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

  dimension: email {
    type: string
    hidden: yes
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
    group_label: "Personal info"
  }

  dimension: gender {
    type: string
    sql: ${TABLE}."GENDER" ;;
    group_label: "Personal info"
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
    group_label: "Personal info"
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
    group_label: "Geography"
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
    group_label: "Geography"
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
    group_label: "Geography"
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}."TRAFFIC_SOURCE" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
    group_label: "Geography"
  }

  dimension: user_location {
    type: location
    label: "User Location"
    description: "User latitude and longitude coordinates"
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
    group_label: "Geography"
  }

  measure: count {
    type: count
    label: "Customer Count"
  }

  # measure: count {
  #   type: count
  #   hidden:  yes
  #   drill_fields: [id, last_name, first_name, events.count, order_items.count]
  # }


  # Creating set of dimensions and measures to be shown in Customers explore

  set: user_info {
    fields: [
      id,
      age,
      age_tier,
      city_state,
      country,
      gender,
      first_name,
      last_name,
      user_location,
      traffic_source,
      count
    ]
  }
}
