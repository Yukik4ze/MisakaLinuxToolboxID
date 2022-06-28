#!/bin/bash

version="v3.0"
version_log="Memfaktorkan ulang menu skrip kotak peralatan, fungsi aslinya tetap tidak berubah."

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
PLAIN="\033[0m"

red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}

yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}

REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|alma|rocky" "'amazon linux'")
RELEASE=("Debian" "Ubuntu" "CentOS" "CentOS")
PACKAGE_UPDATE=("apt-get update" "apt-get update" "yum -y update" "yum -y update")
PACKAGE_INSTALL=("apt -y install" "apt -y install" "yum -y install" "yum -y install")
PACKAGE_REMOVE=("apt -y remove" "apt -y remove" "yum -y remove" "yum -y remove")
PACKAGE_UNINSTALL=("apt -y autoremove" "apt -y autoremove" "yum -y autoremove" "yum -y autoremove")

CMD=("$(grep -i pretty_name /etc/os-release 2>/dev/null | cut -d \" -f2)" "$(hostnamectl 2>/dev/null | grep -i system | cut -d : -f2)" "$(lsb_release -sd 2>/dev/null)" "$(grep -i description /etc/lsb-release 2>/dev/null | cut -d \" -f2)" "$(grep . /etc/redhat-release 2>/dev/null)" "$(grep . /etc/issue 2>/dev/null | cut -d \\ -f1 | sed '/^[ ]*$/d')") 

for i in "${CMD[@]}"; do
    SYS="$i" 
    if [[ -n $SYS ]]; then
        break
    fi
done

