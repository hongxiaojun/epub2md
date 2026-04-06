# Ebook Chapter Splitter - Technical Reference

## Architecture

```
ebook-chapter-splitter/
├── SKILL.md                 # Main routing and usage
├── agents/
│   └── interface.yaml       # Agent interface definition
├── scripts/
│   └── split_ebook.py       # Core implementation
└── references/
    ├── README.md            # This file
    ├── chapter-detection.md # Chapter recognition patterns
    └── troubleshooting.md  # Common issues and solutions
```

## Chapter Detection Patterns

### Supported Formats

1. **中文章节**: `第X章`、`第X节`、`第X回`
   - Regex: `^第[一二三四五六七八九十百千0-9]+[章回节篇]`

2. **英文章节**: `Chapter X`、`CHAPTER X`
   - Regex: `^Chapter\s*\d+`、`^CHAPTER\s*\d+`

3. **小数点编号**: `1.5`、`2.3`
   - Regex: `^\d+\.\d+\s+`

4. **数字编号**: `1. 标题`、`2、标题`
   - Regex: `^\d+\.\s+[^\d]{1,30}`、`^\d+、\s*[^\d]{1,30}`

5. **中文数字序号**: `一、`、`二、`
   - Regex: `^[一二三四五六七八九十]+、\s*[^\d]{1,30}`

6. **部分/节**: `Part X`、`Section X`
   - Regex: `^Part\s*\d+`、`^Section\s*\d+`

### Fallback Strategy

When no chapter patterns are detected:
- Books ≤ 50 pages: 5 pages per chapter
- Books 51-100 pages: 10 pages per chapter
- Books 101-200 pages: 15 pages per chapter
- Books > 200 pages: 20 pages per chapter

## Content Filtering

### Ignore Keywords

Automatically skipped content:
- 封面、目录、序言、推荐序、前言、自序
- 版权、版权声明、出版社、出版说明
- 献词、致谢、作者简介、关于作者
- Contents, Table of Contents, Introduction
- Preface, Foreword, Copyright, Publisher

### Quality Filter

- Minimum character count: 100
- Pages with fewer characters are automatically excluded
- Cleaning removes <200 byte files after processing

## File Naming Strategy

### Format

```
{clean_book_name}-第{N}章节-{clean_title}.md
```

### Rules

1. Strip special characters (keep alphanumeric, Chinese, hyphens, underscores)
2. Limit title length to 30 characters
3. Replace whitespace and multiple underscores with single underscore
4. If filename > 150 chars, simplify to `{book_name}-第{N}章节.md`
5. Handle encoding errors with fallback simplified names

### Examples

```
Input:  让时间陪你慢慢变富.pdf
Output: 让时间陪你慢慢变富-第1章节-第1章_第4-13页.md

Input:  This is Psychology.epub
Output: This_is_Psychology-第1章节-part0000.md
```

## Technical Dependencies

### Required Libraries

```bash
pip install PyPDF2 ebooklib html2text
```

### Python Version

- Minimum: Python 3.8
- Recommended: Python 3.10+
- Tested on: Python 3.14

### Library Versions

```
PyPDF2>=3.0.0
ebooklib>=0.18
html2text>=2020.0.0
```

## Performance Considerations

### Processing Speed

- EPUB: ~100-200 chapters/second
- PDF: ~5-10 pages/second (varies by PDF complexity)

### Memory Usage

- EPUB: Low (streaming processing)
- PDF: Moderate (loads entire file into memory)

### Limitations

- **Max file size**: ~500MB (PDF) due to memory constraints
- **Max pages**: ~10,000 pages (PDF)
- **Encoding**: UTF-8 only for EPUB

## Error Handling

### Common Issues

1. **"No module named 'PyPDF2'"**
   - Solution: `pip install PyPDF2`

2. **"UnicodeEncodeError"**
   - Solution: Script auto-handles with simplified filenames

3. **"PdfReadWarning: Advanced encoding not implemented"**
   - Impact: Some characters may not render correctly
   - Severity: Warning only, processing continues

4. **"未找到有效章节"**
   - Solution: Falls back to page-based splitting automatically

### Logging Levels

- ✅ Success: File processed
- ⚠️  Warning: Page skipped, fallback used
- ❌ Error: Critical failure, processing stopped

## Testing

### Test Data

```bash
# Test with sample files
python scripts/split_ebook.py -i tests/data/ -o tests/output/
```

### Expected Output

- 1 EPUB → 65 chapter files
- 1 PDF → 8-12 chapter files (varies by chapter detection)

## Future Enhancements

### Planned Features

1. OCR support for scanned PDFs (tesseract integration)
2. Multi-column layout detection
3. Table preservation in markdown
4. Image extraction and embedding
5. Batch processing with parallel execution
6. Progress bar display
7. JSON output format option
8. TOC extraction for navigation

### Contributing

To add new chapter detection patterns:
1. Update `CHAPTER_PATTERNS` in `split_ebook.py`
2. Add test cases in `tests/`
3. Update this reference document
