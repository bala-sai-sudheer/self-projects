<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<title>YourStore</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
*{box-sizing:border-box}
body { margin:0; font-family:Arial, Helvetica, sans-serif; background:#f6f7fb; }

/* HEADER */
.header {
    background:#131921; color:white;
    display:flex; align-items:center; gap:16px;
    padding:10px 16px; position:sticky; top:0; z-index:10;
}
.logo { color:#ff9900; font-size:22px; font-weight:700; cursor:pointer; }
.search-bar { flex:1; }
.search-bar input {
    width:100%; padding:10px 12px; border-radius:6px; border:none;
}
.cart { position:relative; cursor:pointer; user-select:none; }

/* CART DROPDOWN */
.cart-box {
    position:absolute; right:0; top:34px;
    background:white; color:#111;
    width:260px; display:none;
    box-shadow:0 8px 24px rgba(0,0,0,0.2);
    border-radius:8px; padding:10px;
}
.cart-item { display:flex; justify-content:space-between; margin:6px 0; font-size:14px; }
.cart-empty { color:#777; font-size:14px; }

/* NAV */
.navbar { background:#232f3e; color:white; padding:10px 16px; }
.navbar ul { display:flex; gap:20px; list-style:none; margin:0; padding:0; }
.navbar li { cursor:pointer; }
.navbar li:hover { text-decoration:underline; }

/* HERO */
.hero {
    background:#fff3cd; color:#111;
    padding:20px; text-align:center; border-bottom:1px solid #f1e1a6;
}
.hero h2 { margin:0 0 6px 0; }

/* CONTROLS */
.controls {
    display:flex; justify-content:space-between; align-items:center;
    padding:10px 16px;
}
.controls select {
    padding:6px 8px; border-radius:6px; border:1px solid #ddd;
}

/* PRODUCTS */
.grid {
    display:grid;
    grid-template-columns:repeat(4, minmax(0,1fr));
    gap:18px;
    padding:16px;
}
@media (max-width: 1000px){
  .grid{ grid-template-columns:repeat(2,1fr); }
}
@media (max-width: 520px){
  .grid{ grid-template-columns:1fr; }
}

.card {
    background:white;
    padding:12px;
    border-radius:12px;
    text-align:left;
    position:relative;
    box-shadow:0 6px 18px rgba(0,0,0,0.08);
}
.card img {
    width:100%;
    height:160px;
    object-fit:cover;
    border-radius:8px;
}
.badge {
    position:absolute;
    top:12px; left:12px;
    background:#B12704;
    color:white;
    padding:4px 6px;
    font-size:12px;
    border-radius:4px;
}
.title { font-weight:600; margin:8px 0 4px 0; }
.category { color:#555; font-size:12px; margin-bottom:6px; }
.price { color:#B12704; font-weight:700; }
.old-price { text-decoration:line-through; color:#888; font-size:12px; margin-left:6px; }
.stars { color:#ff9900; font-size:14px; margin:6px 0; }

.btn-row { display:flex; gap:8px; margin-top:8px; }
button {
    flex:1;
    padding:8px;
    border:none;
    border-radius:6px;
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
.footer p { margin:6px 0; }
</style>
</head>

<body>

<!-- HEADER -->
<div class="header">
    <div class="logo" onclick="goHome()">YourStore</div>

    <div class="search-bar">
        <input id="searchInput" type="text" placeholder="Search products..." oninput="searchProducts(this.value)">
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

<!-- CONTROLS -->
<div class="controls">
  <div></div>
  <div>
    Sort:
    <select onchange="sortProducts(this.value)">
      <option value="default">Default</option>
      <option value="price">Price (Low → High)</option>
      <option value="rating">Rating (High → Low)</option>
    </select>
  </div>
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
/* ---------- DATA MODEL (no blanks) ---------- */
const products = [
 {id:1, name:"boAt Rockerz Headphones", price:1499, old:2999, rating:4, category:"Electronics Deals", img:"https://picsum.photos/seed/p1/400/300"},
 {id:2, name:"Men's Winter Jacket", price:1999, old:3999, rating:4, category:"Fashion Deals", img:"https://picsum.photos/seed/p2/400/300"},
 {id:3, name:"Non-stick Kitchen Set", price:999, old:1999, rating:3, category:"Home", img:"https://picsum.photos/seed/p3/400/300"},
 {id:4, name:"Atomic Habits (Book)", price:399, old:699, rating:5, category:"Books", img:"https://picsum.photos/seed/p4/400/300"},
 {id:5, name:"Remote Toy Car", price:699, old:1299, rating:4, category:"Toys", img:"https://picsum.photos/seed/p5/400/300"},
 {id:6, name:"Bluetooth Speaker", price:1299, old:2499, rating:4, category:"Electronics", img:"https://picsum.photos/seed/p6/400/300"},
 {id:7, name:"Women's Kurti", price:899, old:1799, rating:4, category:"Fashion", img:"https://picsum.photos/seed/p7/400/300"},
 {id:8, name:"LED Desk Lamp", price:599, old:1199, rating:3, category:"Home Deals", img:"https://picsum.photos/seed/p8/400/300"}
];

let currentList = [...products];
let cart = JSON.parse(localStorage.getItem("cart") || "[]");
let wishlist = JSON.parse(localStorage.getItem("wishlist") || "[]");

/* ---------- RENDER ---------- */
function renderProducts(list){
  const grid = document.getElementById("productGrid");
  grid.innerHTML = "";

  list.forEach(p=>{
    const discount = Math.round((1 - (p.price / p.old)) * 100);
    const stars = "⭐".repeat(p.rating);

    const el = document.createElement("div");
    el.className = "card";
    el.innerHTML = `
      <span class="badge">-${discount}%</span>
      <img src="${p.img}" alt="${p.name}">
      <div class="title">${p.name}</div>
      <div class="category">${p.category}</div>
      <div>
        <span class="price">₹${p.price}</span>
        <span class="old-price">₹${p.old}</span>
      </div>
      <div class="stars">${stars}</div>
      <div class="btn-row">
        <button class="cart-btn" onclick="addToCart(${p.id})">Add to Cart</button>
        <button class="wishlist-btn" onclick="addToWishlist(${p.id})">❤</button>
      </div>
    `;
    grid.appendChild(el);
  });
}

/* ---------- CART (with qty + persistence) ---------- */
function addToCart(id){
  const found = cart.find(i=>i.id===id);
  if(found){ found.qty += 1; }
  else{
    const p = products.find(x=>x.id===id);
    cart.push({...p, qty:1});
  }
  localStorage.setItem("cart", JSON.stringify(cart));
  updateCartUI();
}

function updateCartUI(){
  const count = cart.reduce((s,i)=>s+i.qty,0);
  document.getElementById("cartCount").textContent = count;

  const box = document.getElementById("cartBox");
  if(cart.length === 0){
    box.innerHTML = `<div class="cart-empty">Cart is empty</div>`;
    return;
  }
  box.innerHTML = cart.map(i=>`
    <div class="cart-item">
      <span>${i.name}</span>
      <span>x${i.qty}</span>
    </div>
  `).join("");
}

function toggleCart(){
  const box = document.getElementById("cartBox");
  box.style.display = (box.style.display === "block") ? "none" : "block";
}

/* ---------- WISHLIST ---------- */
function addToWishlist(id){
  if(!wishlist.includes(id)) wishlist.push(id);
  localStorage.setItem("wishlist", JSON.stringify(wishlist));
  alert("Added to Wishlist");
}

/* ---------- FILTER / SEARCH / SORT ---------- */
function filterProducts(cat){
  if(cat === "All"){
    currentList = [...products];
  } else {
    currentList = products.filter(p => p.category.includes(cat));
  }
  renderProducts(currentList);
}

function searchProducts(text){
  const t = text.toLowerCase();
  const filtered = currentList.filter(p =>
    p.name.toLowerCase().includes(t) || p.category.toLowerCase().includes(t)
  );
  renderProducts(filtered);
}

function sortProducts(type){
  let arr = [...currentList];
  if(type === "price") arr.sort((a,b)=>a.price - b.price);
  else if(type === "rating") arr.sort((a,b)=>b.rating - a.rating);
  renderProducts(arr);
}

/* ---------- HOME ---------- */
function goHome(){
  document.getElementById("searchInput").value = "";
  currentList = [...products];
  renderProducts(currentList);
}

/* ---------- INIT ---------- */
renderProducts(currentList);
updateCartUI();
</script>

</body>
</html>