for ((int = 0; int < ${#REGEX[@]}; int++)); do
    if [[ $(echo "$SYS" | tr '[:upper:]' '[:lower:]') =~ ${REGEX[int]} ]]; then
        SYSTEM="${RELEASE[int]}"
        if [[ -n $SYSTEM ]]; then
            break
        fi
    fi
done

[[ $EUID -ne 0 ]] && red "Catatan: Silakan jalankan skrip di bawah pengguna root" && exit 1
[[ -z $SYSTEM ]] && red "Sistem saat ini yang tidak mendukung VPS, silakan gunakan sistem operasi mainstream" && exit 1

check_status(){
    yellow "Memeriksa status sistem VPS..."
    if [[ -z $(type -P curl) ]]; then
        yellow "Mendeteksi bahwa curl tidak diinstal, sedang diinstal ..."
        if [[ ! $SYSTEM == "CentOS" ]]; then
            ${PACKAGE_UPDATE[int]}
        fi
        ${PACKAGE_INSTALL[int]} curl
    fi
    if [[ -z $(type -P sudo) ]]; then
        yellow "Deteksi sudo tidak diinstal, instal ..."
        if [[ ! $SYSTEM == "CentOS" ]]; then
            ${PACKAGE_UPDATE[int]}
        fi
        ${PACKAGE_INSTALL[int]} sudo
    fi

    IPv4Status=$(curl -s4m8 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
    IPv6Status=$(curl -s6m8 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)

    if [[ $IPv4Status =~ "on"|"plus" ]] || [[ $IPv6Status =~ "on"|"plus" ]]; then
        # Matikan Wgcf-WARP jika terjadi salah pengenalan
        wg-quick down wgcf >/dev/null 2>&1
        v66=`curl -s6m8 https://ip.gs -k`
        v44=`curl -s4m8 https://ip.gs -k`
        wg-quick up wgcf >/dev/null 2>&1
    else
        v66=`curl -s6m8 https://ip.gs -k`
        v44=`curl -s4m8 https://ip.gs -k`
    fi

    if [[ $IPv4Status == "off" ]]; then
        w4="${RED}WARP tidak diaktifkan${PLAIN}"
    fi
    if [[ $IPv6Status == "off" ]]; then
        w6="${RED}WARP tidak diaktifkan${PLAIN}"
    fi
    if [[ $IPv4Status == "on" ]]; then
        w4="${YELLOW}Akun Gratis WARP${PLAIN}"
    fi
    if [[ $IPv6Status == "on" ]]; then
        w6="${YELLOW}Akun Gratis WARP${PLAIN}"
    fi
    if [[ $IPv4Status == "plus" ]]; then
        w4="${GREEN}WARP+ / Teams${PLAIN}"
    fi
    if [[ $IPv6Status == "plus" ]]; then
        w6="${GREEN}WARP+ / Teams${PLAIN}"
    fi

    # Deskripsi variabel VPSIP: 0 adalah VPS IPv6 murni, 1 adalah VPS IPv4 murni, 2 adalah VPS dual-stack asli
    if [[ -n $v66 ]] && [[ -z $v44 ]]; then
        VPSIP=0
    elif [[ -z $v66 ]] && [[ -n $v44 ]]; then
        VPSIP=1
    elif [[ -n $v66 ]] && [[ -n $v44 ]]; then
        VPSIP=2
    fi

    v4=$(curl -s4m8 https://ip.gs -k)
    v6=$(curl -s6m8 https://ip.gs -k)
    c4=$(curl -s4m8 https://ip.gs/country -k)
    c6=$(curl -s6m8 https://ip.gs/country -k)
    s5p=$(warp-cli --accept-tos settings 2>/dev/null | grep 'WarpProxy on port' | awk -F "port " '{print $2}')
    w5p=$(grep BindAddress /etc/wireguard/proxy.conf 2>/dev/null | sed "s/BindAddress = 127.0.0.1://g")
    if [[ -n $s5p ]]; then
        s5s=$(curl -sx socks5h://localhost:$s5p https://www.cloudflare.com/cdn-cgi/trace -k --connect-timeout 8 | grep warp | cut -d= -f2)
        s5i=$(curl -sx socks5h://localhost:$s5p https://ip.gs -k --connect-timeout 8)
        s5c=$(curl -sx socks5h://localhost:$s5p https://ip.gs/country -k --connect-timeout 8)
    fi
    if [[ -n $w5p ]]; then
        w5s=$(curl -sx socks5h://localhost:$w5p https://www.cloudflare.com/cdn-cgi/trace -k --connect-timeout 8 | grep warp | cut -d= -f2)
        w5i=$(curl -sx socks5h://localhost:$w5p https://ip.gs -k --connect-timeout 8)
        w5c=$(curl -sx socks5h://localhost:$w5p https://ip.gs/country -k --connect-timeout 8)
    fi

    if [[ -z $s5s ]] || [[ $s5s == "off" ]]; then
        s5="${RED}Belum dimulai${PLAIN}"
    fi
    if [[ -z $w5s ]] || [[ $w5s == "off" ]]; then
        w5="${RED}Belum dimulai${PLAIN}"
    fi
    if [[ $s5s == "on" ]]; then
        s5="${YELLOW}Akun Gratis WARP${PLAIN}"
    fi
    if [[ $w5s == "on" ]]; then
        w5="${YELLOW}Akun Gratis WARP${PLAIN}"
    fi
    if [[ $s5s == "plus" ]]; then
        s5="${GREEN}WARP+ / Teams${PLAIN}"
    fi
    if [[ $w5s == "plus" ]]; then
        w5="${GREEN}WARP+ / Teams${PLAIN}"
    fi
}

open_ports(){
    systemctl stop firewalld.service 2>/dev/null
    systemctl disable firewalld.service 2>/dev/null
    setenforce 0 2>/dev/null
    ufw disable 2>/dev/null
    iptables -P INPUT ACCEPT 2>/dev/null
    iptables -P FORWARD ACCEPT 2>/dev/null
    iptables -P OUTPUT ACCEPT 2>/dev/null
    iptables -t nat -F 2>/dev/null
    iptables -t mangle -F 2>/dev/null
    iptables -F 2>/dev/null
    iptables -X 2>/dev/null
    netfilter-persistent save 2>/dev/null
    green "Port firewall VPS telah dirilis!"
}

bbr_script(){
    virt=$(systemd-detect-virt)
    TUN=$(cat /dev/net/tun 2>&1 | tr '[:upper:]' '[:lower:]')
    if [[ ${virt} =~ "kvm"|"zvm"|"microsoft"|"xen"|"vmware" ]]; then
        wget -N --no-check-certificate "https://raw.githubusercontents.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
    elif [ ${virt} == "openvz" ]; then
        if [[ ! $TUN =~ 'in bad state' ]] && [[ ! $TUN =~ 'Sedang dalam keadaan error.' ]] && [[ ! $TUN =~ 'Pegangan file dalam kondisi buruk' ]]; then
            wget -N --no-check-certificate https://raw.githubusercontents.com/Misaka-blog/tun-script/master/tun.sh && bash tun.sh
        else
            wget -N --no-check-certificate https://raw.githubusercontents.com/mzz2017/lkl-haproxy/master/lkl-haproxy.sh && bash lkl-haproxy.sh
        fi
    else
        red "Maaf, arsitektur virtualisasi VPS Anda tidak mendukung skrip akselerasi bbr untuk sementara"
    fi
}

v6_dns64(){
    wg-quick down wgcf 2>/dev/null
    v66=`curl -s6m8 https://ip.gs -k`
    v44=`curl -s4m8 https://ip.gs -k`
    if [[ -z $v44 && -n $v66 ]]; then
        echo -e "nameserver 2a01:4f8:c2c:123f::1" > /etc/resolv.conf
        green "Siapkan server DNS64 dengan sukses!"
    else
        red "VPS IPv6 non-murni, gagal menyiapkan server DNS64!"
    fi
    wg-quick up wgcf 2>/dev/null
}

warp_script(){
    green "Silakan pilih skrip yang akan Anda gunakan selanjutnya"
    echo "1. Misaka-WARP"
    echo "2. fscarmen"
    echo "3. fscarmen-docker"
    echo "4. fscarmen warp membuka skrip streaming Netflix"
    echo "5. P3TERX"
    echo "0. Kembali ke menu utama"
    echo ""
    read -rp "Silakan masukkan opsi:" warpNumberInput
	case $warpNumberInput in
        1) wget -N https://raw.githubusercontents.com/Misaka-blog/Misaka-WARP-Script/master/misakawarp.sh && bash misakawarp.sh ;;
        2) wget -N https://raw.githubusercontents.com/fscarmen/warp/main/menu.sh && bash menu.sh ;;
        3) wget -N https://raw.githubusercontents.com/fscarmen/warp/main/docker.sh && bash docker.sh ;;
        4) bash <(curl -sSL https://raw.githubusercontents.com/fscarmen/warp_unlock/main/unlock.sh) ;;
        5) bash <(curl -fsSL https://raw.githubusercontents.com/P3TERX/warp.sh/main/warp.sh) menu ;;
        0) menu ;;
    esac
}

# Set Bahasa
setChinese(){
    chattr -i /etc/locale.gen
    cat > '/etc/locale.gen' << EOF
zh_CN.UTF-8 UTF-8
zh_TW.UTF-8 UTF-8
en_US.UTF-8 UTF-8
ja_JP.UTF-8 UTF-8
EOF
    locale-gen
    update-locale
    chattr -i /etc/default/locale
    cat > '/etc/default/locale' << EOF
LANGUAGE="zh_CN.UTF-8"
LANG="zh_CN.UTF-8"
LC_ALL="zh_CN.UTF-8"
EOF
    export LANGUAGE="zh_CN.UTF-8"
    export LANG="zh_CN.UTF-8"
    export LC_ALL="zh_CN.UTF-8"
}

aapanel(){
    if [[ $SYSTEM = "CentOS" ]]; then
        yum install -y wget && wget -O install.sh http://www.aapanel.com/script/install_6.0_en.sh && bash install.sh forum
    elif [[ $SYSTEM = "Debian" ]]; then
        wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && bash install.sh forum
    else
        wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && sudo bash install.sh forum
    fi
}

xui() {
    echo "                            "
    green "Silakan pilih versi panel X-ui yang akan Anda gunakan selanjutnya"
    echo "1. Gunakan versi asli resmi X-ui"
    echo "2. Gunakan Modifikasi Sihir Misaka"
    echo "3. Gunakan revisi sihir FranzKafkaYu"
    echo "0. Kembali ke menu utama"
    read -rp "Silakan masukkan opsi:" xuiNumberInput
    case "$xuiNumberInput" in
        1) bash <(curl -Ls https://raw.githubusercontents.com/vaxilu/x-ui/master/install.sh) ;;
        2) wget -N --no-check-certificate https://raw.githubusercontents.com/Misaka-blog/x-ui/master/install.sh && bash install.sh ;;
        3) bash <(curl -Ls https://raw.githubusercontents.com/FranzKafkaYu/x-ui/master/install.sh) ;;
        0) menu ;;
    esac
}

qlpanel(){
    [[ -z $(docker -v 2>/dev/null) ]] && curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    read -rp "Silakan masukkan nama wadah panel Azure Dragon yang akan dipasang：" qlPanelName
    read -rp "Silakan masukkan port akses jaringan eksternal：" qlHTTPPort
    docker run -dit --name $qlPanelName --hostname $qlPanelName --restart always -p $qlHTTPPort:5700 -v $PWD/QL/config:/ql/config -v $PWD/QL/log:/ql/log -v $PWD/QL/db:/ql/db -v $PWD/QL/scripts:/ql/scripts -v $PWD/QL/jbot:/ql/jbot whyour/qinglong:latest
    wg-quick down wgcf 2>/dev/null
    v66=`curl -s6m8 https://ip.gs -k`
    v44=`curl -s4m8 https://ip.gs -k`
    yellow "Panel Qinglong berhasil dipasang! ! !"
    if [[ -n $v44 && -z $v66 ]]; then
        green "Alamat akses IPv4 adalah：http://$v44:$qlHTTPPort"
    elif [[ -n $v66 && -z $v44 ]]; then
        green "Alamat akses IPv6 adalah：http://[$v66]:$qlHTTPPort"
    elif [[ -n $v44 && -n $v66 ]]; then
        green "Alamat akses IPv4 adalah：http://$v44:$qlHTTPPort"
        green "Alamat akses IPv6 adalah：http://[$v66]:$qlHTTPPort"
    fi
    yellow "请稍等1-3分钟，等待青龙面板容器启动"
    wg-quick up wgcf 2>/dev/null
}

serverstatus() {
    wget -N https://raw.githubusercontents.com/cokemine/ServerStatus-Hotaru/master/status.sh
    echo "                            "
    green "Silakan pilih jenis klien yang Anda butuhkan untuk menginstal probe"
    echo "1. Server"
    echo "2. Terminal pemantauan"
    echo "0. Kembali ke halaman rumah"
    echo "                            "
	read -rp "Silakan masukkan opsi:" menuNumberInput1
    case "$menuNumberInput1" in
        1) bash status.sh s ;;
        2) bash status.sh c ;;
        0) menu ;;
    esac
}

menu(){
    check_status
    clear
    echo "#############################################################"
    echo -e "#                   ${RED}Misaka Linux Toolbox${PLAIN}                    #"
    echo -e "# ${GREEN}作者${PLAIN}: Misaka No                                           #"
    echo -e "# ${GREEN}网址${PLAIN}: https://owo.misaka.rest                             #"
    echo -e "# ${GREEN}论坛${PLAIN}: https://vpsgo.co                                    #"
    echo -e "# ${GREEN}TG群${PLAIN}: https://t.me/misakanetcn                            #"
    echo -e "# ${GREEN}GitHub${PLAIN}: https://github.com/Misaka-blog                    #"
    echo -e "# ${GREEN}Bitbucket${PLAIN}: https://bitbucket.org/misakano7545             #"
    echo -e "# ${GREEN}GitLab${PLAIN}: https://gitlab.com/misaka-blog                    #"
    echo "#############################################################"
    echo ""
    echo -e " ${GREEN}1.${PLAIN} Sistem terkait"
    echo -e " ${GREEN}2.${PLAIN} Terkait panel"
    echo -e " ${GREEN}3.${PLAIN} Node terkait"
    echo -e " ${GREEN}4.${PLAIN} Pengujian Kinerja"
    echo -e " ${GREEN}5.${PLAIN} Pemeriksaan VPS"
    echo " -------------"
    echo -e " ${GREEN}9.${PLAIN} Skrip yang diperbarui"
    echo -e " ${GREEN}0.${PLAIN} Keluar skrip"
    echo ""
    echo -e "${YELLOW}Versi sekarang${PLAIN}：$version"
    echo -e "${YELLOW}Changelog${PLAIN}：$version_log"
    echo ""
    if [[ -n $v4 ]]; then
        echo -e "Alamat IPv4：$v4  Daerah：$c4  Status WARP：$w4"
    fi
    if [[ -n $v6 ]]; then
        echo -e "Alamat IPv6：$v6  Daerah：$c6  Status WARP：$w6"
    fi
    if [[ -n $w5p ]]; then
        echo -e "Port proxy WireProxy: 127.0.0.1:$w5p  Status WireProxy: $w5"
        if [[ -n $w5i ]]; then
            echo -e "WireProxy IP: $w5i  Daerah: $w5c"
        fi
    fi
    echo ""
    read -rp " Silakan masukkan opsi [0-9]:" menuInput
    case $menuInput in
        1) menu1 ;;
        2) menu2 ;;
        3) menu3 ;;
        4) menu4 ;;
        5) menu5 ;;
        *) exit 1 ;;
    esac
}

