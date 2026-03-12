<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">


<xsl:output method="html"/>
    
<!-- CONSIGNES -->
<!-- 
    [X] 4 fonctions Xpath différentes
        - concat, string join, upper-case et count dans la section variable 
        
    [X] 2 prédicats Xpath différents 
        - not et or, not dans la section variable et or dans les deux tableaux qui itèrent sur les enfants de titlePage
    
    [X] 2 variables XSLT
        
    [X] 2 règles avec plusieurs conditions
        - plusieurs Choose dans la création des pages grâce à div
        
    [X] 1 règle avec une ou plusieurs boucles
        
    [X] Navigation avec des liens hypertextes autre que la navbar et le footer
        - J'ai créé des boutons précédents et suivant s'intégrant au body
-->
    
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
            <div class="header-logo"><a href="https://en.wikipedia.org/wiki/Zine"><img src="../img/icon.jpg" alt="An Icone representing the project"/></a></div>
            <div class="header-title"><a href="index.html"><h1>The Zine Encoding project</h1></a><p>Let's preserve the underground cultures of yesterday</p></div>
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
    
<xsl:variable name="footer">
    <footer>
        <div class="footer">
            <div class="footer_logo">
                <a href="https://www.chartes.psl.eu/"><img src="../img/logo-chartes-psl-coul.png" alt="Logo de l'École nationale des Chartes - PSL"/></a>
            </div>
            <div class="footer-autor"><p><a href="https://github.com/Anarchiviste">a work by <xsl:copy-of select="$editor"></xsl:copy-of></a></p></div>
        </div>
    </footer>
</xsl:variable>

<!-- Variable de header pour les tables -->
<xsl:variable name="table">
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
</xsl:variable>

<!-- VARIABLE LIÉES À LA PUBLICATION --> <!-- j'ai utilisé pleins de fonctions pour rentrer dans les consignes mais ce n'est pas forcément pertinent -->
    
<xsl:variable name="editor" select="string-join((//publicationStmt//forename/text(), //publicationStmt//surname/text()), ' ')"/>
    
<xsl:variable name="author" select="concat(//teiHeader//titleStmt//persName/text(), ' alias ', //teiHeader//titleStmt//addName/text())"/>
    
<xsl:variable name="title" select="upper-case(//teiHeader//title/text())"/>
    
<xsl:variable name="site" select="//teiHeader//repository/text()"/>
    
<xsl:variable name="ark" select="lower-case(//teiHeader//msIdentifier/@source)"/>
    
<xsl:variable name="licence" select="//teiHeader//licence//text()"/>
    
<xsl:variable name="licence_uri" select="//teiHeader//licence/@target"/>
    
<xsl:variable name="number_pages">
    <xsl:value-of select="count(//div1) + count(//front/titlePage)"/> pages,  <!-- additionne les valeurs des div1 + titlePage -->
</xsl:variable>
    
<xsl:variable name="number_materials">
    <xsl:value-of select="count(//div1[not(@material = preceding-sibling::div1/@material)])"/> 
    <!-- compte le nombre d'occurence de l'attribut material 
        en distinguant les doublons avec not, mais j'ai jamais réussi à le faire fonctionner correctement, 
        il y a toujours un doublon qui se faufile, il suffit de faire -1 pour avoir le chiffre réel-->
</xsl:variable>
    
<xsl:variable name="number_ink">
    <xsl:value-of select="count(//front/titlePage//*[@letter_color][not(@letter_color = following::*/@letter_color)]) + count(//div1[not(@letter_color = preceding-sibling::div1/@letter_color)]/@letter_color) + count(//div2[not(@letter_color = preceding-sibling::div2/@letter_color) and not(@letter_color = //div1/@letter_color)and not(@letter_color = //front/titlePage//*/@letter_color)]/@letter_color)"/> 
    <!-- Super long mais globalement la même chose que la fonction précédente : compte distinctement les valeurs de titlePage, div1 et div2 et les additionnes pour donner le nombre d'encres différentes utilisées-->
</xsl:variable>

<!-- TEMPLATES DE PUBLICATION-->


