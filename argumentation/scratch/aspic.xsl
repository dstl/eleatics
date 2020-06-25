<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" version="1.0">

<xsl:output method="text" indent="yes"/>

<xsl:template match="/">
	<xsl:apply-templates select="//owl:NamedIndividual[rdf:type/@rdf:resource = 'http://www.arg.dundee.ac.uk/aif#I-node'][count(aif:Conclusion) = 0]" mode="premise"/>
	<xsl:apply-templates select="//owl:NamedIndividual[rdf:type/@rdf:resource = 'http://www.arg.dundee.ac.uk/aif#RA-node']" mode="rule"/>
	<xsl:apply-templates select="//owl:NamedIndividual[rdf:type/@rdf:resource = 'http://www.arg.dundee.ac.uk/aif#CA-node']" mode="contradiction"/>
</xsl:template>

<xsl:template match="owl:NamedIndividual" mode="premise">
  <xsl:text>=&gt; <xsl:apply-templates select="." mode="name"/></xsl:text>
  <xsl:text>&#13;</xsl:text>
</xsl:template>

<xsl:template match="owl:NamedIndividual" mode="rule">
  <xsl:text><xsl:value-of select="concat('r', position(), ': ')"/></xsl:text>
  <xsl:apply-templates select="aif:Premise" mode="rule"/>
</xsl:template>

<xsl:template match="aif:Premise" mode="rule">
  <xsl:variable name="premise"><xsl:apply-templates select="." mode="name"/></xsl:variable>
  <xsl:for-each select="../aif:Conclusion">
  	<xsl:text><xsl:value-of select="$premise"/></xsl:text>
  	<xsl:text> =&gt; </xsl:text>
  	<xsl:apply-templates select="." mode="name"/>
    <xsl:text>&#13;</xsl:text>
  </xsl:for-each>
</xsl:template>

<xsl:template match="owl:NamedIndividual" mode="contradiction">
  <xsl:variable name="premise"><xsl:apply-templates select="aif:Premise" mode="name"/></xsl:variable>
  <xsl:variable name="conclusion"><xsl:apply-templates select="aif:Conclusion" mode="name"/></xsl:variable>
  	<xsl:text><xsl:value-of select="$premise"/></xsl:text>
  	<xsl:text> =&gt; ! </xsl:text>
  	<xsl:text><xsl:value-of select="$conclusion"/></xsl:text>
    <xsl:text>&#13;</xsl:text>
</xsl:template>

<xsl:template match="owl:NamedIndividual" mode="name">
  <xsl:value-of select="substring-after(@rdf:about, 'http://www.arg.dundee.ac.uk/AIFdb/nodes/')"/>
</xsl:template>

<xsl:template match="aif:Premise | aif:Conclusion" mode="name">
  <xsl:value-of select="substring-after(@rdf:resource, 'http://www.arg.dundee.ac.uk/AIFdb/nodes/')"/>
</xsl:template>


</xsl:stylesheet>
 