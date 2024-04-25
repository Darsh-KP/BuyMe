<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mainstays Vanilla Scented Single-Wick Large Jar Candle</title>
    <style>
        /* CSS styles */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f2f2f2;
        }
        .container {
            display: flex;
            max-width: 800px;
            margin: 20px auto;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        .image-container {
            flex: 1;
        }
        .image-container img {
            width: 100%;
            height: auto;
            display: block;
        }
        .product-details {
            flex: 1;
            padding: 20px;
        }
        .title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .seller-info {
            margin-bottom: 10px;
        }
        .price {
            font-size: 24px;
            color: #007bff;
            margin-bottom: 10px;
        }
        .condition {
            margin-bottom: 10px;
        }
        .quantity-info, .size-info {
            margin-bottom: 10px;
        }
        .buttons {
            margin-top: 20px;
            display: flex;
        }
        .button {
            flex: 1;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .button:hover {
            background-color: #0056b3;
        }
        .heart-icon {
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="image-container">
            <!-- Placeholder image for candle -->
            <img src="candle.jpg" alt="Mainstays Vanilla Scented Single-Wick Large Jar Candle">
        </div>
        <div class="product-details">
            <div class="title">Mainstays Vanilla Scented Single-Wick Large Jar Candle</div> 
            <div class="seller-info">
                <span>PHT Express Store</span><br>
                <span>99.4% positive</span><br>
            </div>
            <div class="price">US $11.69</div>
            <div class="condition">Condition: New</div>
            <div class="quantity-info">
                <label for="quantity">Quantity:</label>
                <input type="number" id="quantity" name="quantity" value="1" min="1" max = "100">
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

    <script>
        function addToCart() {
            // Get selected values
            var quantity = document.getElementById('quantity').value;
            var size = document.getElementById('size').value;
            
            // Perform further actions (e.g., send data to server, update cart)
            alert("Added " + quantity + " item(s) of size " + size + " to cart!");
        }
    </script>
</body>
</html>
