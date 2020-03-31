<xsl:stylesheet  xmlns="http://graphml.graphdrawing.org/xmlns" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:y="http://www.yworks.com/xml/graphml" xmlns:aif="http://www.arg.dundee.ac.uk/aif#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:map="http://to.do/" version="1.0">

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
		<xsl:apply-templates select="//aif:I-node" mode="node" />
		<xsl:apply-templates select="//aif:RA-node" mode="node" />
		<xsl:apply-templates select="//aif:CA-node" mode="node" />
	</graph>
</graphml>
</xsl:template>

<xsl:template match="aif:I-node" mode="node">
  <xsl:variable name="id"><xsl:call-template name="getNodeID"/></xsl:variable>
  <node id="{$id}">
  <data key="id"><xsl:value-of select="map:id"/></data>
  <data key="nodeType"><xsl:value-of select="substring-after(name(), 'aif:')"/></data>
  <data key="claim"><xsl:value-of select="aif:claimText"/></data>
      <data key="nodegraphic">
        <y:GenericNode configuration="com.yworks.flowchart.process">
          <y:Geometry height="30.0" width="162.0" x="37.5" y="40.0"/>
          <y:Fill color="#E8EEF7" color2="#B7C9E3" transparent="false"/>
          <y:BorderStyle color="#000000" type="line" width="1.0"/>
          <y:NodeLabel alignment="center" autoSizePolicy="node_width" configuration="CroppingLabel" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="21.09375" horizontalTextPosition="center" iconTextGap="4" modelName="internal" modelPosition="c" textColor="#000000" verticalTextPosition="bottom" visible="true" width="162.0" x="0.0" y="4.453125"><xsl:value-of select="aif:claimText"/></y:NodeLabel>
        </y:GenericNode>
      </data>
  </node>
  <xsl:apply-templates select="./aif:Premise" mode="edge">
  	<xsl:with-param name="target" select="$id"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="./aif:Conclusion" mode="edge">
  	<xsl:with-param name="source" select="$id"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="aif:CA-node" mode="node">
  <xsl:variable name="id"><xsl:call-template name="getNodeID"/></xsl:variable>
  <node id="{$id}">
  <data key="id"><xsl:value-of select="map:id"/></data>
  <data key="nodeType"><xsl:value-of select="substring-after(name(), 'aif:')"/></data>
  <data key="claim"><xsl:value-of select="aif:claimText"/></data>
  </node>
  <xsl:apply-templates select="./aif:Premise" mode="edge">
  	<xsl:with-param name="target" select="$id"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="./aif:Conclusion" mode="edge">
  	<xsl:with-param name="source" select="$id"/>
  </xsl:apply-templates>
</xsl:template>



<xsl:template match="aif:RA-node" mode="node">
  <xsl:variable name="id"><xsl:call-template name="getNodeID"/></xsl:variable>
  <node id="{$id}">
  <data key="id"><xsl:value-of select="map:id"/></data>
  <data key="nodeType"><xsl:value-of select="substring-after(name(), 'aif:')"/></data>
  <data key="claim"><xsl:value-of select="aif:claimText"/></data>
      <data key="nodegraphic">
        <y:GenericNode configuration="com.yworks.flowchart.decision">
          <y:Geometry height="58.0" width="150.0" x="43.5" y="139.0"/>
          <y:Fill color="#E8EEF7" color2="#99CC00" transparent="false"/>
          <y:BorderStyle color="#000000" type="line" width="1.0"/>
          <y:NodeLabel alignment="center" autoSizePolicy="content" fontFamily="Dialog" fontSize="10" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="16.2509765625" horizontalTextPosition="center" iconTextGap="4" modelName="custom" textColor="#000000" verticalTextPosition="bottom" visible="true" width="35.1181640625" x="57.44091796875" y="20.87451171875">implies<y:LabelModel>
              <y:SmartNodeLabelModel distance="4.0"/>
            </y:LabelModel>
            <y:ModelParameter>
              <y:SmartNodeLabelModelParameter labelRatioX="0.0" labelRatioY="0.0" nodeRatioX="0.0" nodeRatioY="0.0" offsetX="0.0" offsetY="0.0" upX="0.0" upY="-1.0"/>
            </y:ModelParameter>
          </y:NodeLabel>
        </y:GenericNode>
      </data>
   </node>
  <xsl:apply-templates select="./aif:Premise" mode="edge">
  	<xsl:with-param name="target" select="$id"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="./aif:Conclusion" mode="edge">
  	<xsl:with-param name="source" select="$id"/>
  </xsl:apply-templates>
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
