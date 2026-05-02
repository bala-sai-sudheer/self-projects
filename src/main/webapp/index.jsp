<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>YourStore | Online Shopping</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/styles.css">
</head>

<body>

<!-- ================= HEADER ================= -->
<header class="header">
    <div class="logo">YourStore</div>

    <div class="search-bar">
        <select>
            <option>All</option>
            <option>Electronics</option>
            <option>Fashion</option>
            <option>Home</option>
        </select>
        <input type="text" placeholder="Search YourStore">
        <button>🔍</button>
    </div>

    <div class="header-right">
        <div>Account</div>
        <div>Orders</div>
        <div class="cart">🛒 Cart</div>
    </div>
</header>

<!-- ================= NAVBAR ================= -->
<nav class="navbar">
    <ul>
        <li>All</li>
        <li>Today's Deals</li>
        <li>Electronics</li>
        <li>Fashion</li>
        <li>Home & Kitchen</li>
        <li>Books</li>
        <li>Toys</li>
    </ul>
</nav>

<!-- ================= HERO ================= -->
<section class="hero">
    <h2>Great Summer Sale</h2>
    <p>Up to 70% OFF on top categories</p>
</section>

<!-- ================= CATEGORY SECTION ================= -->
<section class="category-section">

    <div class="category-card">
        <h3>Electronics</h3>
        <img src="images/electronics.jpg">
        <button>Shop Now</button>
    </div>

    <div class="category-card">
        <h3>Fashion</h3>
        <img src="images/fashion.jpg">
        <button>Shop Now</button>
    </div>

    <div class="category-card">
        <h3>Home & Kitchen</h3>
        <img src="images/home.jpg">
        <button>Shop Now</button>
    </div>

    <div class="category-card">
        <h3>Books</h3>
        <img src="images/books.jpg">
        <button>Shop Now</button>
    </div>

</section>

<!-- ================= PRODUCT GRID ================= -->
<section class="products">

    <h2>Top Deals</h2>

    <div class="product-grid">

        <div class="product-card">
            <img src="images/electronics.jpg">
            <h4>Wireless Headphones</h4>
            <p class="price">₹1,999</p>
            <button>Add to Cart</button>
        </div>

        <div class="product-card">
            <img src="images/fashion.jpg">
            <h4>Men's Jacket</h4>
            <p class="price">₹2,499</p>
            <button>Add to Cart</button>
        </div>

        <div class="product-card">
            <img src="images/home.jpg">
            <h4>Kitchen Set</h4>
            <p class="price">₹1,299</p>
            <button>Add to Cart</button>
        </div>

        <div class="product-card">
            <img src="images/books.jpg">
            <h4>Bestseller Book</h4>
            <p class="price">₹499</p>
            <button>Add to Cart</button>
        </div>

    </div>

</section>

<!-- ================= FOOTER ================= -->
<footer class="footer">
    <p>© 2026 YourStore | Designed like Amazon UI</p>
</footer>

</body>
</html>
