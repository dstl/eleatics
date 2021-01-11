<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:schema="http://schema.org/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">

<xsl:import href="expand-iri.xsl"/>

<xsl:output method="text" encoding="UTF-8" />

<xsl:param name="source" select="'_:'"/>
<xsl:variable name="LANGUAGE" select="'@en'"/>
<xsl:variable name="NS-RDF" select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'"/>


<xsl:template match="/">
	<xsl:apply-templates select="//*[@typeof]" mode="type"/>
	<xsl:apply-templates select="//*[@property]" mode="property"/>
	<xsl:apply-templates select="//*[@rev]" mode="rev"/>
	<xsl:apply-templates select="//*[@rel]" mode="rel"/>
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
	<xsl:variable name="subject">
		<xsl:call-template name="expandIRI">
			<xsl:with-param name="name" select="ancestor-or-self::*[@about][1]/@about"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="typelist">
		<xsl:call-template name="getTypeList">
			<xsl:with-param name="text" select="@typeof"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:for-each select="exsl:node-set($typelist)/type">
		<xsl:value-of select="$subject"/>
		<xsl:text> </xsl:text>
		<xsl:text>&lt;</xsl:text><xsl:value-of select="concat($NS-RDF, 'type')"/><xsl:text>&gt;</xsl:text>
		<xsl:text> </xsl:text>
		<xsl:value-of select="."/>
		<xsl:text> .&#13;</xsl:text>
	</xsl:for-each>	
</xsl:template>


<xsl:template match="*[@rev]" mode="rev">
	<xsl:variable name="object">
		<xsl:call-template name="expandIRI">
			<xsl:with-param name="name" select="@about"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:text> </xsl:text>
	<xsl:variable name="property">
		<xsl:call-template name="getProperty">
			<xsl:with-param name="property" select="@rev"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:apply-templates select="./*[@about]" mode="revsubject">
		<xsl:with-param name="object" select="$object"/>
		<xsl:with-param name="property" select="$property"/>
	</xsl:apply-templates>
</xsl:template>


<xsl:template match="*[@about]" mode="revsubject">
	<xsl:param name="object"/>
	<xsl:param name="property"/>
	<xsl:call-template name="expandIRI">
		<xsl:with-param name="name" select="@about"/>
	</xsl:call-template>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$property"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$object"/>
	<xsl:text> .&#13;</xsl:text>
</xsl:template>


<xsl:template match="*[@rev][@resource]" mode="rev">
	<xsl:call-template name="expandIRI">
		<xsl:with-param name="name" select="@resource"/>
	</xsl:call-template>
	<xsl:text> </xsl:text>
	<xsl:call-template name="getProperty">
		<xsl:with-param name="property" select="@rev"/>
	</xsl:call-template>
	<xsl:text> </xsl:text>
	<xsl:call-template name="expandIRI">
		<xsl:with-param name="name" select="ancestor-or-self::*[@about][1]/@about"/>
	</xsl:call-template>
	<xsl:text> .&#13;</xsl:text>
</xsl:template>


<xsl:template match="*[@rel]" mode="rel">
	<xsl:variable name="property">
		<xsl:call-template name="getProperty">
		<xsl:with-param name="property" select="@rel"/>
	</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="subject">
		<xsl:call-template name="expandIRI">
			<xsl:with-param name="name" select="@about"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:apply-templates select="./*[@about]" mode="relobject">
		<xsl:with-param name="subject" select="$subject"/>
		<xsl:with-param name="property" select="$property"/>
	</xsl:apply-templates>
</xsl:template>


<xsl:template match="*[@about]" mode="relobject">
	<xsl:param name="subject"/>
	<xsl:param name="property"/>
	<xsl:value-of select="$subject"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$property"/>
	<xsl:text> </xsl:text>
	<xsl:call-template name="expandIRI">
		<xsl:with-param name="name" select="@about"/>
	</xsl:call-template>
	<xsl:text> .&#13;</xsl:text>
</xsl:template>


<xsl:template match="*[@rel][@resource]" mode="rel">
	<xsl:call-template name="expandIRI">
		<xsl:with-param name="name" select="ancestor-or-self::*[@about][1]/@about"/>
	</xsl:call-template>
	<xsl:text> </xsl:text>
	<xsl:call-template name="getProperty">
		<xsl:with-param name="property" select="@rel"/>
	</xsl:call-template>
	<xsl:text> </xsl:text>
	<xsl:call-template name="expandIRI">
		<xsl:with-param name="name" select="@resource"/>
	</xsl:call-template>
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

<xsl:template name="expandIRI">
	<xsl:param name="name"/>
	<xsl:param name="source" select="'_:'"/>
	<xsl:choose>
		<xsl:when test="not($name)">
			<!-- blank node: generate an ID -->
			<xsl:text>_:</xsl:text>
			<xsl:value-of select="generate-id()"/>
		</xsl:when>
		<xsl:when test="starts-with($name, '#')">
			<!-- prepend document URL if ID starts with '#' -->
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="$source"/>
			<xsl:value-of select="$name"/>
			<xsl:text>&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="contains($name, ':')">
			<!-- a URL, or a URI shortened using a prefix -->
			<xsl:text>&lt;</xsl:text>
			<xsl:variable name="prefix" select="substring-before($name, ':')"/>
			<xsl:variable name="ns" select="//namespace::*[name() = $prefix]" />
			<xsl:choose>
				<xsl:when test="$ns">
					<!-- expand the namespace prefix -->
					<xsl:value-of select="$ns" />
					<xsl:value-of select="substring-after($name, ':')"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- use URL as is -->
					<xsl:value-of select="$name"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>&gt;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<!-- blank node: use the name given -->
			<xsl:text>_:</xsl:text>
			<xsl:value-of select="$name"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="getProperty">
	<xsl:param name="property" select="@property"/>
	<xsl:variable name="vocab" select="ancestor-or-self::*[@vocab]/@vocab"/>
	<xsl:choose>
		<xsl:when test="contains($property, ':')">
			<xsl:call-template name="expandIRI">
				<xsl:with-param name="name" select="$property"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>&lt;</xsl:text>
			<xsl:value-of select="concat($vocab, $property)"/>
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
	<xsl:variable name="vocab" select="ancestor-or-self::*[@vocab]/@vocab"/>
	<xsl:text>&lt;</xsl:text>
	<xsl:value-of select="concat($vocab, @typeof)"/>
	<xsl:text>&gt;</xsl:text>
</xsl:template>

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

<xsl:template name="getTypeList">
<!-- break up a space-delimited list of types -->
	<xsl:param name="text"/>
	<xsl:choose>
		<xsl:when test="contains($text, ' ')">
			<type>
				<xsl:variable name="thistype" select="substring-before($text, ' ')"/>
				<xsl:choose>
					<xsl:when test="contains($thistype, ':')">
						<xsl:call-template name="expandIRI">
							<xsl:with-param name="name" select="$thistype"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
					<xsl:call-template name="getProperty">
						<xsl:with-param name="property" select="$thistype"/>
					</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</type>
			<xsl:call-template name="getTypeList">
				<xsl:with-param name="text" select="normalize-space(substring-after($text, ' '))"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<type>
				<xsl:choose>
					<xsl:when test="contains($text, ':')">
						<xsl:call-template name="expandIRI">
							<xsl:with-param name="name" select="$text"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
					<xsl:call-template name="getProperty">
						<xsl:with-param name="property" select="$text"/>
					</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>	
			</type>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
