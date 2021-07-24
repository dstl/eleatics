<?xml version="1.0"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" xmlns:context="https://dstl.github.io/eleatics/argumentation/coronavirus/information.xhtml#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
	<xhtml:html>
	<xhtml:head>
		<xhtml:title>Info</xhtml:title>
		<xhtml:link rel="stylesheet" href="story.css"/>
	</xhtml:head>
	<xhtml:body>
		<xhtml:dl>
			<xsl:apply-templates select="//aif:I-node"/>
		</xhtml:dl>
	</xhtml:body>
	</xhtml:html>
</xsl:template>

<xsl:template match="aif:I-node">
	<xsl:variable name="id" select="substring-after(@rdf:about, '#')"/>
	<xhtml:dt about="{@rdf:about}" typeof="aif:I-node" property="rdfs:label" id="{@id}"><xsl:value-of select="rdfs:label"/></xhtml:dt>
	<xhtml:dd about="{@rdf:about}" typeof="aif:I-node" property="aif:claimText"><xsl:value-of select="aif:claimText"/></xhtml:dd>
</xsl:template>

</xsl:stylesheet>
 
