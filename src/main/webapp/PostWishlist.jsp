<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Wishlist</title>
    <link rel="stylesheet" href="PostWishlist.css">
     <link rel="icon" type="image/x-icon" href="./data/Favicon.png">
</head>
<body>


    <div class="container">
        <h1>New Wishlist</h1>
        <form action="#">
            <div class="form-group">
                <label for="subcategory">Category:</label>
                <select id="subcategory" name="subcategory">
                    <option value="" disabled selected>Select Category</option>
                    <option value="shirt">Shirt</option>
                    <option value="pant">Pant</option>
                    <option value="hat">Hat</option>
                </select>
            </div>
            <div class="form-group">
                <label for="maxThreshold">Max Threshold:</label>
                <input type="number" id="maxThreshold" name="maxThreshold" placeholder="Enter max value">
            </div>
            <div class="form-group" id="attributes">
                <label for="addAtrrubute">Add Attribute:</label>
                <button type="button" id="addAttribute">Add Attribute</button>
                <div class="attribute">
                    <select name="size">
                        <option value="" disabled selected>Select Size</option>
                        <option value="XS">XS</option>
                        <option value="S">S</option>
                        <option value="M">M</option>
                        <option value="L">L</option>
                        <option value="XL">XL</option>
                    </select>
                    <input type="text" name="color" placeholder="Color">
                    <button type="button" class="remove-attribute">Remove</button>
                </div>
            </div>
            <button type="submit">Post to Wishlist</button>
        </form>
    </div>
    <script src="script.js"></script>
</body>
</html>
