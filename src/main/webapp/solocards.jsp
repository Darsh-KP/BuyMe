<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mainstays Vanilla Scented Single-Wick Large Jar Candle</title>
    <link rel="stylesheet" href="solocards.css">

</head>
<body>

    <nav>
        <div class="logo">
            <img src="./data/LogoFinal.png" alt="Marketplace Central Logo">
        </div>
        <div class="nav-links">
            <a href="#">Home</a>
            <a href="#">Tickets</a>
            <a href="#">Listings</a>
            <a href="#">Wishlist</a>
        </div>
        <div class="search">
            <input type="text" placeholder="Search...">
            <button>Search</button>
        </div>
        <div class="profile">
            <img src="./data/Defaultpfp.jpg" alt="Profile Picture">
            <a href="#">View Your Profile</a>
        </div>
    </nav>

    <div class="container">
        <div class="image-container">
            <!-- Placeholder image for candle -->
            <img src="./data/RUhat.jpg" alt="Mainstays Vanilla Scented Single-Wick Large Jar Candle">
            <div class="listing-info">
                <div class="dates-container">
                    <div class="listing-dates">
                        <p>Start Date: April 25, 2024</p>
                        <p>Close Date: April 30, 2024</p>
                    </div>
                    <div class="status">
                        <div class="circle green"></div>
                        <div class="text">Available</div>
                    </div>
                </div>
                <div class="bidding-container">
                    <div class="bid-info"> 
                        <label for="bid">Your Bid:</label>
                        <input type="number" id="bid" name="bid" min="20.99" step="1.00">
                        <button onclick="placeBid()" class="button">Place Bid</button>
                    </div>
                    <p>Minimum Bidding Increment: US $1.00</p>
                </div>
            </div>
        </div>
        <div class="product-details">
            <div class="title">Official Collegiate Dad Cap - The U18 Adjustable Relaxed-Fit Hat with Team Logo</div> 
            <div class="description">College reunions, university sporting events, or general campus shenanigans – express your school spirit with a look as unique as you are. Designed for daily wear, our strapback dad hat showcases a breathable all-season weave in a classic baseball silhouette that pairs with everything from your favorite tee shirt to business button-up.</div>
            <div class="seller-info">
                <span>Rutgers Store</span><br>
                <span>99.4% positive</span><br>
            </div>
            <div class="price">US $20.99</div>
            <div class="condition">Condition: New</div>
            <div class="quantity-info">
                <label for="quantity">Quantity:</label>
                <input type="number" id="quantity" name="quantity" value="1" min="1" max="100">
            </div>
            <div class="size-info">
                <label for="size">Size:</label>
                <select id="size" name="size">
                    <option value="small">Small</option>
                    <option value="medium">Medium</option>
                    <option value="large">Large</option>
                </select>
            </div>
            <div class="buttons">
                <button onclick="addToCart()" class="button">Add to Cart</button>
                <button class="button"><span class="heart-icon">&#9825;</span> Add to Wishlist</button>
            </div>
        </div>
    </div>

    <!-- History of Bids Section -->
    <div class="history-of-bids">
        <h2>History of Bids</h2>
        <div class="bid-item">
            <p>John Doe - April 28, 2024 - $21.99</p>
        </div>
        <div class="bid-item">
            <p>Jane Smith - April 27, 2024 - $20.99</p>
        </div>
        <div class="bid-item">
            <p>Zeel Patel - April 29, 2024 - $22.99</p>
        </div>
        <div class="bid-item">
            <p>Omar Elhatab - April 30, 2024 - $10.99</p>
        </div>
        <div class="bid-item">
            <p>Darsh Patel - April 27, 2024 - $20.99</p>
        </div>
        <div class="bid-item">
            <p>Sweta Desai - April 28, 2024 - $23.99</p>
        </div>
    </div>

    <!-- Place this code after the main container and before the closing body tag -->

    <div class="subcategories-section">
        <h2 class="subcategories-title">Similar Items</h2>
        <div class="subcategories-container">
            <div class="subcategory-card shirt">
                <img src="./data/RUshirt.jpg" alt="Shirts">
                <div class="subcategory-details">
                    <div class="subcategory-title">Men's Shirts</div>
                    <div class="subcategory-price">$29.99</div>
                </div>
            </div>
            <div class="subcategory-card pant">
                <img src="./data/RUpants.jpg" alt="Pants">
                <div class="subcategory-details">
                    <div class="subcategory-title">Men's Pants</div>
                    <div class="subcategory-price">$39.99</div>
                </div>
            </div>
        </div>
    </div>

    <div class="product-list-container">
        <!-- individual product card-->
        <div class="trending-product-card">
            <a href="product-page.html">
                <div class="product-title">Name</div>
                <div class="trending-product-image"></div>
                <div class="product-price">Price</div>
            </a>
        </div>
    </div>

</body>
</html>