<!-- CRÉATION DE L'INDEX -->
<xsl:template match="/">
    <xsl:result-document href="out/index.html">
        <html lang="en">
            <xsl:copy-of select="$head"></xsl:copy-of>
            <body>
                <xsl:copy-of select="$header"></xsl:copy-of>
                <div class="display-text">
                    <p>You can find the <a href="https://github.com/Anarchiviste/tei_assignment_3">original project in TEI</a> and my custom rng schema and the XSLT stylesheet used for this work on my <a href="{$site}">github</a> </p>
                    <p>Hi, my name is <xsl:value-of select="$editor"/> and last year I worked a lot on web archives and emergent archives of cultural memories. For this assignment, I wanted to keep working on popular writing style and archives. I chose to work on Fanzine (for fanatic magazine). They are a type of text creation made to be printed or to be published online by amateurs, they are a place expression that have been used by music fans, activists, artistes, civil right movements to spread informations and popular education. Zines use a variety of writing styles, print techniques and methods of illustration. Some zines are written by a single person, but most of them are collective expression around a common subject. Authors are always amateurs that can borrow from styles such as comics, poetry, novels, or manifestos.</p>
                        
                    <p>In France, zines are mostly used by feminists and left-wing activists to spread awareness for health, mental-health, human-right and politics. Zines are part of what we call at the École des chartes, “new heritage objects”, since these objects are not part of “legitimate culture,” libraries and institutionals archives are not very effective at preserving them and making them available. As a result, groups dedicated to preserving this memory have been set up. For examples I can cite :</p>
                    <ul>   
                        <li><a href="https://www.fanzino.org/presentation/presentation/">La Fanzinothèque à Poitiers</a> that is the biggest collection of fanzine in France and host a publishing house specially for zines.</li>
                        <li><a href="https://gittings.qzap.org/">The Queer Zine archive project</a> that host a queer zine faire in New-York.</li>
                    </ul>
                    <p>To make it easier for you to read and correct, I have decided to focus on English-language zines found on the Internet Archives. To make a useful use of XML and TEI, I will encode the material of the zine (some are in paper, printed on surgical masks, with gold paper), the illustration type (drawings, prints, engravings, collages), and the form of the text.</p>
                    <p>This test site publishes a zine by <xsl:copy-of select="$author"></xsl:copy-of> named <xsl:copy-of select="$title"/> published on <a href="{$ark}"><xsl:copy-of select="$site"/></a></p>
                    <p>The orignal work is available within <a href="{$licence_uri}"><xsl:value-of select="$licence"/></a> licence agreement</p>
                </div>
                <xsl:copy-of select="$footer"/>
            </body>
        </html>
    </xsl:result-document>
    
