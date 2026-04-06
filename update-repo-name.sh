#!/bin/bash
# 更新仓库名称为 epub2md

set -e

echo "========================================
  📦 更新仓库名称
========================================"
echo ""
echo "新仓库名: epub2md"
echo "GitHub 用户: hongxiaojun"
echo "新仓库地址: https://github.com/hongxiaojun/epub2md"
echo ""

# 询问用户是否已在 GitHub 完成操作
echo "⚠️  请确认您已在 GitHub 完成："
echo ""
echo "选项1（创建新仓库）:"
echo "  • 访问: https://github.com/new"
echo "  • 创建仓库: epub2md"
echo ""
echo "选项2（重命名现有仓库）:"
echo "  • 访问: https://github.com/hongxiaojun/pdfepub2md/settings"
echo "  • 重命名为: epub2md"
echo ""
read -p "已完成？(y/n): " READY

if [ "$READY" != "y" ] && [ "$READY" != "Y" ]; then
    echo "❌ 请先在 GitHub 完成操作，然后重新运行此脚本"
    exit 1
fi

echo ""
echo "========================================
  🔄 更新本地配置
========================================"
echo ""

# 更新远程仓库地址
echo "1️⃣  更新远程仓库地址..."
git remote set-url origin git@github.com:hongxiaojun/epub2md.git
echo "   ✓ 远程仓库已更新"
echo "   origin -> git@github.com:hongxiaojun/epub2md.git"
echo ""

# 验证连接
echo "2️⃣  验证连接..."
if git ls-remote --heads origin > /dev/null 2>&1; then
    echo "   ✓ GitHub 连接成功"
else
    echo "   ⚠️  无法连接到仓库"
    echo "   请确认："
    echo "     1. 仓库已在 GitHub 创建/重命名"
    echo "     2. SSH 密钥已正确配置"
    exit 1
fi
echo ""

# 推送代码
echo "3️⃣  推送代码到新仓库..."
if git push -u origin master; then
    echo ""
    echo "========================================"
    echo "  🎉 成功！"
    echo "========================================"
    echo ""
    echo "📍 新仓库地址:"
    echo "   https://github.com/hongxiaojun/epub2md"
    echo ""
    echo "🔗 克隆命令:"
    echo "   git clone git@github.com:hongxiaojun/epub2md.git"
    echo ""
    echo "✅ 仓库名称已从 pdfepub2md 更新为 epub2md"
    echo ""
else
    echo ""
    echo "========================================"
    echo "  ❌ 推送失败"
    echo "========================================"
    echo ""
    echo "可能的原因:"
    echo "  1. 仓库 epub2md 尚未在 GitHub 创建"
    echo "  2. 需要先在 GitHub 创建/重命名仓库"
    echo ""
fi
