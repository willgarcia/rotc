#!/usr/bin/env bash

set -euo pipefail

curl https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc -o gh-md-toc
chmod a+x gh-md-toc
./gh-md-toc `find . -iname "*.md" | grep 0 | sort` >> README.md