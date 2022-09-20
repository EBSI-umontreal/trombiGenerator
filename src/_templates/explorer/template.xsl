<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
	xmlns:epub="http://www.idpf.org/2007/ops"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="html xsl">
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" encoding="utf-8" />
	
	
	<xsl:template match="album">
		
		<xsl:apply-templates select="folder"/>
		
		<!-- if <folder name='album'> doesn't exists, create a root index.html with folder links --> 
		<xsl:if test="not(folder[@name='album'])">
			<xsl:call-template name="folder">
				<xsl:with-param name="name">
					<xsl:text>album</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="folder">
		<xsl:call-template name="folder">
			<xsl:with-param name="name">
				<xsl:value-of select="@name"/>
			</xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>
	
	<xsl:template name="folder">
		<xsl:param name="name"/>
		
		<xsl:variable name="file-root">
			<xsl:choose>
				<xsl:when test="$name='album'">./</xsl:when>
				<xsl:otherwise>../</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="file-output">
			<xsl:choose>
				<xsl:when test="$name='album'">index.html</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(@name,'/','index.html')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:result-document href="{$file-output}">
			<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
			<html>
				<head>
					<meta charset="utf-8"/>
					<title><xsl:value-of select="replace($name,'%20',' ')"/></title>
					<link type="text/css" rel="stylesheet" href="{concat($file-root, 'ressources/template.css')}" />
				</head>
				<body>
					<div class="container">
						<div class="cell left">
							<div class="navigation">
								<ul>
									<!-- back to root -->
									<li>
										<a>
											<xsl:attribute name="href">
												<xsl:choose>
													<xsl:when test="$name='album'">
														<xsl:text>./index.html</xsl:text>
													</xsl:when>
													<xsl:otherwise>
														<xsl:text>../index.html</xsl:text>
													</xsl:otherwise>
												</xsl:choose>												
											</xsl:attribute>
											<xsl:text>Album</xsl:text>
										</a>
									</li>
									<!-- other folder -->
									<xsl:for-each select="//folder[not(@name='album')]">
										<li>
											<a>
												<xsl:attribute name="href">
													<xsl:value-of select="concat($file-root, @name, '/index.html')"/>
												</xsl:attribute>
												<xsl:value-of select="replace(@name,'%20',' ')"/>
											</a>
										</li>
									</xsl:for-each>
								</ul>
							</div>
						</div>
						<div class="cell right">
							<h1><xsl:value-of select="replace($name,'%20',' ')"/></h1>
							
							<!-- subfolders in root album -->
							<xsl:if test="$name='album'">
								<xsl:for-each select="//folder[not(@name='album')]">
									<div class="photo">
										<img src="{concat($file-root, 'ressources/OneDrive_Folder_Icon.svg')}" width="100" height="100" />
										<span class="photo-name">
											<a>
												<xsl:attribute name="href">
													<xsl:value-of select="concat($file-root, @name, '/index.html')"/>
												</xsl:attribute>
												<xsl:value-of select="replace(@name,'%20',' ')"/>
											</a>
										</span>
									</div>
								</xsl:for-each>
							</xsl:if>
							
							<!-- photos -->
							<xsl:apply-templates select="file"/>
							
						</div>
					</div>
				</body>
			</html>
		</xsl:result-document>
		
	</xsl:template>

	
	<xsl:template match="file">
		<xsl:variable name="nomFichier">
			<xsl:call-template name="substring-before-last">
				<xsl:with-param name="string1" select="." />
				<xsl:with-param name="string2" select="'.'" />
			</xsl:call-template>
		</xsl:variable>
	
		<div class="photo">
			<img src="./{.}" width="100" height="100" />
			<span class="photo-name"><xsl:value-of select="replace($nomFichier,'%20',' ')" disable-output-escaping="yes"/></span>
		</div>
	</xsl:template>	
	
	<!-- Source : https://stackoverflow.com/questions/1119449/removing-the-last-characters-in-an-xslt-string/ -->
	<xsl:template name="substring-before-last">
		<xsl:param name="string1" select="''" />
		<xsl:param name="string2" select="''" />

		<xsl:if test="$string1 != '' and $string2 != ''">
			<xsl:variable name="head" select="substring-before($string1, $string2)" />
			<xsl:variable name="tail" select="substring-after($string1, $string2)" />
			<xsl:value-of select="$head" />
			<xsl:if test="contains($tail, $string2)">
				<xsl:value-of select="$string2" />
				<xsl:call-template name="substring-before-last">
					<xsl:with-param name="string1" select="$tail" />
					<xsl:with-param name="string2" select="$string2" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	
</xsl:stylesheet>
