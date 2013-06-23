<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    
    <xsl:output method="xml" indent="yes" name="xml"/>

    <xsl:param name="package-name" select="'Generated Package'" />
    <xsl:param name="package-description" select="'Generated Package'" />
    <xsl:param name="package-group" select="'my_packages'" />
    <xsl:param name="package-admin" select="'admin'" />
    <xsl:param name="package-version" select="''" />
    <xsl:param name="package-build-count" select="'1'" />
    <xsl:param name="package-achandling" select="'merge_preserve'" />
    <xsl:param name="package-mode" select="'replace'" />
    <xsl:param name="package-filter" select="'/content/generated'" />
    <xsl:param name="package-filter-nodes" />
    <xsl:param name="package-definition-filter-nodes" />
    <xsl:param name="package-date" select="current-dateTime()" />
    <xsl:param name="package-root" select="'package/jcr_root'" />
    <xsl:param name="package-create-root-content" select="'true'" />
    <xsl:param name="package-create-filter" select="'true'" />
    <xsl:param name="package-create-properties" select="'true'" />
    <xsl:param name="package-create-config" select="'false'" />
    <xsl:param name="package-create-nodetypes" select="'false'" />
    <xsl:param name="package-create-definition" select="'false'" />
    <xsl:param name="meta-root" select="'package/META-INF'" />

    <xsl:template name="vault-files">

      <!-- weird hack to easily get braces in an attribute -->
      <xsl:variable name="lbrace"><![CDATA[{]]></xsl:variable>
      <xsl:variable name="rbrace"><![CDATA[}]]></xsl:variable>

      <!-- Package Files Below, shouldn't need to edit, use variable in the header. -->

      <xsl:if test="$package-create-root-content = 'true'">
        <xsl:result-document href="{concat($package-root, '/.content.xml')}" format="xml">
<jcr:root xmlns:sling="http://sling.apache.org/jcr/sling/1.0" xmlns:jcr="http://www.jcp.org/jcr/1.0" xmlns:rep="internal"
    jcr:mixinTypes="[rep:AccessControllable,rep:RepoAccessControllable]"
    jcr:primaryType="rep:root"
    sling:resourceType="sling:redirect"
    sling:target="/index.html">
    <bin/>
    <rep:repoPolicy/>
    <rep:policy/>
    <jcr:system/>
    <var/>
    <libs/>
    <etc/>
    <apps/>
    <home/>
    <tmp/>
    <content/>
</jcr:root>
        </xsl:result-document>
      </xsl:if>

      <xsl:if test="$package-create-filter = 'true'">
        <xsl:result-document href="{concat($meta-root, '/vault/filter.xml')}" format="xml">
<workspaceFilter version="1.0">
  <xsl:choose>
    <xsl:when test="$package-filter-nodes">
      <xsl:copy-of select="$package-filter-nodes" />
    </xsl:when>
    <xsl:when test="$package-filter">
      <filter root="{$package-filter}"/>
    </xsl:when>
  </xsl:choose>
</workspaceFilter>
        </xsl:result-document>
      </xsl:if>

      <xsl:if test="$package-create-properties = 'true'">
        <xsl:result-document href="{concat($meta-root, '/vault/properties.xml')}" format="xml">
