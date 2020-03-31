<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:graphml="http://graphml.graphdrawing.org/xmlns" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" version="1.0">

<xsl:import href="yed.xsl"/>

<xsl:output method="text" indent="yes"/>

<xsl:template match="graphml:graphml">
	<xsl:apply-templates select=".//graphml:node" mode="knowledge"/>
	<xsl:apply-templates select=".//graphml:node" mode="rules"/>
</xsl:template>


<xsl:template match="graphml:node[graphml:data[@key = $nodeTypeKey] = 'I-node'][graphml:data[@key = $knownKey] = 'true']" mode="knowledge">

	<xsl:variable name="nodeid">
		<xsl:apply-templates select="." mode="getData"><xsl:with-param name="key" select="$nodeIdKey"/></xsl:apply-templates>
	</xsl:variable>

	<xsl:variable name="defeasible">
		<xsl:apply-templates select="." mode="getData"><xsl:with-param name="key" select="$defeasibleKey"/></xsl:apply-templates>
	</xsl:variable>
	
	<xsl:choose>
		<xsl:when test="$defeasible = 'false'">
			<xsl:text>-> </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>=> </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	
	<xsl:value-of select="$nodeid"/>
	<xsl:text>&#13;</xsl:text>

</xsl:template>

<xsl:template match="graphml:node" mode="knowledge"/>



<xsl:template match="graphml:node[graphml:data[@key = $nodeTypeKey] = 'RA-node']" mode="rules">
	<xsl:call-template name="makeRule">
		<xsl:with-param name="negation" select="''"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="graphml:node[graphml:data[@key = $nodeTypeKey] = 'CA-node']" mode="rules">
	<xsl:call-template name="makeRule">
		<xsl:with-param name="negation" select="'! '"/>
	</xsl:call-template>	
</xsl:template>

<xsl:template match="graphml:node" mode="rules"/>

<!--
<xsl:template match="graphml:edge" mode="premise">
	<xsl:apply-templates select="//graphml:node[@id = current()/@source]" mode="getData">
		<xsl:with-param name="key" select="$nodeIdKey"/>
	</xsl:apply-templates>
	<xsl:if test="not(position() = last())">
		<text>, </text>
	</xsl:if>
</xsl:template>
-->

<xsl:template match="graphml:edge" mode="premise">	
<premise>
	<!-- only I-nodes can be premises (need to filter out undercutting CA-nodes) -->
	<xsl:apply-templates select="//graphml:node[@id = current()/@source][graphml:data[@key = $nodeTypeKey] = 'I-node']" mode="getData">
		<xsl:with-param name="key" select="$nodeIdKey"/>
	</xsl:apply-templates>
</premise>
</xsl:template>


<xsl:template match="graphml:edge" mode="conclusion">
	<xsl:apply-templates select="//graphml:node[@id = current()/@target]" mode="getData">
		<xsl:with-param name="key" select="$nodeIdKey"/>
	</xsl:apply-templates>
</xsl:template>


</xsl:stylesheet>
 