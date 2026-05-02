<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<title>YourStore</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
body {
    margin:0;
    font-family: 'Segoe UI', Arial;
    background:#eaeded;
}

/* HEADER */
.header {
    background:#131921;
    color:white;
    padding:10px 20px;
    display:flex;
    align-items:center;
}
.logo {
    color:#ff9900;
    font-size:22px;
    font-weight:bold;
    cursor:pointer;
}
.search { flex:1; margin:0 20px; }
.search input {
    width:100%;
    padding:10px;
    border-radius:5px;
    border:none;
}

/* NAV */
.nav {
    background:#232f3e;
    color:white;
    padding:10px 20px;
}
.nav span {
    margin-right:20px;
    cursor:pointer;
    font-size:14px;
}
.nav span:hover {
    text-decoration:underline;
}

/* HERO */
.hero {
    background:linear-gradient(to right,#ff9900,#ffcc66);
    text-align:center;
    padding:20px;
    font-weight:bold;
}

/* GRID */
.grid {
    display:grid;
    grid-template-columns:repeat(auto-fit, minmax(220px,1fr));
    gap:20px;
    padding:20px;
}

/* CARD */
.card {
    background:white;
    padding:15px;
    border-radius:10px;
    box-shadow:0 2px 10px rgba(0,0,0,0.1);
    transition:0.3s;
    position:relative;
}
.card:hover {
    transform:translateY(-5px);
}

/* IMAGE */
.card img {
    width:100%;
    height:150px;
    object-fit:cover;
    border-radius:8px;
}

/* BADGE */
.badge {
    position:absolute;
    top:10px;
    left:10px;
    background:#cc0c39;
    color:white;
    padding:5px;
    font-size:12px;
    border-radius:4px;
}

/* TEXT */
.card h3 {
    margin:10px 0 5px;
}
.card p {
    margin:3px 0;
    font-size:14px;
}

/* PRICE */
.price {
    color:#B12704;
    font-weight:bold;
    font-size:16px;
}
.old {
    text-decoration:line-through;
    color:gray;
    font-size:12px;
}

/* BUTTON */
.card button {
    margin-top:10px;
    width:100%;
    padding:8px;
    background:#ffd814;
    border:none;
    border-radius:5px;
    cursor:pointer;
}
.card button:hover {
    background:#f7ca00;
}

/* FOOTER */
.footer {
    background:#131921;
    color:white;
    text-align:center;
    padding:20px;
}
</style>
</head>

<body>

<!-- HEADER -->
<div class="header">
    <div class="logo" onclick="loadProducts()">YourStore</div>
    <div class="search">
        <input placeholder="Search products..." onkeyup="search(this.value)">
    </div>
    <div>🛒 <span id="count">0</span></div>
</div>

<!-- NAV -->
<div class="nav">
    <span onclick="filter('All')">All</span>
    <span onclick="filter('Electronics')">Electronics</span>
    <span onclick="filter('Fashion')">Fashion</span>
    <span onclick="filter('Home')">Home</span>
    <span onclick="filter('Books')">Books</span>
    <span onclick="filter('Toys')">Toys</span>
</div>

<!-- HERO -->
<div class="hero">
    ☀️ Summer Sale - Up to 60% OFF
</div>

<!-- PRODUCTS -->
<div id="grid" class="grid"></div>

<!-- FOOTER -->
<div class="footer">
    YourStore Pvt Ltd<br>
    support@yourstore.com<br>
    +91 98765 43210
</div>

<script>

/* PRODUCT DATA */
var products = [
 {id:1,name:"Headphones",price:1499,old:2999,cat:"Electronics"},
 {id:2,name:"Bluetooth Speaker",price:1299,old:2499,cat:"Electronics"},
 {id:3,name:"Smart Watch",price:1999,old:3999,cat:"Electronics"},
 {id:4,name:"Jacket",price:1999,old:3999,cat:"Fashion"},
 {id:5,name:"Shoes",price:1799,old:3499,cat:"Fashion"},
 {id:6,name:"Kitchen Set",price:999,old:1999,cat:"Home"},
 {id:7,name:"Table Lamp",price:599,old:1199,cat:"Home"},
 {id:8,name:"Book",price:399,old:699,cat:"Books"},
 {id:9,name:"Notebook",price:299,old:599,cat:"Books"},
 {id:10,name:"Toy Car",price:699,old:1299,cat:"Toys"}
];

var cart = 0;

/* RENDER */
function loadProducts(list) {
    var data = list || products;
    var grid = document.getElementById("grid");
    grid.innerHTML = "";

    data.forEach(function(p) {

        var discount = Math.round((1 - p.price/p.old)*100);

        var div = document.createElement("div");
        div.className = "card";

        div.innerHTML =
            "<div class='badge'>-" + discount + "%</div>" +
            "<img src='https://source.unsplash.com/300x200/?" + p.name + "'>" +
            "<h3>" + p.name + "</h3>" +
            "<p>" + p.cat + "</p>" +
            "<p class='price'>₹" + p.price +
            " <span class='old'>₹" + p.old + "</span></p>" +
            "<button onclick='addCart()'>Add to Cart</button>";

        grid.appendChild(div);
    });
}

/* CART */
function addCart() {
    cart++;
    document.getElementById("count").innerText = cart;
}

/* FILTER */
function filter(cat) {
    if (cat === "All") {
        loadProducts(products);
    } else {
        loadProducts(products.filter(p => p.cat === cat));
    }
}

/* SEARCH */
function search(txt) {
    txt = txt.toLowerCase();
    loadProducts(products.filter(p =>
        p.name.toLowerCase().includes(txt)
    ));
}

/* INIT */
window.onload = function () {
    loadProducts(products);
};

</script>

</body>
</html>
