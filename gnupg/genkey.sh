#!/bin/bash
# Quickly generate GPG keys for use with Yubikeys.
# Therefor we generate one 4096 cert key and three 2048 subkeys.
# The master (cert) key is only stored offline, the subkeys are stored on yubikey.
# Preparation:
# * Boot a Linux CD to ensure an untampered OS
# * Go offline, unplug ethernet, etc
# * Ensure you have a HWRNG and rngd running (or keygen will take very very long)
# note on key roles:
# sign: for signing to proof your identity
# encr: for receiving encrypted data (the sender will encrypt with this key)
# auth: for authentication, used for SSH (gpg-agent --enable-ssh_support)

IDENTITY="Max Mustermann <max.mustermann@acme.com>"
MASTERKEYSIZE=rsa4096
SUBKEYSIZE=rsa2048
PASSWORD=secret
EXPIRATION=1y
BATCH="--batch --pinentry-mode=loopback --passphrase $PASSWORD"
# disable batch
#BATCH=""

if [ $# -gt 0 ]; then
    IDENTITY="$1"
fi

# create master key
echo "Creating masterkey with $MASTERKEYSIZE for $IDENTITY..."
gpg $BATCH --quick-gen-key "$IDENTITY" $MASTERKEYSIZE cert
# get fingerprint
FINGERPRINT=`gpg --list-keys --with-colons $IDENTITY | awk -F: '/^fpr:/ { print $10 }'`
echo "Fingerprint=$FINGERPRINT"
# create subkeys
echo "Creating signing subkey with $SUBKEYSIZE..."
gpg $BATCH --quick-addkey $FINGERPRINT $SUBKEYSIZE sign $EXPIRATION
echo "Creating encryption subkey with $SUBKEYSIZE..."
gpg $BATCH --quick-addkey $FINGERPRINT $SUBKEYSIZE encr $EXPIRATION
echo "Creating authentication subkey with $SUBKEYSIZE..."
gpg $BATCH --quick-addkey $FINGERPRINT $SUBKEYSIZE auth $EXPIRATION

# export data
mkdir "$IDENTITY"
echo "Exporting public keys..."
gpg $BATCH --export --armor $FINGERPRINT > "$IDENTITY/$FINGERPRINT.pub"
echo "Exporting private keys..."
gpg $BATCH --export-secret-keys --armor $FINGERPRINT > "$IDENTITY/$FINGERPRINT.prv"
echo "Exporting private subkeys..."
gpg $BATCH --export-secret-subkeys --armor $FINGERPRINT > "$IDENTITY/$FINGERPRINT.prv-sub"
if [ -f ~/.gnupg/openpgp-revocs.d/$FINGERPRINT.rev ]; then
    echo "Copying revocation certificate..."
    cp ~/.gnupg/openpgp-revocs.d/$FINGERPRINT.rev "$IDENTITY/$FINGERPRINT.rev"
else
    echo "Creating revocation certificate..."
    gpg --gen-revoke --armor $FINGERPRINT > "$IDENTITY/$FINGERPRINT.rev"
fi
