-- Creating "customers" collection

db.createCollection("customers", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "email", "address", "phone", "registration_date"],
      properties: {
        name: {
          bsonType: "string",
          description: "Name must be a string and is required"
        },
        email: {
          bsonType: "string",
          pattern: "^.+@.+$",
          description: "Email must be a string and match the email format"
        },
        address: {
          bsonType: "object",
          required: ["street", "city", "zipcode"],
          properties: {
            street: {
              bsonType: "string",
              description: "Street must be a string and is required"
            },
            city: {
              bsonType: "string",
              description: "City must be a string and is required"
            },
            zipcode: {
              bsonType: "string",
              pattern: "^[0-9]{5}$",
              description: "Zipcode must be a 5-digit string"
            }
          },
          description: "Address is required and must be an object with street, city, and zipcode"
        },
        phone: {
          bsonType: "string",
          pattern: "^[0-9-]+$",
          description: "Phone must be a string of digits and dashes"
        },
        registration_date: {
          bsonType: "date",
          description: "Registration date must be a valid date and is required"
        }
      }
    }
  }
});


-- Creating "orders" collection

db.createCollection("orders", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["order_id", "customer_id", "order_date", "status", "items", "total_value"],
      properties: {
        order_id: {
          bsonType: "string",
          description: "Order ID must be a string and is required"
        },
        customer_id: {
          bsonType: "objectId",
          description: "Customer ID must be an ObjectId and is required"
        },
        order_date: {
          bsonType: "date",
          description: "Order date must be a valid date and is required"
        },
        status: {
          enum: ["pending", "shipped", "delivered", "cancelled"],
          description: "Status can only be one of the specified values"
        },
        items: {
          bsonType: "array",
          minItems: 1,
          items: {
            bsonType: "object",
            required: ["product_name", "quantity", "price"],
            properties: {
              product_name: {
                bsonType: "string",
                description: "Product name must be a string and is required"
              },
              quantity: {
                bsonType: "int",
                minimum: 1,
                description: "Quantity must be an integer of at least 1"
              },
              price: {
                bsonType: "int",
                minimum: 0,
                description: "Price must be a non-negative integer"
              }
            }
          },
          description: "Items must be an array of objects, each with product_name, quantity, and price"
        },
        total_value: {
          bsonType: "int",
          minimum: 0,
          description: "Total value must be a non-negative integer and is required"
        }
      }
    }
  }
});



-- Inserting values into "customers" collection

db.customers.insertMany([
    {name: "John Doe", email: "johndoe@example.com", address: {street: "123 Main St", city: "springField", zipcode: "12345"}, "phone": "555-1235", registration_date: new Date()},
    {name: "Jane Doe", email: "janedoe@example.com", address: {street: "124 Main St", city: "HillTown", zipcode: "23135"}, "phone": "555-1236", registration_date: new Date()},
    {name: "Mike Doe", email: "mikedoe@example.com", address: {street: "125 Main St", city: "TownHill", zipcode: "44444"}, "phone": "555-1237", registration_date: new Date()},
    {name: "Test Doe", email: "testdoe@example.com", address: {street: "126 Main St", city: "Lakeside", zipcode: "23213"}, "phone": "555-1238", registration_date: new Date()},
    {name: "Hello Doe", email: "hellodoe@example.com", address: {street: "127 Main St", city: "Riverside", zipcode: "53313"}, "phone": "555-1239", registration_date: new Date()}]);

-- Getting the objectIds of each customer
db.customers.find({}, {_id: 1, name: 1});

-- Inserting values into "orders"

