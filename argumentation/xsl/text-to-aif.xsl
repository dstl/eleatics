<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" version="1.0">

<xsl:import href="aif.xsl"/>

<xsl:output method="text" encoding="utf-8" indent="yes"/>

<xsl:template match="/">
	<xsl:apply-templates select=".//xhtml:p"/>
</xsl:template>


<xsl:template match="xhtml:p">
	<xsl:apply-templates select="*"/>	
</xsl:template>


<xsl:template match="xhtml:*[@class = 'support' or @class = 'contradiction']">
	<xsl:variable name="nodetype">
		<xsl:apply-templates select="." mode="getType"/>
	</xsl:variable>
	<xsl:variable name="conclusion" select="concat('&lt;', 'urn:eleatics:', ../xhtml:*[@class = 'conclusion']/@about, '&gt;')"/>
	<xsl:variable name="nodeid" select="concat('_:', generate-id())"/>
	<xsl:choose>
		<xsl:when test="./xhtml:*[@class = 'disjunction']">
			<xsl:apply-templates select="../xhtml:*[@class = 'premise']" mode="disjunction">
				<xsl:with-param name="nodetype" select="$nodetype"/>
				<xsl:with-param name="conclusion" select="$conclusion"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="aif-snode">
				<xsl:with-param name="nodetype" select="$nodetype"/>
				<xsl:with-param name="nodeid" select="$nodeid"/>
				<xsl:with-param name="premises">
					<xsl:apply-templates select="../xhtml:*[@class = 'premise']" mode="make-premise"/>
				</xsl:with-param>
				<xsl:with-param name="conclusion" select="$conclusion"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:apply-templates select="../xhtml:*[@class = 'undercut']" mode="undercut">
		<xsl:with-param name="conclusion" select="$nodeid"/>
	</xsl:apply-templates>	
</xsl:template>


<xsl:template match="xhtml:*[@class = 'premise' or @class = 'contrary-premise']" mode="make-premise">
	<premise><xsl:value-of select="concat('&lt;', 'urn:eleatics:', @about, '&gt;')"/></premise>
</xsl:template>


<xsl:template match="xhtml:*[@class = 'premise']" mode="disjunction">
	<xsl:param name="nodetype"/>
	<xsl:param name="conclusion"/>
	<xsl:call-template name="aif-snode">
		<xsl:with-param name="nodetype" select="$nodetype"/>
		<xsl:with-param name="nodeid" select="concat('_:', generate-id())"/>
		<xsl:with-param name="premises">
			<premise><xsl:value-of select="concat('&lt;', 'urn:eleatics:', @about, '&gt;')"/></premise>
		</xsl:with-param>
		<xsl:with-param name="conclusion" select="$conclusion"/>
	</xsl:call-template>
</xsl:template>


<xsl:template match="xhtml:*[@class = 'undercut']" mode="undercut">
	<xsl:param name="conclusion"/>
	<xsl:call-template name="aif-snode">
		<xsl:with-param name="nodetype" select="$canode"/>
		<xsl:with-param name="nodeid" select="concat('_:', generate-id())"/>
		<xsl:with-param name="premises">
			<xsl:apply-templates select="../xhtml:*[@class = 'contrary-premise']" mode="make-premise"/>
		</xsl:with-param>
		<xsl:with-param name="conclusion" select="$conclusion"/>
	</xsl:call-template>
</xsl:template>


<xsl:template match="xhtml:*[@class = 'support']" mode="getType">
	<xsl:value-of select="$ranode"/>
</xsl:template>

<xsl:template match="xhtml:*[@class = 'contradiction']" mode="getType">
	<xsl:value-of select="$canode"/>
</xsl:template>


<xsl:template match="xhtml:*"/>

</xsl:stylesheet>
 