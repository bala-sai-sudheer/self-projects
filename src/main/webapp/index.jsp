<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>YourStore</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">

<style>
/* ============================================================
   RESET & VARIABLES
============================================================ */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

:root {
  --bg:        #0d0d0d;
  --surface:   #161616;
  --surface2:  #1e1e1e;
  --border:    #2a2a2a;
  --accent:    #f5a623;
  --accent2:   #ff4d4d;
  --text:      #f0f0f0;
  --muted:     #888;
  --radius:    14px;
  --font-head: 'Syne', sans-serif;
  --font-body: 'DM Sans', sans-serif;
  --transition: 0.25s cubic-bezier(0.4,0,0.2,1);
}

html { scroll-behavior: smooth; }

body {
  font-family: var(--font-body);
  background: var(--bg);
  color: var(--text);
  min-height: 100vh;
}

/* ============================================================
   HEADER
============================================================ */
.header {
  position: sticky;
  top: 0;
  z-index: 100;
  background: rgba(13,13,13,0.9);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  border-bottom: 1px solid var(--border);
  padding: 14px 28px;
  display: flex;
  align-items: center;
  gap: 20px;
}

.logo {
  font-family: var(--font-head);
  font-size: 22px;
  font-weight: 800;
  color: var(--accent);
  cursor: pointer;
  letter-spacing: -0.5px;
  white-space: nowrap;
  transition: opacity var(--transition);
}
.logo:hover { opacity: 0.8; }

.search-wrap {
  flex: 1;
  position: relative;
  max-width: 520px;
}
.search-wrap input {
  width: 100%;
  background: var(--surface2);
  border: 1px solid var(--border);
  color: var(--text);
  padding: 10px 16px 10px 42px;
  border-radius: 999px;
  font-family: var(--font-body);
  font-size: 14px;
  outline: none;
  transition: border-color var(--transition), box-shadow var(--transition);
}
.search-wrap input::placeholder { color: var(--muted); }
.search-wrap input:focus {
  border-color: var(--accent);
  box-shadow: 0 0 0 3px rgba(245,166,35,0.12);
}
.search-icon {
  position: absolute;
  left: 14px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--muted);
  font-size: 15px;
  pointer-events: none;
}

/* Cart button */
.cart-btn {
  position: relative;
  background: var(--surface2);
  border: 1px solid var(--border);
  color: var(--text);
  font-size: 20px;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background var(--transition), border-color var(--transition);
  flex-shrink: 0;
}
.cart-btn:hover { background: var(--surface); border-color: var(--accent); }

.cart-badge {
  position: absolute;
  top: -4px;
  right: -4px;
  background: var(--accent2);
  color: white;
  font-size: 10px;
  font-weight: 700;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  line-height: 1;
  transition: transform 0.2s;
  display: none;
}
.cart-badge.visible { display: flex; }
.cart-badge.bump {
  animation: bump 0.3s cubic-bezier(0.36, 0.07, 0.19, 0.97);
}
@keyframes bump {
  0%,100% { transform: scale(1); }
  40%      { transform: scale(1.5); }
}

/* ============================================================
   NAV / FILTERS
============================================================ */
.nav {
  background: var(--surface);
  border-bottom: 1px solid var(--border);
  padding: 0 28px;
  display: flex;
  gap: 4px;
  overflow-x: auto;
  scrollbar-width: none;
}
.nav::-webkit-scrollbar { display: none; }

.nav-item {
  background: none;
  border: none;
  color: var(--muted);
  font-family: var(--font-body);
  font-size: 13px;
  font-weight: 500;
  padding: 14px 16px;
  cursor: pointer;
  white-space: nowrap;
  border-bottom: 2px solid transparent;
  transition: color var(--transition), border-color var(--transition);
}
.nav-item:hover { color: var(--text); }
.nav-item.active {
  color: var(--accent);
  border-bottom-color: var(--accent);
}