db.orders.insertMany([
    {order_id: "ORD123456", customer_id: ObjectId('6733882e084fa1c460c1c18c'), order_date: new Date() ,status: "shipped", items: [{product_name: "laptop", quantity: 1, price: 20000}, {product_name: "mouse", quantity: 2, price:500}], total_value: 21000},
    {order_id: "ORD123457", customer_id: ObjectId('6733882e084fa1c460c1c18d'), order_date: new Date() ,status: "pending", items: [{product_name: "laptop", quantity: 1, price: 20000}, {product_name: "mouse", quantity: 1, price:500}], total_value: 20500},
    {order_id: "ORD123458", customer_id: ObjectId('6733882e084fa1c460c1c18e'), order_date: new Date() ,status: "delivered", items: [{product_name: "laptop", quantity: 2, price: 20000}, {product_name: "mouse", quantity: 2, price:500}], total_value: 41000},
    {order_id: "ORD123459", customer_id: ObjectId('6733882e084fa1c460c1c18f'), order_date: new Date() ,status: "cancelled", items: [{product_name: "laptop", quantity: 1, price: 20000}, {product_name: "mouse", quantity: 3, price:500}], total_value: 21500},
    {order_id: "ORD123450", customer_id: ObjectId('6733882e084fa1c460c1c190'), order_date: new Date() ,status: "shipped", items: [{product_name: "laptop", quantity: 1, price: 20000}, {product_name: "mouse", quantity: 2, price:500}], total_value: 21000},

]
);



-- Write a script to find all orders placed by a customer with the name “John Doe”. Use the customer’s _id to query the orders collection.

assessments> let customer = db.customers.findOne({name: "John Doe"});

assessments> db.orders.find({customer_id: customer._id});
[
  {
    _id: ObjectId('67338cda084fa1c460c1c196'),
    order_id: 'ORD123456',
    customer_id: ObjectId('6733882e084fa1c460c1c18c'),
    order_date: ISODate('2024-11-12T17:14:02.471Z'),
    status: 'shipped',
    items: [
      { product_name: 'laptop', quantity: 1, price: 20000 },
      { product_name: 'mouse', quantity: 2, price: 500 }
    ],
    total_value: 21000
  }
]

-- Write a script to find the customer information for a specific order (e.g., order_id = “ORD123456”).

assessments> db.orders.findOne({order_id: "ORD123456"});
{
  _id: ObjectId('67338cda084fa1c460c1c196'),
  order_id: 'ORD123456',
  customer_id: ObjectId('6733882e084fa1c460c1c18c'),
  order_date: ISODate('2024-11-12T17:14:02.471Z'),
  status: 'shipped',
  items: [
    { product_name: 'laptop', quantity: 1, price: 20000 },
    { product_name: 'mouse', quantity: 2, price: 500 }
  ],
  total_value: 21000
}

-- Write a script to update the status of an order to “delivered” where the order_id is “ORD123456”.
assessments> db.orders.updateOne({order_id: "“ORD123456”"}, {$set: {status: "delivered"}});
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 0,
  modifiedCount: 0,
  upsertedCount: 0
}

-- Write a script to delete an order where the order_id is “ORD123456”.
assessments> db.orders.deleteOne({ order_id: "ORD123456" });

-- Write a script to calculate the total value of all orders for each customer. This should return each customer’s name and the total order value.
assessments> db.orders.aggregate([
  {
    $lookup: {
      from: "customers",
      localField: "customer_id",
      foreignField: "_id",
      as: "customer_info"
    }
  },
  {
    $unwind: "$customer_info"
  },
  {
    $group: {
      _id: "$customer_info._id",
      customer_name: { $first: "$customer_info.name" },
      total_order_value: { $sum: "$total_value" }
    }
  },
  {
    $project: {
      _id: 0,
      customer_name: 1,
      total_order_value: 1
    }
  }
]);

[
  { customer_name: 'John Doe', total_order_value: 21000 },
  { customer_name: 'Test Doe', total_order_value: 21500 },
  { customer_name: 'Hello Doe', total_order_value: 21000 },
  { customer_name: 'Jane Doe', total_order_value: 20500 },
  { customer_name: 'Mike Doe', total_order_value: 41000 }
]

-- Write a script to group orders by their status (e.g., “shipped”, “delivered”, etc.) and count how many orders are in each status.
assessments> db.orders.aggregate([
  {
    $group: {
      _id: "$status",
      orderCount: { $sum: 1 }
    }
  },
  {
    $project: {
      _id: 0,
      status: "$_id",
      orderCount: 1
    }
  }
]);

