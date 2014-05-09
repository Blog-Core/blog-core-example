#!/usr/bin/env bash

set -o errexit
set -o nounset

# Make debconf not complain about
# us not using terminal.

export DEBIAN_FRONTEND=noninteractive

apt-get update

# Install extra tools for aptitude.

apt-get install -y curl

# Remove cruft

apt-get clean

rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Obtain the Swi-Prolog installation path.

eval `swipl --dump-runtime-variables`

if [[ -z "$PLBASE" ]]; then

    echo "PLBASE is not detected"
    exit 1
fi

# Download dependencies.

readonly TMP=/tmp/blog-core-example

mkdir -p "$TMP"

readonly PACK_AROUTER=arouter-1.0.0.tgz
readonly PACK_BLOG_CORE=blog_core-0.0.1.tgz
readonly PACK_DICT_SCHEMA=dict_schema-0.0.2.tgz
readonly PACK_DOCSTORE=docstore-1.0.1.tgz
readonly PACK_MARKDOWN=markdown-0.0.2.tgz
readonly PACK_SIMPLE_TEMPLATE=simple_template-0.3.0.tgz
readonly PACK_SORT_DICT=sort_dict-0.0.3.tgz
readonly PACK_LIST_UTIL=list_util-0.3.0.tgz

# Download packs.

curl -# "http://packs.rlaanemets.com/alternative-router/$PACK_AROUTER" > "$TMP/$PACK_AROUTER"
curl -# "http://packs.rlaanemets.com/blog-core/$PACK_BLOG_CORE" > "$TMP/$PACK_BLOG_CORE"
curl -# "http://packs.rlaanemets.com/dict-schema/$PACK_DICT_SCHEMA" > "$TMP/$PACK_DICT_SCHEMA"
curl -# "http://packs.rlaanemets.com/docstore/$PACK_DOCSTORE" > "$TMP/$PACK_DOCSTORE"
curl -# "http://packs.rlaanemets.com/markdown/$PACK_MARKDOWN" > "$TMP/$PACK_MARKDOWN"
curl -# "http://packs.rlaanemets.com/simple-template/$PACK_SIMPLE_TEMPLATE" > "$TMP/$PACK_SIMPLE_TEMPLATE"
curl -# "http://packs.rlaanemets.com/sort-dict/$PACK_SORT_DICT" > "$TMP/$PACK_SORT_DICT"
curl -# "http://packs.ndrix.com/list_util/$PACK_LIST_UTIL" > "$TMP/$PACK_LIST_UTIL"

# Extract Prolog modules.

tar -xf "$TMP/$PACK_AROUTER" -C "$TMP" prolog
tar -xf "$TMP/$PACK_BLOG_CORE" -C "$TMP" prolog
tar -xf "$TMP/$PACK_DICT_SCHEMA" -C "$TMP" prolog
tar -xf "$TMP/$PACK_DOCSTORE" -C "$TMP" prolog
tar -xf "$TMP/$PACK_MARKDOWN" -C "$TMP" prolog
tar -xf "$TMP/$PACK_SIMPLE_TEMPLATE" -C "$TMP" prolog
tar -xf "$TMP/$PACK_SORT_DICT" -C "$TMP" prolog
tar -xf "$TMP/$PACK_LIST_UTIL" -C "$TMP" prolog

# Install into Swi.

cp -v -r "$TMP/prolog/"* "$PLBASE/library"

rm -rf "$TMP"
