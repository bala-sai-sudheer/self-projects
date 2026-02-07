const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Set view engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Middleware
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Restaurant data for Hyderabad
const restaurants = [
    {
        id: 1,
        name: "Pizza Palace",
        cuisine: "Pizza, Italian, Pasta",
        rating: 4.5,
        price: "₹500 for two",
        priceRange: "mid",
        deliveryTime: "30-40 mins",
        isPureVeg: false,
        hasOffers: true,
        image: "https://images.pexels.com/photos/9692142/pexels-photo-9692142.jpeg",
        category: "pizza"
    },
    {
        id: 2,
        name: "Burger Hub",
        cuisine: "Burgers, Fast Food, American",
        rating: 4.3,
        price: "₹400 for two",
        priceRange: "mid",
        deliveryTime: "25-35 mins",
        isPureVeg: false,
        hasOffers: true,
        image: "https://images.pexels.com/photos/29368033/pexels-photo-29368033.jpeg",
        category: "burger"
    },
    {
        id: 3,
        name: "Hyderabad Biryani House",
        cuisine: "Hyderabadi, Mughlai, Indian",
        rating: 4.7,
        price: "₹600 for two",
        priceRange: "mid",
        deliveryTime: "40-50 mins",
        isPureVeg: false,
        hasOffers: true,
        image: "https://images.pexels.com/photos/33947401/pexels-photo-33947401.jpeg",
        category: "indian"
    },
    {
        id: 4,
        name: "Sushi Express",
        cuisine: "Japanese, Sushi, Asian",
        rating: 4.6,
        price: "₹1200 for two",
        priceRange: "high",
        deliveryTime: "35-45 mins",
        isPureVeg: false,
        hasOffers: false,
        image: "https://images.pexels.com/photos/17308502/pexels-photo-17308502.jpeg",
        category: "sushi"
    },
    {
        id: 5,
        name: "Noodle World",
        cuisine: "Chinese, Asian, Noodles",
        rating: 4.4,
        price: "₹350 for two",
        priceRange: "low",
        deliveryTime: "20-30 mins",
        isPureVeg: false,
        hasOffers: true,
        image: "https://images.pexels.com/photos/16681314/pexels-photo-16681314.jpeg",
        category: "noodles"
    },
    {
        id: 6,
        name: "Green Salads",
        cuisine: "Healthy, Salads, Vegetarian",
        rating: 4.2,
        price: "₹300 for two",
        priceRange: "low",
        deliveryTime: "15-25 mins",
        isPureVeg: true,
        hasOffers: false,
        image: "https://images.pexels.com/photos/14090828/pexels-photo-14090828.jpeg",
        category: "salads"
    }
];

// Categories data
const categories = [
    { name: "Pizza", icon: "fas fa-pizza-slice", category: "pizza" },
    { name: "Burgers", icon: "fas fa-hamburger", category: "burger" },
    { name: "Biryani", icon: "fas fa-utensils", category: "indian" },
    { name: "Sushi", icon: "fas fa-fish", category: "sushi" },
    { name: "Noodles", icon: "fas fa-utensil-spoon", category: "noodles" },
    { name: "Salads", icon: "fas fa-seedling", category: "salads" },
    { name: "Desserts", icon: "fas fa-ice-cream", category: "desserts" },
    { name: "Breakfast", icon: "fas fa-mug-hot", category: "breakfast" }
];

// Filter restaurants based on criteria
function filterRestaurants(filters) {
    return restaurants.filter(restaurant => {
        if (filters.pureVeg && !restaurant.isPureVeg) return false;
        if (filters.fastDelivery && restaurant.deliveryTime > "30 mins") return false;
        if (filters.highRating && restaurant.rating < 4.0) return false;
        if (filters.hasOffers && !restaurant.hasOffers) return false;

        if (filters.priceRange) {
            if (filters.priceRange === "low" && restaurant.priceRange !== "low") return false;
            if (filters.priceRange === "mid" && restaurant.priceRange !== "mid") return false;
            if (filters.priceRange === "high" && restaurant.priceRange !== "high") return false;
        }

        if (filters.category && restaurant.category !== filters.category) return false;

        return true;
    });
}

// Routes
app.get('/', (req, res) => {
    const filters = {
        pureVeg: req.query.pureVeg === 'true',
        fastDelivery: req.query.fastDelivery === 'true',
        highRating: req.query.highRating === 'true',
        hasOffers: req.query.hasOffers === 'true',
        priceRange: req.query.priceRange,
        category: req.query.category
    };

    const filteredRestaurants = filterRestaurants(filters);

    res.render('index', {
        location: "Hyderabad, Telangana",
        restaurants: filteredRestaurants,
        categories: categories,
        activeFilters: filters,
        showDeepavaliBanner: true
    });
});

app.get('/api/restaurants', (req, res) => {
    const filters = {
        pureVeg: req.query.pureVeg === 'true',
        fastDelivery: req.query.fastDelivery === 'true',
        highRating: req.query.highRating === 'true',
        hasOffers: req.query.hasOffers === 'true',
        priceRange: req.query.priceRange,
        category: req.query.category
    };

    const filteredRestaurants = filterRestaurants(filters);
    res.json(filteredRestaurants);
});

app.get('/api/restaurants/:id', (req, res) => {
    const restaurant = restaurants.find(r => r.id === parseInt(req.params.id));
    if (restaurant) {
        res.json(restaurant);
    } else {
        res.status(404).json({ error: 'Restaurant not found' });
    }
});

// Start server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
    console.log(`Serving food delivery app for Hyderabad`);
});
