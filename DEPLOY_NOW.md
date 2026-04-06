# 🚀 立即部署到 GitHub

## 快速部署（3个命令）

**替换 `YOUR_USERNAME` 为您的 GitHub 用户名，然后依次执行：**

```bash
cd /Users/add/.claude/skills/ebook-chapter-splitter

git remote add origin https://github.com/YOUR_USERNAME/pdfepub2md.git

git push -u origin master
```

就这么简单！✨

---

## 详细步骤（如果需要帮助）

### 第1步：在 GitHub 创建仓库

1. 访问：https://github.com/new
2. 填写：
   - **Repository name**: `pdfepub2md`
   - **Description**: `智能电子书章节拆解工具 - 将PDF和EPUB自动转换为Markdown章节文件`
   - **Public**: ✅ 勾选
   - ⚠️ **不要勾选** "Add a README file"
3. 点击 "Create repository"

### 第2步：配置并推送

```bash
# 进入项目目录
cd /Users/add/.claude/skills/ebook-chapter-splitter

# 添加远程仓库（替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/pdfepub2md.git

# 推送代码
git push -u origin master
```

### 第3步：验证

访问您的仓库：`https://github.com/YOUR_USERNAME/pdfepub2md`

---

## 使用 SSH（推荐，无需输入密码）

如果您已配置 SSH 密钥：

```bash
git remote add origin git@github.com:YOUR_USERNAME/pdfepub2md.git
git push -u origin master
```

---

## 完成！🎉

仓库上传成功后，您可以：
- 📦 分享仓库链接
- 🔄 使用 `git add . && git commit -m "update" && git push` 更新
- 🌟 添加 Star 收藏
- 📝 完善 README

---

**需要帮助？** 查看 `GITHUB_UPLOAD_GUIDE.md` 获取详细说明。
