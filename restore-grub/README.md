# PANDUAN SINGKAT !! RESTORE GRUB !!
(windows sialan = damn you windows = くそ windows = windows asu = i helvete windows)

========================================== PROLOG ==========================================
Hari itu merupakan hari yang indah. Ayahmu baru saja memberikan sebuah laptop gaming terbaru untuk kamu gunakan sehari-hari. Tentunya kamu yang merupakan seorang gamer dan programmer merasa senang dengan laptop ini. Namun, sayang sekali laptopmu memiliki OS Windows 10 dan kamu ingin mengupdatenya menjadi Windows 11 bersama dengan Debian 8 untuk programming. Ketika kamu selesai menginstall Debian dan mengupdate Windows, kamu pun terkejut. Alangkah anehnya laptop yang baru saja kamu beli hanya bisa menggunakan Windows 11 dan tidak ada pilihan untuk memakai Debian 8. Bagai petir di siang bolong, kamu baru sadar bahwa... Ya, Windows akan selalu mengganti boot loader yang ada dengan miliknya karena dia berasumsi bahwa dialah satu-satunya OS pada perangkat itu. Ditemani kekesalan akan OS Windows, kamu pun segera mencari cara untuk memperbaiki GRUB Debian 8 ini. Semua ini salah Windows, memang Windows sialan!!!!

Cara untuk me-restore GRUB adalah dengan menggunakan langkah-langkah berikut ini:
Reference: https://askubuntu.com/questions/88384/how-can-i-repair-grub-how-to-get-ubuntu-back-after-installing-windows

1. Import main.ova ke VM (e.g. VirtualBox)
2. Boot ke VM. Boot harusnya terlihat gagal.
3. Berikutnya coba boot menggunakan live CD.
4. Gunakan command-command dibawah ini untuk mendapat list partisi yang tersedia. Cari root untuk Linux filesystem.
a. sudo fdisk -l
b. Gunakan command ini untuk mount: sudo mount /dev/sdXY /mnt
c. Dengan contoh /dev/sda2
d. Mount partisi EFI menggunakan command: sudo mount /dev/sdXX /mnt/boot/efi
e. Dengan contoh /dev/sda1
f. Gunakan command ini: for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
g. Ganti root partisi menjadi /mnt dan lakukan instalasi serta update GRUB: sudo chroot /mnt
h. Pada chroot, gunakan command ini: grub-install /dev/sdX lalu update-grub
   Pada contoh ini, devicenya adalah /dev/sda
i. Jika terdapat kasus dimana efivars tidak ditemukan, gunakan command dibawah ini:
   mount -t efivarfs none /sys/firmware/efi/efivars
j. Keluar dari chroot (Ctrl+D) dan gunakan command ini: sudo reboot
k. Coba untuk masuk menggunakan credentials berikut:
   User: user
   Password: qwertyui

Selamat mencoba!

𝓘𝓷 𝓢𝓸𝓵𝓲𝓽𝓾𝓭𝓮 𝓦𝓱𝓮𝓻𝓮 𝓦𝓮 𝓐𝓻𝓮 𝓛𝓮𝓪𝓼𝓽 𝓐𝓵𝓸𝓷𝓮.

COPYRIGHT 2023 Nexafero. No Rights Reserved.