/* ============================================================
   HERO
============================================================ */
.hero {
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, #1a0a00 0%, #2c1500 50%, #0d0d0d 100%);
  padding: 52px 28px;
  text-align: center;
}
.hero::before {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse 60% 80% at 50% 50%, rgba(245,166,35,0.15) 0%, transparent 70%);
}
.hero-tag {
  display: inline-block;
  background: rgba(245,166,35,0.15);
  border: 1px solid rgba(245,166,35,0.3);
  color: var(--accent);
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 2px;
  text-transform: uppercase;
  padding: 5px 14px;
  border-radius: 999px;
  margin-bottom: 16px;
  position: relative;
}
.hero h1 {
  font-family: var(--font-head);
  font-size: clamp(28px, 5vw, 52px);
  font-weight: 800;
  line-height: 1.1;
  position: relative;
}
.hero h1 span { color: var(--accent); }
.hero p {
  color: var(--muted);
  margin-top: 12px;
  font-size: 15px;
  position: relative;
}

/* ============================================================
   TOOLBAR (count + sort)
============================================================ */
.toolbar {
  padding: 16px 28px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}
.result-count {
  font-size: 13px;
  color: var(--muted);
}
.result-count strong { color: var(--text); }

.sort-select {
  background: var(--surface2);
  border: 1px solid var(--border);
  color: var(--text);
  font-family: var(--font-body);
  font-size: 13px;
  padding: 7px 12px;
  border-radius: 8px;
  outline: none;
  cursor: pointer;
}

/* ============================================================
   PRODUCT GRID
============================================================ */
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(230px, 1fr));
  gap: 20px;
  padding: 0 28px 40px;
}

/* ============================================================
   PRODUCT CARD
============================================================ */
.card {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  transition: transform var(--transition), border-color var(--transition), box-shadow var(--transition);
  animation: fadeUp 0.4s both;
}
.card:hover {
  transform: translateY(-6px);
  border-color: #3a3a3a;
  box-shadow: 0 20px 40px rgba(0,0,0,0.4);
}
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0);    }
}

/* stagger */
.card:nth-child(1)  { animation-delay: 0.02s; }
.card:nth-child(2)  { animation-delay: 0.05s; }
.card:nth-child(3)  { animation-delay: 0.08s; }
.card:nth-child(4)  { animation-delay: 0.11s; }
.card:nth-child(5)  { animation-delay: 0.14s; }
.card:nth-child(6)  { animation-delay: 0.17s; }
.card:nth-child(7)  { animation-delay: 0.20s; }
.card:nth-child(8)  { animation-delay: 0.23s; }
.card:nth-child(9)  { animation-delay: 0.26s; }
.card:nth-child(10) { animation-delay: 0.29s; }

.card-img-wrap {
  position: relative;
  overflow: hidden;
  height: 170px;
  background: var(--surface2);
}
.card-img-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s var(--transition);
  display: block;
}
.card:hover .card-img-wrap img { transform: scale(1.07); }

/* placeholder shown while image loads */
.img-placeholder {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 40px;
  color: var(--border);
  background: var(--surface2);
}

.badge {
  position: absolute;
  top: 10px;
  left: 10px;
  background: var(--accent2);
  color: white;
  font-size: 11px;
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 6px;
  letter-spacing: 0.5px;
}

