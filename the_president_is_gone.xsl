<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">


<xsl:output method="html"/>
    
<!-- VARIABLES LIÉES AU FONCTIONNEMENT DE BASE -->
    
<!-- Variable pour l'élément head -->
<xsl:variable name="head">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>The Zine Encoding Project</title>
        <link rel="icon" type="image/x-icon" href="../img/icon.jpg"/>
        <link type="text/css" rel="stylesheet" href="css.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com"/>
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
        <link href="https://fonts.googleapis.com/css2?family=Abel&amp;display=swap" rel="stylesheet"/> 
        <script src="https://cdn.jsdelivr.net/npm/openseadragon@4.1/build/openseadragon/openseadragon.min.js"></script>
    </head>
</xsl:variable>
    
<!-- Variable pour l'élément header -->
<xsl:variable name="header">
    <header>
        <div class="header">
            <div class="header-logo"><img src="../img/icon.jpg" alt="An Icone representing the project"/></div>
            <div class="header-title"><a href="index.html"><h1>The Zine Encoding project</h1></a><p>Let's preserve the underground cultures of yesterday</p></div>
            <div class="header-autor"><p><a href="https://github.com/Anarchiviste">a work by <xsl:copy-of select="$editor"></xsl:copy-of></a></p></div>
        </div>
        <div class="navbar">
            <div class="navbutton">
                <a href="page_1.html">page n°1</a>
            </div>
            <xsl:for-each select="//div1">
                <xsl:variable name="button_id" select="./@n"/>
                <div class="navbutton">
                    <a href="page_{$button_id}.html">page n°<xsl:value-of select="$button_id"/></a>
                </div>
            </xsl:for-each>
            <div class="navbutton">
                <a href="page_index.html">Index</a>
            </div>
        </div>
    </header>
</xsl:variable>

<!-- VARIABLE LIÉES À LA PUBLICATION -->
    
<xsl:variable name="editor" select="concat(//publicationStmt//forename/text(), ' ', //publicationStmt//surname/text())"/>
<xsl:variable name="author" select="concat(//teiHeader//titleStmt//persName/text(), ' alias ', //teiHeader//titleStmt//addName/text())"/>
<xsl:variable name="title" select="upper-case(//teiHeader//title/text())"/>
<xsl:variable name="site" select="//teiHeader//sourceDesc//repository/text()"/>
<xsl:variable name="ark" select="lower-case(//teiHeader//sourceDesc//msIdentifier/@source)"/>
    
<!-- TEMPLATES DE PUBLICATION-->


<!-- CRÉATION DE L'INDEX -->
<xsl:template match="/">
    <xsl:result-document href="out/index.html">
        <html lang="en">
            <xsl:copy-of select="$head"></xsl:copy-of>
            <body>
                <xsl:copy-of select="$header"></xsl:copy-of>
                <div class="display-text">
                    <p>Hi, my name is Jules Musquin and last year I worked a lot on web archives and emergent archives of cultural memories. For this assignment, I wanted to keep working on popular writing style and archives. I chose to work on Fanzine (for fanatic magazine). They are a type of text creation made to be printed or to be published online by amateurs, they are a place expression that have been used by music fans, activists, artistes, civil right movements to spread informations and popular education. Zines use a variety of writing styles, print techniques and methods of illustration. Some zines are written by a single person, but most of them are collective expression around a common subject. Authors are always amateurs that can borrow from styles such as comics, poetry, novels, or manifestos.</p>
                        
                    <p>In France, zines are mostly used by feminists and left-wing activists to spread awareness for health, mental-health, human-right and politics. Zines are part of what we call at the École des chartes, “new heritage objects”, since these objects are not part of “legitimate culture,” libraries and institutionals archives are not very effective at preserving them and making them available. As a result, groups dedicated to preserving this memory have been set up. For examples I can cite :</p>
                    <ul>   
                        <li><a href="https://www.fanzino.org/presentation/presentation/">La Fanzinothèque à Poitiers</a> that is the biggest collection of fanzine in France and host a publishing house specially for zines.</li>
                        <li><a href="https://gittings.qzap.org/">The Queer Zine archive project</a> that host a queer zine faire in New-York.</li>
                    </ul>
                    <p>To make it easier for you to read and correct, I have decided to focus on English-language zines found on the Internet Archives. To make a useful use of XML and TEI, I will encode the material of the zine (some are in paper, printed on surgical masks, with gold paper), the illustration type (drawings, prints, engravings, collages), and the form of the text.</p>
                    <p>This test site publishes a zine by <xsl:copy-of select="$author"></xsl:copy-of> named <xsl:copy-of select="$title"/> published on <a href="{$ark}"><xsl:copy-of select="$site"/></a></p>
                </div>
            </body>
        </html>
    </xsl:result-document>
    
