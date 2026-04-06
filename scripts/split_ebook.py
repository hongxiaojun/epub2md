#!/usr/bin/env python3
"""
电子书章节拆解工具 Ebook Chapter Splitter
支持PDF和EPUB格式，智能识别章节，自动过滤非正文内容
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Dict, Optional

try:
    from ebooklib import epub
    from ebooklib import ITEM_DOCUMENT
    from PyPDF2 import PdfReader
    import html2text
except ImportError as e:
    print(f"❌ 缺少依赖库: {e}")
    print("请安装: pip install PyPDF2 ebooklib html2text")
    sys.exit(1)


class EbookSplitter:
    """电子书拆解器"""

    # 需要忽略的关键词
    IGNORE_KEYWORDS = [
        '封面', '目录', '序言', '推荐序', '前言', '自序', '他序',
        '版权', '版权声明', '版权所有', '出版社', '出版说明',
        '献词', '致谢', '作者简介', '关于作者', '作者介绍',
        'Contents', 'Table of Contents', 'Introduction',
        'Preface', 'Foreword', 'Copyright', 'Publisher',
        'Acknowledgments', 'About the Author', 'Dedication',
        '书名', 'ISBN', '版次', '印次', '定价'
    ]

    # 章节标题模式
    CHAPTER_PATTERNS = [
        r'^第[一二三四五六七八九十百千0-9]+[章回节篇]',
        r'^Chapter\s*\d+',
        r'^CHAPTER\s*\d+',
        r'^第\s*\d+\s*[章回节篇]',
        r'^\d+\.\d+\s+',
        r'^\d+\.\s+[^\d]{1,30}',
        r'^\d+、\s*[^\d]{1,30}',
        r'^[一二三四五六七八九十]+、\s*[^\d]{1,30}',
        r'^Part\s*\d+',
        r'^Section\s*\d+',
        r'^第[一二三四五六七八九十\d]+部分',
    ]

    def __init__(self, input_dir: str, output_dir: Optional[str] = None):
        """初始化拆解器

        Args:
            input_dir: 输入目录路径
            output_dir: 输出目录路径（默认为input_dir/processed）
        """
        self.input_dir = Path(input_dir)
        self.output_dir = Path(output_dir) if output_dir else self.input_dir / "processed"
        self.output_dir.mkdir(parents=True, exist_ok=True)

    def is_chapter_title(self, line: str) -> bool:
        """判断是否是章节标题"""
        if len(line) > 100:
            return False

        for pattern in self.CHAPTER_PATTERNS:
            if re.match(pattern, line, re.IGNORECASE):
                return True
        return False

    def is_ignore_page(self, title: str, content: str) -> bool:
        """判断是否应该忽略该页面"""
        if title:
            for keyword in self.IGNORE_KEYWORDS:
                if keyword in title:
                    return True

        if content and len(content.strip()) < 100:
            return True

        return False

    def extract_book_name(self, filename: str) -> str:
        """从文件名提取书名"""
        name = Path(filename).stem

        # 移除无关后缀
        patterns = [
            r'\s*\(.*?\)',
            r'\s*\[.*?\]',
            r'\s*--.*$',
            r'\s*_.*$',
            r'\s*z-lib\.org.*$',
            r'\s*B01.*$',
        ]

        for pattern in patterns:
            name = re.sub(pattern, '', name, flags=re.IGNORECASE)

        return name.strip()

    def split_epub(self, epub_path: Path) -> None:
        """拆解EPUB文件"""
        print(f"\n📖 处理EPUB: {epub_path.name}")

        try:
            book = epub.read_epub(str(epub_path))
            book_name = self.extract_book_name(epub_path.name)

            chapters = []
            for item in book.get_items():
                if item.get_type() == ITEM_DOCUMENT:
                    filename = item.get_name()
                    title = self._extract_chapter_title_from_filename(filename)

                    content = item.get_content()
                    html_content = content.decode('utf-8')

                    h = html2text.HTML2Text()
                    h.ignore_links = False
                    h.ignore_images = False
                    md_content = h.handle(html_content)

                    chapters.append({'title': title, 'content': md_content})

            self._save_chapters(chapters, book_name)
            print(f"✅ EPUB处理完成: {epub_path.name}")

        except Exception as e:
            print(f"❌ EPUB处理失败: {e}")

    def split_pdf(self, pdf_path: Path) -> None:
        """拆解PDF文件"""
        print(f"\n📕 处理PDF: {pdf_path.name}")

        try:
            reader = PdfReader(str(pdf_path))
            book_name = self.extract_book_name(pdf_path.name)
            total_pages = len(reader.pages)

            chapters = []
            chapter_num = 1
            current_content = []
            current_title = None
            found_first_chapter = False
            pages_in_current_chapter = 0

            for page_num, page in enumerate(reader.pages, 1):
                try:
                    text = page.extract_text()
                    if not text:
                        continue

                    lines = text.split('\n')
                    page_has_content = False

                    for line in lines:
                        line = line.strip()
                        if not line:
                            continue

                        if self.is_chapter_title(line):
                            if current_content and found_first_chapter and pages_in_current_chapter >= 2:
                                content = '\n'.join(current_content)
                                if not self.is_ignore_page(current_title, content):
                                    chapters.append({
                                        'title': current_title or f"第{chapter_num}章",
                                        'content': content
                                    })
                                    chapter_num += 1

                            current_title = line
                            current_content = []
                            found_first_chapter = True
                            page_has_content = True
                            pages_in_current_chapter = 0
                        else:
                            if found_first_chapter:
                                current_content.append(line)
                                page_has_content = True

                    pages_in_current_chapter += 1

                except Exception as e:
                    print(f"   ⚠️  页面 {page_num} 处理失败: {e}")
                    continue

            # 保存最后一章
            if current_content and found_first_chapter and pages_in_current_chapter >= 2:
                content = '\n'.join(current_content)
                if not self.is_ignore_page(current_title, content):
                    chapters.append({
                        'title': current_title or f"第{chapter_num}章",
                        'content': content
                    })

            # 如果没有找到任何章节，使用备用方法：按页数分割
            if not chapters and total_pages > 0:
                print(f"   ℹ️  未找到明确章节，按页数分割...")
                chapters = self._split_pdf_by_pages(reader, book_name)

            if chapters:
                self._save_chapters(chapters, book_name)
                print(f"✅ PDF处理完成: {pdf_path.name}，共 {len(chapters)} 章")
            else:
                print(f"⚠️  PDF未找到有效章节: {pdf_path.name}")

        except Exception as e:
            print(f"❌ PDF处理失败: {e}")

    def _split_pdf_by_pages(self, reader, book_name: str) -> List[Dict]:
        """按页数分割PDF（备用方法）"""
        chapters = []
        total_pages = len(reader.pages)

        # 根据总页数决定每章的页数
        if total_pages <= 50:
            pages_per_chapter = 5
        elif total_pages <= 100:
            pages_per_chapter = 10
        elif total_pages <= 200:
            pages_per_chapter = 15
        else:
            pages_per_chapter = 20

        # 跳过前几页（通常是封面、目录等）
        start_page = 3
        if start_page >= total_pages:
            start_page = 0

        chapter_num = 1
        current_content = []

        for page_num in range(start_page, total_pages):
            try:
                page = reader.pages[page_num]
                text = page.extract_text()

                if text:
                    current_content.append(text)

                if (page_num - start_page + 1) % pages_per_chapter == 0:
                    content = '\n'.join(current_content)
                    if len(content.strip()) > 100:
                        chapters.append({
                            'title': f"第{chapter_num}章 (第{start_page + 1}-{page_num + 1}页)",
                            'content': content
                        })
                        chapter_num += 1
                        current_content = []

            except Exception:
                continue

        # 保存剩余内容
        if current_content:
            content = '\n'.join(current_content)
            if len(content.strip()) > 100:
                chapters.append({
                    'title': f"第{chapter_num}章 (第{start_page + 1}-{total_pages}页)",
                    'content': content
                })

        return chapters

    def _extract_chapter_title_from_filename(self, filename: str) -> str:
        """从文件名提取章节标题"""
        title = Path(filename).stem

        prefixes_to_remove = [
            r'^split_\d+',
            r'^chapter_\d+',
            r'^xhtml_\d+',
        ]

        for prefix in prefixes_to_remove:
            title = re.sub(prefix, '', title, flags=re.IGNORECASE)

        return title.strip()

    def _save_chapters(self, chapters: List[Dict], book_name: str) -> None:
        """保存章节到文件"""
        for i, chapter in enumerate(chapters, 1):
            title = chapter['title']
            content = chapter['content']

            # 跳过要忽略的页面
            if self.is_ignore_page(title, content):
                continue

            # 清理书名和标题用于文件名
            safe_book_name = re.sub(r'[^\w\s\-_\u4e00-\u9fff]', '', book_name)
            safe_title = re.sub(r'[^\w\s\-_\u4e00-\u9fff]', '_', title)
            safe_title = safe_title[:30]

            # 移除多余的空格和下划线
            safe_book_name = re.sub(r'[\s_]+', '_', safe_book_name).strip('_')
            safe_title = re.sub(r'[\s_]+', '_', safe_title).strip('_')

            # 生成文件名
            if safe_title:
                filename = f"{safe_book_name}-第{i}章节-{safe_title}.md"
            else:
                filename = f"{safe_book_name}-第{i}章节.md"

            # 如果文件名过长，简化
            if len(filename) > 150:
                filename = f"{safe_book_name}-第{i}章节.md"

            file_path = self.output_dir / filename

            # 写入文件
            try:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(f"# {title}\n\n")
                    f.write(content)

                print(f"   💾 已保存: {filename}")
            except Exception as e:
                print(f"   ⚠️  保存失败 {filename}: {e}")
                # 尝试使用简化文件名
                simple_filename = f"{safe_book_name}-第{i}章节.md"
                simple_path = self.output_dir / simple_filename
                try:
                    with open(simple_path, 'w', encoding='utf-8') as f:
                        f.write(f"# {title}\n\n")
                        f.write(content)
                    print(f"   💾 已保存（简化名）: {simple_filename}")
                except Exception as e2:
                    print(f"   ❌ 完全失败: {e2}")

    def process_all(self) -> None:
        """处理输入目录中的所有电子书"""
        pdf_files = list(self.input_dir.glob("*.pdf"))
        epub_files = list(self.input_dir.glob("*.epub"))

        total = len(pdf_files) + len(epub_files)
        if total == 0:
            print("❌ 未找到PDF或EPUB文件")
            return

        print(f"📚 找到 {total} 个电子书文件")
        print(f"   PDF: {len(pdf_files)} 个")
        print(f"   EPUB: {len(epub_files)} 个")

        # 处理EPUB文件
        for epub_file in epub_files:
            self.split_epub(epub_file)

        # 处理PDF文件
        for pdf_file in pdf_files:
            self.split_pdf(pdf_file)

        print(f"\n✅ 全部完成！文件保存在: {self.output_dir}")


def main():
    """主函数"""
    import argparse

    parser = argparse.ArgumentParser(
        description='电子书章节拆解工具 - 将PDF和EPUB拆解成Markdown章节'
    )
    parser.add_argument('-i', '--input', required=True, help='输入目录')
    parser.add_argument('-o', '--output', help='输出目录 (默认为输入目录/processed)')
    parser.add_argument('--version', action='version', version='%(prog)s 1.0.0')

    args = parser.parse_args()

    splitter = EbookSplitter(args.input, args.output)
    splitter.process_all()


if __name__ == '__main__':
    main()
