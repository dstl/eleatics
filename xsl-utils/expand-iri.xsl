<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" version="1.0">

<xsl:template name="expandIRI">
	<xsl:param name="name"/>
	<xsl:param name="source" select="'_:'"/>
	<xsl:choose>
		<xsl:when test="not($name)">
			<!-- blank node: generate an ID -->
			<xsl:text>_:</xsl:text>
			<xsl:value-of select="generate-id()"/>
		</xsl:when>
		<xsl:when test="starts-with($name, '#')">
			<!-- prepend document URL if ID starts with '#' -->
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="$source"/>
			<xsl:value-of select="$name"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="contains($name, ':')">
			<!-- a URL, or a URI shortened using a prefix -->
			<xsl:text>&lt;</xsl:text>
			<xsl:variable name="prefix" select="substring-before($name, ':')"/>
			<xsl:variable name="ns" select="//namespace::*[name() = $prefix]" />
			<xsl:choose>
				<xsl:when test="$ns">
					<!-- expand the namespace prefix -->
					<xsl:value-of select="$ns" />
					<xsl:value-of select="substring-after($name, ':')"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- use URL as is -->
					<xsl:value-of select="$name"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>&gt;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<!-- blank node: use the name given -->
			<xsl:text>_:</xsl:text>
			<xsl:value-of select="$name"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
 