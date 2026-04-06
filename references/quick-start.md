# Ebook Chapter Splitter - Quick Start Guide

## Installation

### 1. Install Dependencies

```bash
pip install PyPDF2 ebooklib html2text
```

Or use the provided requirements:

```bash
cd /Users/add/.claude/skills/ebook-chapter-splitter
pip install -r requirements.txt
```

### 2. Verify Installation

```bash
python scripts/split_ebook.py --version
```

Expected output: `ebook-chapter-splitter 1.0.0`

## Basic Usage

### Command Line

```bash
# Process current directory
python scripts/split_ebook.py -i . -o processed

# Specify input and output directories
python scripts/split_ebook.py -i /path/to/ebooks -o /path/to/output

# Using the skill in Claude Code
/ebook-chapter-splitter /path/to/ebooks
```

### What to Expect

```
📚 找到 14 个电子书文件
   PDF: 7 个
   EPUB: 7 个

📖 处理EPUB: 这才是心理学：看穿伪心理学的本质.epub
   💾 已保存: 这才是心理学看穿伪心理学的本质-第1章节-part0000.md
   💾 已保存: 这才是心理学看穿伪心理学的本质-第2章节-part0001.md
   ...
✅ EPUB处理完成: 这才是心理学：看穿伪心理学的本质.epub

📕 处理PDF: 让时间陪你慢慢变富.pdf
   ℹ️  未找到明确章节，按页数分割...
   💾 已保存: 让时间陪你慢慢变富-第1章节-第1章_第4-13页.md
   ...
✅ PDF处理完成: 让时间陪你慢慢变富.pdf，共 8 章

✅ 全部完成！文件保存在: processed
```

## Output Structure

```
processed/
├── 这才是心理学看穿伪心理学的本质-第1章节-part0000.md
├── 这才是心理学看穿伪心理学的本质-第2章节-part0001.md
├── 让时间陪你慢慢变富-第1章节-第1章_第4-13页.md
└── ...
```

Each markdown file contains:

```markdown
# Chapter Title

Chapter content starts here...
```

## Advanced Usage

### Filter by File Type

```bash
# Process only PDFs
python scripts/split_ebook.py -i ./pdfs -o ./chapters

# Process only EPUBs
python scripts/split_ebook.py -i ./epubs -o ./chapters
```

### Batch Processing

```bash
# Process multiple directories
for dir in ebooks/*/; do
    python scripts/split_ebook.py -i "$dir" -o "${dir}processed/"
done
```

## Troubleshooting

### "No module named 'PyPDF2'"

```bash
pip install PyPDF2 ebooklib html2text
```

### "未找到PDF或EPUB文件"

Check that:
1. Input directory path is correct
2. Files have .pdf or .epub extension
3. Files are not corrupted

### "PDF未找到有效章节"

This is normal! The script automatically falls back to page-based splitting.

### "UnicodeEncodeError" in filenames

The script handles this automatically with simplified filenames.

## Tips

1. **Organize files first**: Separate PDFs and EPUBs for cleaner processing
2. **Check output**: Review a few chapters to verify quality
3. **Large files**: For very large PDFs (>200MB), consider splitting first
4. **Back up originals**: Always keep original ebook files safe

## Integration

### With Claude Code

```
User: 拆解这个目录的电子书 /Users/add/data/ebooks

Claude: [自动调用ebook-chapter-splitter技能]
```

### As Python Module

```python
from scripts.split_ebook import EbookSplitter

splitter = EbookSplitter(
    input_dir="/path/to/ebooks",
    output_dir="/path/to/output"
)
splitter.process_all()
```

## Next Steps

- See [references/README.md](references/README.md) for technical details
- Check [agents/interface.yaml](agents/interface.yaml) for API usage
- Review [SKILL.md](SKILL.md) for trigger phrases and usage
