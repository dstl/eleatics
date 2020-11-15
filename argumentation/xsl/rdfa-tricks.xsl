<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" version="1.0">

<xsl:import href="aif.xsl"/>
<xsl:import href="../../xsl-utils/expand-iri.xsl"/>

<xsl:output method="text" encoding="utf-8" />

<xsl:template match="xhtml:html">
	<!-- We assume that the members of an rdf:Alt collection are mutually contradictory arguments  -->
	<xsl:apply-templates select=".//xhtml:*[@typeof = 'rdf:Alt']"/>
</xsl:template>


<xsl:template match="xhtml:*[@typeof = 'rdf:Alt']">
	<xsl:variable name="members" select=".//xhtml:*[@property = 'rdfs:member']"/>
	<xsl:apply-templates select=".//xhtml:*[@property = 'rdfs:member']" mode="contradict">
		<xsl:with-param name="members" select="$members"/>
	</xsl:apply-templates>
</xsl:template>


<xsl:template match="xhtml:*[@property = 'rdfs:member']" mode="contradict">

	<xsl:param name="members"/>
	
	<xsl:variable name="this" select="@resource"/>
	
	<xsl:variable name="premise">
		<xsl:call-template name="expandIRI">
			<xsl:with-param name="name" select="$this"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="partId" select="generate-id()"/>
	
	<xsl:for-each select="$members[./@resource != $this]">
	
		<xsl:variable name="conclusion">
			<xsl:call-template name="expandIRI">
				<xsl:with-param name="name" select="@resource"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="aif-canode">
			<xsl:with-param name="nodeid" select="concat('_:', $partId, generate-id())"/>
			<xsl:with-param name="premises">
				<premise><xsl:value-of select="$premise"/></premise>
			</xsl:with-param>
			<xsl:with-param name="conclusion" select="$conclusion"/>
		</xsl:call-template>
		
	</xsl:for-each>
	
</xsl:template>


</xsl:stylesheet>
 