[
  { orderCount: 1, status: 'pending' },
  { orderCount: 1, status: 'cancelled' },
  { orderCount: 1, status: 'delivered' },
  { orderCount: 2, status: 'shipped' }
]


-- Write a script to find each customer and their most recent order. Include customer information such as name, email, and order details (e.g., order_id, total_value).
assessments> db.orders.aggregate([
  {
    $sort: { order_date: -1 }
  },
  {
    $group: {
      _id: "$customer_id",
      mostRecentOrder: { $first: "$$ROOT" }
    }
  },
  {
    $lookup: {
      from: "customers",
      localField: "_id",
      foreignField: "_id",
      as: "customer_info"
    }
  },
  {
    $unwind: "$customer_info"
  },
  {
    $project: {
      _id: 0,
      name: "$customer_info.name",
      email: "$customer_info.email",
      order_id: "$mostRecentOrder.order_id",
      total_value: "$mostRecentOrder.total_value",
      order_date: "$mostRecentOrder.order_date"
    }
  }
]);


-- Write a script to find the most expensive order for each customer. Return the customer’s name and the details of their most expensive order (e.g., order_id, total_value).
assessments> db.orders.aggregate([
  {
    $sort: { total_value: -1 }
  },
  {
    $group: {
      _id: "$customer_id",
      mostExpensiveOrder: { $first: "$$ROOT" }
    }
  },
  {
    $lookup: {
      from: "customers",
      localField: "_id",
      foreignField: "_id",
      as: "customer_info"
    }
  },
  {
    $unwind: "$customer_info"
  },
  {
    $project: {
      _id: 0,
      name: "$customer_info.name",
      order_id: "$mostExpensiveOrder.order_id",
      total_value: "$mostExpensiveOrder.total_value"
    }
  }
]);

[
  { name: 'Test Doe', order_id: 'ORD123459', total_value: 21500 },
  { name: 'Jane Doe', order_id: 'ORD123457', total_value: 20500 },
  { name: 'Mike Doe', order_id: 'ORD123458', total_value: 41000 },
  { name: 'Hello Doe', order_id: 'ORD123450', total_value: 21000 },
  { name: 'John Doe', order_id: 'ORD123456', total_value: 21000 }
]



-- Write a script to find all customers who have placed at least one order in the last 30 days. Return the customer name, email, and the order date for their most recent order.
assessments> db.orders.aggregate([
    {
        $match: {order_date: {$gte: new Date(new Date()- 30*24*60*60*1000)}}
    },
    {
        $lookup: {
            from: "customers",
            localField: "customer_id",
            foreignField: "_id",
            as: "customer_info"
        }
    },
    {$unwind: "$customer_info"},
    {
        $group: {
            _id: "$customer_id",
            customer_name: {$first: "$customer_info.name"},
            customer_email: {$first: "$customer_info.email"},
            recent_order_date: {$max: "$order_date"}
        }
    }
]);


[
  {
    _id: ObjectId('6733882e084fa1c460c1c190'),
    customer_name: 'Hello Doe',
    customer_email: 'hellodoe@example.com',
    recent_order_date: ISODate('2024-11-12T17:14:02.471Z')
  },
  {
    _id: ObjectId('6733882e084fa1c460c1c18c'),
    customer_name: 'John Doe',
    customer_email: 'johndoe@example.com',
    recent_order_date: ISODate('2024-11-12T17:14:02.471Z')
  },
  {
    _id: ObjectId('6733882e084fa1c460c1c18d'),
    customer_name: 'Jane Doe',
    customer_email: 'janedoe@example.com',
    recent_order_date: ISODate('2024-11-12T17:14:02.471Z')
  },
  {
    _id: ObjectId('6733882e084fa1c460c1c18e'),
    customer_name: 'Mike Doe',
    customer_email: 'mikedoe@example.com',
    recent_order_date: ISODate('2024-11-12T17:14:02.471Z')
  },
  {
    _id: ObjectId('6733882e084fa1c460c1c18f'),
    customer_name: 'Test Doe',
    customer_email: 'testdoe@example.com',
    recent_order_date: ISODate('2024-11-12T17:14:02.471Z')
  }
]

