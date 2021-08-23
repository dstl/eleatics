<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" version="1.0">

<xsl:output method="text" indent="yes"/>

<xsl:template match="root">
	<xsl:apply-templates select="nodes"/>
</xsl:template>


<xsl:template match="nodes">
	<xsl:apply-templates select="element" mode="node"/>
</xsl:template>

<xsl:template match="element" mode="node">

	<xsl:variable name="type">
		<xsl:value-of select="concat(type, '-node')"/>
	</xsl:variable>
	
	<xsl:variable name="rdfnodeid">
		<xsl:value-of select="concat('&lt;urn:eleatics:cis:', nodeID, '&gt;')" />
	</xsl:variable>

	<xsl:value-of select="$rdfnodeid"/><xsl:text> </xsl:text>
	<xsl:value-of select="'&lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#type&gt;'"/><xsl:text> </xsl:text>
	<xsl:value-of select="concat('&lt;http://www.arg.dundee.ac.uk/aif#', $type, '&gt;')"/>
	<xsl:text> .</xsl:text>
	<xsl:text>&#13;</xsl:text>
	
	<xsl:if test="$type = 'I-node'">
	
		<!-- claim text -->
		<xsl:value-of select="$rdfnodeid"/><xsl:text> </xsl:text>
		<xsl:value-of select="'&lt;http://www.arg.dundee.ac.uk/aif#claimText&gt;'"/><xsl:text> "</xsl:text>
		<xsl:value-of select="text" />
		<xsl:text>" .</xsl:text>
		<xsl:text>&#13;</xsl:text>
		
		<!-- premises -->
		<xsl:apply-templates select="//edges/element[source = current()/nodeID]" mode="premise"/>
		<!-- conclusions -->
		<xsl:apply-templates select="//edges/element[target = current()/nodeID]" mode="conclusion"/>
		
	</xsl:if>
	
	<xsl:if test="$type = 'CA-node'">
	
		<!-- this CA-node may undercut ... -->
		<xsl:apply-templates select="//edges/element[source = current()/nodeID]" mode="undercut"/>

	</xsl:if>
	
</xsl:template>


<xsl:template match="element" mode="premise">
	<xsl:variable name="source"><xsl:value-of select="concat('&lt;urn:eleatics:cis:', source, '&gt;')" /></xsl:variable>
	<xsl:variable name="target"><xsl:value-of select="concat('&lt;urn:eleatics:cis:', target, '&gt;')" /></xsl:variable>
	<xsl:value-of select="$target"/><xsl:text> </xsl:text>
	<xsl:value-of select="'&lt;http://www.arg.dundee.ac.uk/aif#Premise&gt;'"/><xsl:text> </xsl:text>
	<xsl:value-of select="$source"/><xsl:text> </xsl:text>
	<xsl:text> .</xsl:text>
	<xsl:text>&#13;</xsl:text>
</xsl:template>


<xsl:template match="element" mode="conclusion">
	<xsl:variable name="source"><xsl:value-of select="concat('&lt;urn:eleatics:cis:', source, '&gt;')" /></xsl:variable>
	<xsl:variable name="target"><xsl:value-of select="concat('&lt;urn:eleatics:cis:', target, '&gt;')" /></xsl:variable>
	<xsl:value-of select="$source"/><xsl:text> </xsl:text>
	<xsl:value-of select="'&lt;http://www.arg.dundee.ac.uk/aif#Conclusion&gt;'"/><xsl:text> </xsl:text>
	<xsl:value-of select="$target"/><xsl:text> </xsl:text>
	<xsl:text> .</xsl:text>
	<xsl:text>&#13;</xsl:text>
</xsl:template>


<xsl:template match="element" mode="undercut">
	<xsl:variable name="type">
		<xsl:value-of select="concat(//node/element[nodeID = current()/target]/type, '-node')"/>
	</xsl:variable>
	<xsl:if test="$type = 'RA-node'">
		<xsl:apply-templates select="." mode="conclusion"/>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>
 