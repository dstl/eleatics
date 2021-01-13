<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" version="1.0">

<xsl:import href="aif.xsl"/>
<xsl:import href="../../xsl-utils/expand-iri.xsl"/>

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
	
	<xsl:call-template name="aif-inode">
		<xsl:with-param name="nodeid" select="$nodeid"/>
		<xsl:with-param name="claimText"><xsl:value-of select="."/></xsl:with-param>
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
		<xsl:call-template name="expandIRI">
			<xsl:with-param name="name" select="@about"/>
		</xsl:call-template>
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


</xsl:stylesheet>
 