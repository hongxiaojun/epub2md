# 上传到 GitHub 指南

## 方式一：使用自动化脚本（推荐）

在技能目录下运行：

```bash
cd /Users/add/.claude/skills/ebook-chapter-splitter
./upload_to_github.sh
```

脚本会引导您完成整个上传过程。

---

## 方式二：手动上传

### 第1步：在 GitHub 创建仓库

1. 访问：https://github.com/new
2. 填写信息：
   - **Repository name**: `pdfepub2md`
   - **Description**: `智能电子书章节拆解工具 - 将PDF和EPUB自动转换为Markdown章节文件`
   - **Public/Private**: 选择 Public
   - ⚠️ **重要**: 不要勾选 "Add a README file"
3. 点击 "Create repository"

### 第2步：推送代码到 GitHub

在技能目录执行以下命令：

```bash
# 进入技能目录
cd /Users/add/.claude/skills/ebook-chapter-splitter

# 添加远程仓库（替换 YOUR_USERNAME 为您的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/pdfepub2md.git

# 推送代码
git push -u origin master
```

### 第3步：验证

访问您的仓库：https://github.com/YOUR_USERNAME/pdfepub2md

您应该看到所有文件都已上传成功！

---

## 仓库内容

上传后，您的仓库将包含：

```
pdfepub2md/
├── SKILL.md                    # 技能路由和使用说明
├── README.md                   # 项目介绍
├── manifest.json               # 包配置
├── requirements.txt            # Python 依赖
├── .gitignore                  # Git 忽略配置
├── agents/
│   └── interface.yaml          # Agent 接口定义
├── scripts/
│   └── split_ebook.py          # 核心实现脚本
├── references/
│   ├── README.md               # 技术参考
│   ├── quick-start.md          # 快速开始
│   └── SKILL_SUMMARY.md        # 功能总结
└── upload_to_github.sh         # 上传脚本
```

---

## 常见问题

### Q: 提示需要认证？

**A**: 使用 SSH 密钥或个人访问令牌：

```bash
# 方式1: 使用 SSH（需要先配置 SSH 密钥）
git remote set-url origin git@github.com:YOUR_USERNAME/pdfepub2md.git
git push -u origin master

# 方式2: 使用 HTTPS + 个人访问令牌
# 推送时输入：YOUR_USERNAME + PAT（而不是密码）
git push -u origin master
```

### Q: 推送失败？

**A**: 检查远程仓库配置：

```bash
git remote -v
# 应该显示: origin https://github.com/YOUR_USERNAME/pdfepub2md.git
```

### Q: 想要修改仓库描述？

**A**: 访问仓库页面 → Settings → General → Description

---

## 后续优化建议

上传成功后，您可以：

1. ✅ 添加 GitHub Topics（标签）：
   - `ebook`
   - `pdf`
   - `epub`
   - `markdown`
   - `python`
   - `text-extraction`

2. ✅ 设置仓库 Stars 看板

3. ✅ 添加 LICENSE 文件

4. ✅ 创建 Releases（发布版本）

5. ✅ 添加 Issues 模板

6. ✅ 配置 GitHub Actions（CI/CD）

---

## 分享您的仓库

上传成功后，您可以分享仓库链接：

```
https://github.com/YOUR_USERNAME/pdfepub2md
```

其他人可以通过以下方式使用：

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/pdfepub2md.git

# 安装依赖
cd pdfepub2md
pip install -r requirements.txt

# 使用
python scripts/split_ebook.py -i /path/to/ebooks -o /path/to/output
```

---

需要帮助？请查看：
- [GitHub 官方文档](https://docs.github.com/)
- [Git 基础教程](https://git-scm.com/docs/gittutorial)
