<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:graphml="http://graphml.graphdrawing.org/xmlns" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" version="1.0">

<xsl:import href="../../xsl-utils/textutils.xsl"/>
<xsl:import href="yed.xsl"/>

<xsl:output method="text" encoding="utf-8" indent="yes"/>

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

	<xsl:value-of select="$rdfnodeid"/><xsl:text> </xsl:text>
	<xsl:value-of select="'&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt;'"/><xsl:text> </xsl:text>
	<xsl:value-of select="concat('&lt;http://www.arg.dundee.ac.uk/aif#', $type, '&gt;')"/>
	<xsl:text> .</xsl:text>
	<xsl:text>&#13;</xsl:text>
	
	<xsl:if test="$type = 'I-node'">
	
		<!-- claim text -->
		<xsl:value-of select="$rdfnodeid"/><xsl:text> </xsl:text>
		<xsl:value-of select="'&lt;http://www.arg.dundee.ac.uk/aif#claimText&gt;'"/><xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="claimtext"/>
		<xsl:text> .</xsl:text>
		<xsl:text>&#13;</xsl:text>
		
		<!-- premises -->
		<xsl:apply-templates select="../graphml:edge[@source = current()/@id]" mode="premise"/>
		<!-- conclusions -->
		<xsl:apply-templates select="../graphml:edge[@target = current()/@id]" mode="conclusion"/>
		
		<!-- link to knowledge base ... -->
		<xsl:variable name="known">
			<xsl:apply-templates select="." mode="known"/>
		</xsl:variable>
		
		<xsl:if test="$known = 'true'">
			<xsl:value-of select="$rdfnodeid"/><xsl:text> </xsl:text>
			<xsl:value-of select="'&lt;http://to.do/premise&gt;'"/><xsl:text> </xsl:text>
			<xsl:text>&quot;true&quot;</xsl:text>
			<xsl:text> .</xsl:text>
			<xsl:text>&#13;</xsl:text>
		</xsl:if>

	</xsl:if>

	<xsl:variable name="defeasible">
		<xsl:apply-templates select="." mode="defeasible"/>
	</xsl:variable>
	<xsl:if test="$defeasible = 'false'">
		<xsl:value-of select="$rdfnodeid"/><xsl:text> </xsl:text>
		<xsl:value-of select="'&lt;http://to.do/defeasible&gt;'"/><xsl:text> </xsl:text>
		<xsl:text>&quot;false&quot;</xsl:text>
		<xsl:text> .</xsl:text>
		<xsl:text>&#13;</xsl:text>
	</xsl:if>

	<xsl:if test="$type = 'CA-node'">
	
		<!-- this CA-node may undercut ... -->
		<xsl:apply-templates select="../graphml:edge[@source = current()/@id]" mode="undercut"/>

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


<xsl:template match="graphml:edge" mode="premise">
	<xsl:variable name="source"><xsl:apply-templates select="../graphml:node[./@id = current()/@source]" mode="uri"/></xsl:variable>
	<xsl:variable name="target"><xsl:apply-templates select="../graphml:node[./@id = current()/@target]" mode="uri"/></xsl:variable>
	<xsl:value-of select="$target"/><xsl:text> </xsl:text>
	<xsl:value-of select="'&lt;http://www.arg.dundee.ac.uk/aif#Premise&gt;'"/><xsl:text> </xsl:text>
	<xsl:value-of select="$source"/><xsl:text> </xsl:text>
	<xsl:text> .</xsl:text>
	<xsl:text>&#13;</xsl:text>
</xsl:template>


<xsl:template match="graphml:edge" mode="conclusion">
	<xsl:variable name="source"><xsl:apply-templates select="../graphml:node[./@id = current()/@source]" mode="uri"/></xsl:variable>
	<xsl:variable name="target"><xsl:apply-templates select="../graphml:node[./@id = current()/@target]" mode="uri"/></xsl:variable>
	<xsl:value-of select="$source"/><xsl:text> </xsl:text>
	<xsl:value-of select="'&lt;http://www.arg.dundee.ac.uk/aif#Conclusion&gt;'"/><xsl:text> </xsl:text>
	<xsl:value-of select="$target"/><xsl:text> </xsl:text>
	<xsl:text> .</xsl:text>
	<xsl:text>&#13;</xsl:text>
</xsl:template>


<xsl:template match="graphml:edge" mode="undercut">
	<xsl:variable name="type">
		<xsl:apply-templates select="../graphml:node[@id = current()/@target]" mode="nodetype"/>
	</xsl:variable>
	<xsl:if test="$type = 'RA-node'">
		<xsl:apply-templates select="." mode="conclusion"/>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
 