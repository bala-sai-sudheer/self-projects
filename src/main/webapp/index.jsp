<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>YourStore</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
body { margin:0; font-family:Arial; background:#f9fafb; }

/* HEADER */
.header {
    background:#131921; color:white;
    display:flex; align-items:center; padding:10px 20px;
}
.logo { color:#ff9900; font-size:22px; font-weight:bold; cursor:pointer; }
.search-bar { flex:1; margin:0 20px; }
.search-bar input { width:100%; padding:8px; }
.cart { position:relative; cursor:pointer; }

/* CART DROPDOWN */
.cart-box {
    position:absolute; right:0; top:30px;
    background:white; color:black;
    width:250px; display:none;
    box-shadow:0 2px 10px rgba(0,0,0,0.2);
    padding:10px;
}

/* NAV */
.navbar { background:#232f3e; color:white; padding:10px; }
.navbar ul { display:flex; gap:20px; list-style:none; margin:0; }

/* HERO */
.hero {
    background:#fff3cd;
    padding:20px;
    text-align:center;
}

/* PRODUCTS */
.grid {
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:20px;
    padding:20px;
}

.card {
    background:white;
    padding:10px;
    border-radius:8px;
    text-align:center;
    position:relative;
}

.card img {
    width:100%;
    height:150px;
    object-fit:cover;
}

.badge {
    position:absolute;
    top:10px;
    left:10px;
    background:#B12704;
    color:white;
    padding:5px;
}

.price { color:#B12704; font-weight:bold; }
.old-price { text-decoration:line-through; color:gray; font-size:12px; }

button {
    margin-top:5px;
    padding:8px;
    border:none;
    cursor:pointer;
}
.cart-btn { background:#ffd814; }
.wishlist-btn { background:#ff4081; color:white; }

/* FOOTER */
.footer {
    background:#131921;
    color:white;
    padding:20px;
    text-align:center;
}
</style>
</head>

<body>

<!-- HEADER -->
<div class="header">
    <div class="logo" onclick="goHome()">YourStore</div>

    <div class="search-bar">
        <input type="text" placeholder="Search products..." onkeyup="searchProducts(this.value)">
    </div>

    <div class="cart" onclick="toggleCart()">
        🛒 Cart (<span id="cartCount">0</span>)
        <div class="cart-box" id="cartBox"></div>
    </div>
</div>

<!-- NAV -->
<div class="navbar">
<ul>
<li onclick="filterProducts('All')">All</li>
<li onclick="filterProducts('Deals')">Today's Deals</li>
<li onclick="filterProducts('Electronics')">Electronics</li>
<li onclick="filterProducts('Fashion')">Fashion</li>
<li onclick="filterProducts('Home')">Home</li>
<li onclick="filterProducts('Books')">Books</li>
<li onclick="filterProducts('Toys')">Toys</li>
</ul>
</div>

<!-- HERO -->
<div class="hero">
    <h2>☀️ Summer Sale</h2>
    <p>Up to 60% OFF on selected items</p>
</div>

<!-- PRODUCTS -->
<div class="grid" id="productGrid"></div>

<!-- FOOTER -->
<div class="footer">
    <p><b>YourStore Pvt Ltd</b></p>
    <p>Email: support@yourstore.com</p>
    <p>Phone: +91 98765 43210</p>
    <p>© 2026 YourStore. All rights reserved.</p>
</div>

<script>

/* PRODUCTS DATA */
let products = [
{ id:1, name:"Boat Headphones", price:1499, old:2999, rating:4, category:"Electronics Deals", img:"https://picsum.photos/200?1" },
{ id:2, name:"Men Jacket", price:1999, old:3999, rating:4, category:"Fashion Deals", img:"https://picsum.photos/200?2" },
{ id:3, name:"Kitchen Set", price:999, old:1999, rating:3, category:"Home", img:"https://picsum.photos/200?3" },
{ id:4, name:"Atomic Habits", price:399, old:699, rating:5, category:"Books", img:"https://picsum.photos/200?4" },
{ id:5, name:"Toy Car", price:699, old:1299, rating:4, category:"Toys", img:"https://picsum.photos/200?5" }
];

let cart = JSON.parse(localStorage.getItem("cart")) || [];
let wishlist = JSON.parse(localStorage.getItem("wishlist")) || [];

/* RENDER */
function renderProducts(list) {
    let grid = document.getElementById("productGrid");
    grid.innerHTML = "";

    list.forEach(p => {
        let discount = Math.round((1 - p.price/p.old) * 100);

        grid.innerHTML += `
        <div class="card">
            <span class="badge">-${discount}%</span>
            <img src="${p.img}">
            <h4>${p.name}</h4>
            <p>${p.category}</p>
            <p class="price">₹${p.price} <span class="old-price">₹${p.old}</span></p>
            <p>${"⭐".repeat(p.rating)}</p>

            <button class="cart-btn" onclick="addToCart(${p.id})">Add to Cart</button>
            <button class="wishlist-btn" onclick="addToWishlist(${p.id})">❤ Wishlist</button>
        </div>`;
    });
}

/* CART */
function addToCart(id) {
    let item = cart.find(p => p.id === id);
    if(item) item.qty++;
    else {
        let product = products.find(p => p.id === id);
        cart.push({...product, qty:1});
    }
    localStorage.setItem("cart", JSON.stringify(cart));
    updateCart();
}

function updateCart() {
    let total = cart.reduce((sum,p)=>sum+p.qty,0);
    document.getElementById("cartCount").innerText = total;

    let box = document.getElementById("cartBox");
    box.innerHTML = cart.map(p=>`${p.name} x${p.qty}`).join("<br>");
}

function toggleCart() {
    let box = document.getElementById("cartBox");
    box.style.display = box.style.display === "block" ? "none" : "block";
}

/* WISHLIST */
function addToWishlist(id) {
    if(!wishlist.includes(id)) wishlist.push(id);
    localStorage.setItem("wishlist", JSON.stringify(wishlist));
    alert("Added to Wishlist");
}

/* FILTER */
function filterProducts(cat) {
    if(cat==="All") renderProducts(products);
    else renderProducts(products.filter(p=>p.category.includes(cat)));
}

/* SEARCH */
function searchProducts(text) {
    text = text.toLowerCase();
    renderProducts(products.filter(p=>p.name.toLowerCase().includes(text)));
}

/* HOME RESET */
function goHome() {
    renderProducts(products);
}

/* INIT */
renderProducts(products);
updateCart();

</script>

</body>
</html>
