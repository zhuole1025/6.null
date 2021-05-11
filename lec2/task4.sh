#!/usr/bin/env bash

find . -name "*.html" -print0 | xargs -0 zip -r html.zip