.wishlist-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background: rgba(0,0,0,0.5);
  border: none;
  color: var(--muted);
  font-size: 14px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background var(--transition), color var(--transition);
  backdrop-filter: blur(6px);
}
.wishlist-btn:hover,
.wishlist-btn.active { color: #ff4d4d; background: rgba(255,77,77,0.15); }

/* Card body */
.card-body {
  padding: 14px 16px;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.cat-label {
  font-size: 11px;
  color: var(--accent);
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1px;
}
.card-title {
  font-family: var(--font-head);
  font-size: 15px;
  font-weight: 700;
  color: var(--text);
  line-height: 1.3;
}
.rating {
  font-size: 12px;
  color: var(--accent);
}
.rating span { color: var(--muted); margin-left: 4px; }

.price-row {
  display: flex;
  align-items: baseline;
  gap: 8px;
  margin-top: 4px;
}
.price {
  font-family: var(--font-head);
  font-size: 18px;
  font-weight: 700;
  color: var(--text);
}
.price-old {
  font-size: 13px;
  color: var(--muted);
  text-decoration: line-through;
}
.savings {
  font-size: 12px;
  color: #4caf50;
  font-weight: 500;
}

.card-footer {
  padding: 0 16px 16px;
}
.add-btn {
  width: 100%;
  padding: 10px;
  background: var(--accent);
  border: none;
  border-radius: 8px;
  color: #000;
  font-family: var(--font-head);
  font-size: 13px;
  font-weight: 700;
  cursor: pointer;
  letter-spacing: 0.3px;
  transition: background var(--transition), transform 0.15s;
}
.add-btn:hover  { background: #f0a020; }
.add-btn:active { transform: scale(0.97); }
.add-btn.added  { background: #222; color: var(--accent); border: 1px solid var(--accent); }

/* ============================================================
   EMPTY STATE
============================================================ */
.empty {
  grid-column: 1 / -1;
  text-align: center;
  padding: 80px 20px;
  color: var(--muted);
}
.empty .empty-icon { font-size: 52px; margin-bottom: 16px; }
.empty h2 { font-family: var(--font-head); color: var(--text); margin-bottom: 8px; }

/* ============================================================
   CART DRAWER
============================================================ */
.drawer-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.6);
  z-index: 200;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s;
  backdrop-filter: blur(4px);
}
.drawer-overlay.open { opacity: 1; pointer-events: all; }

.drawer {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  width: min(400px, 100vw);
  background: var(--surface);
  border-left: 1px solid var(--border);
  z-index: 201;
  display: flex;
  flex-direction: column;
  transform: translateX(100%);
  transition: transform 0.35s cubic-bezier(0.4,0,0.2,1);
}
.drawer.open { transform: translateX(0); }

.drawer-header {
  padding: 20px 24px;
  border-bottom: 1px solid var(--border);
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.drawer-header h2 {
  font-family: var(--font-head);
  font-size: 18px;
  font-weight: 700;
}
.close-btn {
  background: var(--surface2);
  border: 1px solid var(--border);
  color: var(--text);
  width: 32px;
  height: 32px;
  border-radius: 8px;
  cursor: pointer;
  font-size: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background var(--transition);
}
.close-btn:hover { background: var(--bg); }

.drawer-items {
  flex: 1;
  overflow-y: auto;
  padding: 16px 24px;
  display: flex;
  flex-direction: column;
  gap: 14px;
}
.drawer-items::-webkit-scrollbar { width: 4px; }
.drawer-items::-webkit-scrollbar-track { background: transparent; }
.drawer-items::-webkit-scrollbar-thumb { background: var(--border); border-radius: 4px; }

.cart-item {
  background: var(--surface2);
  border: 1px solid var(--border);
  border-radius: 10px;
  padding: 12px;
  display: flex;
  gap: 12px;
  align-items: center;
}
.cart-item-info { flex: 1; }
.cart-item-name {
  font-weight: 600;
  font-size: 14px;
  margin-bottom: 4px;
}
.cart-item-price {
  color: var(--accent);
  font-size: 14px;
  font-weight: 700;
}
.qty-controls {
  display: flex;
  align-items: center;
  gap: 8px;
}
.qty-btn {
  width: 26px;
  height: 26px;
  border-radius: 6px;
  background: var(--border);
  border: none;
  color: var(--text);
  font-size: 15px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background var(--transition);
  line-height: 1;
}
.qty-btn:hover { background: var(--accent); color: #000; }
.qty-num { font-size: 14px; font-weight: 600; min-width: 20px; text-align: center; }

.cart-empty-msg {
  text-align: center;
  color: var(--muted);
  margin-top: 60px;
}
.cart-empty-msg .ci { font-size: 48px; margin-bottom: 12px; }

.drawer-footer {
  border-top: 1px solid var(--border);
  padding: 20px 24px;
}
.total-row {
  display: flex;
  justify-content: space-between;
  font-size: 15px;
  margin-bottom: 6px;
  color: var(--muted);
}
.total-row.grand {
  font-family: var(--font-head);
  font-weight: 700;
  font-size: 20px;
  color: var(--text);
  margin-bottom: 16px;
}
.checkout-btn {
  width: 100%;
  padding: 14px;
  background: var(--accent);
  border: none;
  border-radius: 10px;
  color: #000;
  font-family: var(--font-head);
  font-size: 15px;
  font-weight: 800;
  cursor: pointer;
  transition: background var(--transition);
}
.checkout-btn:hover { background: #f0a020; }

/* ============================================================
   FOOTER
============================================================ */
.footer {
  background: var(--surface);
  border-top: 1px solid var(--border);
  padding: 32px 28px;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 28px;
}
.footer-col h4 {
  font-family: var(--font-head);
  font-size: 13px;
  font-weight: 700;
  color: var(--accent);
  text-transform: uppercase;
  letter-spacing: 1.5px;
  margin-bottom: 12px;
}
.footer-col p, .footer-col a {
  color: var(--muted);
  font-size: 13px;
  line-height: 2;
  display: block;
  text-decoration: none;
  transition: color var(--transition);
}
.footer-col a:hover { color: var(--text); }
.footer-bottom {
  background: var(--bg);
  border-top: 1px solid var(--border);
  text-align: center;
  padding: 14px;
  font-size: 12px;
  color: var(--muted);
}

/* ============================================================
   TOAST
============================================================ */
.toast {
  position: fixed;
  bottom: 28px;
  left: 50%;
  transform: translateX(-50%) translateY(80px);
  background: var(--surface2);
  border: 1px solid var(--border);
  color: var(--text);
  padding: 12px 22px;
  border-radius: 999px;
  font-size: 13px;
  font-weight: 500;
  z-index: 300;
  transition: transform 0.35s cubic-bezier(0.34,1.56,0.64,1), opacity 0.35s;
  opacity: 0;
  pointer-events: none;
  white-space: nowrap;
  box-shadow: 0 8px 30px rgba(0,0,0,0.4);
}
.toast.show { transform: translateX(-50%) translateY(0); opacity: 1; }

/* ============================================================
   RESPONSIVE
============================================================ */
@media (max-width: 600px) {
  .header { padding: 12px 16px; }
  .nav    { padding: 0 16px; }
  .hero   { padding: 36px 16px; }
  .grid   { padding: 0 16px 40px; gap: 14px; }
  .toolbar { padding: 12px 16px; }
  .footer { padding: 24px 16px; }
}
</style>
</head>

<body>

<!-- ══════════════ HEADER ══════════════ -->
<header class="header">
  <div class="logo" id="logoBtn">YourStore</div>
  <div class="search-wrap">
    <span class="search-icon">⌕</span>
    <input type="search" id="searchInput" placeholder="Search products…" autocomplete="off">
  </div>
  <button class="cart-btn" id="cartBtn" title="Open cart">
    🛒
    <span class="cart-badge" id="cartBadge">0</span>
  </button>
</header>

<!-- ══════════════ NAV ══════════════ -->
<nav class="nav" id="navBar">
  <button class="nav-item active" data-cat="All">All</button>
  <button class="nav-item" data-cat="Electronics">Electronics</button>
  <button class="nav-item" data-cat="Fashion">Fashion</button>
  <button class="nav-item" data-cat="Kitchen">Kitchen</button>
  <button class="nav-item" data-cat="Books">Books</button>
  <button class="nav-item" data-cat="Toys">Toys</button>
</nav>

<!-- ══════════════ HERO ══════════════ -->
<section class="hero">
  <div class="hero-tag">☀️ Limited Time</div>
  <h1>Summer Sale<br><span>Up to 60% OFF</span></h1>
  <p>Handpicked deals across every category — updated daily.</p>
</section>

<!-- ══════════════ TOOLBAR ══════════════ -->
<div class="toolbar">
  <p class="result-count" id="resultCount"><strong>10</strong> products</p>
  <select class="sort-select" id="sortSelect">
    <option value="default">Sort: Featured</option>
    <option value="price-asc">Price: Low → High</option>
    <option value="price-desc">Price: High → Low</option>
    <option value="discount">Biggest Discount</option>
  </select>
</div>

<!-- ══════════════ PRODUCT GRID ══════════════ -->
<main class="grid" id="grid"></main>

<!-- ══════════════ CART DRAWER ══════════════ -->
<div class="drawer-overlay" id="overlay"></div>
<aside class="drawer" id="cartDrawer" role="dialog" aria-label="Shopping cart">
  <div class="drawer-header">
    <h2>Your Cart</h2>
    <button class="close-btn" id="closeDrawer">✕</button>
  </div>
  <div class="drawer-items" id="cartItems"></div>
  <div class="drawer-footer" id="cartFooter"></div>
</aside>

<!-- ══════════════ FOOTER ══════════════ -->
<footer class="footer">
  <div class="footer-col">
    <h4>YourStore</h4>
    <p>Premium products,<br>delivered fast.</p>
  </div>
  <div class="footer-col">
    <h4>Help</h4>
    <a href="#">Track Order</a>
    <a href="#">Returns</a>
    <a href="#">FAQ</a>
  </div>
  <div class="footer-col">
    <h4>Contact</h4>
    <p>support@yourstore.com</p>
    <p>+91 98765 43210</p>
  </div>
</footer>
<div class="footer-bottom">© 2025 YourStore Pvt Ltd. All rights reserved.</div>

<!-- ══════════════ TOAST ══════════════ -->
<div class="toast" id="toast"></div>

<!-- ══════════════ SCRIPT ══════════════ -->
<script>
/* ─────────────────────────────────────────
   DATA
   FIX: Use Picsum for stable, working images
   (Unsplash /300x200/?query is deprecated)
───────────────────────────────────────── */
var products = [
  {id:1, name:"Headphones",        price:5499, old:9999, cat:"Electronics", img:"https://www.apple.com/newsroom/images/product/airpods/standard/apple_airpods-max_hero_12082020_big.jpg.large_2x.jpg",    stars:4.5, reviews:1234},
  {id:2, name:"Bluetooth Speaker", price:4999, old:9999, cat:"Electronics", img:"https://www.apple.com/newsroom/images/product/homepod/standard/Apple_homepod-mini-white-10132020_big.jpg.large_2x.jpg",       stars:4.3, reviews:876},
  {id:3, name:"Smart Watch",       price:5999, old:9999, cat:"Electronics", img:"https://www.apple.com/newsroom/images/product/watch/standard/Apple_watch-series7_hero_09142021_big.jpg.large_2x.jpg",    stars:4.7, reviews:2103},
  {id:4, name:"Jacket",            price:1999, old:3999, cat:"Fashion",     img:"https://static.zara.net/assets/public/1424/00b6/781849c6930a/141805fe5ad7/00562602700-e1/00562602700-e1.jpg?ts=1770018371850&w=1024",        stars:4.2, reviews:543},
  {id:5, name:"Running Shoes",     price:1799, old:3499, cat:"Fashion",     img:"https://rukminim2.flixcart.com/image/1280/1280/xif0q/shoe/v/f/9/-original-imahfkjab7gqczgp.jpeg?q=90",         stars:4.6, reviews:1897},
  {id:6, name:"Kitchen Set",       price:1999,  old:2999, cat:"Kitchen",        img:"https://www.ikea.com/in/en/images/products/ikea-365-cookware-set-of-6-stainless-steel__1062091_pe850656_s5.jpg?f=xl",       stars:4.1, reviews:321},
  {id:7, name:"Dining Table",        price:1599,  old:3199, cat:"Kitchen",        img:"https://www.ikea.com/in/en/images/products/haegernaes-table-and-4-chairs-antique-stain-pine__1350925_pe951817_s5.jpg?f=xl",          stars:4.4, reviews:654},
  {id:8, name:"Bhagavad Gita",   price:399,  old:699,  cat:"Books",       img:"https://i0.wp.com/www.iskconbooks.com/wp-content/uploads/2020/10/Eng-cvr-Bhagavad-gita.jpg?resize=768%2C768&ssl=1",         stars:5.0, reviews:100M+},
  {id:9, name:"Notebooks",          price:299,  old:599,  cat:"Books",       img:"https://5.imimg.com/data5/HK/LF/MY-17842015/school-note-book-1000x1000.jpg",      stars:4.0, reviews:198},
  {id:10,name:"Toy Car",           price:999,  old:1599, cat:"Toys",        img:"https://m.media-amazon.com/images/I/5164gN4xYqL._SX300_SY300_QL70_FMwebp_.jpg",        stars:4.3, reviews:765}
];

/* Category emoji fallback icons */
var catIcon = {
  Electronics:"🎧", Fashion:"👗", Kitchen:"🏠", Books:"📚", Toys:"🧸"
};

/* ─────────────────────────────────────────
   STATE
───────────────────────────────────────── */
var cart      = {};          /* { productId: quantity } */
var wishlist  = new Set();   /* Set of product ids */
var activeFilter = "All";
var currentSearch = "";
var currentSort   = "default";

/* ─────────────────────────────────────────
   HELPERS
───────────────────────────────────────── */
function discount(p) {
  return Math.round((1 - p.price / p.old) * 100);
}

function cartTotal() {
  return Object.entries(cart).reduce(function(sum, entry) {
    var id  = parseInt(entry[0]);
    var qty = entry[1];
    var p   = products.find(function(x){ return x.id === id; });
    return sum + (p ? p.price * qty : 0);
  }, 0);
}

function cartCount() {
  return Object.values(cart).reduce(function(a, b){ return a + b; }, 0);
}

/* Escape text to prevent XSS — FIX for innerHTML injection */
function esc(str) {
  var d = document.createElement("div");
  d.appendChild(document.createTextNode(String(str)));
  return d.innerHTML;
}

function stars(n) {
  var full  = Math.floor(n);
  var half  = (n % 1) >= 0.5 ? 1 : 0;
  var empty = 5 - full - half;
  return "★".repeat(full) + (half ? "½" : "") + "☆".repeat(empty);
}

/* ─────────────────────────────────────────
   RENDER PRODUCTS
───────────────────────────────────────── */
function getFiltered() {
  var list = products.slice();

  /* Filter by category */
  if (activeFilter !== "All") {
    list = list.filter(function(p){ return p.cat === activeFilter; });
  }

  /* Filter by search — FIX: renamed from search() to avoid window.search collision */
  if (currentSearch) {
    var q = currentSearch.toLowerCase();
    list = list.filter(function(p){
      return p.name.toLowerCase().includes(q) || p.cat.toLowerCase().includes(q);
    });
  }

  /* Sort */
  if (currentSort === "price-asc")  list.sort(function(a,b){ return a.price - b.price; });
  if (currentSort === "price-desc") list.sort(function(a,b){ return b.price - a.price; });
  if (currentSort === "discount")   list.sort(function(a,b){ return discount(b) - discount(a); });

  return list;
}

function renderProducts() {
  var list = getFiltered();
  var grid = document.getElementById("grid");
  grid.innerHTML = "";

  /* Result count */
  var rc = document.getElementById("resultCount");
  rc.innerHTML = "<strong>" + esc(list.length) + "</strong> product" + (list.length !== 1 ? "s" : "");

  if (list.length === 0) {
    var empty = document.createElement("div");
    empty.className = "empty";
    empty.innerHTML =
      "<div class='empty-icon'>🔍</div>" +
      "<h2>No products found</h2>" +
      "<p>Try a different keyword or category.</p>";
    grid.appendChild(empty);
    return;
  }

  list.forEach(function(p) {
    var d     = discount(p);
    var inCart = cart[p.id] && cart[p.id] > 0;
    var liked  = wishlist.has(p.id);
    var savings = p.old - p.price;

    var card = document.createElement("div");
    card.className = "card";
    card.dataset.id = p.id;

    /* FIX: Use esc() to prevent XSS. Image uses onerror fallback. */
    card.innerHTML =
      "<div class='card-img-wrap'>" +
        "<div class='img-placeholder'>" + (catIcon[p.cat] || "📦") + "</div>" +
        "<img src='" + esc(p.img) + "' alt='" + esc(p.name) + "' loading='lazy'" +
             " onload=\"this.previousElementSibling.style.display='none'\"" +
             " onerror=\"this.style.display='none'\">" +
        "<div class='badge'>-" + d + "%</div>" +
        "<button class='wishlist-btn" + (liked ? " active" : "") + "'" +
                " data-wish='" + p.id + "' title='Wishlist'>" +
                (liked ? "♥" : "♡") + "</button>" +
      "</div>" +
      "<div class='card-body'>" +
        "<div class='cat-label'>" + esc(p.cat) + "</div>" +
        "<div class='card-title'>" + esc(p.name) + "</div>" +
        "<div class='rating'>" + stars(p.stars) + " <span>(" + esc(p.reviews) + ")</span></div>" +
        "<div class='price-row'>" +
          "<span class='price'>₹" + esc(p.price.toLocaleString("en-IN")) + "</span>" +
          "<span class='price-old'>₹" + esc(p.old.toLocaleString("en-IN")) + "</span>" +
        "</div>" +
        "<div class='savings'>You save ₹" + esc(savings.toLocaleString("en-IN")) + "</div>" +
      "</div>" +
      "<div class='card-footer'>" +
        "<button class='add-btn" + (inCart ? " added" : "") + "' data-add='" + p.id + "'>" +
          (inCart ? "✓ Added (" + cart[p.id] + ")" : "Add to Cart") +
        "</button>" +
      "</div>";

    grid.appendChild(card);
  });
}

/* ─────────────────────────────────────────
   CART RENDER
───────────────────────────────────────── */
function renderCart() {
  var items    = document.getElementById("cartItems");
  var footer   = document.getElementById("cartFooter");
  var badge    = document.getElementById("cartBadge");
  var count    = cartCount();
  var total    = cartTotal();

  /* badge */
  badge.textContent = count;
  if (count > 0) badge.classList.add("visible");
  else           badge.classList.remove("visible");

  /* items */
  items.innerHTML = "";

  var cartProducts = products.filter(function(p){ return cart[p.id] > 0; });

  if (cartProducts.length === 0) {
    items.innerHTML =
      "<div class='cart-empty-msg'>" +
        "<div class='ci'>🛒</div>" +
        "<p>Your cart is empty.<br>Start adding items!</p>" +
      "</div>";
    footer.innerHTML = "";
    return;
  }

  cartProducts.forEach(function(p) {
    var qty  = cart[p.id];
    var row  = document.createElement("div");
    row.className = "cart-item";
    row.innerHTML =
      "<div class='cart-item-info'>" +
        "<div class='cart-item-name'>" + esc(p.name) + "</div>" +
        "<div class='cart-item-price'>₹" + esc((p.price * qty).toLocaleString("en-IN")) + "</div>" +
      "</div>" +
      "<div class='qty-controls'>" +
        "<button class='qty-btn' data-dec='" + p.id + "'>−</button>" +
        "<span class='qty-num'>" + qty + "</span>" +
        "<button class='qty-btn' data-inc='" + p.id + "'>+</button>" +
      "</div>";
    items.appendChild(row);
  });

  /* footer summary */
  var subtotal = total;
  var shipping = subtotal > 999 ? 0 : 49;
  var grand    = subtotal + shipping;
  footer.innerHTML =
    "<div class='total-row'><span>Subtotal</span><span>₹" + subtotal.toLocaleString("en-IN") + "</span></div>" +
    "<div class='total-row'><span>Shipping</span><span>" + (shipping === 0 ? "<span style='color:#4caf50'>FREE</span>" : "₹" + shipping) + "</span></div>" +
    "<div class='total-row grand'><span>Total</span><span>₹" + grand.toLocaleString("en-IN") + "</span></div>" +
    "<button class='checkout-btn'>Proceed to Checkout →</button>";
}

/* ─────────────────────────────────────────
   TOAST
───────────────────────────────────────── */
var _toastTimer;
function showToast(msg) {
  var t = document.getElementById("toast");
  t.textContent = msg;
  t.classList.add("show");
  clearTimeout(_toastTimer);
  _toastTimer = setTimeout(function(){ t.classList.remove("show"); }, 2200);
}

/* ─────────────────────────────────────────
   CART DRAWER OPEN / CLOSE
───────────────────────────────────────── */
function openCart() {
  document.getElementById("cartDrawer").classList.add("open");
  document.getElementById("overlay").classList.add("open");
  document.body.style.overflow = "hidden";
}
function closeCart() {
  document.getElementById("cartDrawer").classList.remove("open");
  document.getElementById("overlay").classList.remove("open");
  document.body.style.overflow = "";
}

/* ─────────────────────────────────────────
   BUMP ANIMATION on badge
───────────────────────────────────────── */
function bumpBadge() {
  var b = document.getElementById("cartBadge");
  b.classList.remove("bump");
  void b.offsetWidth;   /* force reflow */
  b.classList.add("bump");
}

/* ─────────────────────────────────────────
   EVENT DELEGATION — single listener on
   document catches all clicks (fast, clean)
───────────────────────────────────────── */
document.addEventListener("click", function(e) {
  var t = e.target;

  /* Add to cart */
  var addId = t.closest("[data-add]");
  if (addId) {
    var id = parseInt(addId.dataset.add);
    cart[id] = (cart[id] || 0) + 1;
    renderProducts();
    renderCart();
    bumpBadge();
    var p = products.find(function(x){ return x.id === id; });
    showToast("✓ " + p.name + " added to cart");
    return;
  }

  /* Wishlist */
  var wId = t.closest("[data-wish]");
  if (wId) {
    var wid = parseInt(wId.dataset.wish);
    if (wishlist.has(wid)) {
      wishlist.delete(wid);
      showToast("Removed from wishlist");
    } else {
      wishlist.add(wid);
      showToast("❤️ Added to wishlist");
    }
    renderProducts();
    return;
  }

  /* Qty decrease */
  var decId = t.closest("[data-dec]");
  if (decId) {
    var did = parseInt(decId.dataset.dec);
    cart[did] = (cart[did] || 1) - 1;
    if (cart[did] <= 0) delete cart[did];
    renderProducts();
    renderCart();
    return;
  }

  /* Qty increase */
  var incId = t.closest("[data-inc]");
  if (incId) {
    var iid = parseInt(incId.dataset.inc);
    cart[iid] = (cart[iid] || 0) + 1;
    renderProducts();
    renderCart();
    bumpBadge();
    return;
  }

  /* Cart open */
  if (t.closest("#cartBtn"))     { openCart();  return; }
  if (t.closest("#closeDrawer")) { closeCart(); return; }
  if (t.id === "overlay")        { closeCart(); return; }

  /* Logo → reset all filters */
  if (t.closest("#logoBtn")) {
    activeFilter  = "All";
    currentSearch = "";
    currentSort   = "default";
    document.getElementById("searchInput").value = "";
    document.getElementById("sortSelect").value  = "default";
    document.querySelectorAll(".nav-item").forEach(function(b){
      b.classList.toggle("active", b.dataset.cat === "All");
    });
    renderProducts();
    return;
  }

  /* Nav filter buttons */
  var navItem = t.closest(".nav-item");
  if (navItem) {
    activeFilter = navItem.dataset.cat;
    document.querySelectorAll(".nav-item").forEach(function(b){
      b.classList.toggle("active", b === navItem);
    });
    renderProducts();
    return;
  }
});

/* ─────────────────────────────────────────
   SEARCH INPUT — FIX: handler on input event,
   no more window.search() name clash
───────────────────────────────────────── */
document.getElementById("searchInput").addEventListener("input", function() {
  currentSearch = this.value.trim();
  renderProducts();
});

/* ─────────────────────────────────────────
   SORT
───────────────────────────────────────── */
document.getElementById("sortSelect").addEventListener("change", function() {
  currentSort = this.value;
  renderProducts();
});

/* ─────────────────────────────────────────
   KEYBOARD: Escape closes drawer
───────────────────────────────────────── */
document.addEventListener("keydown", function(e) {
  if (e.key === "Escape") closeCart();
});

/* ─────────────────────────────────────────
   INIT
───────────────────────────────────────── */
renderProducts();
renderCart();
</script>

</body>
</html>
