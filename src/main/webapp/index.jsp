<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>YourStore | Online Shopping</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>

        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(to bottom, #f3f3f3, #e6e6e6);
        }

        /* HEADER */
        .header {
            background: #131921;
            color: white;
            display: flex;
            align-items: center;
            padding: 12px 20px;
        }

        .logo {
            font-size: 24px;
            font-weight: 600;
            color: #ff9900;
            margin-right: 20px;
        }

        .search-bar {
            display: flex;
            flex: 1;
        }

        .search-bar select {
            padding: 10px;
            border: none;
        }

        .search-bar input {
            flex: 1;
            padding: 10px;
            border: none;
        }

        .search-bar button {
            background: #febd69;
            border: none;
            padding: 10px 15px;
            cursor: pointer;
        }

        .header-right {
            display: flex;
            gap: 20px;
            margin-left: 20px;
        }

        /* NAVBAR */
        .navbar {
            background: #232f3e;
            color: white;
            padding: 10px 20px;
        }

        .navbar ul {
            display: flex;
            list-style: none;
            margin: 0;
            padding: 0;
            gap: 20px;
        }

        /* HERO */
        .hero {
            background: url('https://images.unsplash.com/photo-1607083206968-13611e3d76db') center/cover no-repeat;
            height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
            position: relative;
        }

        .hero::after {
            content: "";
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.5);
        }

        .hero-content {
            position: relative;
        }

        .hero h2 {
            font-size: 40px;
            margin: 0;
        }

        .hero p {
            font-size: 18px;
        }

        /* CATEGORY SECTION */
        .category-section {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            padding: 20px;
            margin-top: -100px;
        }

        .category-card {
            background: white;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .category-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .category-card button {
            margin-top: 10px;
            width: 100%;
            padding: 8px;
            background: #ffd814;
            border: none;
            cursor: pointer;
        }

        /* PRODUCTS */
        .products {
            padding: 20px;
        }

        .products h2 {
            margin-bottom: 10px;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .product-card {
            background: white;
            padding: 15px;
            border-radius: 10px;
            transition: 0.3s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .product-card:hover {
            transform: translateY(-5px);
        }

        .product-card img {
            width: 100%;
            height: 160px;
            object-fit: cover;
        }

        .price {
            color: #B12704;
            font-weight: bold;
        }

        .product-card button {
            width: 100%;
            padding: 8px;
            background: #ffa41c;
            border: none;
            margin-top: 10px;
            cursor: pointer;
        }

        /* FOOTER */
        .footer {
            background: #131921;
            color: white;
            text-align: center;
            padding: 15px;
        }

    </style>
</head>

<body>

<!-- HEADER -->
<div class="header">
    <div class="logo">YourStore</div>

    <div class="search-bar">
        <select>
            <option>All</option>
        </select>
        <input type="text" placeholder="Search YourStore">
        <button>🔍</button>
    </div>

    <div class="header-right">
        <div>Account</div>
        <div>Orders</div>
        <div>🛒 Cart</div>
    </div>
</div>

<!-- NAVBAR -->
<div class="navbar">
    <ul>
        <li>All</li>
        <li>Today's Deals</li>
        <li>Electronics</li>
        <li>Fashion</li>
        <li>Home</li>
        <li>Books</li>
        <li>Toys</li>
    </ul>
</div>

<!-- HERO -->
<div class="hero">
    <div class="hero-content">
        <h2>Great Summer Sale</h2>
        <p>Up to 70% OFF on top categories</p>
    </div>
</div>

<!-- CATEGORY -->
<div class="category-section">

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

</div>

<!-- PRODUCTS -->
<div class="products">
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
</div>

<!-- FOOTER -->
<div class="footer">
    © 2026 YourStore
</div>

</body>
</html>
