#!/usr/bin/env sh

set -e

# Verify Language Extractors
scalibr -plugins="$LANGUAGE_EXTRACTORS" -o textproto=/tmp/result.textproto
grep -q "$DEFAULT_PKG_FILE" /tmp/result.textproto || { echo "FAIL: DEFAULT_PKG_FILE: $DEFAULT_PKG_FILE not found"; exit 1; }
grep -q "$EXTRA_PKG_FILE" /tmp/result.textproto || { echo "FAIL: EXTRA_PKG_FILE: $EXTRA_PKG_FILE not found"; exit 1; }

echo "----"

# Verify OS Extractor
scalibr -plugins="$OS_EXTRACTOR" -o textproto=/tmp/result.textproto
grep -qE "\sname:\s+\"$DEFAULT_PKG\"" /tmp/result.textproto || { echo "FAIL: DEFAULT_PKG: $DEFAULT_PKG not detected by OS extractor"; exit 1; }
grep -qE "\sname:\s+\"$EXTRA_PKG\"" /tmp/result.textproto || { echo "FAIL: EXTRA_PKG: $EXTRA_PKG not detected by OS extractor"; exit 1; }

echo "----"

# Verify that exploitability_signals are only added to default pkg related packages:

scalibr -plugins="$OS_EXTRACTOR,$DUP_ANNOTATOR,$LANGUAGE_EXTRACTORS" -o textproto=/tmp/result.textproto
cat /tmp/result.textproto | grep -B 5 'exploitability_signals' | grep -qv "$EXTRA_PKG_FILE" || { echo "FAIL: exploitability_signals added to inventory found inside the EXTRA_PKG_FILE: $EXTRA_PKG_FILE"; exit 1; }
cat /tmp/result.textproto | grep -B 5 'exploitability_signals' | grep -q "$DEFAULT_PKG_FILE" || { echo "FAIL: no exploitability_signals added to inventory found inside the DEFAULT_PKG_FILE: $DEFAULT_PKG_FILE"; exit 1; }

echo "--- All Tests Passed ---"
