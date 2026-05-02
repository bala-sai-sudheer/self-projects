<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>YourStore Advanced</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        body { margin:0; font-family:Arial; background:#f3f3f3; }

        /* HEADER */
        .header {
            background:#131921; color:white;
            display:flex; align-items:center; padding:10px;
        }
        .logo { color:#ff9900; font-size:22px; font-weight:bold; }
        .search-bar { flex:1; margin:0 20px; display:flex; }
        .search-bar input { flex:1; padding:8px; }
        .cart { font-weight:bold; }

        /* NAV */
        .navbar { background:#232f3e; color:white; padding:10px; }
        .navbar ul { display:flex; gap:20px; list-style:none; margin:0; }
        .navbar li { cursor:pointer; }

        /* HERO + CAROUSEL */
        .carousel {
            position:relative; height:250px;
            overflow:hidden;
        }
        .slide {
            position:absolute;
            width:100%; height:100%;
            display:flex; align-items:center; justify-content:center;
            color:white; font-size:30px;
            transition:opacity 1s;
        }
        .slide1 { background:linear-gradient(#ff9900,#ffcc66); }
        .slide2 { background:linear-gradient(#232f3e,#37475a); }
        .slide3 { background:linear-gradient(#B12704,#ff6f61); }

        /* TIMER */
        .timer { text-align:center; padding:10px; background:#fff3cd; }

        /* PRODUCTS */
        .controls {
            display:flex; justify-content:space-between;
            padding:10px;
        }

        .grid {
            display:grid;
            grid-template-columns:repeat(4,1fr);
            gap:20px; padding:20px;
        }

        .card {
            background:white;
            padding:10px;
            border-radius:8px;
            text-align:center;
            position:relative;
        }

        .badge {
            position:absolute; top:10px; left:10px;
            background:#B12704; color:white; padding:5px;
        }

        .price { color:#B12704; font-weight:bold; }

        .stars { color:#ff9900; }

        button {
            background:#ffd814; border:none;
            padding:8px; width:100%; cursor:pointer;
        }

    </style>
</head>

<body>

<!-- HEADER -->
<div class="header">
    <div class="logo">YourStore</div>
    <div class="search-bar">
        <input placeholder="Search">
    </div>
    <div class="cart">🛒 Cart (<span id="cartCount">0</span>)</div>
</div>

<!-- NAVBAR -->
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

<!-- CAROUSEL -->
<div class="carousel">
    <div class="slide slide1">🔥 Summer Sale - 70% OFF</div>
    <div class="slide slide2">⚡ Electronics Mega Deals</div>
    <div class="slide slide3">👕 Fashion Fest</div>
</div>

<!-- COUNTDOWN -->
<div class="timer">
    Offer ends in: <span id="countdown"></span>
</div>

<!-- CONTROLS -->
<div class="controls">
    <div>
        Sort:
        <select onchange="sortProducts(this.value)">
            <option value="default">Default</option>
            <option value="price">Price</option>
            <option value="rating">Rating</option>
        </select>
    </div>
</div>

<!-- PRODUCTS -->
<div class="grid" id="productGrid"></div>

<script>

let products = [
    {name:"Headphones", price:1999, rating:4.5, category:"Electronics Deals"},
    {name:"Jacket", price:2499, rating:4.2, category:"Fashion Deals"},
    {name:"Kitchen Set", price:1299, rating:4.0, category:"Home"},
    {name:"Book", price:499, rating:4.8, category:"Books"},
    {name:"Toy Car", price:899, rating:4.1, category:"Toys"}
];

let cart = JSON.parse(localStorage.getItem("cart")) || [];

function renderProducts(list) {
    let grid = document.getElementById("productGrid");
    grid.innerHTML = "";

    list.forEach((p, i) => {
        grid.innerHTML += `
        <div class="card" data-category="${p.category}">
            <span class="badge">-${Math.floor(p.rating*10)}%</span>
            <h4>${p.name}</h4>
            <p class="stars">${"⭐".repeat(Math.floor(p.rating))}</p>
            <p class="price">₹${p.price}</p>
            <button onclick="addToCart(${i})">Add to Cart</button>
        </div>`;
    });
}

function addToCart(i) {
    cart.push(products[i]);
    localStorage.setItem("cart", JSON.stringify(cart));
    updateCart();
}

function updateCart() {
    document.getElementById("cartCount").innerText = cart.length;
}

function filterProducts(cat) {
    if(cat==="All") return renderProducts(products);
    renderProducts(products.filter(p => p.category.includes(cat)));
}

function sortProducts(type) {
    let sorted = [...products];
    if(type==="price") sorted.sort((a,b)=>a.price-b.price);
    if(type==="rating") sorted.sort((a,b)=>b.rating-a.rating);
    renderProducts(sorted);
}

/* CAROUSEL */
let slides = document.querySelectorAll(".slide");
let index=0;
setInterval(()=>{
    slides.forEach(s=>s.style.opacity=0);
    slides[index].style.opacity=1;
    index=(index+1)%slides.length;
},3000);

/* COUNTDOWN */
let end = new Date().getTime()+3600000;
setInterval(()=>{
    let now = new Date().getTime();
    let diff = end-now;
    let min = Math.floor(diff/60000);
    let sec = Math.floor((diff%60000)/1000);
    document.getElementById("countdown").innerText = min+"m "+sec+"s";
},1000);

/* INIT */
renderProducts(products);
updateCart();

</script>

</body>
</html>
