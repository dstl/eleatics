<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:schema="http://schema.org/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="expand-iri.xsl"/>
<xsl:import href="textutils.xsl"/>

<xsl:output method="text" encoding="UTF-8" />

<xsl:param name="source" select="'_:'"/>
<xsl:variable name="LANGUAGE" select="'@en'"/>
<xsl:variable name="NS-RDF" select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'"/>


<xsl:template match="/">
	<xsl:apply-templates select="//*[@typeof]" mode="type"/>
	<xsl:apply-templates select="//*[@property]" mode="property"/>
	<xsl:apply-templates select="//*[@rel]" mode="rel"/>
	<xsl:apply-templates select="//*[@rev]" mode="rev"/>
</xsl:template>


<xsl:template match="*[@property]" mode="property">
	<xsl:call-template name="expandIRI">
		<xsl:with-param name="name" select="ancestor-or-self::*[@about][1]/@about"/>
	</xsl:call-template>
	<xsl:text> </xsl:text>
	<xsl:call-template name="getProperty"/>
	<xsl:text> </xsl:text>
	<xsl:call-template name="getPropertyValue"/>	
	<xsl:text> .&#13;</xsl:text>
</xsl:template>


<xsl:template match="*[@typeof]" mode="type">
	<xsl:call-template name="expandIRI">
		<xsl:with-param name="name" select="ancestor-or-self::*[@about][1]/@about"/>
	</xsl:call-template>
	<xsl:text> </xsl:text>
	<xsl:text>&lt;</xsl:text><xsl:value-of select="concat($NS-RDF, 'type')"/><xsl:text>&gt;</xsl:text>
	<xsl:text> </xsl:text>
	<xsl:call-template name="getType"/>
	<xsl:text> .&#13;</xsl:text>
</xsl:template>


<xsl:template match="*[@rel]" mode="rel">
	<xsl:variable name="subject">
		<xsl:call-template name="expandIRI">
			<xsl:with-param name="name" select="@about"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="predicate">
		<xsl:call-template name="expandIRI">
			<xsl:with-param name="name" select="@rel"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:for-each select="./*[@about]">
		<xsl:value-of select="$subject"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$predicate"/>
		<xsl:text> </xsl:text>
		<xsl:call-template name="expandIRI">
			<xsl:with-param name="name" select="@about"/>
		</xsl:call-template>
		<xsl:text> .&#13;</xsl:text>
	</xsl:for-each>
</xsl:template>


<xsl:template match="*[@rev]" mode="rev">
	<xsl:call-template name="expandIRI">
		<xsl:with-param name="name" select="@resource"/>
	</xsl:call-template>
	<xsl:text> </xsl:text>
	<xsl:call-template name="getPropertyRev"/>
	<xsl:text> </xsl:text>
	<xsl:call-template name="expandIRI">
		<xsl:with-param name="name" select="ancestor-or-self::*[@about][1]/@about"/>
	</xsl:call-template>
	<xsl:text> .&#13;</xsl:text>
</xsl:template>


<xsl:template match="*[@rev][not(@resource)]" mode="rev">
	<xsl:variable name="objectRev">
		<xsl:call-template name="getPropertyRev"/>
		<xsl:text> </xsl:text>
		<xsl:call-template name="getSubject"/>
		<xsl:text> </xsl:text>
	</xsl:variable>
	<xsl:apply-templates select="*[@about]" mode="fillTripleSubject">
		<xsl:with-param name="predicateObject" select="$objectRev"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="*[@about]" mode="fillTripleSubject">
	<xsl:param name="predicateObject"/>
	<xsl:call-template name="expandIRI">
		<xsl:with-param name="name" select="@about"/>
	</xsl:call-template>
	<xsl:text><xsl:value-of select="$predicateObject"/></xsl:text>
	<xsl:text> .&#13;</xsl:text>
</xsl:template>

<xsl:template name="getSubject">
	<xsl:variable name="about" select="ancestor-or-self::*[@about][1]/@about"/>
	<xsl:choose>
		<xsl:when test="not($about)">
			<!-- blank node: generate an ID -->
			<xsl:text>_:</xsl:text>
			<xsl:value-of select="generate-id()"/>
		</xsl:when>
		<xsl:when test="starts-with($about, '#')">
			<!-- prepend document URL if ID starts with '#' -->
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="$source"/>
			<xsl:value-of select="$about"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="contains($about, ':')">
			<!-- a URL, or a URI shortened using a prefix -->
			<xsl:text>&lt;</xsl:text>
			<xsl:variable name="prefix" select="substring-before($about, ':')"/>
			<xsl:variable name="ns" select="//namespace::*[name() = $prefix]" />
			<xsl:choose>
				<xsl:when test="$ns">
					<!-- expand the namespace prefix -->
					<xsl:value-of select="$ns" />
					<xsl:value-of select="substring-after($about, ':')"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- use URL as is -->
					<xsl:value-of select="$about"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>&gt;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<!-- blank node: use the name given -->
			<xsl:text>_:</xsl:text>
			<xsl:value-of select="$about"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="getProperty">
	<xsl:choose>
		<xsl:when test="contains(@property, ':')">
			<xsl:call-template name="expandIRI">
				<xsl:with-param name="name" select="@property"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="vocab" select="ancestor-or-self::*[@vocab]/@vocab"/>
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="concat($vocab, @property)"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="getPropertyRev">
	<xsl:choose>
		<xsl:when test="contains(@rev, ':')">
			<xsl:call-template name="expandIRI">
				<xsl:with-param name="name" select="@rev"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="vocab" select="ancestor-or-self::*[@vocab]/@vocab"/>
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="concat($vocab, @rev)"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="getPropertyValue">
	<xsl:choose>
		<xsl:when test="@content">
			<xsl:text>&quot;</xsl:text>
			<xsl:value-of select="@content"/>
			<xsl:text>&quot;</xsl:text>
			<xsl:value-of select="$LANGUAGE"/>
		</xsl:when>
		<xsl:when test="@resource">
			<xsl:call-template name="expandIRI">
				<xsl:with-param name="name" select="@resource"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>&quot;</xsl:text>
			<xsl:call-template name="escapeQuotes">
				<xsl:with-param name="text" select="normalize-space(.)"/>
			</xsl:call-template>
			<xsl:text>&quot;</xsl:text>
			<xsl:value-of select="$LANGUAGE"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="getType">
	<xsl:choose>
		<xsl:when test="contains(@typeof, ':')">
			<xsl:call-template name="expandIRI">
				<xsl:with-param name="name" select="@typeof"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="vocab" select="ancestor-or-self::*[@vocab]/@vocab"/>
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="concat($vocab, @typeof)"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet> 
