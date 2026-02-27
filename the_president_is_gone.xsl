<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">

    <xsl:output method="html"/>
<!-- VARIABLES LIÉES AU FONCTIONNEMENT DE BASE -->
<xsl:variable name="head">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>The Zine Encoding Project</title>
        <link rel="icon" type="image/x-icon" href="../img/icon.jpg"/>
        <link type="text/css" rel="stylesheet" href="css.css"/>
    </head>
</xsl:variable>
<xsl:variable name="header">
    <header>
        <div class="header">
            <div class="header-logo"><img src="../img/icon.jpg" width="200%"/></div>
            <div class="header-title"><h1>The Zine Encoding project</h1><p>Let's preserve the underground cultures of yesterday</p></div>
            <div class="header-autor">a work by <h2><xsl:copy-of select="$editor"></xsl:copy-of></h2></div>
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
        </div>
    </header>
</xsl:variable>

<!-- VARIABLE LIÉES À LA PUBLICATION -->
<xsl:variable name="editor" select="concat(//publicationStmt//forename/text(), ' ', //publicationStmt//surname/text())"/>

<!-- CRÉATION DE L'INDEX -->
<xsl:template match="/">
    <xsl:result-document href="out/index.html">
        <html>
            <xsl:copy-of select="$head"></xsl:copy-of>
            <body>
                <xsl:copy-of select="$header"></xsl:copy-of>
                <div class="display_text">
                    <p>
                        
                    </p>
                </div>
            </body>
        </html>
    </xsl:result-document>
    
<!-- CRÉATION DE LA PAGE FRONT-->
   <xsl:result-document href="out/page_1.html">
       <html>
           <xsl:copy-of select="$head"/>
           <body>
                <xsl:copy-of select="$header"/>
           </body>
       </html>
   </xsl:result-document>
    
<!-- CRÉATION DES PAGES VIA DIV -->
    <xsl:for-each select="//div1">
        <xsl:variable name="page_id" select="./@n"/>
        <xsl:result-document href="out/page_{$page_id}.html">
            <html>
                <xsl:copy-of select="$head"/>
                <body>
                    <xsl:copy-of select="$header"></xsl:copy-of>
                </body>
            </html>
        </xsl:result-document>
    </xsl:for-each>
</xsl:template>

</xsl:stylesheet>