menu1(){
    clear
    echo "#############################################################"
    echo -e "#                   ${RED}Misaka Linux Toolbox${PLAIN}                    #"
    echo -e "# ${GREEN}作者${PLAIN}: Misaka No                                           #"
    echo -e "# ${GREEN}网址${PLAIN}: https://owo.misaka.rest                             #"
    echo -e "# ${GREEN}论坛${PLAIN}: https://vpsgo.co                                    #"
    echo -e "# ${GREEN}TG群${PLAIN}: https://t.me/misakanetcn                            #"
    echo -e "# ${GREEN}GitHub${PLAIN}: https://github.com/Misaka-blog                    #"
    echo -e "# ${GREEN}Bitbucket${PLAIN}: https://bitbucket.org/misakano7545             #"
    echo -e "# ${GREEN}GitLab${PLAIN}: https://gitlab.com/misaka-blog                    #"
    echo "#############################################################"
    echo ""
    echo -e " ${GREEN}1.${PLAIN} Buka port firewall sistem"
    echo -e " ${GREEN}2.${PLAIN} Ubah metode login menjadi root + kata sandi"
    echo -e " ${GREEN}3.${PLAIN} Manajemen tugas latar belakang layar"
    echo -e " ${GREEN}4.${PLAIN} Skrip seri akselerasi BBR"
    echo -e " ${GREEN}5.${PLAIN} Server DNS64 pengaturan VPS IPv6 murni"
    echo -e " ${GREEN}6.${PLAIN} Menyiapkan CloudFlare WARP"
    echo -e " ${GREEN}7.${PLAIN} Unduh dan instal Docker"
    echo -e " ${GREEN}8.${PLAIN} Permintaan sertifikat Acme.sh"
    echo -e " ${GREEN}9.${PLAIN} Penetrasi terowongan CF Argo Tunnel"
    echo -e " ${GREEN}10.${PLAIN} Penetrasi intranet Ngrok"
    echo -e " ${GREEN}11.${PLAIN} Ubah sumber perangkat lunak sistem Linux"
    echo -e " ${GREEN}12.${PLAIN} Ganti bahasa sistem ke bahasa Cina"
    echo -e " ${GREEN}13.${PLAIN} OpenVZ VPS mengaktifkan modul TUN"
    echo " -------------"
    echo -e " ${GREEN}0.${PLAIN} Kembali ke menu utama"
    echo ""
    read -rp " Silakan masukkan opsi [0-13]:" menuInput
    case $menuInput in
        1) open_ports ;;
        2) wget -N --no-check-certificate https://raw.githubusercontents.com/Misaka-blog/rootLogin/master/root.sh && bash root.sh ;;
        3) wget -N --no-check-certificate https://raw.githubusercontents.com/Misaka-blog/screenManager/master/screen.sh && bash screen.sh ;;
        4) bbr_script ;;
        5) v6_dns64 ;;
        6) warp_script ;;
        7) curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun ;;
        8) wget -N --no-check-certificate https://raw.githubusercontents.com/Misaka-blog/acme-1key/master/acme1key.sh && bash acme1key.sh ;;
        9) wget -N --no-check-certificate https://raw.githubusercontents.com/Misaka-blog/argo-tunnel-script/master/argo.sh && bash argo.sh ;;
        10) wget -N --no-check-certificate https://raw.githubusercontents.com/Misaka-blog/Ngrok-1key/master/ngrok.sh && bash ngrok.sh ;;
        11) bash <(curl -sSL https://cdn.jsdelivr.net/gh/SuperManito/LinuxMirrors@main/ChangeMirrors.sh) ;;
        12) setChinese ;;
        13) wget -N --no-check-certificate https://raw.githubusercontents.com/Misaka-blog/tun-script/master/tun.sh && bash tun.sh ;;
        *) exit 1 ;;
    esac
}