<!-- CRÉATION DE LA PAGE FRONT-->
    <xsl:result-document href="out/page_1.html">
        <html lang="en">
            <xsl:copy-of select="$head"/>
            <body>
                <xsl:copy-of select="$header"/>
                <div class="main-content"> <!-- Main Content est le conteneur flexbox pour organiser le texte et la visionneuse -->
                    <div class="zine-intro">
                        <xsl:for-each select="//front/titlePage/child::*"> <!-- pour chaques enfants de titlepages, sélectionne la valeur du noeud courant -->
                            <p>
                                <xsl:value-of select="."/>
                            </p>
                        </xsl:for-each>
                        <hr/>
                        <table>
                            <xsl:copy-of select="$table"/>
                            <xsl:for-each select="//front/titlePage//*[@material or @letter_color]"> <!-- Cette boucle itère sur les enfants de TitlePage pour créer le tableau d'information de la page 1 -->
                                <tr>
                                    <td>
                                        <xsl:value-of select="//front/titlePage/@rendition"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="@material"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="@material_color"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="@letter_color"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                        <div class="bouton_div">
                            <xsl:variable name="n_suivant">
                                <xsl:value-of select="//titlePage/@n"/>
                            </xsl:variable>
                            <div class="buton">
                                <a>page n° <xsl:value-of select="$n_suivant"/></a> 
                            </div>
                            <div class="buton">
                                <a href="page_{$n_suivant + 1}.html">page suivante</a>
                            </div>
                        </div>
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
                            '<xsl:value-of select="//text//titlePage/@sameAs"/>', <!-- L'URI IIIF a été ajouté rétroactivement dans l'encodage TEI car cela fait sens dans le cadre d'un encodgage de zine. -->
                            ]
                            });
                            });
                        </script>
                    </div>
                </div>
                <xsl:copy-of select="$footer"/>
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
                            <xsl:choose>
                                <xsl:when test=".//div2"> <!-- cas pour les pages utilisant div2 -->
                                    <xsl:for-each select=".//div2/child::*"> 
                                        <p>
                                            <xsl:value-of select="."/>
                                        </p>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise> <!-- cas pour les pages avec uniquement div 1 -->
                                    <xsl:for-each select="./child::*">
                                        <p>
                                            <xsl:value-of select="."/>
                                        </p>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                            <hr/>
                            <table>
                                <xsl:copy-of select="$table"/>
                                <xsl:choose> <!-- Cette règle existe pour s'accomoder des pages avec plusieurs couleurs par page. Dans ces cas là l'information n'est pas encodée dans div1, mais en utilisant div2 -->
                                    <xsl:when test="./@letter_color"> <!-- cas pour les pages monochromes -->
                                        <tr>
                                            <td>
                                                <xsl:value-of select="./@rendition"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="./@material"/>
                                            </td>    
                                            <td>
                                                <xsl:value-of select="./@material_color"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="./@letter_color"/>
                                            </td>
                                        </tr>
                                    </xsl:when>
                                    <xsl:otherwise> <!-- cas pour les pages polychromes -->
                                        <xsl:for-each select=".//div2">
                                            <tr>
                                                <td>
                                                    <xsl:value-of select="parent::div1/@rendition"/>
                                                </td>
                                                <td>
                                                    <xsl:value-of select="./@material"/>
                                                </td>
                                                <td>
                                                    <xsl:value-of select="./@material_color"/>
                                                </td>
                                                <td>
                                                    <xsl:value-of select="./@letter_color"/>
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </table>
                            <div class="bouton_div">
                                <xsl:choose>
                                    <xsl:when test="./@n != 11"> <!-- Cette règle s'applique à toutes les pages sauf la 1 et la 11 -->
                                        <xsl:variable name="n_suivant">
                                            <xsl:value-of select="./@n"/> <!-- sélectionne le n du noeud courant -->
                                        </xsl:variable>
                                        <div class="buton">
                                            <a href="page_{$n_suivant - 1}.html">page précédente</a> <!-- ajoute -1 au n du noeud courant pour créer un bouton qui rétrograde-->
                                        </div>
                                        <div class="buton">
                                            <a>page n° <xsl:value-of select="$n_suivant"/></a> <!-- créer un bouton qui ne sert de repère à l'utilisateur-->
                                        </div>
                                        <div class="buton">
                                            <a href="page_{$n_suivant + 1}.html">page suivante</a> <!-- ajoute +1 au n du noeud courant pour créer un bouton qui avance dans les pages -->
                                        </div>
                                    </xsl:when>
                                    <xsl:otherwise> <!-- cas pour la dernière page qui est la dernière et ne possède pas de page suivante à afficher-->
                                        <xsl:variable name="n_suivant">
                                            <xsl:value-of select="./@n"/>
                                        </xsl:variable>
                                        <div class="buton">
                                            <a href="page_{$n_suivant - 1}.html">page précédente</a>
                                        </div>
                                        <div class="buton">
                                            <a>page n° <xsl:value-of select="$n_suivant"/></a>
                                        </div>
                                        <div class="buton">
                                            <a href="page_index.html">Index</a>
                                        </div>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>
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
                    <xsl:copy-of select="$footer"/>
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
                <p>
                    Fanzines often contain little information or names, making it difficult to create an index. As you can understand, my TEI project was focused on encoding structures, materials, and techniques, not on linguistics or history.
                </p>
                <div class="zine-intro">
                    <p>In this Zine, the editor recensed <xsl:copy-of select="$number_pages"/> using 
                        <xsl:copy-of select="$number_materials - 1"></xsl:copy-of> <!-- le fameux -1 cité plus haut pour avoir le compte réel de matériaux utilisés -->
                        differents materials and 
                        <xsl:copy-of select="$number_ink"></xsl:copy-of>
                        color of ink.
                    </p>
                <table> <!-- Cette partie réagrège toutes les informations matérielles dans un grand tableau-->
                    <tr>
                        <th>
                            Page
                        </th>
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
                    <xsl:for-each select="//front/titlePage//*[@material or @letter_color]"> <!-- Cette boucle itère sur les enfants de TitlePage pour créer le tableau d'information de la page 1 -->
                        <tr>
                            <td>
                                page n° <xsl:value-of select="//parent::titlePage/@n"/>
                            </td>
                            <td>
                                <xsl:value-of select="//front/titlePage/@rendition"/>
                            </td>
                            <td>
                                <xsl:value-of select="@material"/>
                            </td>
                            <td>
                                <xsl:value-of select="@material_color"/>
                            </td>
                            <td>
                                <xsl:value-of select="@letter_color"/>
                            </td>
                        </tr>
                    </xsl:for-each>
                    <xsl:for-each select="//div1"> <!-- Cette boucle itère sur toutes les autres pages -->
                        <xsl:choose> <!-- Cette règle existe pour s'accomoder des pages avec plusieurs couleurs par page. Dans ces cas là l'information n'est pas encodée dans div1, mais en utilisant div2 -->
                            <xsl:when test="./@letter_color"> <!-- cas pour les pages monochromes -->
                                <tr>
                                    <td>
                                        page n° <xsl:value-of select="./@n"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="./@rendition"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="./@material"/>
                                    </td>    
                                    <td>
                                        <xsl:value-of select="./@material_color"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="./@letter_color"/>
                                    </td>
                                </tr>
                            </xsl:when>
                            <xsl:otherwise> <!-- cas pour les pages polychromes -->
                                <xsl:for-each select=".//div2">
                                    <tr>
                                        <td>
                                            page n° <xsl:value-of select="./parent::div1/@n"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="parent::div1/@rendition"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./@material"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./@material_color"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./@letter_color"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </table>
                </div>
            </div>
            <xsl:copy-of select="$footer"/>
        </body>
    </html>
</xsl:result-document>
</xsl:template>

</xsl:stylesheet>