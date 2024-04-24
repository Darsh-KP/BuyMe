<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Web Page Template</title>
    <link rel="stylesheet" href="Home.css">
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
