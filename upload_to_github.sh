#!/bin/bash
# Github 上传脚本

set -e

echo "======================================"
echo "  Ebook Chapter Splitter - GitHub 上传向导"
echo "======================================"
echo ""

REPO_NAME="pdfepub2md"
CURRENT_DIR="$(pwd)"

echo "📁 当前目录: $CURRENT_DIR"
echo "📦 仓库名称: $REPO_NAME"
echo ""

# 检查是否已经初始化了 git
if [ ! -d ".git" ]; then
    echo "❌ 错误: 当前目录不是 git 仓库"
    echo "   请在 ebook-chapter-splitter 目录下运行此脚本"
    exit 1
fi

echo "✅ Git 仓库已初始化"
echo ""

# 检查 git 状态
echo "📊 当前 Git 状态:"
git status
echo ""

# 询问 GitHub 用户名
echo "======================================"
echo "请提供您的 GitHub 用户名:"
echo "======================================"
read -p "GitHub 用户名: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo "❌ 错误: GitHub 用户名不能为空"
    exit 1
fi

echo ""
echo "======================================"
echo "即将创建仓库: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "======================================"
echo ""
read -p "确认继续? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "❌ 已取消"
    exit 1
fi

echo ""
echo "📋 步骤指南:"
echo ""
echo "1️⃣  在浏览器中打开: https://github.com/new"
echo ""
echo "2️⃣  填写以下信息:"
echo "   - Repository name: $REPO_NAME"
echo "   - Description: 智能电子书章节拆解工具 - 将PDF和EPUB自动转换为Markdown章节"
echo "   - 选择: Public"
echo "   - ⚠️  不要勾选 'Add a README file' (我们已有 README.md)"
echo ""
echo "3️⃣  点击 'Create repository'"
echo ""

read -p "按 Enter 键继续，当您在 GitHub 上创建好仓库后..."

# 添加远程仓库
echo ""
echo "🔗 配置远程仓库..."
git remote add origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git" 2>/dev/null || \
git remote set-url origin "https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"

echo "✅ 远程仓库已配置: origin"
echo ""

# 推送到 GitHub
echo "⬆️  推送到 GitHub..."
git push -u origin master

echo ""
echo "======================================"
echo "🎉 上传完成！"
echo "======================================"
echo ""
echo "📍 仓库地址:"
echo "   https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo ""
echo "🔗 快捷克隆命令:"
echo "   git clone https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
echo ""
echo "✨ 下一步:"
echo "   1. 在仓库设置中添加主题"
echo "   2. 编写更详细的 README (如果需要)"
echo "   3. 添加 GitHub Actions (如果需要)"
echo ""