menu2(){
    clear
    echo "#############################################################"
    echo -e "#                   ${RED}Misaka Linux Toolbox${PLAIN}                    #"
    echo -e "# ${GREEN}作者${PLAIN}: Misaka No                                           #"
    echo -e "# ${GREEN}网址${PLAIN}: https://owo.misaka.rest                             #"
    echo -e "# ${GREEN}论坛${PLAIN}: https://vpsgo.co                                    #"
    echo -e "# ${GREEN}TG群${PLAIN}: https://t.me/misakanetcn                            #"
    echo -e "# ${GREEN}GitHub${PLAIN}: https://github.com/Misaka-blog                    #"
    echo -e "# ${GREEN}Bitbucket${PLAIN}: https://bitbucket.org/misakano7545             #"
    echo -e "# ${GREEN}GitLab${PLAIN}: https://gitlab.com/misaka-blog                    #"
    echo "#############################################################"
    echo ""
    echo -e " ${GREEN}1.${PLAIN} Panel aapanel"
    echo -e " ${GREEN}2.${PLAIN} Panel x-ui"
    echo -e " ${GREEN}3.${PLAIN} aria2(Panel untuk tautan jarak jauh)"
    echo -e " ${GREEN}4.${PLAIN} Panel CyberPanel"
    echo -e " ${GREEN}5.${PLAIN} Panel Qinglong"
    echo -e " ${GREEN}6.${PLAIN} Panel Trojan"
    echo " -------------"
    echo -e " ${GREEN}0.${PLAIN} Kembali ke menu utama"
    echo ""
    read -rp " Silakan masukkan opsi [0-6]:" menuInput
    case $menuInput in
        1) aapanel ;;
        2) xui ;;
        3) ${PACKAGE_INSTALL[int]} ca-certificates && wget -N git.io/aria2.sh && chmod +x aria2.sh && bash aria2.sh ;;
        4) sh <(curl https://cyberpanel.net/install.sh || wget -O - https://cyberpanel.net/install.sh) ;;
        5) qlpanel ;;
        6) source <(curl -sL https://git.io/trojan-install) ;;
        0) menu ;;
        *) exit 1 ;;
    esac
}

