<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:graphml="http://graphml.graphdrawing.org/xmlns" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" version="1.0">

<xsl:import href="../../xsl-utils/textutils.xsl"/>
<xsl:import href="yed.xsl"/>

<xsl:output method="text" indent="yes"/>

<xsl:template match="graphml:graphml">
	<xsl:apply-templates select=".//graphml:node"/>
</xsl:template>


<xsl:template match="graphml:node">

	<xsl:variable name="type">
		<xsl:apply-templates select="." mode="nodetype"/>
	</xsl:variable>
	
	<xsl:variable name="rdfnodeid">
		<xsl:apply-templates select="." mode="uri"/>
	</xsl:variable>
	
	<xsl:if test="$type = 'I-node'">

		<xsl:value-of select="$rdfnodeid"/><xsl:text> </xsl:text>
		<xsl:value-of select="'&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt;'"/><xsl:text> </xsl:text>
		<xsl:value-of select="concat('&lt;http://www.w3.org/2004/02/skos/core#Concept', '&gt;')"/>
		<xsl:text> .</xsl:text>
		<xsl:text>&#13;</xsl:text>
	
		<!-- claim text becomes definition -->
		<xsl:value-of select="$rdfnodeid"/><xsl:text> </xsl:text>
		<xsl:value-of select="'&lt;http://www.w3.org/2004/02/skos/core#definition&gt;'"/><xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="claimtext"/>
		<xsl:text> .</xsl:text>
		<xsl:text>&#13;</xsl:text>
		
		<xsl:variable name="nodeid">
			<xsl:apply-templates select="." mode="getData"><xsl:with-param name="key" select="$nodeIdKey"/></xsl:apply-templates>
		</xsl:variable>
		
		<xsl:variable name="label">
			<xsl:apply-templates select="." mode="yed-label"/>
		</xsl:variable>

		<!-- label becomes prefLabel -->
		<xsl:value-of select="$rdfnodeid"/><xsl:text> </xsl:text>
		<xsl:value-of select="'&lt;http://www.w3.org/2004/02/skos/core#prefLabel&gt;'"/><xsl:text> </xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:call-template name="escapeQuotes">
			<xsl:with-param name="text" select="normalize-space($label)"/>
		</xsl:call-template>
		<xsl:text>&quot;@en</xsl:text>
		<xsl:text> .</xsl:text>
		<xsl:text>&#13;</xsl:text>
		
		<!-- nodeid becomes notation -->
		<xsl:value-of select="$rdfnodeid"/><xsl:text> </xsl:text>
		<xsl:value-of select="'&lt;http://www.w3.org/2004/02/skos/core#notation&gt;'"/><xsl:text> </xsl:text>
		<xsl:text>&quot;</xsl:text>
		<xsl:call-template name="escapeQuotes">
			<xsl:with-param name="text" select="normalize-space($nodeid)"/>
		</xsl:call-template>
		<xsl:text>&quot;@en</xsl:text>
		<xsl:text> .</xsl:text>
		<xsl:text>&#13;</xsl:text>
		
	</xsl:if>

</xsl:template>


<xsl:template match="graphml:node" mode="nodetype">
		<xsl:apply-imports/>
</xsl:template>


<xsl:template match="graphml:node" mode="claimtext">
	<xsl:variable name="text">
		<xsl:apply-imports/>
	</xsl:variable>
	<xsl:text>&quot;</xsl:text>
	<xsl:call-template name="escapeQuotes">
		<xsl:with-param name="text" select="normalize-space($text)"/>
	</xsl:call-template>
	<xsl:text>&quot;@en</xsl:text>
</xsl:template>


</xsl:stylesheet>
 