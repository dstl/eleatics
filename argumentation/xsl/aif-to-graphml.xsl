<xsl:stylesheet  xmlns="http://graphml.graphdrawing.org/xmlns" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:y="http://www.yworks.com/xml/graphml" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:map="http://to.do/" version="1.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"/>


<xsl:template match="/">
<graphml>    
    <key for="node" id="nodegraphic" yfiles.type="nodegraphics"/>
    <key attr.name="url" attr.type="string" for="node" id="url"/>
    <key attr.name="claim" attr.type="string" for="node" id="claim"/>
    <key attr.name="id" attr.type="string" for="node" id="id"/>
    <key attr.name="nodeType" attr.type="string" for="node" id="nodeType"/>
    <key attr.name="defeasible" attr.type="boolean" for="node" id="defeasible">
      <default>true</default>
    </key>
    <key attr.name="known" attr.type="boolean" for="node" id="known">
      <default>false</default>
    </key>
    
	<graph>
		<xsl:apply-templates select="//rdf:Description" mode="node" />
		<xsl:apply-templates select="//owl:NamedIndividual" mode="node" />
	</graph>
</graphml>
</xsl:template>

<xsl:template match="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2002/07/owl#Ontology']" mode="node"/>

<xsl:template match="rdf:Description|owl:NamedIndividual" mode="node">
  <xsl:variable name="id"><xsl:call-template name="getNodeID"/></xsl:variable>
  <node id="{$id}">
  <data key="id"><xsl:value-of select="$id"/></data>
  <data key="nodeType"><xsl:value-of select="substring-after(rdf:type/@rdf:resource, '#')"/></data>
  <data key="claim"><xsl:value-of select="aif:claimText"/></data>
  </node>
  <xsl:if test="not(rdf:type/@rdf:resource='http://www.arg.dundee.ac.uk/aif#I-node')">
	  <xsl:apply-templates select="./aif:Premise" mode="edge">
	  	<xsl:with-param name="target" select="$id"/>
	  </xsl:apply-templates>
	  <xsl:apply-templates select="./aif:Conclusion" mode="edge">
	  	<xsl:with-param name="source" select="$id"/>
	  </xsl:apply-templates>
  </xsl:if>
</xsl:template>



<xsl:template match="aif:Premise" mode="edge">
  <xsl:param name="target"/>
  <xsl:variable name="source">
    <xsl:choose>
    	<xsl:when test="@rdf:nodeID">
    	  <xsl:value-of select="@rdf:nodeID"/>
    	</xsl:when>
    	<xsl:when test="@rdf:resource">
    	  <xsl:value-of select="@rdf:resource"/>
    	</xsl:when>
    	<xsl:otherwise>
    	  <xsl:for-each select="aif:I-node[1]">
  	        <xsl:call-template name="getNodeID"/>
  	      </xsl:for-each>
    	</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <edge source="{$source}" target="{$target}"/>
</xsl:template>


<xsl:template match="aif:Conclusion" mode="edge">
  <xsl:param name="source"/>
  <xsl:variable name="target">
    <xsl:choose>
    	<xsl:when test="@rdf:nodeID">
    	  <xsl:value-of select="@rdf:nodeID"/>
    	</xsl:when>
    	<xsl:when test="@rdf:resource">
    	  <xsl:value-of select="@rdf:resource"/>
    	</xsl:when>
    	<xsl:otherwise>
    	  <xsl:for-each select="aif:I-node[1]">
  	        <xsl:call-template name="getNodeID"/>
  	      </xsl:for-each>
    	</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <edge source="{$source}" target="{$target}"/>
</xsl:template>


<xsl:template name="getNodeID">
	<xsl:choose>
		<xsl:when test="@rdf:about">
			<xsl:value-of select="@rdf:about"/>
		</xsl:when>
		<xsl:when test="@rdf:nodeID">
			<xsl:value-of select="@rdf:nodeID"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="map:id"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
