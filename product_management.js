const jsonData = `[
    {"id": 1, "name": "Laptop", "category": "Electronics", "price": 1200, "available": true},
    {"id": 2, "name": "Chair", "category": "Furniture", "price": 200, "available": false},
    {"id": 3, "name": "Smartphone", "category": "Electronics", "price": 800, "available": true}
]`;

function parseJSONData(data) {
    try {
        return JSON.parse(data);
    } catch (error) {
        console.error("Invalid JSON data:", error);
        return [];
    }
}

let products = parseJSONData(jsonData);

function addProduct(newProduct) {
    products.push(newProduct);
    console.log("Product added successfully:", newProduct);
}


function updateProductPrice(productId, newPrice) {
    const product = products.find(p => p.id === productId);
    if (product) {
        product.price = newPrice;
        console.log(`Price of product with ID ${productId} updated to ${newPrice}`);
    } else {
        console.log(`Product with ID ${productId} not found.`);
    }
}

function getAvailableProducts() {
    return products.filter(p=> p.available ===true);

    // return products.filter(product => product.available);
}


function getProductsByCategory(category) {
    return products.filter(product => product.category === category);
}


function viewAllProducts() {
    console.log("All products:", products);
}


viewAllProducts();
addProduct({ id: 5, name: "Bookshelf", category: "Furniture", price: 150, available: true });
updateProductPrice(1, 1100);
console.log("Available products:", getAvailableProducts());
console.log("Furniture products:", getProductsByCategory("Furniture"));
viewAllProducts();
