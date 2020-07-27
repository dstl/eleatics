<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:graphml="http://graphml.graphdrawing.org/xmlns" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" xmlns:y="http://www.yworks.com/xml/graphml" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" version="1.0">

<xsl:variable name="knownKey"       select="/graphml:graphml/graphml:key[@attr.name = 'known']/@id"/>
<xsl:variable name="nodeIdKey"      select="/graphml:graphml/graphml:key[@attr.name = 'id']/@id"/>
<xsl:variable name="nodeUrlKey"     select="/graphml:graphml/graphml:key[@attr.name = 'url']/@id"/>
<xsl:variable name="nodeTypeKey"    select="/graphml:graphml/graphml:key[@attr.name = 'nodeType']/@id"/>
<xsl:variable name="defeasibleKey"  select="/graphml:graphml/graphml:key[@attr.name = 'defeasible']/@id"/>
<xsl:variable name="descriptionKey" select="/graphml:graphml/graphml:key[@attr.name = 'description']/@id"/>

<xsl:template match="graphml:node" mode="nodetype">
	<xsl:value-of select="graphml:data[@key = $nodeTypeKey]"/>
</xsl:template>

<xsl:template match="graphml:node" mode="nodeid">
	<xsl:value-of select="graphml:data[@key = $nodeIdKey]"/>
</xsl:template>

<xsl:template match="graphml:node" mode="known">
	<xsl:value-of select="graphml:data[@key = $knownKey]"/>
</xsl:template>

<xsl:template match="graphml:node" mode="defeasible">
	<xsl:value-of select="graphml:data[@key = $defeasibleKey]"/>
</xsl:template>

<xsl:template match="graphml:node" mode="claimtext">
	<xsl:value-of select="graphml:data[@key = $descriptionKey]"/>
</xsl:template>

<xsl:template match="graphml:node" mode="yed-label">
	<xsl:value-of select=".//y:NodeLabel[1]"/>
</xsl:template>

<xsl:template match="graphml:node" mode="uri">
	<xsl:variable name="url" select="graphml:data[@key = $nodeUrlKey]"/>
	<xsl:choose>
		<xsl:when test="$url and string-length($url) &gt; 0">
			<xsl:value-of select="concat('&lt;', $url, '&gt;')"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat('_:', @id)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="graphml:node" mode="url">
	<xsl:variable name="url" select="graphml:data[@key = $nodeUrlKey]"/>
	<xsl:choose>
		<xsl:when test="$url and string-length($url) &gt; 0">
			<xsl:value-of select="$url"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat('_:', @id)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template match="graphml:node" mode="getData">
	<xsl:param name="key"/>
	<xsl:value-of select="graphml:data[@key = $key]"/>
</xsl:template>


<xsl:template name="makeRule">

	<xsl:param name="negation" select="''" />

	<xsl:variable name="nodeid">
		<xsl:apply-templates select="." mode="getData"><xsl:with-param name="key" select="$nodeIdKey"/></xsl:apply-templates>
	</xsl:variable>

	<xsl:variable name="defeasible">
		<xsl:apply-templates select="." mode="getData"><xsl:with-param name="key" select="$defeasibleKey"/></xsl:apply-templates>
	</xsl:variable>
	
	<xsl:value-of select="$nodeid"/><xsl:text>: </xsl:text>
	
	<xsl:variable name="list">
		<xsl:apply-templates select="//graphml:edge[@target = current()/@id]" mode="premise"/>
	</xsl:variable>
	<xsl:apply-templates select="exsl:node-set($list)/premise[text()]" mode="print"/>
	
	<xsl:text> </xsl:text>
	<xsl:choose>
		<xsl:when test="$defeasible = 'false'">
			<xsl:text>-> </xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>=> </xsl:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:value-of select="$negation"/>
	
	<xsl:apply-templates select="//graphml:edge[@source = current()/@id]" mode="conclusion"/>

	<xsl:text>&#13;</xsl:text>
	
</xsl:template>


<xsl:template match="premise" mode="print">
	<xsl:value-of select="."/>
	<xsl:if test="not(position() = last())">
		<text>, </text>
	</xsl:if>
</xsl:template>



</xsl:stylesheet>
 