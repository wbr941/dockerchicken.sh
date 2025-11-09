#!/bin/bash

# 将菜单放入循环：执行完操作后返回菜单并继续提示，直到用户选择退出
print_header() {
	echo " ____             _              ____ _     _      _                    _     "
	echo "|  _ \\  ___   ___| | _____ _ __ / ___| |__ (_) ___| | _____ _ __    ___| |__  "
	echo "| | | |/ _ \\ / __| |/ / _ \\ '__| |   | '_ \\| |/ __| |/ / _ \\ '_ \\  / __| '_ \\ "
	echo "| |_| | (_) | (__|   <  __/ |  | |___| | | | | (__|   <  __/ | | |_\\__ \\ | | |"
	echo "|____/ \\___/ \\___|_|\\_\\___|_|   \\____|_| |_|_|\\___|_|\\_\\___|_| |_|(_)___/_| |_|"
	echo ""
}

show_menu() {
	echo "1. 查询系统信息"
	echo "2. 安装老王四合一 Sing-Box"
	echo "3. 安装 TG 消息推送"
	echo "4. 安装 Warp "
	echo "0. 退出"
	echo ""
}

while true; do
	print_header
	show_menu

	# 在下面显示输入提示，等待用户输入序号
	read -p "请输入序号：" choice
	echo ""

	case "$choice" in
		1)
			echo "== 系统信息 =="
			if [ -f /etc/os-release ]; then
				osv=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d'=' -f2- | tr -d '"')
				echo "操作系统版本: ${osv}"
			else
				echo "操作系统版本: 未知"
			fi

			echo "内核信息: $(uname -r)"
			echo "主机名: $(hostname)"

			cpu_info=$(grep -m1 -E 'model name|型号名称' /proc/cpuinfo 2>/dev/null | awk -F: '{print $2}' | xargs)
			if [ -z "$cpu_info" ]; then
				cpu_info=$(lscpu 2>/dev/null | grep -E 'Model name|型号名称' | head -n1 | awk -F: '{print $2}' | xargs)
			fi
			echo "CPU 信息: ${cpu_info:-未知}"

			if command -v free >/dev/null 2>&1; then
				mem=$(free -h | awk '/^Mem:/ {print $2 " total, " $3 " used, " $4 " free"}')
				echo "内存: ${mem}"
			fi

					# 完成后等待用户按回车返回菜单
					read -p "按回车返回菜单..." _junk
			;;
				2)
					echo "== 安装 Sing-Box =="
					if ! command -v curl >/dev/null 2>&1; then
						echo "错误：系统未安装 curl，请先安装 curl 后重试。"
					else
						echo "开始下载并执行 sing-box 安装脚本..."
						# 运行一键安装命令
						bash <(curl -Ls https://raw.githubusercontent.com/wbr941/dockerchicken.sh/main/sing-box.sh)
						echo "Sing-Box 安装脚本执行完成（若脚本有交互，则以脚本输出为准）。"
					fi
					read -p "按回车返回菜单..." _junk
					;;
				3)
					echo "== 安装 TG 消息推送 =="
					if ! command -v curl >/dev/null 2>&1; then
						echo "错误：系统未安装 curl，请先安装 curl 后重试。"
					else
						echo "下载并执行 tg 推送脚本..."
						# 下载脚本、标记可执行并运行
						curl -o tgvsdd3.sh -fsSL https://raw.githubusercontent.com/MEILOI/scripts/main/tgvsdd3.sh && chmod +x tgvsdd3.sh && ./tgvsdd3.sh
						echo "TG 推送脚本执行完成（若脚本有交互，则以脚本输出为准）。"
					fi
					read -p "按回车返回菜单..." _junk
					;;
				4)
					echo "== 安装 Warp =="
					# 优先使用 wget 回传到 bash，否则使用 curl 回退
					if command -v wget >/dev/null 2>&1; then
						echo "使用 wget 下载并执行 Warp 安装脚本..."
						bash <(wget -qO- https://raw.githubusercontent.com/yonggekkk/warp-yg/main/CFwarp.sh)
					elif command -v curl >/dev/null 2>&1; then
						echo "使用 curl 下载并执行 Warp 安装脚本..."
						bash <(curl -fsSL https://raw.githubusercontent.com/yonggekkk/warp-yg/main/CFwarp.sh)
					else
						echo "错误：系统未安装 wget 或 curl，请先安装其中一个后重试。"
					fi
					read -p "按回车返回菜单..." _junk
					;;
				0)
					echo "退出。"
					exit 0
					;;
		*)
			echo "无效的选择：${choice}。请输入有效序号。"
			# 小的延迟后返回菜单
			sleep 1
			;;
	esac
done

exit 0