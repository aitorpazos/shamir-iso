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
- Generate a QR image:
echo "My text" | qrencode -o <qr file.png>
- Display QR image:
display <qr file.png>

## Experimental USB printer support:

- Add a printer (user: user , password: user) using CUPS admin page in the browser:
http://127.0.0.1:631/admin
- Display detected printers:
lpstat -p
- Print file:
lp <file to print>