<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd"&gt;</xsl:text>
<properties>
<comment>FileVault Package Properties</comment>
<entry key="createdBy"><xsl:value-of select="$package-admin"/></entry>
<entry key="name"><xsl:value-of select="$package-name"/></entry>
<entry key="lastModified"><xsl:value-of select="$package-date"/></entry>
<entry key="lastModifiedBy"><xsl:value-of select="$package-admin"/></entry>
<entry key="acHandling"><xsl:value-of select="$package-achandling"/></entry>
<entry key="created"><xsl:value-of select="$package-date"/></entry>
<entry key="buildCount"><xsl:value-of select="$package-build-count"/></entry>
<entry key="version"><xsl:value-of select="$package-version"/></entry>
<entry key="dependencies"/>
<entry key="packageFormatVersion">2</entry>
<entry key="description"><xsl:value-of select="$package-description"/></entry>
<entry key="lastWrapped"><xsl:value-of select="$package-date"/></entry>
<entry key="group"><xsl:value-of select="$package-group"/></entry>
<entry key="lastWrappedBy"><xsl:value-of select="$package-admin"/></entry>
</properties>
        </xsl:result-document>
      </xsl:if>

      <xsl:if test="$package-create-config = 'true'">
        <xsl:message>Config</xsl:message>
        <xsl:variable name="config-nodes" select="document('config.xml')" />
        <xsl:message>Config Nodes: <xsl:value-of select="$config-nodes/handlers" /></xsl:message>
        <xsl:result-document href="{concat($meta-root, '/vault/config.xml')}" format="xml" omit-xml-declaration="yes">
          <xsl:copy-of select="$config-nodes" />
        </xsl:result-document>
      </xsl:if>
        
      <xsl:if test="$package-create-nodetypes = 'true'">
        <xsl:result-document href="{concat($meta-root, '/vault/nodetypes.cnd')}" method="text"><![CDATA[
<'sling'='http://sling.apache.org/jcr/sling/1.0'>
<'nt'='http://www.jcp.org/jcr/nt/1.0'>
<'cq'='http://www.day.com/jcr/cq/1.0'>
<'rep'='internal'>
<'mix'='http://www.jcp.org/jcr/mix/1.0'>
<'jcr'='http://www.jcp.org/jcr/1.0'>

[sling:Folder] > nt:folder
  - * (undefined)
  - * (undefined) multiple
  + * (nt:base) = sling:Folder version

[sling:Redirect] > sling:Resource
  mixin
  - sling:target (undefined)

[sling:Resource]
  mixin
  - sling:resourceType (string)

[sling:OrderedFolder] > sling:Folder
  orderable
  + * (nt:base) = sling:OrderedFolder version

[cq:ReplicationStatus]
  mixin
  - cq:lastReplicatedBy (string) ignore
  - cq:lastPublished (date) ignore
  - cq:lastReplicationStatus (string) ignore
  - cq:lastPublishedBy (string) ignore
  - cq:lastReplicationAction (string) ignore
  - cq:lastReplicated (date) ignore

[cq:OwnerTaggable] > cq:Taggable
  mixin

[cq:Taggable]
  mixin
  - cq:tags (string) multiple

[rep:RepoAccessControllable]
  mixin
  + rep:repoPolicy (rep:Policy) protected ignore

[sling:VanityPath]
  mixin
  - sling:vanityPath (string) multiple
  - sling:redirectStatus (long)
  - sling:vanityOrder (long)
  - sling:redirect (boolean)

[cq:PageContent] > cq:OwnerTaggable, cq:ReplicationStatus, mix:created, mix:title, nt:unstructured, sling:Resource, sling:VanityPath
  orderable
  - cq:lastModified (date)
  - cq:template (string)
  - pageTitle (string)
  - offTime (date)
  - hideInNav (boolean)
  - cq:lastModifiedBy (string)
  - onTime (date)
  - jcr:language (string)
  - cq:allowedTemplates (string) multiple
  - cq:designPath (string)
  - navTitle (string)

[cq:Page] > nt:hierarchyNode
  orderable primaryitem jcr:content
  + jcr:content (nt:base) = nt:unstructured
  + * (nt:base) = nt:base version]]>
        </xsl:result-document>
      </xsl:if>

      <xsl:if test="$package-create-definition = 'true'">
        <xsl:result-document href="{concat($meta-root, '/vault/definition/.content.xml')}" format="xml">
<jcr:root xmlns:vlt="http://www.day.com/jcr/vault/1.0" xmlns:jcr="http://www.jcp.org/jcr/1.0" xmlns:nt="http://www.jcp.org/jcr/nt/1.0"
    jcr:created="{$lbrace}Date{$rbrace}{$package-date}"
    jcr:createdBy="{$package-admin}"
    jcr:description="{$package-description}"
    jcr:lastModified="{$lbrace}Date{$rbrace}{$package-date}"
    jcr:lastModifiedBy="{$package-admin}"
    jcr:primaryType="vlt:PackageDefinition"
    acHandling="{$package-achandling}"
    buildCount="{$package-build-count}"
    builtWith="Adobe CQ-5.6.0.20130125 (Ant-Generated)"
    group="{$package-group}"
    lastUnwrapped="{$lbrace}Date{$rbrace}{$package-date}"
    lastUnwrappedBy="{$package-admin}"
    lastWrapped="{$lbrace}Date{$rbrace}{$package-date}"
    lastWrappedBy="admin"
    name="{$package-name}"
    version="{$package-version}">
    <filter jcr:primaryType="nt:unstructured">
      <xsl:choose>
        <xsl:when test="$package-definition-filter-nodes">
          <xsl:copy-of select="$package-definition-filter-nodes" />
        </xsl:when>
        <xsl:when test="$package-filter">
          <f0
            jcr:primaryType="nt:unstructured"
            mode="{$package-mode}"
            root="{$package-filter}"
            rules="[]"/>
        </xsl:when>
      </xsl:choose>
    </filter>
</jcr:root>
        </xsl:result-document>
      </xsl:if>

    </xsl:template>

</xsl:transform>        