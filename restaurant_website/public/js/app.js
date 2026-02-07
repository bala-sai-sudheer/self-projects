document.addEventListener('DOMContentLoaded', function() {
    // Filter functionality
    const filterButtons = document.querySelectorAll('.filter-btn');
    const categoryCards = document.querySelectorAll('.category-card');
    const restaurantContainer = document.querySelector('.restaurants-container');
    const loadingElement = document.querySelector('.loading');

    // Current active filters
    let currentFilters = {
        pureVeg: false,
        fastDelivery: false,
        highRating: false,
        hasOffers: false,
        priceRange: null,
        category: null
    };

    // Apply filter function
    function applyFilters() {
        showLoading();

        // Build query string
        const params = new URLSearchParams();

        if (currentFilters.pureVeg) params.set('pureVeg', 'true');
        if (currentFilters.fastDelivery) params.set('fastDelivery', 'true');
        if (currentFilters.highRating) params.set('highRating', 'true');
        if (currentFilters.hasOffers) params.set('hasOffers', 'true');
        if (currentFilters.priceRange) params.set('priceRange', currentFilters.priceRange);
        if (currentFilters.category) params.set('category', currentFilters.category);

        // Use Fetch API to get filtered restaurants
        fetch(`/api/restaurants?${params.toString()}`)
            .then(response => response.json())
            .then(restaurants => {
                updateRestaurantDisplay(restaurants);
                hideLoading();
            })
            .catch(error => {
                console.error('Error fetching restaurants:', error);
                hideLoading();
            });
    }

    // Update restaurant display
    function updateRestaurantDisplay(restaurants) {
        restaurantContainer.innerHTML = '';

        if (restaurants.length === 0) {
            restaurantContainer.innerHTML = `
                <div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
                    <h3>No restaurants found</h3>
                    <p>Try adjusting your filters</p>
                </div>
            `;
            return;
        }

        restaurants.forEach(restaurant => {
            const restaurantCard = createRestaurantCard(restaurant);
            restaurantContainer.appendChild(restaurantCard);
        });
    }

    // Create restaurant card HTML
    function createRestaurantCard(restaurant) {
        const card = document.createElement('div');
        card.className = 'restaurant-card';
        card.dataset.id = restaurant.id;

        card.innerHTML = `
            <img src="${restaurant.image}" alt="${restaurant.name}" class="restaurant-img">
            <div class="restaurant-info">
                <h3 class="restaurant-name">${restaurant.name}</h3>
                <p class="restaurant-cuisine">${restaurant.cuisine}</p>
                <div class="restaurant-details">
                    <div class="rating">
                        <i class="fas fa-star"></i>
                        <span>${restaurant.rating}</span>
                    </div>
                    <div class="delivery-time">${restaurant.deliveryTime}</div>
                </div>
                <div class="price">${restaurant.price}</div>
                <div class="restaurant-actions">
                    <button class="order-btn" onclick="orderFromRestaurant(${restaurant.id})">
                        <i class="fas fa-shopping-cart"></i> Order Now
                    </button>
                    <button class="view-btn" onclick="viewRestaurant(${restaurant.id})">
                        <i class="fas fa-eye"></i> View
                    </button>
                </div>
            </div>
        `;

        return card;
    }

    // Show loading spinner
    function showLoading() {
        if (loadingElement) {
            loadingElement.style.display = 'block';
        }
    }

    // Hide loading spinner
    function hideLoading() {
        if (loadingElement) {
            loadingElement.style.display = 'none';
        }
    }

    // Filter button click handlers
    filterButtons.forEach(button => {
        button.addEventListener('click', function() {
            const filterType = this.dataset.filter;

            // Reset all filter buttons
            filterButtons.forEach(btn => btn.classList.remove('active'));

            // Handle price range filters
            if (filterType === 'lowPrice' || filterType === 'midPrice' || filterType === 'highPrice') {
                currentFilters.priceRange = filterType.replace('Price', '');
                this.classList.add('active');
            }
            // Handle other filters
            else if (filterType === 'all') {
                // Reset all filters
                currentFilters = {
                    pureVeg: false,
                    fastDelivery: false,
                    highRating: false,
                    hasOffers: false,
                    priceRange: null,
                    category: null
                };
                this.classList.add('active');
            }
            else if (filterType === 'pureVeg') {
                currentFilters.pureVeg = !currentFilters.pureVeg;
                if (currentFilters.pureVeg) {
                    this.classList.add('active');
                }
            }
            else if (filterType === 'fastDelivery') {
                currentFilters.fastDelivery = !currentFilters.fastDelivery;
                if (currentFilters.fastDelivery) {
                    this.classList.add('active');
                }
            }
            else if (filterType === 'highRating') {
                currentFilters.highRating = !currentFilters.highRating;
                if (currentFilters.highRating) {
                    this.classList.add('active');
                }
            }
            else if (filterType === 'hasOffers') {
                currentFilters.hasOffers = !currentFilters.hasOffers;
                if (currentFilters.hasOffers) {
                    this.classList.add('active');
                }
            }

            applyFilters();
        });
    });

    // Category card click handlers
    categoryCards.forEach(card => {
        card.addEventListener('click', function() {
            const category = this.dataset.category;
            currentFilters.category = category;

            // Update active category
            categoryCards.forEach(c => c.classList.remove('active'));
            this.classList.add('active');

            applyFilters();
        });
    });

    // Search functionality
    const searchInput = document.querySelector('.search-bar input');
    searchInput.addEventListener('keyup', function(event) {
        if (event.key === 'Enter') {
            const query = this.value.trim().toLowerCase();

            if (query) {
                showLoading();

                fetch('/api/restaurants')
                    .then(response => response.json())
                    .then(restaurants => {
                        const filtered = restaurants.filter(restaurant =>
                            restaurant.name.toLowerCase().includes(query) ||
                            restaurant.cuisine.toLowerCase().includes(query)
                        );
                        updateRestaurantDisplay(filtered);
                        hideLoading();
                    })
                    .catch(error => {
                        console.error('Error searching restaurants:', error);
                        hideLoading();
                    });
            }
        }
    });

    // Location selector
    document.querySelector('.location').addEventListener('click', function() {
        const newLocation = prompt('Enter your delivery location in Hyderabad:');
        if (newLocation) {
            this.querySelector('span').textContent = newLocation + ', Hyderabad';
        }
    });
});

// Global functions for restaurant actions
function orderFromRestaurant(restaurantId) {
    alert(`Ordering from restaurant ID: ${restaurantId}\n\nIn a real app, this would open the cart/menu for this restaurant.`);
}

function viewRestaurant(restaurantId) {
    fetch(`/api/restaurants/${restaurantId}`)
        .then(response => response.json())
        .then(restaurant => {
            alert(`Viewing: ${restaurant.name}\n\nCuisine: ${restaurant.cuisine}\nRating: ${restaurant.rating}\nPrice: ${restaurant.price}\nDelivery Time: ${restaurant.deliveryTime}`);
        })
        .catch(error => {
            console.error('Error fetching restaurant:', error);
        });
}
