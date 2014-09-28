<?xml version="1.0" ?>
<!-- this stylesheet replaces
	- @VERSION@ with the actual gpodder version from mymodules.modules
	- @YEAR@ with current year
  -->
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:str="http://exslt.org/strings"
	xmlns:date="http://exslt.org/dates-and-times"
        extension-element-prefixes="str date">
        
        <xsl:param name="app"/>

        <xsl:variable name="tag" select="string(document('../mymodules.modules')/moduleset/*[@id=$app]/branch/@version)"/>
        <xsl:variable name="myversion" select="$tag"/>
        <xsl:variable name="myyear" select="date:year()"/>
        
        <xsl:template match="/">
        
		<xsl:message>
Tag     is <xsl:value-of select="$tag"/>
Version is <xsl:value-of select="$myversion"/>
Year    is <xsl:value-of select="$myyear"/> 
		</xsl:message>

		<xsl:if test="$tag = '' or $myversion = ''">
			<xsl:message terminate="yes">Couldn't get the version !</xsl:message>
		</xsl:if>
		
		<xsl:apply-templates/>
        </xsl:template>
        
	<xsl:template match="@*|*">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="text()">
	<xsl:value-of select="str:replace(str:replace(.,'@VERSION@',$myversion)
					  ,'@YEAR@', $myyear)"/>
	</xsl:template>

</xsl:stylesheet>

