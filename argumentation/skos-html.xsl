<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:info="http://dstl.gov.uk/example/ach/info#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="rdf rdfs owl" version="1.0">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>


<xsl:template match="/">
<html>
<head>
<title>Definitions</title>
<style type="text/css">

dt {
	padding-top: 1em;
	font-style: italic;
	font-size: small;
}

dd.label {
	font-weight: bold;
}

</style>
</head>
<body vocab="http://www.w3.org/2004/02/skos/core#">
<h2>FORTITUDE SOUTH</h2>

<dl>
	<xsl:apply-templates select="//skos:Concept">
		<xsl:sort select="skos:notation"/>
	</xsl:apply-templates>
</dl>
</body>
</html>
</xsl:template>


<xsl:template match="skos:Concept">
<xsl:variable name="uri">
	<xsl:apply-templates select="." mode="uri"/>
</xsl:variable>
<dt about="{$uri}" typeof="Concept" property="notation">
	<xsl:value-of select="skos:notation"/>
</dt>
<dd class="label" about="{$uri}" property="prefLabel">
  	<xsl:value-of select="skos:prefLabel"/>
</dd>
<dd about="{$uri}" property="definition">
  	<xsl:value-of select="skos:definition"/>
</dd>
</xsl:template>


<xsl:template match="skos:Concept" mode="uri">
<xsl:choose>
	<xsl:when test="@rdf:about">
		<xsl:value-of select="@rdf:about"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="concat('info:', skos:notation)"/>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>


</xsl:stylesheet>