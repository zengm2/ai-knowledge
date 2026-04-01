#!/bin/bash
# check-links.sh - 检查 README.md 中所有 Markdown 链接是否指向存在的文件
# 同时检查文件名是否包含空格等不安全字符
#
# 用法: cd ai-knowledge/ && bash check-links.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

errors=0
warnings=0
checked=0

echo "========================================"
echo " AI Knowledge 链接 & 文件名检查"
echo "========================================"
echo ""

# --- 检查 1: README.md 中的链接是否指向存在的文件 ---
echo "[ 检查 1 ] README.md 中的链接有效性"
echo "----------------------------------------"

if [ ! -f "README.md" ]; then
    echo -e "${RED}错误: 未找到 README.md，请在 ai-knowledge/ 目录下运行此脚本${NC}"
    exit 1
fi

# 提取所有相对链接路径 (匹配 ](./xxx) 格式)
grep -oP '\]\(\./[^)]+\)' README.md | sed 's/\](\.\/\(.*\))/\1/' | while read -r link; do
    checked=$((checked + 1))
    if [ -f "./$link" ]; then
        echo -e "  ${GREEN}OK${NC}  $link"
    else
        echo -e "  ${RED}BROKEN${NC}  $link"
        echo "$link" >> /tmp/check-links-errors.txt
    fi
done

# --- 检查 2: QA-常见问题/ 目录下文件名是否包含空格 ---
echo ""
echo "[ 检查 2 ] 文件名中是否包含空格"
echo "----------------------------------------"

if [ -d "QA-常见问题" ]; then
    find "QA-常见问题" -name "* *" -type f | while read -r file; do
        echo -e "  ${RED}含空格${NC}  $file"
        echo "$file" >> /tmp/check-links-errors.txt
    done

    # 如果没有含空格的文件
    space_count=$(find "QA-常见问题" -name "* *" -type f 2>/dev/null | wc -l)
    if [ "$space_count" -eq 0 ]; then
        echo -e "  ${GREEN}全部通过${NC}  所有文件名均不含空格"
    fi
fi

# 同时检查其他目录
find . -maxdepth 2 -name "* *" -type f ! -path "./.git/*" ! -path "./node_modules/*" | while read -r file; do
    if [[ "$file" != *"QA-常见问题"* ]]; then
        echo -e "  ${YELLOW}警告${NC}  $file (非 QA 目录，但文件名含空格)"
    fi
done

# --- 检查 3: QA 文档内部的交叉引用链接 ---
echo ""
echo "[ 检查 3 ] QA 文档内部交叉引用链接"
echo "----------------------------------------"

if [ -d "QA-常见问题" ]; then
    for mdfile in QA-常见问题/*.md; do
        # 提取文档内的相对链接
        grep -oP '\]\(\./[^)]+\.md\)' "$mdfile" 2>/dev/null | sed 's/\](\.\/\(.*\))/\1/' | while read -r link; do
            target="QA-常见问题/$link"
            if [ ! -f "$target" ]; then
                echo -e "  ${RED}BROKEN${NC}  $mdfile -> $link"
                echo "$mdfile:$link" >> /tmp/check-links-errors.txt
            fi
        done
    done

    # 检查是否有内部链接错误
    internal_broken=$(grep -roP '\]\(\./[^)]+\.md\)' QA-常见问题/*.md 2>/dev/null | while read -r line; do
        file=$(echo "$line" | cut -d: -f1)
        link=$(echo "$line" | grep -oP '\]\(\./\K[^)]+')
        target="QA-常见问题/$link"
        if [ ! -f "$target" ]; then
            echo "broken"
        fi
    done | wc -l)

    if [ "$internal_broken" -eq 0 ]; then
        echo -e "  ${GREEN}全部通过${NC}  所有内部交叉引用均有效"
    fi
fi

# --- 汇总 ---
echo ""
echo "========================================"

if [ -f /tmp/check-links-errors.txt ]; then
    error_count=$(wc -l < /tmp/check-links-errors.txt)
    echo -e "${RED}发现 $error_count 个问题，请修复后再提交${NC}"
    rm -f /tmp/check-links-errors.txt
    exit 1
else
    echo -e "${GREEN}全部检查通过！${NC}"
    exit 0
fi
