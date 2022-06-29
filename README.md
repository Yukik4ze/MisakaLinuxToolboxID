# Kotak Alat VPS Linux Misaka Sisters

Untuk memfasilitasi para suster untuk mengelola server mereka dengan lebih baik, saudara perempuan saya telah menulis skrip manajemen satu klik untuk Anda.

Meskipun tidak banyak fungsi yang dapat saya berikan kepada Anda manajemen satu klik, tetapi saya punya waktu untuk mempersiapkannya untuk Anda!

![image.png](https://s2.loli.net/2021/12/26/WkiwbdExvnGAXCh.png)

## instruksi

1. Berikan proyek ini Bintang 
2. Gunakan klien SSH untuk terhubung ke VPS dan masukkan perintah berikut (jika Anda bukan pengguna root, silakan `sudo -i` untuk mengeskalasi hak istimewa)

```shell
wget -N --no-check-certificate https://raw.githubusercontents.com/Yukik4ze/MisakaLinuxToolboxID/master/MisakaToolbox.sh && bash MisakaToolbox.sh
```

Setelah lari pertama, pintasan dapat digunakan untuk memulai
```bash
bash MisakaToolbox.sh
```

## Proposal Fitur Kotak Alat

Ingin menambahkan fungsionalitas baru ke kotak alat? Ada dua cara untuk memilih:
1. Kirim setelah memodifikasi kode sendiri [Pull Request](https://github.com/Misaka-blog/MisakaLinuxToolbox/pulls)
2. Kirim [Discussion](https://github.com/Misaka-blog/MisakaLinuxToolbox/discussions/20)  
Pengembang akan menambahkannya segera setelah mereka melihatnya~

## Changelog dari kakak perempuan saya

Ver 3.0 Menu toolbox refactoring, fungsi asli tidak berubah

<details>
    <summary>Catatan pembaruan riwayat (klik untuk meluaskan)</summary>
    
Ver 2.1.9 Menambahkan Skrip X-ui Modifikasi Misaka

Ver 2.1.8 Menambahkan opsi bahasa Mandarin dan skrip sumber satu klik
    
Script Misaka-WARP ditambahkan ke Ver 2.1.7 WARP

Ver 2.1.6 Menambahkan skrip Ngrok

Ver 2.1.5 Menambahkan opsi untuk melepaskan semua port jaringan VPS

Ver 2.1.4 Memodifikasi sumber pembaruan ke GitLab untuk menghindari larangan GitHub yang tidak masuk akal

Ver 2.1.3 Mengganti skripnya dengan versi blog Misaka yang diperbaiki karena lompatan jaringan

Ver 2.1.2 Menambahkan skrip satu klik CloudFlare Argo Tunnel

Ver 2.1.1 Menambahkan skrip tes misakabench

Ver 2.1.0 Selamat Tahun Baru 2022! Menambahkan panel V2ray.Fun, skrip terintegrasi untuk memodifikasi root + kata sandi

Ver 2.0.9 Menambahkan panel Trojan, skrip buka kunci streaming warp fscarmen

Ver 2.0.8 Menambahkan panel Qinglong untuk memperbaiki masalah bahwa sistem Debian murni tidak dapat memperoleh alamat IP VPS

Ver 2.0.7 Menambahkan statistik pada jumlah skrip yang dijalankan, skrip versi warp docker fscarmen

Ver 2.0.6 Menambahkan opsi sistem DD (opsi hanya ditampilkan di KVM VPS)

Ver 2.0.5 Menambahkan skrip WARP dari penulis yang berbeda untuk memberi pengguna lebih banyak pilihan. Tambahkan solusi jaringan Deji DiG9

Ver 2.0.4 Menambahkan skrip ShadowSocks, BBR mendukung IBM LinuxONE

Ver 2.0.3.1 Memecahkan masalah perbaikan modul BBR dan TUN OpenVZ

Ver 2.0.3 Mengoptimalkan mekanisme penilaian sistem dan menambahkan skrip aplikasi sertifikat Acme.sh dari blog ini

Ver 2.0.2 Menghapus skrip Pagoda Happy Edition dan mengoptimalkan aturan penilaian BBR

Ver 2.0.1 Menambahkan beberapa skrip uji VPS

Skrip refactoring Ver 2.0, untuk detailnya, lihat peta pikiran proyek Github

Ver 1.4.5 Menambahkan menonaktifkan firewall bawaan sistem Oracle, Acme.sh, dan skrip manajemen tugas latar belakang Layar

Ver 1.4.4 Meminta informasi VPS di menu utama, dan menambahkan skrip untuk menyebarkan Telegram MTProxy

Ver 1.4.3 Perbarui skrip v2 dari bos hijk untuk mendukung simpul pembuatan mesin dari IBM LinuxONE s390x

Ver 1.4.2 Perbarui skrip untuk memperbaiki masalah yang jsdelivr tidak dapat diuraikan

Ver 1.4.1 Perbaikan bug kecil tentang menambahkan probe tetapi tidak menambahkannya ke menu

Ver 1.4: Tambahkan dan ubah nama host, dan ubah beberapa masalah kecil

Ver 1.3: Tambahkan manajemen dan klien probe ServerStatus-Horatu Cola

Ver 1.2: Tambahkan deteksi media streaming, tiga skrip uji kecepatan jaringan

Ver 1.1: Tambahkan BBR dan Pagoda Happy Edition, skrip instalasi Docker
</details>

## Daftar terima kasih

Terima kasih atas kontribusi mereka untuk lebih meningkatkan skrip
<details>
    <summary>Klik untuk memperluas</summary>

BBR(KVM)：https://github.com/ylx2016/Linux-NetSpeed

BBR(OpenVZ)：https://github.com/mzz2017/lkl-haproxy/

Skenario WARP：https://github.com/fscarmen/warp

Pagoda Edisi Internasional（aapanel）：https://www.aapanel.com/

X-ui: https://github.com/vaxilu/x-ui

Aria2: https://github.com/P3TERX/aria2.sh

CyberPanel：https://cyberpanel.net/

Mack-a：https://github.com/mack-a/v2ray-agent

233boy：https://github.com/233boy/v2ray/wiki/V2Ray%E4%B8%80%E9%94%AE%E5%AE%89%E8%A3%85%E8%84%9A%E6%9C%AC

hijk：https://github.com/hijkpw/scripts

ShadowSocks: https://github.com/teddysun/shadowsocks_install/tree/master

bench.sh https://bench.sh

superbench https://github.com/oooldking/script

lemonbench https://blog.ilemonrain.com/linux/LemonBench.html

Deteksi streaming：https://github.com/lmc999/RegionRestrictionCheck

Tiga tes kecepatan jaringan：https://github.com/ernisn/superspeed/

Panel Nezha：https://github.com/naiba/nezha

ServerStartus-Horatu Cola：https://github.com/cokemine/ServerStatus-Hotaru

Sistem DD：https://www.cxthhhhh.com/network-reinstall-system-modify

Panel Qinglong：https://github.com/whyour/qinglong

Ubah bahasa sistem：https://github.com/johnrosen1/vpstoolbox
</details>  

## Mensponsori kami

Klik tombol Sponsor di bagian atas halaman untuk mensponsori kami!  
Sponsor Anda akan membantu membuat kotak peralatan menjadi lebih baik!

## Grup pertukaran
[Telegram](https://t.me/misakanetcn)

## Gudang cadangan anti-harmoni

GitHub：https://github.com/Misaka-blog/MisakaLinuxToolbox/

GitLab：https://gitlab.com/misakano7545/MisakaLinuxToolbox

BitBucket：https://bitbucket.org/misakano7545/misakalinuxtoolbox/
## Rekor pertumbuhan Bintang

[![Stargazers over time](https://starchart.cc/Misaka-blog/MisakaLinuxToolbox.svg)](https://starchart.cc/Misaka-blog/MisakaLinuxToolbox)

## Statistik Repo
![Alt](https://repobeats.axiom.co/api/embed/2512c745cf3ee94ad15c8e8ada474469e081f1c4.svg "Repobeats analytics image")

## Penyumbang
<a href="https://github.com/Yukik4ze/MisakaLinuxToolboxID/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Yukik4ze/MisakaLinuxToolboxID" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
## License
GNU General Public License v3.0  
