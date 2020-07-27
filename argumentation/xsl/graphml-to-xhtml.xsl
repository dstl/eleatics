<?xml version="1.0"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:graphml="http://graphml.graphdrawing.org/xmlns" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="1.0">

<xsl:import href="../../xsl-utils/textutils.xsl"/>
<xsl:import href="yed.xsl"/>

<xsl:output method="xml" indent="yes"/>

<xsl:template match="graphml:graphml">
	<html>
	<head>
		<title>Info</title>
		<link rel="stylesheet" href="hypothesis.css"/>
	</head>
	<body>
		<dl>
			<xsl:apply-templates select=".//graphml:node"/>
		</dl>
	</body>
	</html>
</xsl:template>


<xsl:template match="graphml:node">

	<xsl:variable name="type">
		<xsl:apply-templates select="." mode="nodetype"/>
	</xsl:variable>
	
	<xsl:variable name="rdfnodeid">
		<xsl:apply-templates select="." mode="url"/>
	</xsl:variable>
	
	<xsl:if test="$type = 'I-node'">
		
		<xsl:variable name="nodeid">
			<xsl:apply-templates select="." mode="getData"><xsl:with-param name="key" select="$nodeIdKey"/></xsl:apply-templates>
		</xsl:variable>
		
		<xsl:variable name="label">
			<xsl:apply-templates select="." mode="yed-label"/>
		</xsl:variable>

		<dt about="{$rdfnodeid}" typeof="skos:Concept" property="skos:prefLabel" class="label"><p><xsl:value-of select="normalize-space($label)"/></p></dt>
		<dt about="{$rdfnodeid}" typeof="skos:Concept" property="skos:notation" class="notation"><p><xsl:value-of select="normalize-space($nodeid)"/></p></dt>
		<dd about="{$rdfnodeid}" typeof="skos:Concept" property="skos:definition"><p><xsl:apply-templates select="." mode="claimtext"/></p></dd>
			
	</xsl:if>

</xsl:template>


<xsl:template match="graphml:node" mode="nodetype">
	<xsl:apply-imports/>
</xsl:template>


<xsl:template match="graphml:node" mode="claimtext">
	<xsl:apply-imports/>
</xsl:template>


</xsl:stylesheet>
 
