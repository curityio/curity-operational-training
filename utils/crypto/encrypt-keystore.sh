#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")"

CLASSPATH="$IDSVR_HOME/lib/*:$IDSVR_HOME/lib/xml-tools/*"
XML_FILE=$(mktemp)
XSLT_FILE=$(mktemp)
trap 'rm -f "$XML_FILE $XSLT_FILE"' EXIT

cat <<'EOF' > $XSLT_FILE
<stylesheet version="1.0" xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xalan="http://xml.apache.org/xalan"
            xmlns:sec="xalan://se.curity.identityserver.crypto.ConvertKeyStore"
            exclude-result-prefixes="xalan">
    <output indent="no" omit-xml-declaration="yes"/>

    <param name="encryptionKey" select="initialValue"/>
    <param name="decryptionKeys"/>

    <template match="valueToEncrypt">
      <variable name="data">
        <value-of select="." />
      </variable>
      <value-of select="sec:reencryptKeyStores($data, $encryptionKey, $decryptionKeys)"/>
    </template>
    <template match="text()"/>
</stylesheet>
EOF

cat <<EOF > $XML_FILE
<values>
  <valueToEncrypt>$PLAINTEXT</valueToEncrypt>
</values>
EOF

java -cp "$CLASSPATH" org.apache.xalan.xslt.Process \
  -xsl "$XSLT_FILE" \
  -in "$XML_FILE" \
  -param encryptionKey "$CONFIG_ENCRYPTION_KEY"