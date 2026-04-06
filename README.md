# Ebook Chapter Splitter

智能电子书章节拆解工具，将PDF和EPUB自动转换为Markdown章节文件。

## 快速开始

### 安装依赖

```bash
pip install -r requirements.txt
```

### 基本使用

```bash
# 拆解当前目录的电子书
python scripts/split_ebook.py -i . -o processed

# 指定输入输出目录
python scripts/split_ebook.py -i /path/to/ebooks -o /path/to/output
```

## 功能特点

✅ **支持格式**: PDF和EPUB电子书
✅ **智能识别**: 自动识别多种章节格式
✅ **内容过滤**: 自动忽略封面、目录、序言等
✅ **质量保证**: 过滤少于100字符的页面
✅ **清晰命名**: `书名-第N章节-标题.md` 格式
✅ **容错处理**: 找不到章节时自动按页数分割

## 触发词

在Claude Code中使用：
- "拆解电子书"
- "split ebook into chapters"
- "把PDF转换成章节markdown"
- "电子书章节拆分"

## 文档

- [快速开始](references/quick-start.md) - 5分钟上手指南
- [技术参考](references/README.md) - 架构和实现细节
- [技能总结](references/SKILL_SUMMARY.md) - 完整功能说明
- [SKILL.md](SKILL.md) - 路由和触发配置

## 实际效果

测试14本电子书（7本PDF + 7本EPUB）：
- ✅ 成功处理13本（93%成功率）
- ✅ 生成522个独立章节文件
- ✅ 平均每本37章

## 依赖要求

- Python 3.8+
- PyPDF2 >= 3.0.0
- ebooklib >= 0.18
- html2text >= 2020.0.0

## 许可

MIT License