<!-- CRÉATION DE LA PAGE FRONT-->
    <xsl:result-document href="out/page_1.html">
        <html lang="en">
            <xsl:copy-of select="$head"/>
            <body>
                <xsl:copy-of select="$header"/>
                <div class="main-content">
                    <div class="zine-intro">
                        <xsl:copy-of select="//front//text()"/>
                    </div>
                    <div id="visioneuse">
                        <div id="_viewer" style="width: 100%; height: 800px;"/>
                        <script>
                            document.addEventListener("DOMContentLoaded", function() {
                            var _viewer = OpenSeadragon({
                            id: "_viewer",
                            prefixUrl: "https://openseadragon.github.io/openseadragon/images/",
                            sequenceMode: false,
                            defaultZoomLevel: 0.5,
                            tileSources: [
                            '<xsl:value-of select="//text//titlePage/@sameAs"/>', <!-- Le lien IIIF a été ajouté rétroactivement dans l'encodage TEI car cela fait sens dans le cadre d'un encodgage de zine. -->
                            ]
                            });
                            });
                        </script>
                    </div>
                </div>
            </body>
       </html>
   </xsl:result-document>
    
<!-- CRÉATION DES PAGES VIA DIV -->
   <xsl:for-each select="//div1">
        <xsl:variable name="page_id" select="./@n"/>
        <xsl:result-document href="out/page_{$page_id}.html">
            <html lang="en">
                <xsl:copy-of select="$head"/>
                <body>
                    <xsl:copy-of select="$header"/>
                    <div class="main-content">
                        <div class="zine-intro">
                            <xsl:for-each select=".//p">
                                <p>
                                    <xsl:copy-of select="./text()"/>
                                </p>
                            </xsl:for-each>
                            <hr/>
                            <table>
                                <tr>
                                    <th>
                                        Technique
                                    </th>
                                    <th>
                                        Material
                                    </th>
                                    <th>
                                        Color
                                    </th>
                                    <th>
                                        Ink
                                    </th>
                                </tr>
                                    <xsl:choose>
                                        <xsl:when test="./@letter_color">
                                            <tr>
                                                <th>
                                                    <xsl:value-of select="./@rendition"/>
                                                </th>
                                                <th>
                                                    <xsl:value-of select="./@material"/>
                                                </th>    
                                                <th>
                                                    <xsl:value-of select="./@material_color"/>
                                                </th>
                                                <th>
                                                    <xsl:value-of select="./@letter_color"/>
                                                </th>
                                            </tr>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each select=".//div2">
                                                <tr>
                                                    <th>
                                                        <xsl:value-of select="parent::div1/@rendition"/>
                                                    </th>
                                                    <th>
                                                        <xsl:value-of select="./@material"/>
                                                    </th>
                                                    <th>
                                                        <xsl:value-of select="./@material_color"/>
                                                    </th>
                                                    <th>
                                                        <xsl:value-of select="./@letter_color"/>
                                                    </th>
                                                </tr>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                            </table>
                        </div>
                        <div id="visioneuse">
                                <div id="_viewer" style="width: 100%; height: 800px;"/>
                                <script>
                                    document.addEventListener("DOMContentLoaded", function() {
                                    var _viewer = OpenSeadragon({
                                    id: "_viewer",
                                    prefixUrl: "https://openseadragon.github.io/openseadragon/images/",
                                    sequenceMode: false,
                                    defaultZoomLevel: 0.5,
                                    tileSources: [
                                    '<xsl:value-of select="./@sameAs"/>',
                                    ]
                                    });
                                    });
                               </script>
                        </div>
                    </div>
                </body>
            </html>
        </xsl:result-document>
   </xsl:for-each>
    
<!-- CRÉATION DE LA PAGE INDEX -->
<xsl:result-document href="out/page_index.html">
    <html lang="en">
        <xsl:copy-of select="$head"/>
        <body>
            <xsl:copy-of select="$header"/>
            <div class="display-text">
                <p>zizi</p>
            </div>
        </body>
    </html>
</xsl:result-document>
</xsl:template>

</xsl:stylesheet>