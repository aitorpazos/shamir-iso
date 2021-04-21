# Sharmir ISO tips

These commands are only provided to try to help you in the use of this image. 

They may or may not suit your needs.
- Split a key in n number of pieces that you can recover with any x number of them (max 128 characters):
echo "My key" | ssss-rs split -t <x> -s <n> -i -
- Recover the key from t number of pieces:
ssss-rs combine <shares space separated>
- Generate scrypt derived keys
echo "My passphrase" | scrypt-rs -l<generated key length> -s <salt string>
- Generate a QR image:
echo "My text" | qrencode -o <qr file.png>
- Display QR image:
display <qr file.png>
- Scan QR code using webcam:
zbarcam --raw

If you are dealing with BIP39 word lists or seeds you can use the `hal` command:
hal bip39 get-seed "your BIP words" | jq -r .entropy | ssss-rs split -t <x> -s <n> -i -

In order to recover the original words, you can run:
ssss-rs combine <shares space separated>
and then generate the words from the returned value:
hal bip39 generate -w <number of words> --entropy <entropy value>

If you don't select the correct number of words, the generation will fail. However the possible values are: 
3, 6, 9, 12, 15, 18, 21 or 24 (the usual ones being 12 and 24).
