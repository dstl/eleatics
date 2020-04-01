<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xalan/java">

<xsl:variable name="messageDigest" select="java:java.security.MessageDigest.getInstance('MD5')"/>

<xsl:template name="hashMD5">
<!--
This calls normalize-space() for the "text" parameter (any whitespace reduced to single space, and leading and 
trailing spaces removed), then converts to lower case, then gets the MD5 hash of the result.
-->
	<xsl:param name="text"/>
	<xsl:variable name="string"  select="java:java.lang.String.new(normalize-space($text))"/>
	<xsl:variable name="lower"   select="java:java.lang.String.new(java:toLowerCase($string))"/>
	<xsl:variable name="bytes"   select="java:getBytes($lower)"/>
	<xsl:variable name="md5"     select="java:digest($messageDigest, $bytes)"/>
	<xsl:value-of select="java:javax.xml.bind.DatatypeConverter.printHexBinary($md5)"/>
</xsl:template>

</xsl:stylesheet>
