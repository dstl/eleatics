<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="escapeQuotes">
	<xsl:param name="text"/>
	<xsl:choose>
		<xsl:when test="contains($text, '&quot;')">
			<xsl:value-of select="substring-before($text, '&quot;')"/>
			<xsl:text>\&quot;</xsl:text>
			<xsl:call-template name="escapeQuotes">
				<xsl:with-param name="text" select="substring-after($text, '&quot;')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$text"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
 
