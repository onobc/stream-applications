#!/usr/bin/env bash
if [ "$1" = "" ]; then
  echo "Version argument required"
  exit 2
fi
VERSION=$1
REL_TYPE=libs_release_local
if [[ "$VERSION" = *"-SNAPSHOT"* ]]; then
  REL_TYPE=libs_release_local
elif [[ "$VERSION" = *"-M"* ]]; then
  REL_TYPE=libs_milestone_local
elif [[ "$VERSION" = *"-R"* ]]; then
  REL_TYPE=libs_milestone_local
else
  REL_TYPE=libs_release_local
fi
if [[ "$VERSION" = *"-SNAPSHOT"* ]]; then
  META_DATA="https://repo.spring.io/snapshot/org/springframework/cloud/stream/app/stream-applications-docs/${VERSION}/maven-metadata.xml"
  echo "Downloading $META_DATA"
  curl -o maven-metadata.xml -s $META_DATA
  DL_TS=$(xmllint --xpath "/metadata/versioning/snapshot/timestamp/text()" maven-metadata.xml | sed 's/\.//')
  DL_VERSION=$(xmllint --xpath "/metadata/versioning/snapshotVersions/snapshotVersion[extension/text() = 'pom' and updated/text() = '$DL_TS']/value/text()" maven-metadata.xml)
  PATH=${REL_TYPE}/org/springframework/cloud/stream/app/stream-applications-docs/${VERSION}/stream-applications-docs-${DL_VERSION}.zip
else
  PATH=${REL_TYPE}/org/springframework/cloud/stream/app/stream-applications-docs/${VERSION}/stream-applications-docs-${VERSION}.zip
fi
PROPS="zip.deployed=false;zip.type=docs;zip.name=stream-applications;zip.displayname=Stream Applications"
echo "Setting $PROPS on $PATH"
jfrog rt set-props --server-id repo.spring.io "$PATH" "$PROPS"
