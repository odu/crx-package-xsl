# CRX Package Vault XSL Helper

This is a helper XSL file that will help create the necessary CRX vault package files to create a package using XSLT.  It can be used to create the appropriate `jcr_root/.content.xml`, `META-INF/vault/` `properties.xml`, `filter.xml`, and optionally `nodetypes.cnd`, `config.xml`, and `definition/.content.xml` files.  To the best of my knowledge the optional files aren't really needed in current versions and are turned off by default, but this isn't based on anything concrete, only trail and error on AEM 5.6.

* Installing packages can delete and modify data.  If the filters are wrong the package will happily delete a ton of data. *

## Usage

In your XSL file to generate a package, include the vault.xsl file, set the appropriate parameters and call the vault-files temlplate.

In the header area of your xsl file before any templates are defined:

```
    <xsl:import href="vault.xsl"/>

    <!-- Vault Parameters -->
    <xsl:variable name="package-name">Sample Package</xsl:variable>
    <xsl:variable name="package-description">Sample Package</xsl:variable>
```

In a template that only runs once such as the below root template:

```
    <xsl:template match="/">

        <!-- Do You Own Package Actions -->
        
        <!-- Include Standard Vault Files -->
        <xsl:call-template name="vault-files" />

    </xsl:template>
```

## Parameters

The Vault Parameters are defined in vault.xsl and easily overriden by top-level variables in your calling XSL file.

`package-name` Default: "Generated Package", the Package `name` defined in the properties.xml and optional definition/.content.xml (hereafter known as metadata)

`package-description` Default: "Generated Package", the `description` in metadata.

`package-root` Default: "package/jcr_root", the desired location for the output files for the `jcr_root/.content.xml` file.

`meta-root` Default: "package/META-INF", the desired location for the metadate output files in META-INF.

`package-group` Default: "my_packages", the `group` in metadata

`package-admin` Default: "admin", the Package Admin name for the metadata attributes `createdBy`, `lastModifiedBy`, and `lastWrappedBy`.

`package-version` Default: "", the package `version` in metadata

`package-build-count` Default: "1", the `buildCount` in metadata

`package-achandling` Default: "merge_preserve", the `acHandling` in metadata

`package-mode` Default: "replace", the filter mode in the optional `definition/.config.xml`.  This is overriden if the `package-definition-filter-nodes` is present.

`package-filter` Default: "/content/generated", the filter/@root property in both the `filter.xml` and the `filter/f0/@root` property in `definition/.config.xml`.  These are individually overriden by the two below node-based options, `package-filter-nodes` and `package-definition-filter-nodes`

`package-filter-nodes`, there is no default but this provides the ability to include multiple filters and complex filter rules as nodes for the `filter.xml` file.  Example:

```
<xsl:variable name="package-filter-nodes">
    <filter root="/content/package-test-node-1"/>
    <filter root="/content/package-test-node-2"/>
</xsl:variable>
```

`package-definition-filter-nodes`, there is no default but this provides the ability to include multiple filters and complex filter rules as nodes for the `definition/.content.xml` file.  This is also not created (nor needed) by default, see `package-create-definition` option.  Example:

```
<xsl:variable name="package-definition-filter-nodes">
    <f0
        jcr:primaryType="nt:unstructured"
        mode="replace"
        root="/content/package-test-node-1"
        rules="[]"/>
    <f1
        jcr:primaryType="nt:unstructured"
        mode="replace"
        root="/content/package-test-node-2"
        rules="[]"/>
</xsl:variable>
```

`package-date` Default: "current-dateTime()", the metadata dates for `jcr:lastModified`, `created`, `lastWrapped`, and `lastUnwrapped`.

`package-create-root-content` Default: "true", Option to supress the creation of the `jcr_root/.content.xml` file.

`package-create-filter` Default: "true", Option to supress the creation of the `META-INF/vault/filter.xml` file.

`package-create-properties` Default: "true", Option to supress the creation of the `META-INF/vault/properties.xml` file.

`package-create-config` Default: "false", Option to create of the `META-INF/vault/config.xml` file.  This is a file labeled as confidential by Adobe and therefore not provided by this library.  If it is desired, build a package and unzip, finding the `META-INF/vault/config.xml` and place beside the vault.xsl file.  The vault.xsl will effectively copy this into the META-INF/vault location.

`package-create-nodetypes` Default: "false", Option to create of the `META-INF/vault/nodetypes.cnd` file.

`package-create-definition` Default: "false", Option to create of the `META-INF/vault/definition/.config.xml` file.