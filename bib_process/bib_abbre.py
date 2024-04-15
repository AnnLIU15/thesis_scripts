import bibtexparser
from bibtexparser.bparser import BibTexParser
import sys
from pathlib import Path

base_dir = str(Path(__file__).resolve().parent)
sys.path.append(base_dir)

from utils import (
    replace_text,
    chinese_to_english_mapping,
    check_key,
    upper_name,
    title_process,
    abbreviate_journal_booktitle,
)

if __name__ == "__main__":
    # 获取当前笔记本文件的路径
    factor_pre = 1  # 双大括号形式 (2) or 单大括号形式 (1)
    title_process_flag = True
    in_bib = f"{base_dir}/test/Reference.bib"
    out_bib = f"{base_dir}/test/Reference2.bib"

    with open(in_bib, "r", encoding="utf-8") as file:
        content = file.read()
    # 替换中文字符
    content = replace_text(content, chinese_to_english_mapping)

    # 处理替换后的内容
    # 这里的 content 已经没有原始的中文字符了，可以安全地送入 bibtexparser 或其他处理流程
    parser = BibTexParser(ignore_nonstandard_types=False)
    bib_database = bibtexparser.loads(content, parser=parser)

    # bib_database.entries是一个包含条目的字典列表
    # 将其转换为一个字典，其中键是每个条目的ID
    # entries_dict = {entry['ID']: entry for entry in bib_database.entries}

    # 修改字典中的条目
    for entry in bib_database.entries:
        # if entry['ENTRYTYPE'].lower() in ['masterthesis', 'patent', 'online', 'standard']:
        #     entry['ENTRYTYPE'] = 'misc'
        # 这里可以进行其他修改
        # publisher
        replace_key_entry = check_key(entry)
        upper_last_name_entry = upper_name(replace_key_entry, factor_pre)
        if title_process_flag:
            upper_last_name_entry = title_process(upper_last_name_entry, factor_pre)
        upper_last_name_entry = abbreviate_journal_booktitle(upper_last_name_entry)
        entry.update(upper_last_name_entry)

    # 将修改后的字典转换回列表
    # bib_database.entries = list(entries_dict.values())

    # 保存修改后的BibTeX文件
    with open(out_bib, "w", encoding="utf8") as bibtex_file:
        bibtexparser.dump(bib_database, bibtex_file)
