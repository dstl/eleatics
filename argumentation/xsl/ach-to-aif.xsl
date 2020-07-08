<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" version="1.0">

<xsl:import href="aif.xsl"/>

<xsl:param name="source" select="'_:'"/>
<xsl:variable name="hypotheses" select="//xhtml:table//xhtml:th[@scope = 'col']/@about"/>

<xsl:output method="text" encoding="utf-8" />

<xsl:template match="xhtml:html">
	<xsl:apply-templates select=".//*[@property = 'skos:definition']"/>
	<xsl:apply-templates select=".//xhtml:td[@class = 'plus' or @class = 'minus']"/>
</xsl:template>


<xsl:template match="*[@property = 'skos:definition']">

	<xsl:variable name="nodeid">
		<xsl:call-template name="expandIRI">
			<xsl:with-param name="name" select="ancestor-or-self::*[@about][1]/@about"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="isPremise">
		<xsl:choose>
			<xsl:when test="ancestor::*[@rel = 'skos:narrower'][1]/@about = 'urn:eleatics:evidence'">
				<xsl:value-of select="'true'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'false'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:call-template name="aif-inode">
		<xsl:with-param name="nodeid" select="$nodeid"/>
		<xsl:with-param name="claimText"><xsl:value-of select="."/></xsl:with-param>
		<xsl:with-param name="premise" select="$isPremise"/>
	</xsl:call-template>
	
</xsl:template>


<xsl:template match="xhtml:td[@class]">

	<xsl:variable name="premise">
		<xsl:call-template name="expandIRI">
			<xsl:with-param name="name" select="preceding-sibling::xhtml:th[1]/@about"/>
		</xsl:call-template>
	</xsl:variable>
	
 	<xsl:variable name="conclusion">
 		<xsl:variable name="index" select="count(preceding-sibling::xhtml:td) + 1"/>
		<xsl:call-template name="expandIRI">
			<xsl:with-param name="name" select="$hypotheses[$index]"/>
		</xsl:call-template>
	</xsl:variable>
	
	
	<xsl:variable name="nodeid">
		<xsl:value-of select="concat('_:', generate-id())"/>
	</xsl:variable>
	
	<xsl:choose>
		<xsl:when test="@class = 'plus'">
			<xsl:call-template name="aif-ranode">
				<xsl:with-param name="nodeid" select="$nodeid"/>
				<xsl:with-param name="premises">
					<premise><xsl:value-of select="$premise"/></premise>
				</xsl:with-param>
				<xsl:with-param name="conclusion" select="$conclusion"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="@class = 'minus'">
			<xsl:call-template name="aif-canode">
				<xsl:with-param name="nodeid" select="$nodeid"/>
				<xsl:with-param name="premises">
					<premise><xsl:value-of select="$premise"/></premise>
				</xsl:with-param>
				<xsl:with-param name="conclusion" select="$conclusion"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
	
</xsl:template>


<xsl:template name="expandIRI">
	<xsl:param name="name"/>
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
 