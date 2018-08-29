USE LocalLibrary
GO

/****** Object:  XmlSchemaCollection [dbo].[BookChaptersSchema]    Script Date: 09/10/2010 14:32:49 ******/
IF  EXISTS (SELECT * FROM sys.xml_schema_collections c, sys.schemas s WHERE c.schema_id = s.schema_id AND (quotename(s.name) + '.' + quotename(c.name)) = N'[dbo].[BookChaptersSchema]')
DROP XML SCHEMA COLLECTION  [dbo].[BookChaptersSchema]
GO

CREATE XML SCHEMA COLLECTION BookChaptersSchema 
AS
'<?xml version = "1.0" encoding = "UTF-8"?>
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns="http://myChapters" 
	elementFormDefault="qualified"
	targetNamespace="http://myChapters">
<!--create requisite types-->
<xsd:simpleType name="KEYWORDTYPE">
    <xsd:restriction base="xsd:string">
        <xsd:maxLength value="20"/>
    </xsd:restriction>
</xsd:simpleType>
<xsd:simpleType name="CHAPNOTYPE">
    <xsd:restriction base="xsd:string">
         <xsd:maxLength value="3"/>
         <xsd:pattern value="[0-9]{1,3}"/>
    </xsd:restriction>
</xsd:simpleType>
<xsd:element name="CHAPTERLIST">
	<xsd:complexType>
		<xsd:sequence>
			<xsd:element name="CHAPTER">
				<xsd:complexType>
					<xsd:sequence>
						<xsd:element name="TITLE" type="xsd:string"/>
						<xsd:element name="SUMMARY" type="xsd:string"/>
						<xsd:element name="KEYWORD" type="KEYWORDTYPE" minOccurs="1" maxOccurs="3"/>
						<xsd:element name="REFERENCE" type="xsd:string" minOccures="0" maxOccurs="100"/>
					</xsd:sequence>
					<xsd:attribute name="ChapNo" type="CHAPNOTYPE"/>
				</xsd:complexType>
			</xsd:element>
		</xsd:sequence>
	</xsd:complexType>
</xsd:element>
</xsd:schema>'
