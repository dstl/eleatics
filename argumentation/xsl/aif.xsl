<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">

<xsl:import href="rdf.xsl"/>
<xsl:import href="../../xsl-utils/textutils.xsl"/>

<xsl:variable name="ns-aif"  select="'http://www.arg.dundee.ac.uk/aif#'"/>

<xsl:variable name="inode"     select="concat('&lt;', $ns-aif, 'I-node', '&gt;')"/>
<xsl:variable name="ranode"    select="concat('&lt;', $ns-aif, 'RA-node', '&gt;')"/>
<xsl:variable name="canode"    select="concat('&lt;', $ns-aif, 'CA-node', '&gt;')"/>
<xsl:variable name="claimtext" select="concat('&lt;', $ns-aif,'claimText', '&gt;')"/>

<xsl:variable name="aif-premise"    select="concat('&lt;', $ns-aif,'Premise', '&gt;')"/>
<xsl:variable name="aif-conclusion" select="concat('&lt;', $ns-aif,'Conclusion', '&gt;')"/>

<xsl:template name="aif-inode">

	<xsl:param name="nodeid"/>
	<xsl:param name="claimText"/>
	<xsl:param name="graphName"/>
	
	<xsl:value-of select="$nodeid"/><xsl:text> </xsl:text>
	<xsl:value-of select="$rdf-type"/><xsl:text> </xsl:text>
	<xsl:value-of select="$inode"/>
	<xsl:if test="$graphName">
		<xsl:text> </xsl:text><xsl:value-of select="$graphName"/>
	</xsl:if>	
	<xsl:text> .&#13;</xsl:text>
	
	<xsl:if test="$claimText">
		<xsl:value-of select="$nodeid"/><xsl:text> </xsl:text>
		<xsl:value-of select="$claimtext"/><xsl:text> </xsl:text>
		<xsl:text>&quot;</xsl:text>
			<xsl:call-template name="escapeQuotes">
				<xsl:with-param name="text" select="$claimText"/>
			</xsl:call-template>
		<xsl:text>&quot;@en</xsl:text>
		<xsl:if test="$graphName">
			<xsl:text> </xsl:text><xsl:value-of select="$graphName"/>
		</xsl:if>	
		<xsl:text> .&#13;</xsl:text>
	</xsl:if>
	
</xsl:template>


<xsl:template name="aif-ranode">

	<xsl:param name="nodeid"/>
	<xsl:param name="claimText"/>
	<xsl:param name="graphName"/>
	<xsl:param name="premises"/>
	<xsl:param name="conclusion"/>
	
	<xsl:call-template name="aif-snode">
		<xsl:with-param name="nodeid" select="$nodeid"/>
		<xsl:with-param name="nodetype" select="$ranode"/>
		<xsl:with-param name="claimText" select="$claimText"/>
		<xsl:with-param name="graphName" select="$graphName"/>
		<xsl:with-param name="premises" select="$premises"/>
		<xsl:with-param name="conclusion" select="$conclusion"/>
	</xsl:call-template>
		
</xsl:template>


<xsl:template name="aif-canode">

	<xsl:param name="nodeid"/>
	<xsl:param name="claimText"/>
	<xsl:param name="graphName"/>
	<xsl:param name="premises"/>
	<xsl:param name="conclusion"/>
	
	<xsl:call-template name="aif-snode">
		<xsl:with-param name="nodeid" select="$nodeid"/>
		<xsl:with-param name="nodetype" select="$canode"/>
		<xsl:with-param name="claimText" select="$claimText"/>
		<xsl:with-param name="graphName" select="$graphName"/>
		<xsl:with-param name="premises" select="$premises"/>
		<xsl:with-param name="conclusion" select="$conclusion"/>
	</xsl:call-template>
		
</xsl:template>


<xsl:template name="aif-snode">

	<xsl:param name="nodeid"/>
	<xsl:param name="nodetype"/>
	<xsl:param name="claimText"/>
	<xsl:param name="graphName"/>
	<xsl:param name="premises"/>
	<xsl:param name="conclusion"/>
	
	<xsl:value-of select="$nodeid"/><xsl:text> </xsl:text>
	<xsl:value-of select="$rdf-type"/><xsl:text> </xsl:text>
	<xsl:value-of select="$nodetype"/>
	<xsl:if test="$graphName">
		<xsl:text> </xsl:text><xsl:value-of select="$graphName"/>
	</xsl:if>	
	<xsl:text> .&#13;</xsl:text>
	
	<xsl:if test="$claimText">
		<xsl:value-of select="$nodeid"/><xsl:text> </xsl:text>
		<xsl:value-of select="$claimtext"/><xsl:text> </xsl:text>
		<xsl:text>&quot;</xsl:text>
			<xsl:call-template name="escapeQuotes">
				<xsl:with-param name="text" select="$claimText"/>
			</xsl:call-template>
		<xsl:text>&quot;@en</xsl:text>
		<xsl:if test="$graphName">
			<xsl:text> </xsl:text><xsl:value-of select="$graphName"/>
		</xsl:if>	
		<xsl:text> .&#13;</xsl:text>
	</xsl:if>
	
	<!-- premises -->
	<xsl:for-each select="exsl:node-set($premises)/premise">
		<xsl:value-of select="$nodeid"/><xsl:text> </xsl:text>
		<xsl:value-of select="$aif-premise"/><xsl:text> </xsl:text>
 		<xsl:value-of select="."/><xsl:text> </xsl:text>
		<xsl:if test="$graphName">
			<xsl:text> </xsl:text><xsl:value-of select="$graphName"/>
		</xsl:if>	
		<xsl:text> .&#13;</xsl:text>
	</xsl:for-each>
		
	<!-- conclusion -->
	<xsl:value-of select="$nodeid"/><xsl:text> </xsl:text>
	<xsl:value-of select="$aif-conclusion"/><xsl:text> </xsl:text>
 	<xsl:value-of select="$conclusion"/><xsl:text> </xsl:text>
	<xsl:if test="$graphName">
		<xsl:text> </xsl:text><xsl:value-of select="$graphName"/>
	</xsl:if>	
	<xsl:text> .&#13;</xsl:text>
		
</xsl:template>


</xsl:stylesheet>
