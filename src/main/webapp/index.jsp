<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<title>YourStore</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
body { margin:0; font-family:Arial; background:#f5f5f5; }

/* HEADER */
.header {
    background:#131921;
    color:white;
    padding:10px;
    display:flex;
    align-items:center;
}
.logo { color:#ff9900; font-weight:bold; cursor:pointer; }
.search { flex:1; margin:0 15px; }
.search input { width:100%; padding:8px; }

/* NAV */
.nav { background:#232f3e; color:white; padding:10px; }
.nav span { margin-right:15px; cursor:pointer; }

/* HERO */
.hero { background:#fff3cd; text-align:center; padding:15px; }

/* GRID */
.grid {
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:15px;
    padding:15px;
}
.card {
    background:white;
    padding:10px;
    border-radius:6px;
    text-align:center;
}
.price { color:#B12704; font-weight:bold; }
.old { text-decoration:line-through; color:gray; font-size:12px; }
.badge {
    background:red;
    color:white;
    padding:3px;
    font-size:12px;
}

/* FOOTER */
.footer {
    background:#131921;
    color:white;
    text-align:center;
    padding:15px;
}
</style>
</head>

<body>

<div class="header">
    <div class="logo" onclick="loadProducts()">YourStore</div>
    <div class="search">
        <input placeholder="Search products..." onkeyup="search(this.value)">
    </div>
    <div>🛒 <span id="count">0</span></div>
</div>

<div class="nav">
    <span onclick="filter('All')">All</span>
    <span onclick="filter('Electronics')">Electronics</span>
    <span onclick="filter('Fashion')">Fashion</span>
    <span onclick="filter('Home')">Home</span>
    <span onclick="filter('Books')">Books</span>
    <span onclick="filter('Toys')">Toys</span>
</div>

<div class="hero">
    ☀️ Summer Sale - Up to 60% OFF
</div>

<div id="grid" class="grid"></div>

<div class="footer">
    YourStore Pvt Ltd<br>
    support@yourstore.com<br>
    +91 98765 43210
</div>

<script>

/* DATA (STRICT + SAFE) */
var products = [
 {id:1,name:"Headphones",price:1499,old:2999,cat:"Electronics"},
 {id:2,name:"Jacket",price:1999,old:3999,cat:"Fashion"},
 {id:3,name:"Kitchen Set",price:999,old:1999,cat:"Home"},
 {id:4,name:"Book",price:399,old:699,cat:"Books"},
 {id:5,name:"Toy Car",price:699,old:1299,cat:"Toys"}
];

var cart = 0;

/* RENDER FUNCTION (NO TEMPLATE STRINGS) */
function loadProducts(list) {
    var data = list || products;
    var grid = document.getElementById("grid");
    grid.innerHTML = "";

    for (var i = 0; i < data.length; i++) {
        var p = data[i];

        var discount = Math.round((1 - p.price / p.old) * 100);

        var div = document.createElement("div");
        div.className = "card";

        div.innerHTML =
            "<div class='badge'>-" + discount + "%</div>" +
            "<h3>" + p.name + "</h3>" +
            "<p>" + p.cat + "</p>" +
            "<p class='price'>₹" + p.price +
            " <span class='old'>₹" + p.old + "</span></p>" +
            "<button onclick='addCart()'>Add to Cart</button>";

        grid.appendChild(div);
    }
}

/* CART */
function addCart() {
    cart++;
    document.getElementById("count").innerText = cart;
}

/* FILTER */
function filter(cat) {
    if (cat == "All") {
        loadProducts(products);
        return;
    }

    var result = [];
    for (var i = 0; i < products.length; i++) {
        if (products[i].cat == cat) {
            result.push(products[i]);
        }
    }
    loadProducts(result);
}

/* SEARCH */
function search(txt) {
    txt = txt.toLowerCase();
    var result = [];

    for (var i = 0; i < products.length; i++) {
        if (products[i].name.toLowerCase().includes(txt)) {
            result.push(products[i]);
        }
    }
    loadProducts(result);
}

/* INIT */
window.onload = function () {
    loadProducts(products);
};

</script>

</body>
</html>
