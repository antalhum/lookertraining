connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

datagroup: looker_intensive2_antal_hum_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: looker_intensive2_antal_hum_default_datagroup


explore: order_items {
  view_label: "Order Items"
  label: "Order Items"
  join: inventory_items {
    view_label: "Order Items"
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    view_label: "Customers"
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    view_label: "Products"
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    view_label: "Distribution Centers"
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}



explore: customers {
  label: "Customers"
  from: users
  fields: [customers.user_info*]
  }



# explore: distribution_centers {}

# explore: etl_jobs {}

# explore: events {
#   view_label: "Events"
#   join: users {
#     view_label: "Customers"
#     type: left_outer
#     sql_on: ${events.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }

# explore: inventory_items {
#   view_label: "Inventory"
#   join: products {
#     view_label: "Products"
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }

#   join: distribution_centers {
#     view_label: "Distribution Centers"
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }
# }

# explore: order_items {
#   view_label: "Orders"
#   label: "Orders"
#   join: inventory_items {
#     view_label: "Inventory"
#     type: left_outer
#     sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
#     relationship: many_to_one
#   }

#   join: users {
#     view_label: "Customers"
#     type: left_outer
#     sql_on: ${order_items.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }

#   join: products {
#     view_label: "Products"
#     type: left_outer
#     sql_on: ${inventory_items.product_id} = ${products.id} ;;
#     relationship: many_to_one
#   }

#   join: distribution_centers {
#     view_label: "Distribution Centers"
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }
# }

# explore: products {
#   view_label: "Products"
#   label: "Products"
#   join: distribution_centers {
#     view_label: "Distribution Centers"
#     type: left_outer
#     sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
#     relationship: many_to_one
#   }
# }

# explore: users {}