menu3(){
    clear
    echo "#############################################################"
    echo -e "#                   ${RED}Misaka Linux Toolbox${PLAIN}                    #"
    echo -e "# ${GREEN}作者${PLAIN}: Misaka No                                           #"
    echo -e "# ${GREEN}网址${PLAIN}: https://owo.misaka.rest                             #"
    echo -e "# ${GREEN}论坛${PLAIN}: https://vpsgo.co                                    #"
    echo -e "# ${GREEN}TG群${PLAIN}: https://t.me/misakanetcn                            #"
    echo -e "# ${GREEN}GitHub${PLAIN}: https://github.com/Misaka-blog                    #"
    echo -e "# ${GREEN}Bitbucket${PLAIN}: https://bitbucket.org/misakano7545             #"
    echo -e "# ${GREEN}GitLab${PLAIN}: https://gitlab.com/misaka-blog                    #"
    echo "#############################################################"
    echo ""
    echo -e " ${GREEN}1.${PLAIN} mack-a"
    echo -e " ${GREEN}2.${PLAIN} wulabing v2ray"
    echo -e " ${GREEN}3.${PLAIN} wulabing xray (Nginx Depan)"
    echo -e " ${GREEN}4.${PLAIN} wulabing xray (Xray Depan)"
    echo -e " ${GREEN}5.${PLAIN} misaka xray"
    echo -e " ${GREEN}6.${PLAIN} teddysun shadowsocks"
    echo -e " ${GREEN}7.${PLAIN} telegram mtproxy"
    echo " -------------"
    echo -e " ${GREEN}0.${PLAIN} Kembali ke menu utama"
    echo ""
    read -rp " Silakan masukkan opsi [0-6]:" menuInput
    case $menuInput in
        1) wget -P /root -N --no-check-certificate "https://raw.githubusercontents.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh ;;
        2) wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontents.com/wulabing/V2Ray_ws-tls_bash_onekey/master/install.sh" && chmod +x install.sh && bash install.sh ;;
        3) wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontents.com/wulabing/Xray_onekey/nginx_forward/install.sh" && chmod +x install.sh && bash install.sh ;;
        4) wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontents.com/wulabing/Xray_onekey/main/install.sh" && chmod +x install.sh && bash install.sh ;;
        5) wget -N --no-check-certificate https://raw.githubusercontents.com/Misaka-blog/Xray-script/master/xray.sh && bash xray.sh ;;
        6) wget --no-check-certificate -O shadowsocks-all.sh https://raw.githubusercontents.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh && chmod +x shadowsocks-all.sh && ./shadowsocks-all.sh 2>&1 | tee shadowsocks-all.log ;;
        7) mkdir /home/mtproxy && cd /home/mtproxy && curl -s -o mtproxy.sh https://raw.githubusercontents.com/sunpma/mtp/master/mtproxy.sh && chmod +x mtproxy.sh && bash mtproxy.sh && bash mtproxy.sh start ;;
        0) menu ;;
        *) exit 1 ;;
    esac
}

