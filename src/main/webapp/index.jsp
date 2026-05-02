<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<title>YourStore</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
body { margin:0; font-family:'Segoe UI'; background:#eaeded; }

/* HEADER */
.header {
    background:#131921;
    color:white;
    padding:10px 20px;
    display:flex;
    align-items:center;
}
.logo { color:#ff9900; font-size:22px; font-weight:bold; cursor:pointer; }
.search { flex:1; margin:0 20px; }
.search input { width:100%; padding:10px; border:none; border-radius:5px; }

.cart { position:relative; cursor:pointer; }

/* CART DROPDOWN */
.cart-box {
    position:absolute;
    right:0;
    top:30px;
    background:white;
    color:black;
    width:250px;
    display:none;
    padding:10px;
    box-shadow:0 2px 10px rgba(0,0,0,0.3);
}

/* NAV */
.nav { background:#232f3e; color:white; padding:10px 20px; }
.nav span { margin-right:20px; cursor:pointer; }

/* HERO */
.hero {
    background:linear-gradient(to right,#ff9900,#ffcc66);
    text-align:center;
    padding:20px;
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
    position:relative;
    transition:0.3s;
}
.card:hover { transform:translateY(-5px); }

.card img {
    width:100%;
    height:150px;
    object-fit:cover;
    border-radius:8px;
}

.badge {
    position:absolute;
    top:10px;
    left:10px;
    background:#cc0c39;
    color:white;
    padding:5px;
    font-size:12px;
}

.price { color:#B12704; font-weight:bold; }
.old { text-decoration:line-through; color:gray; font-size:12px; }

.stars { color:#ff9900; }

.card button {
    margin-top:5px;
    width:100%;
    padding:8px;
    border:none;
    border-radius:5px;
    cursor:pointer;
}
.cart-btn { background:#ffd814; }
.wish-btn { background:#ff4081; color:white; }

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
        <input placeholder="Search..." onkeyup="search(this.value)">
    </div>

    <div class="cart" onclick="toggleCart()">
        🛒 <span id="count">0</span>
        <div class="cart-box" id="cartBox"></div>
    </div>
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
<div class="hero">☀️ Summer Sale - Up to 60% OFF</div>

<!-- PRODUCTS -->
<div id="grid" class="grid"></div>

<!-- FOOTER -->
<div class="footer">
YourStore Pvt Ltd<br>
support@yourstore.com<br>
+91 98765 43210
</div>

<script>

/* DATA */
var products = [
{id:1,name:"Headphones",price:1499,old:2999,cat:"Electronics",rating:4},
{id:2,name:"Jacket",price:1999,old:3999,cat:"Fashion",rating:4},
{id:3,name:"Kitchen Set",price:999,old:1999,cat:"Home",rating:3},
{id:4,name:"Book",price:399,old:699,cat:"Books",rating:5},
{id:5,name:"Toy Car",price:699,old:1299,cat:"Toys",rating:4}
];

/* CART + STORAGE */
var cart = JSON.parse(localStorage.getItem("cart")) || [];
var wishlist = [];

/* RENDER */
function loadProducts(list) {
    var data = list || products;
    var grid = document.getElementById("grid");
    grid.innerHTML = "";

    data.forEach(function(p) {
        var discount = Math.round((1 - p.price/p.old)*100);

        var stars = "⭐".repeat(p.rating);

        var div = document.createElement("div");
        div.className = "card";

        div.innerHTML =
            "<div class='badge'>-"+discount+"%</div>" +
            "<img src='https://source.unsplash.com/300x200/?"+p.name+"'>" +
            "<h3>"+p.name+"</h3>" +
            "<p>"+p.cat+"</p>" +
            "<p class='price'>₹"+p.price+" <span class='old'>₹"+p.old+"</span></p>" +
            "<p class='stars'>"+stars+"</p>" +
            "<button class='cart-btn' onclick='addCart("+p.id+")'>Add to Cart</button>" +
            "<button class='wish-btn' onclick='addWish("+p.id+")'>❤ Wishlist</button>";

        grid.appendChild(div);
    });
}

/* CART */
function addCart(id) {
    var item = cart.find(p => p.id === id);

    if(item) item.qty++;
    else {
        var product = products.find(p => p.id === id);
        cart.push({...product, qty:1});
    }

    localStorage.setItem("cart", JSON.stringify(cart));
    updateCart();
}

/* UPDATE CART */
function updateCart() {
    var total = 0;
    var box = document.getElementById("cartBox");
    box.innerHTML = "";

    cart.forEach(p => {
        total += p.qty;
        box.innerHTML += p.name + " x" + p.qty + "<br>";
    });

    document.getElementById("count").innerText = total;
}

/* CART TOGGLE */
function toggleCart() {
    var box = document.getElementById("cartBox");
    box.style.display = box.style.display === "block" ? "none" : "block";
}

/* WISHLIST */
function addWish(id) {
    if(!wishlist.includes(id)) {
        wishlist.push(id);
        alert("Added to Wishlist");
    }
}

/* FILTER */
function filter(cat) {
    if(cat==="All") loadProducts(products);
    else loadProducts(products.filter(p=>p.cat===cat));
}

/* SEARCH */
function search(txt) {
    txt = txt.toLowerCase();
    loadProducts(products.filter(p=>p.name.toLowerCase().includes(txt)));
}

/* INIT */
window.onload = function() {
    loadProducts(products);
    updateCart();
};

</script>

</body>
</html>
