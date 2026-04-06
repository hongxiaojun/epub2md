#!/bin/bash
# GitHub 一键部署脚本 - ebook-chapter-splitter
# GitHub 用户: hongxiaojun
# 仓库名: pdfepub2md

set -e

echo "========================================"
echo "  🚀 GitHub 一键部署"
echo "========================================"
echo ""
echo "👤 GitHub 用户: hongxiaojun"
echo "📦 仓库名: pdfepub2md"
echo "📍 仓库地址: https://github.com/hongxiaojun/pdfepub2md"
echo ""

# 检查是否已在正确的目录
if [ ! -f "SKILL.md" ]; then
    echo "❌ 错误: 请在项目目录中运行此脚本"
    echo "   当前目录: $(pwd)"
    echo "   应该在: /Users/add/.claude/skills/ebook-chapter-splitter"
    exit 1
fi

echo "✅ 项目目录确认"
echo ""

# 询问用户是否已在 GitHub 创建仓库
echo "⚠️  请确保您已在 GitHub 创建仓库："
echo "   https://github.com/new"
echo ""
echo "   仓库名: pdfepub2md"
echo "   描述: 智能电子书章节拆解工具"
echo "   可见性: Public"
echo ""
read -p "仓库已创建？(y/n): " REPO_READY

if [ "$REPO_READY" != "y" ] && [ "$REPO_READY" != "Y" ]; then
    echo ""
    echo "请先在 GitHub 创建仓库，然后重新运行此脚本。"
    echo ""
    echo "创建仓库链接: https://github.com/new"
    exit 1
fi

echo ""
echo "========================================"
echo "  开始部署..."
echo "========================================"
echo ""

# 配置远程仓库
echo "1️⃣  配置远程仓库..."
git remote add origin https://github.com/hongxiaojun/pdfepub2md.git 2>/dev/null || \
    git remote set-url origin https://github.com/hongxiaojun/pdfepub2md.git

echo "   ✓ 远程仓库已配置"
echo "   origin -> https://github.com/hongxiaojun/pdfepub2md.git"
echo ""

# 推送代码
echo "2️⃣  推送代码到 GitHub..."
echo "   这可能需要几秒钟..."
echo ""

if git push -u origin master; then
    echo ""
    echo "========================================"
    echo "  🎉 部署成功！"
    echo "========================================"
    echo ""
    echo "📍 仓库地址:"
    echo "   https://github.com/hongxiaojun/pdfepub2md"
    echo ""
    echo "🔗 快速克隆命令:"
    echo "   git clone https://github.com/hongxiaojun/pdfepub2md.git"
    echo ""
    echo "📊 项目包含:"
    echo "   • 14 个文件"
    echo "   • 1700+ 行代码和文档"
    echo "   • 完整的 Python 工具"
    echo "   • 详细的使用文档"
    echo ""
    echo "✨ 下一步:"
    echo "   1. 在 GitHub 上查看您的仓库"
    echo "   2. 添加 README 中的徽章和图片"
    echo "   3. 分享给其他人使用"
    echo "   4. 使用以下命令更新:"
    echo "      git add ."
    echo "      git commit -m '更新说明'"
    echo "      git push"
    echo ""
else
    echo ""
    echo "========================================"
    echo "  ❌ 推送失败"
    echo "========================================"
    echo ""
    echo "可能的原因:"
    echo "  1. 仓库尚未在 GitHub 创建"
    echo "  2. 用户名或仓库名不正确"
    echo "  3. 认证问题（需要 GitHub token）"
    echo ""
    echo "解决方案:"
    echo "  1. 确认仓库已创建: https://github.com/hongxiaojun/pdfepub2md"
    echo "  2. 检查远程配置: git remote -v"
    echo "  3. 使用 SSH 替代 HTTPS:"
    echo "     git remote set-url origin git@github.com:hongxiaojun/pdfepub2md.git"
    echo "     git push -u origin master"
    echo ""
fi
