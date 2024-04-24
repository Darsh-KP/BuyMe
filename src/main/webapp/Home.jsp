<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Web Page Template</title>
    <link rel="stylesheet" href="Home.css">
    <style>
        /* Additional CSS for improved styling */
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            position: relative; /* Added to make space for the fixed navbar */
        }

        .navbar {
            background-color: var(--background);
            overflow: hidden;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000; /* Added to ensure navbar stays on top */
        }

        .nav-list {
            list-style-type: none;
            margin: 0;
            padding: 0;
            float: right;
        }

        .nav-list li {
            display: inline;
            margin-left: 20px;
        }

        .nav-list li a {
            color: var(--primary);
            text-decoration: none;
            padding: 10px 15px;
            transition: all 0.3s ease;
        }

        .nav-list li a:hover {
            background-color: var(--extra2);
        }

        .logo img {
            width: auto;
            height: auto;
            border-radius: 50%;
            max-width: 90px;
        }

        .box-main {
            padding: 20px;
            margin: 80px auto 0; /* Adjusted top margin to account for navbar height */
            max-width: 800px;
            text-align: center;
        }

        .text-big {
            font-size: 32px;
            margin-bottom: 20px;
        }

        .text-small {
            font-size: 14px;
            line-height: 1.6;
        }

        .background {
            background-color: var(--background);
            color: #333;
        }

        .section {
            padding: 50px 0;
        }

        .thumbnail img {
            max-width: 100%;
            height: auto;
        }

        .text-footer {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>

<body>
    <nav class="navbar background">
        <div class="logo">
            <img src="data/LogoFinal.png" alt="Logo">
        </div>
        <ul class="nav-list">
            <li><a href="#home">Home</a></li>
            <li><a href="#tickets">Tickets</a></li>
            <li><a href="#listings">Listings</a></li>
            <li><a href="#wishlist">Wishlist</a></li>
        </ul>
        <div class="rightnav">
            <input type="text" name="search" id="search" placeholder="Search">
            <button class="btn btn-sm">Search</button>
        </div>
    </nav>

    <section class="firstsection background" id="web">
        <div class="box-main">
            <div class="firstHalf">
                <button <h1 class="text-big" >Listings</h1> </button>
                <p class="text-small">
                    HTML stands for HyperText Markup Language.
                    It is used to design web pages using a markup
                    language. HTML is the combination of Hypertext
                    and Markup language. Hypertext defines the
                    link between the web pages. A markup language
                    is used to define the text document within tag
                    which defines the stformat.
                </p>
            </div>
        </div>
    </section>

    <section class="secondsection background" id="program">
        <div class="box-main">
            <div class="firstHalf">
                <button <h1 class="text-big" >Biding</h1> </button>
                <p class="text-small">
                    C is a procedural programming language. It
                    was initially developed by Dennis Ritchie
                    as a system programming language to write
                    operating system. The main features of C
                    language include low-level access to memory,
                    simple set of keywords, and clean style,
                    these features make C language suitable for
                    system programming like operating system or
                    compiler development.
                </p>
            </div>
        </div>
    </section>

    <section class="section background" id="java">
        <div class="box-main">
            <div class="paras">
                <button <h1 class="text-big" >Wishlist</h1> </button>
                <p class="sectionSubTag text-small">
                    Java has been one of the most popular
                    programming languages for many years.
                    Java is Object Oriented. However, it is
                    not considered as pure object-oriented
                    as it provides support for primitive
                    data types (like int, char, etc.). The
                    Java codes are first compiled into byte
                    code (machine independent code). Then
                    the byte code is run on Java Virtual
                    Machine (JVM) regardless of the
                    underlying architecture.
                </p>
            </div>

            <div class="thumbnail">
                <img src="img.png" alt="laptop image">
            </div>
        </div>
    </section>

    <footer class="background">
        <p class="text-footer">Copyright ©-All rights are reserved</p>
    </footer>
</body>

</html>
