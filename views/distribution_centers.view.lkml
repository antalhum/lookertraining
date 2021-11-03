view: distribution_centers {
  sql_table_name: "PUBLIC"."DISTRIBUTION_CENTERS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden:  yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: user_location {
    type: location
    label: "Center Location"
    description: "Distribution center latitude and longitude coordinates"
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  measure: count {
    type: count
    label: "Distribution Center Count"
    }

  # measure: count {
  #   type: count
  #   drill_fields: [id, name, products.count]
  # }

}