menu4(){
    clear
    echo "#############################################################"
    echo -e "#                   ${RED}Misaka Linux Toolbox${PLAIN}                    #"
    echo -e "# ${GREEN}作者${PLAIN}: Misaka No                                           #"
    echo -e "# ${GREEN}网址${PLAIN}: https://owo.misaka.rest                             #"
    echo -e "# ${GREEN}论坛${PLAIN}: https://vpsgo.co                                    #"
    echo -e "# ${GREEN}TG群${PLAIN}: https://t.me/misakanetcn                            #"
    echo -e "# ${GREEN}GitHub${PLAIN}: https://github.com/Misaka-blog                    #"
    echo -e "# ${GREEN}Bitbucket${PLAIN}: https://bitbucket.org/misakano7545             #"
    echo -e "# ${GREEN}GitLab${PLAIN}: https://gitlab.com/misaka-blog                    #"
    echo "#############################################################"
    echo ""
    echo -e " ${GREEN}1.${PLAIN} Tes VPS (misakabench)"
    echo -e " ${GREEN}2.${PLAIN} Tes VPS (bench.sh)"
    echo -e " ${GREEN}3.${PLAIN} Tes VPS (superbench)"
    echo -e " ${GREEN}4.${PLAIN} Tes VPS (lemonbench)"
    echo -e " ${GREEN}5.${PLAIN} Tes VPS (Tes penuh monster fusi)"
    echo -e " ${GREEN}6.${PLAIN} Deteksi streaming"
    echo -e " ${GREEN}7.${PLAIN} Tiga tes kecepatan jaringan"
    echo " -------------"
    echo -e " ${GREEN}0.${PLAIN} Kembali ke menu utama"
    echo ""
    read -rp " Silakan masukkan opsi [0-7]:" menuInput
    case $menuInput in
        1) bash <(curl -Lso- https://cdn.jsdelivr.net/gh/Misaka-blog/misakabench@master/misakabench.sh) ;;
        2) wget -qO- bench.sh | bash ;;
        3) wget -qO- --no-check-certificate https://raw.githubusercontents.com/oooldking/script/master/superbench.sh | bash ;;
        4) curl -fsL https://ilemonra.in/LemonBenchIntl | bash -s fast ;;
        5) bash <(wget -qO- --no-check-certificate https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh) ;;
        6) bash <(curl -L -s https://raw.githubusercontents.com/lmc999/RegionRestrictionCheck/main/check.sh) ;;
        7) bash <(curl -Lso- https://git.io/superspeed.sh) ;;
        0) menu ;;
        *) exit 1 ;;
    esac
}

