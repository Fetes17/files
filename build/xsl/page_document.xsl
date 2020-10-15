<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
  <xsl:import href="tei_header.xsl"/>
  <xsl:import href="tei_flow.xsl"/>
  <xsl:import href="page.xsl"/>
  <xsl:output indent="yes" encoding="UTF-8" method="xml" omit-xml-declaration="yes"/>
  <xsl:key name="name" match="tei:name[not(ancestor::tei:teiHeader)]" use="normalize-space(@key)"/>
  <!--
  <xsl:param name="locorum"/>
  <xsl:variable name="place" select="document($locorum)/*/*"/>
  -->
  <xsl:variable name="ana" select="document('../../index/ana.xml')/*/*"/>
  <xsl:key name="placeName" match="tei:placeName" use="normalize-space(@key)"/>
  <xsl:key name="persName" match="tei:persName" use="normalize-space(@key)"/>
  <xsl:key name="tech" match="tei:tech" use="normalize-space(@type)"/>
  <xsl:key name="ana" match="*[@ana]" use="normalize-space(@ana)"/>
  <xsl:key name="when" match="tei:date[@when]" use="normalize-space(@when)"/>
  <xsl:variable name="lf" select="'&#10;'"/>
  <xsl:variable name="type" select="substring-before(substring-after($filename, '_'), '_')"/>
  <xsl:template match="/">
    <article class="document">
      <div id="doc_bibl">
        <div class="container">
          <xsl:choose>
            <xsl:when test="/tei:TEI/tei:sourceDoc">
              <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt"/>
              <xsl:apply-templates select="/tei:TEI/tei:sourceDoc"/>
              <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:notesStmt"/>
              <xsl:call-template name="download"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="length" select="string-length(normalize-space(/tei:TEI/tei:text))"/>
              <div class="row">
                <div class="col-9">
                  <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt"/>
                  <xsl:call-template name="download"/>
                  <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:notesStmt"/>
                  <xsl:choose>
                    <xsl:when test="$length &lt; 700">
                      <xsl:apply-templates select="/tei:TEI/tei:text"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <a href="../texte/{$filename}{$_html}" class="textofiche">
                        <div class="blurb">
                          <xsl:call-template name="ellipse">
                            <xsl:with-param name="node" select="/tei:TEI/tei:text/tei:body"/>
                            <xsl:with-param name="length" select="600"/>
                          </xsl:call-template>
                        </div>
                        <div  class="textofiche">
                          <span class="link">▶ Texte intégral</span>
                        </div>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </div>
                <div class="col-3">
                  <a>
                    <xsl:choose>
                      <xsl:when test="$length &gt; 650">
                        <xsl:attribute name="href">
                          <xsl:text>../texte/</xsl:text>
                          <xsl:value-of select="$filename"/>
                          <xsl:value-of select="$_html"/>
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:when test="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc//tei:ptr">
                        <xsl:attribute name="href">
                          <xsl:value-of select="(/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc//tei:ptr)[1]/@target"/>
                        </xsl:attribute>
                        <xsl:attribute name="target">_blank</xsl:attribute>
                      </xsl:when>
                    </xsl:choose>
                    <img src="{$filename}.jpg"/>
                  </a>
                </div>
              </div>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </div>
      <div class="container">
        <div class="row">
          <div class="col-9 doc_ventre"> 
            %lieux% 
            %personnes% 
          </div>
          <div class="col-3">
            <xsl:call-template name="events"/>
          </div>
        </div>
        <div class="row techs">
          <div class="col-9 doc_ventre"> 
            <xsl:call-template name="themes"/>
          </div>
          <div class="col-3">
            %techniques% 
            <xsl:call-template name="anas"/>
          </div>
        </div>
      </div>
      <div class="bg-gray">
        <div class="container">
          <xsl:call-template name="relations"/>
        </div>
      </div>
    </article>
  </xsl:template>
  <xsl:template name="relations">
    <h2>Documents liés</h2>
    <p><small>Documents pris au hasard, non signficatifs</small></p>
    <h3>Inclusions</h3>
    <a class="document" href="merveilles17_image_pie1-comparse.html">
      <img src="merveilles17_image_pie1-comparse.jpg"/>
      <div>
        <div class="title">Première journée. Comparse du Roy et de ses chevaliers, auec toutes leurs suittes, dans le Camp de la course de bague, pendant l'Ouuerture : de la feste faite par les recits d'Apollon et des quatre siecles, assis sur un grand char de triomphe</div>
        <div class="publication">Paris – RESERVE QB-201 (46)-FOL, Hennin, 4209</div>
      </div>
    </a>
    <a class="document" href="merveilles17_image_pie1festin.html">
      <img src="merveilles17_image_pie1festin.jpg"/>
      <div>
        <div class="title">Première journée. Festin du Roy, et des Reynes auec plusieurs Princesses et Dames serui de tous les mets et presens faits par les Dieux et les quatre saisons</div>
        <div class="publication"> – RESERVE QB-201 (46)-FOL, Hennin, 4212</div>
      </div>
    </a>
    <h3>Même événement</h3>
    <a class="document" href="merveilles17_i_pie1673.html">
      <img src="merveilles17_i_pie1673.jpg"/>
      <div>
        <div class="title">Les plaisirs de l’isle enchantée. Course de bague; collation ornée de machines; comedie, meslée de danse et de musique; ballet du palais d’Alcine; feu d’artifice; et autres festes galantes et magnifiques faites par le Roy a Versailles le VII. May M.DC.LXIV. et continuées plusieurs autres jours</div>
        <div class="publication">Paris, imprimerie royale – 1673</div>
      </div>
    </a>
    <a class="document" href="merveilles17_i_gdv_felibien1668.html">
      <img src="merveilles17_i_gdv_felibien1668.jpg"/>
      <div>
        <div class="title"> Relation de la feste de Versailles. Du dix-huitième juillet mil six cens soixante-huit. Par André Félibien. </div>
        <div class="publication">Paris, Pierre le Petit – 1668</div>
      </div>
    </a>
  </xsl:template>
  <!-- Techniques d’écriture -->
  <xsl:template name="anas">
    <xsl:if test="//*[@ana][@ana != 'description']">
      <div class="doc_ana">
        <h2>Techniques d’écriture</h2>
        <ul>
          <xsl:for-each select="//*[@ana][@ana != 'description'][count(. | key('ana', normalize-space(@ana))[1]) = 1]">
            <xsl:sort select="count(key('ana', @ana))" order="descending"/>
            <xsl:variable name="key" select="@ana"/>
            <li>
              <xsl:value-of select="$ana[@xml:id = $key]/tei:term"/>
              <xsl:text> </xsl:text>
              <b>
                <xsl:text>(</xsl:text>
                <xsl:value-of select="count(key('ana', $key))"/>
                <xsl:text>)</xsl:text>
              </b>
            </li>
          </xsl:for-each>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template name="themes">
    <div id="doc_theme">
      <h2>Thèmes</h2>
      <xsl:variable name="tag">name</xsl:variable>
      <xsl:for-each select="//*[name() = $tag][count(. | key($tag, normalize-space(@key|@type))[1]) = 1][not(ancestor::tei:teiHeader)]">
        <xsl:sort select="count(key($tag, @key|@type))" order="descending"/>
        <xsl:choose>
          <xsl:when test="position() &gt; 200"/>
          <xsl:when test="@key">
            <a href="#" class="theme">
              <xsl:value-of select="@key"/>
            </a>
            <xsl:text> </xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </div>
  </xsl:template>
  <xsl:template name="events">
    <div id="doc_chrono">
      <h2>Événements liés</h2>
      <ul>
        <xsl:for-each select="//tei:date[count(. | key('when', normalize-space(@when))[1]) = 1][not(ancestor::tei:teiHeader)]">
          <xsl:sort select="@when"/>
          <li class="event">
            <span class="year">
              <xsl:value-of select="substring(@when, 1, 4)"/>
            </span>
            <span class="day">
              <xsl:value-of select="number(substring(@when, 9, 2))"/>
            </span>
            <span class="month">
              <xsl:call-template name="month"/>
            </span>
          </li>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>
  <xsl:template name="download">
    <xsl:for-each select="(/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc//tei:ptr)[1]">
      <div class="download">
        <a class="download" target="_blank">
          <xsl:attribute name="href">
            <xsl:value-of select="@target"/>
          </xsl:attribute>
          <svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 24 24" width="24"><path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/></svg>
          <xsl:text>Document source</xsl:text>
        </a>
      </div>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="ellipse">
    <xsl:param name="node"/>
    <xsl:param name="length"/>
    <xsl:variable name="text">
      <xsl:variable name="txt1">
        <xsl:apply-templates select="$node" mode="txt"/>
      </xsl:variable>
      <xsl:variable name="txt2">
        <xsl:value-of select="normalize-space($txt1)"/>
      </xsl:variable>
      <xsl:variable name="len2" select="string-length($txt2)"/>
      <xsl:variable name="last" select="substring($txt2, $len2)"/>
      <xsl:choose>
        <xsl:when test="$last = '§'">
          <xsl:value-of select="normalize-space(substring($txt2, 1, $len2 - 1))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$txt2"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($text) &lt;= $length">
        <xsl:value-of select="$text"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="less" select="10"/>
        <xsl:value-of select="substring($text, 1, $length - $less)"/>
        <xsl:value-of select="substring-before(concat(substring($text,$length - $less+1, $length), ' '), ' ')"/>
        <xsl:text> […]</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*" mode="txt">
    <xsl:apply-templates mode="txt"/>
  </xsl:template>
  <xsl:template match="tei:p | tei:l | tei:head" mode="txt">
    <xsl:apply-templates mode="txt"/>
    <xsl:text disable-output-escaping="yes"> § </xsl:text>
  </xsl:template>
  <xsl:template match="tei:note" mode="txt"/>
  <xsl:template name="pbgallica">
    <xsl:variable name="facs" select="@facs"/>
    <xsl:choose>
      <xsl:when test="normalize-space($facs) != ''">
        <!-- https://gallica.bnf.fr/ark:/12148/bpt6k1526131p/f104.image -->
        <a class="pb" href="{$facs}" target="_blank">
          <span>
            <xsl:if test="translate(@n, '1234567890', '') = ''">p. </xsl:if>
            <xsl:value-of select="@n"/>
          </span>
          <img src="{substring-before($facs, '/ark:/')}/iiif/ark:/{substring-after($facs, '/ark:/')}/full/150,/0/native.jpg"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <span class="pb">
          <xsl:text>[</xsl:text>
          <xsl:if test="translate(@n, '1234567890', '') = ''">p. </xsl:if>
          <xsl:value-of select="@n"/>
          <xsl:text>]</xsl:text>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--
  <xsl:template match="tei:bibl">
    <div class="bibl">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tei:title">
    <cite class="title">
      <xsl:apply-templates/>
    </cite>
  </xsl:template>

  <xsl:template match="tei:figure">
    <figure>
      <xsl:apply-templates/>
    </figure>
  </xsl:template>

  <xsl:template match="tei:figDesc">
    <figcaption>
      <xsl:apply-templates/>
    </figcaption>
  </xsl:template>

  <xsl:template match="tei:graphic">
    <img src="{@url}"/>
  </xsl:template>

  <xsl:template match="*">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>
  -->
</xsl:transform>