-- Write a script to find all distinct products ordered by a customer with the name “John Doe”. Include the product name and the total quantity ordered.

assessments> let customer = db.customers.find({name: "John Doe"});

assessments> db.orders.aggregate([
    {
        $match: {customer_id: customer._id}
    }, 
    {
        $lookup:{
            from: "customers",
            localField: "customer_id",
            foreignField: "_id",
            as: "items"
        }
    },
    {$unwind: "$items"},
    {
        $group: {
            _id: "$items.product_name",
            total_quantity: {$sum: "$items.quantity"}
        }
    }
]);


-- Write a script to find the top 3 customers who have spent the most on orders. Sort the results by total order value in descending order.
assessments> db.orders.aggregate([
    {$lookup: {
        from: "customers",
        localField: "customer_id",
        foreignField: "_id",
        as: "customer_info"
    }

    },
    {$unwind: "$customer_info"},
    {
        $group: {
            _id: "$customer_id",
            customer_name: {$first: "$customer_info.name"},
            total_spent: {$sum: "$total_value"}
        }
    },
    {
        $sort: {total_spent: -1}
    },
    {$limit: 3}

]);

[
  {
    _id: ObjectId('6733882e084fa1c460c1c18e'),
    customer_name: 'Mike Doe',
    total_spent: 41000
  },
  {
    _id: ObjectId('6733882e084fa1c460c1c18f'),
    customer_name: 'Test Doe',
    total_spent: 21500
  },
  {
    _id: ObjectId('6733882e084fa1c460c1c190'),
    customer_name: 'Hello Doe',
    total_spent: 21000
  }
]


-- Write a script to add a new order for a customer with the name “Jane Doe”. The order should include at least two items, such as “Smartphone” and “Headphones”.
assessments> const jane = db.customers.findOne({ name: "Jane Doe" });

assessments> jane
{
  _id: ObjectId('6733882e084fa1c460c1c18d'),
  name: 'Jane Doe',
  email: 'janedoe@example.com',
  address: { street: '124 Main St', city: 'HillTown', zipcode: '23135' },
  phone: '555-1236',
  registration_date: ISODate('2024-11-12T16:54:06.602Z')
}

assessments> db.orders.insertOne({
    order_id: "ORD192812",
    customer_id: jane._id,
    order_date: new Date(),
    status: "shipped",
    items: [{product_name: "smartphone", quantity: 1, price: 20000}, {product_name: "Headphones", quantity:1, price: 5000}], 
    total_value: 25000
});


-- Write a script to find all customers who have not placed any orders. Return the customer’s name and email.
db.customers.aggregate([
    {
        $lookup: {
            from: "orders",
            localField: "_id",
            foreignField: "customer_id",
            as: "customer_orders"
        }
    },
    {
        $match: {
            "customer_orders": {$size: 0}
        }
    },
    {
        $project: {
            name: 1,
            email: 1
        }
    }
]);

-- Write a script to calculate the average number of items ordered per order across all orders. The result should return the average number of items.
assessments> db.orders.aggregate([
    {
        $project: {
            num_items: {$size: "$items"}
        }
    },
    {
        $group: {
            _id: null,
            avg_items: {$avg: "$num_items"}
        }
    }
]);

[ { _id: null, avg_items: 2 } ]



-- Write a script using the $lookup aggregation operator to join data from the customers collection and the orders collection. Return customer name, email, order details (order_id, total_value), and order date.
db.customers.aggregate([
    {
        $lookup: {
            from: "orders",
            localField: "_id",
            foreignField: "customer_id",
            as: "orders_info"
        }
    },
    {
        $unwind: "$orders_info"
    },
    {
        $project: {
            name: 1,
            email: 1,
            "orders_info.order_id": 1,
            "orders_info.total_value": 1,
            "orders_info.order_date": 1
        }
    }
]);


