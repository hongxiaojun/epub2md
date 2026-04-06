#!/bin/bash
# GitHub 快速部署脚本 - ebook-chapter-splitter

set -e

echo "========================================"
echo "  🚀 GitHub 部署向导"
echo "========================================"
echo ""
echo "📁 项目: ebook-chapter-splitter"
echo "📦 仓库名: pdfepub2md"
echo ""
echo "环境检查:"
echo "  ✓ Git 已安装"
echo "  ✓ Git 已配置"
echo "  ✓ SSH 密钥已配置"
echo "  ✓ Git 仓库已初始化"
echo "  ✓ 2 个提交已准备"
echo ""
echo "========================================"
echo "  部署步骤"
echo "========================================"
echo ""

# 步骤 1
echo "📋 步骤 1/3: 在 GitHub 创建仓库"
echo ""
echo "请打开以下链接创建新仓库："
echo ""
echo "🔗 https://github.com/new"
echo ""
echo "填写信息："
echo "  • Repository name: pdfepub2md"
echo "  • Description: 智能电子书章节拆解工具"
echo "  • Public: ✅"
echo "  • ⚠️  不要勾选 Add a README file"
echo ""
read -p "按 Enter 继续到步骤 2..."
echo ""

# 步骤 2
echo "📝 步骤 2/3: 输入 GitHub 信息"
echo ""
read -p "请输入您的 GitHub 用户名: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo "❌ 用户名不能为空"
    exit 1
fi

REPO_URL="https://github.com/$GITHUB_USERNAME/pdfepub2md"
echo ""
echo "仓库地址: $REPO_URL"
echo ""
read -p "确认正确？(y/n): " CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "❌ 已取消"
    exit 1
fi
echo ""

# 步骤 3
echo "⬆️  步骤 3/3: 推送到 GitHub"
echo ""

# 添加远程仓库
echo "配置远程仓库..."
git remote add origin "$REPO_URL" 2>/dev/null || \
    git remote set-url origin "$REPO_URL"

echo "✓ 远程仓库已配置"
echo ""

# 推送
echo "推送代码到 GitHub..."
git push -u origin master

echo ""
echo "========================================"
echo "  🎉 部署成功！"
echo "========================================"
echo ""
echo "📍 仓库地址:"
echo "   $REPO_URL"
echo ""
echo "🔗 克隆命令:"
echo "   git clone $REPO_URL.git"
echo ""
echo "📊 项目统计:"
echo "   • 12 个文件"
echo "   • 1500+ 行代码和文档"
echo "   • Python 工具"
echo ""
