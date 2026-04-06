---
name: ebook-chapter-splitter
description: Split PDF and EPUB ebooks into individual chapter markdown files with intelligent chapter detection, auto-filtering of frontmatter, and clean filename formatting.
metadata:
  author: add
  mode: Production
  version: 1.0.0
  dependencies:
    - PyPDF2
    - ebooklib
    - html2text
---

# Ebook Chapter Splitter

Automatically split PDF and EPUB ebooks into individual chapter markdown files.

## When to Use

Trigger phrases:
- "拆解电子书"
- "split ebook into chapters"
- "把PDF转换成章节markdown"
- "电子书章节拆分"
- "convert ebook to markdown chapters"

## What It Does

1. **Formats Supported**: PDF and EPUB ebooks
2. **Intelligent Chapter Detection**: Recognizes "第X章", Chapter X, "1.5" decimal numbering
3. **Auto-Filter Frontmatter**: Skips covers, TOCs, prefaces (first 3 pages)
4. **Content Quality Filter**: Removes pages with <100 characters
5. **Clean Naming**: `书名-第N章节-标题.md` format
6. **Fallback Strategy**: Splits by page count (10 pages/chapter) when no chapters found

## Quick Start

```bash
# Basic usage
ebook-splitter -i /path/to/ebooks -o /path/to/output

# Process current directory
ebook-splitter -i . -o processed
```

## Core Workflow

1. Scan input directory for PDF/EPUB files
2. For each file:
   - Extract text content
   - Detect chapter boundaries
   - Skip frontmatter (covers, TOCs, prefaces)
   - Filter short pages (<100 chars)
   - Generate clean markdown files
3. Output chapter files with naming: `书名-第N章节-标题.md`

## Execution

```python
python scripts/split_ebook.py --input ./ebooks --output ./chapters
```

See [scripts/split_ebook.py](scripts/split_ebook.py) for implementation.

## Boundary & Exclusions

**In Scope**:
- PDF and EPUB format ebooks
- Text-based content extraction
- Chinese and English content
- Standard chapter formats

**Out of Scope**:
- Scanned/image-only PDFs (OCR required)
- DRM-protected files
- Audio/video content
- Complex layouts (tables, multi-column)
- Hand-written documents

## Requirements

- Python 3.8+
- PyPDF2: `pip install PyPDF2`
- ebooklib: `pip install ebooklib`
- html2text: `pip install html2text`

## Output Structure

```
processed/
├── 书名-第1章节-标题.md
├── 书名-第2章节-标题.md
└── ...
```

Each markdown file contains:
```markdown
# Chapter Title

Chapter content here...
```