menu5(){
    clear
    echo "#############################################################"
    echo -e "#                   ${RED}Misaka Linux Toolbox${PLAIN}                    #"
    echo -e "# ${GREEN}作者${PLAIN}: Misaka No                                           #"
    echo -e "# ${GREEN}网址${PLAIN}: https://owo.misaka.rest                             #"
    echo -e "# ${GREEN}论坛${PLAIN}: https://vpsgo.co                                    #"
    echo -e "# ${GREEN}TG群${PLAIN}: https://t.me/misakanetcn                            #"
    echo -e "# ${GREEN}GitHub${PLAIN}: https://github.com/Misaka-blog                    #"
    echo -e "# ${GREEN}Bitbucket${PLAIN}: https://bitbucket.org/misakano7545             #"
    echo -e "# ${GREEN}GitLab${PLAIN}: https://gitlab.com/misaka-blog                    #"
    echo "#############################################################"
    echo ""
    echo -e " ${GREEN}1.${PLAIN} Panel Nezha"
    echo -e " ${GREEN}2.${PLAIN} ServerStatusCola-Horatu"
    echo " -------------"
    echo -e " ${GREEN}0.${PLAIN} Kembali ke menu utama"
    echo ""
    read -rp " Silakan masukkan opsi [0-2]:" menuInput
    case $menuInput in
        1) curl -L https://raw.githubusercontents.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && bash nezha.sh ;;
        0) menu ;;
        *) exit 1 ;;
    esac
}

menu
