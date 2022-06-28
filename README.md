# Kotak Alat VPS Linux Misaka Sisters

Untuk memfasilitasi para suster untuk mengelola server mereka dengan lebih baik, saudara perempuan saya telah menulis skrip manajemen satu klik untuk Anda.

Meskipun tidak banyak fungsi yang dapat saya berikan kepada Anda manajemen satu klik, tetapi saya punya waktu untuk mempersiapkannya untuk Anda!

![image.png](https://s2.loli.net/2021/12/26/WkiwbdExvnGAXCh.png)

## instruksi

1. Berikan proyek ini Bintang 
2. Gunakan klien SSH untuk terhubung ke VPS dan masukkan perintah berikut (jika Anda bukan pengguna root, silakan `sudo -i` untuk mengeskalasi hak istimewa)

```shell
wget -N --no-check-certificate https://raw.githubusercontents.com/Yukik4ze/MisakaLinuxToolboxID/master/MisakaToolboxID.sh && bash MisakaToolboxID.sh
```

Setelah lari pertama, pintasan dapat digunakan untuk memulai
```bash
bash MisakaToolboxID.sh
```

## Proposal Fitur Kotak Alat

Ingin menambahkan fungsionalitas baru ke kotak alat? Ada dua cara untuk memilih:
1. Kirim setelah memodifikasi kode sendiri [Pull Request](https://github.com/Misaka-blog/MisakaLinuxToolbox/pulls)
2. Kirim [Discussion](https://github.com/Misaka-blog/MisakaLinuxToolbox/discussions/20)  
Pengembang akan menambahkannya segera setelah mereka melihatnya~

## Changelog dari kakak perempuan saya

Ver 3.0 Menu toolbox refactoring, fungsi asli tidak berubah

<details>
    <summary>历史更新记录（点击展开）</summary>
    
Ver 2.1.9 新增Misaka魔改版X-ui脚本

Ver 2.1.8 新增设置中文语言选项和一键换源脚本
    
Ver 2.1.7 WARP处新增Misaka-WARP脚本

Ver 2.1.6 新增Ngrok脚本

Ver 2.1.5 新增放开VPS所有网络端口选项

Ver 2.1.4 修改更新源为GitLab以规避GitHub无故封号

Ver 2.1.3 由于网络跳跃跑路，故将他的脚本替代为Misaka-blog的修复版

Ver 2.1.2 增加CloudFlare Argo Tunnel一键脚本

Ver 2.1.1 增加misakabench测试脚本

Ver 2.1.0 2022新年快乐！增加V2ray.Fun面板，集成修改root+密码脚本

Ver 2.0.9 增加Trojan面板，fscarmen的warp流媒体解锁脚本

Ver 2.0.8 增加青龙面板，修复纯净Debian系统获取不到VPS IP地址的问题

Ver 2.0.7 增加脚本运行次数统计，fscarmen的warp docker版脚本

Ver 2.0.6 增加DD系统选项（选项仅在KVM VPS显示）

Ver 2.0.5 添加不同作者的WARP脚本，给予用户更多选择。增加德鸡DiG9网络解决方案

Ver 2.0.4 增加安装ShadowSocks脚本，BBR支持IBM LinuxONE

Ver 2.0.3.1 解决修复OpenVZ的BBR，TUN模块判断问题

Ver 2.0.3 优化系统判断机制，增加本博客的Acme.sh证书申请脚本

Ver 2.0.2 删除宝塔开心版脚本，优化BBR判断规则

Ver 2.0.1 新增一些VPS测试脚本

Ver 2.0 重构脚本，详细内容可看Github项目的思维导图

Ver 1.4.5 新增禁用Oracle系统自带防火墙、Acme.sh和Screen后台任务管理脚本

Ver 1.4.4 在主菜单提示VPS信息，并新增部署Telegram MTProxy脚本

Ver 1.4.3 更新hijk大佬的v2脚本，支持IBM LinuxONE s390x的机器搭建节点

Ver 1.4.2 更新脚本，修复jsdelivr无法解析问题

Ver 1.4.1 关于加了探针却没加到菜单的一个小bug的修复

Ver 1.4: 添加修改主机名，以及修改一些小问题

Ver 1.3: 添加可乐的ServerStatus-Horatu探针管理及客户端

Ver 1.2: 添加流媒体检测，三网测速脚本

Ver 1.1: 添加BBR及宝塔开心版、Docker安装脚本
</details>

## Daftar terima kasih

Terima kasih atas kontribusi mereka untuk lebih meningkatkan skrip
<details>
    <summary>点击展开</summary>

BBR(KVM)：https://github.com/ylx2016/Linux-NetSpeed

BBR(OpenVZ)：https://github.com/mzz2017/lkl-haproxy/

WARP脚本：https://github.com/fscarmen/warp

宝塔国际版（aapanel）：https://www.aapanel.com/

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

流媒体检测：https://github.com/lmc999/RegionRestrictionCheck

三网测速：https://github.com/ernisn/superspeed/

哪吒面板：https://github.com/naiba/nezha

可乐 ServerStartus-Horatu：https://github.com/cokemine/ServerStatus-Hotaru

DD系统：https://www.cxthhhhh.com/network-reinstall-system-modify

青龙面板：https://github.com/whyour/qinglong

更换系统语言：https://github.com/johnrosen1/vpstoolbox
</details>  

## 赞助我们

点击页面上方的Sponsor按钮，赞助我们！  
你的赞助会帮助工具箱变得更完善！

## 交流群
[Telegram](https://t.me/misakanetcn)

## 防和谐备份仓库

GitHub：https://github.com/Misaka-blog/MisakaLinuxToolbox/

GitLab：https://gitlab.com/misakano7545/MisakaLinuxToolbox

BitBucket：https://bitbucket.org/misakano7545/misakalinuxtoolbox/
## Stars 增长记录

[![Stargazers over time](https://starchart.cc/Misaka-blog/MisakaLinuxToolbox.svg)](https://starchart.cc/Misaka-blog/MisakaLinuxToolbox)

## Repo 统计
![Alt](https://repobeats.axiom.co/api/embed/2512c745cf3ee94ad15c8e8ada474469e081f1c4.svg "Repobeats analytics image")

## 贡献者
<a href="https://github.com/Misaka-blog/MisakaLinuxToolbox/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Misaka-blog/MisakaLinuxToolbox" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
## License
GNU General Public License v3.0  
