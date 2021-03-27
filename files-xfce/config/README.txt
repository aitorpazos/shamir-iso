# Sharmir ISO tips

These commands are only provided to try to help you in the use of this image. 

They may or may not suit your needs.
- Split a key in n number of pieces that you can recover with any x number of them (max 128 characters):
echo "My key" | ssss-split -t <x> -n <n>
- Recover the key from t number of pieces:
ssss-combine -t <t>
- If the key is longer than 128 characters, you can split it into n number of pieces using the following
 command:
split -n <n> <my file with the key>
- Generate scrypt derived keys
echo "My passphrase" | scrypt-rs -l<generated key length> -s <salt string>
- Generate a QR image:
echo "My text" | qrencode -o <qr file.png>
- Display QR image:
display <qr file.png>
- Scan QR code using webcam:
zbarcam --raw

If you are dealing with BIP39 word lists or seeds you can use the `hal` command:
hal bip39 get-seed "your BIP words" | jq -r .entropy | ssss-split -t <x> -n <n>

In order to recover the original words, you can run:
ssss-combine -t <t>
and then generate the words from the returned value:
hal bip39 generate -w <number of words> --entropy <entropy value>

If you don't select the correct number of words, the generation will fail. However the possible values are: 
3, 6, 9, 12, 15, 18, 21 or 24 (the usual ones being 12 and 24).

## Experimental USB printer support:

- You can generate a card that you can print using your browser with the following command:
create-key-share-card SHARE_NAME SHARE_KEY_VALUE

This command will generate a SHARE_NAME.htm file that you can open in the browser and print it from it after you
configure a printer.

- Add a printer (user: user , password: user) using CUPS admin page in the browser:
http://127.0.0.1:631/admin
- Display detected printers:
lpstat -p
- Print file:
lp <file to print>
