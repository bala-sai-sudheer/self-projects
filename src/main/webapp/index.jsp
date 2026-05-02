<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>YourStore</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        body {
            margin: 0;
            font-family: Arial;
            background: #f3f3f3;
        }

        /* HEADER */
        .header {
            background: #131921;
            color: white;
            display: flex;
            align-items: center;
            padding: 10px 20px;
        }

        .logo { color: #ff9900; font-size: 22px; }

        .search-bar {
            margin-left: 20px;
            flex: 1;
            display: flex;
        }

        .search-bar input {
            flex: 1;
            padding: 8px;
            border: none;
        }

        .search-bar button {
            background: #febd69;
            border: none;
            padding: 8px;
        }

        .cart {
            margin-left: 20px;
            font-weight: bold;
        }

        /* NAVBAR */
        .navbar {
            background: #232f3e;
            color: white;
            padding: 10px;
        }

        .navbar ul {
            display: flex;
            list-style: none;
            gap: 20px;
            margin: 0;
        }

        .navbar li {
            cursor: pointer;
        }

        .navbar li:hover {
            text-decoration: underline;
        }

        /* PRODUCTS */
        .products {
            padding: 20px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .card {
            background: white;
            padding: 10px;
            border-radius: 8px;
            text-align: center;
        }

        .card img {
            width: 100%;
            height: 150px;
            object-fit: cover;
        }

        .price {
            color: #B12704;
            font-weight: bold;
        }

        .card button {
            background: #ffd814;
            border: none;
            padding: 8px;
            width: 100%;
            cursor: pointer;
        }
    </style>
</head>

<body>

<!-- HEADER -->
<div class="header">
    <div class="logo">YourStore</div>

    <div class="search-bar">
        <input type="text" placeholder="Search products">
        <button>🔍</button>
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

<!-- PRODUCTS -->
<div class="products">

    <div class="grid" id="productGrid">

        <!-- Electronics -->
        <div class="card" data-category="Electronics Deals">
            <img src="images/electronics.jpg">
            <h4>Headphones</h4>
            <p class="price">₹1999</p>
            <button onclick="addToCart()">Add to Cart</button>
        </div>

        <!-- Fashion -->
        <div class="card" data-category="Fashion Deals">
            <img src="images/fashion.jpg">
            <h4>Jacket</h4>
            <p class="price">₹2499</p>
            <button onclick="addToCart()">Add to Cart</button>
        </div>

        <!-- Home -->
        <div class="card" data-category="Home">
            <img src="images/home.jpg">
            <h4>Kitchen Set</h4>
            <p class="price">₹1299</p>
            <button onclick="addToCart()">Add to Cart</button>
        </div>

        <!-- Books -->
        <div class="card" data-category="Books">
            <img src="images/books.jpg">
            <h4>Book</h4>
            <p class="price">₹499</p>
            <button onclick="addToCart()">Add to Cart</button>
        </div>

        <!-- Toys -->
        <div class="card" data-category="Toys">
            <img src="images/toys.jpg">
            <h4>Toy Car</h4>
            <p class="price">₹899</p>
            <button onclick="addToCart()">Add to Cart</button>
        </div>

    </div>
</div>

<!-- SCRIPT -->
<script>

    let cartCount = 0;

    function addToCart() {
        cartCount++;
        document.getElementById("cartCount").innerText = cartCount;
    }

    function filterProducts(category) {
        let cards = document.querySelectorAll(".card");

        cards.forEach(card => {
            let cat = card.getAttribute("data-category");

            if (category === "All" || cat.includes(category)) {
                card.style.display = "block";
            } else {
                card.style.display = "none";
            }
        });
    }

</script>

</body>
</html>
