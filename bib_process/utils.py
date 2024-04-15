import re
import sys
import bibtexparser
from bibtexparser.bparser import BibTexParser
from collections import OrderedDict
from langid import classify
import requests

chinese_to_english_mapping = {
        '‘': "'",  # 中文单引号到英文单引号
        '’': "'",  # 中文单引号到英文单引号
        '“': '"',  # 中文双引号到英文双引号
        '”': '"',  # 中文双引号到英文双引号
        '。': '. ',  # 中文句号到英文句号
        '，': ', ',
        '–': '--', # 破折号替换
        '（': ' (',  # 中文左括号到英文左括号
        '）': ') ',  # 中文右括号到英文右括号
        '；': '; ',  # 中文分号到英文分号
        '！': '! '
    }

def replace_text(text, mapping):
    """使用给定的映射替换文本中的字符"""
    for src, dst in mapping.items():
        text = re.sub(src, dst, text)
    return text

# ref https://zhuanlan.zhihu.com/p/609189102 and http://haixing-hu.github.io/nju-thesis/*/gbt7714-2005.bst
# artical keys -- journal
article_key = ['title', 'author', 'journal', 'volume', 'number', 'pages', 'year', 'month', 'publisher']
# conference paper
inproceedings_key = ['title', 'author', 'booktitle', 'pages', 'year', 'month', 'address']
# thesis
thesis_key = ['title', 'author', 'school', 'address', 'year', 'month',]
# patent
patent_key = ['title', 'author', 'country', 'date', 'patentid']
# webpage and online
online_key = ['title', 'author', 'publisher', 'year', 'citedate', 'url'] 
# periodical and newspaper [all]
periodical_key = ['title', 'publisher', 'address', 'year', 'volume', 'number'] 
# program and database
program_key = ['title', 'author', 'publisher', 'address', 'year', 'citedate', 'url']
# unpublished and manuscript
unpublished_key = ['title', 'author', 'year']
# news
news_key = ['title', 'author', 'journal', 'date']
# full conference and proceedings
proceedings_key = ['editor', 'series', 'volume', 'title', 'publisher', 'address', 'year',]
# reference and manual
reference_key = ['series', 'volume', 'title', 'publisher', 'address', 'year',]
# standard
standard_key = ['title', 'author', 'publisher', 'address', 'year', 'citedate', 'pages']
# techreport
techreport_key = ['title', 'author', 'institution', 'year', 'month', 'url']
# book and collection
book_key = ['title', 'author', 'year', 'month', 'pages', 'publisher']
# misc
misc_key = ['title', 'author', 'year', 'url']
# software
software_key = ['author', 'license', 'year', 'month', 'url', 'version']

def check_key(dict4check):
    cite_key = dict4check['ENTRYTYPE'].lower()
    if sys.version_info >= (3, 10):
        match cite_key:
            case 'inproceedings' | 'inbook' | 'incollection':
                keys_list = inproceedings_key
            case 'article':
                keys_list = article_key
            case 'bachelorthesis' | 'masterthesis' | 'phdthesis':
                keys_list = thesis_key
            case 'patent':
                keys_list = patent_key
            case 'online' | 'webpage':
                keys_list = online_key
            case 'periodical' | 'newspaper':
                keys_list = periodical_key
            case 'program' | 'database':
                keys_list = program_key
            case 'unpublished' | 'manuscript':
                keys_list = unpublished_key
            case 'news':
                keys_list = news_key
            case 'proceedings' | 'conference':
                keys_list = proceedings_key
            case 'reference' | 'manual':
                keys_list = reference_key
            case 'standard':
                keys_list = standard_key
            case 'techreport':
                keys_list = techreport_key
            case 'book' | 'collection':
                keys_list = book_key
            case 'misc':
                keys_list = misc_key
            case 'software':
                keys_list = software_key
            case _:
                raise TypeError(f'Unsupport type: {cite_key}')
    else:
        if cite_key in ['inproceedings', 'inbook', 'incollection']:
            keys_list = inproceedings_key
        elif cite_key == 'article':
            keys_list = article_key
        elif cite_key in ['bachelorthesis', 'masterthesis', 'phdthesis']:
            keys_list = thesis_key
        elif cite_key == 'patent':
            keys_list = patent_key
        elif cite_key in ['online', 'webpage']:
            keys_list = online_key
        elif cite_key in ['periodical', 'newspaper']:
            keys_list = periodical_key
        elif cite_key in ['program', 'database']:
            keys_list = program_key
        elif cite_key in ['unpublished', 'manuscript']:
            keys_list = unpublished_key
        elif cite_key == 'news':
            keys_list = news_key
        elif cite_key in ['proceedings', 'conference']:
            keys_list = proceedings_key
        elif cite_key in ['reference', 'manual']:
            keys_list = reference_key
        elif cite_key == 'standard':
            keys_list = standard_key
        elif cite_key == 'techreport':
            keys_list = techreport_key
        elif cite_key in ['book', 'collection']:
            keys_list = book_key
        elif cite_key == 'misc':
            keys_list = misc_key
        elif cite_key == 'software':
            keys_list = software_key
        else:
            raise TypeError(f'Unsupported type: {cite_key}')

    all_keys = keys_list + ['ID', 'ENTRYTYPE']
    ordered_entry = OrderedDict()
    for key in all_keys:
        ordered_entry[key] = dict4check.get(key, '')
    
    return ordered_entry


def contains_letter(text):
    return re.search('[a-zA-Z]', text) is not None
def contains_chinese(text):
    return re.search('[\u4e00-\u9fff]', text) is not None

def upper_name(entry, factor_pre = 2):
    if not contains_chinese(entry['author']):
        multi_author = entry['author'].split(' and ')
        
        is_comma = sum([',' in author for author in multi_author]) >= 1
        if is_comma:
            for idx, author in enumerate(multi_author):
                last_name_pos = author.find(',')
                factor = factor_pre - (('{' == author[0]) and ('}' == author[last_name_pos-1]))
                multi_author[idx] = '{' *factor + author[:last_name_pos] + '}' *factor + author[last_name_pos:]
        else:
            for idx, author in enumerate(multi_author):
                # 中文名无间隔！
                last_name_pos = author.split(' ')
                factor = factor_pre - (('{' == last_name_pos[-1][0]) and ('}' == last_name_pos[-1][-1]))
                last_name_pos[-1] = '{'*factor+last_name_pos[-1]+'}'*factor
                multi_author[idx] = ' '.join(last_name_pos)
        entry['author'] = ' and '.join(multi_author)
        # print(entry['author'])
    else:
        pass
    
    return entry

def strip_outer_braces(s):
    # 循环去除两端的花括号
    while 1:
        break_flag = 1
        if s.startswith('{'):
            s = s[1:]
            break_flag = 0
        if s.endswith('}'):
            s = s[:-1]
            break_flag = 0
        if break_flag:
            break
    return s


def title_process(entry, factor_pre = 2):
    try:
        new_name_list = []
        for val in entry['title'].split(' '):
            new_name_list.append('{'*factor_pre + strip_outer_braces(val) + '}'*factor_pre)
        entry['title'] = ' '.join(new_name_list)
    except Exception:
        pass
    return entry


def get_abbreviated_title(title):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 Edg/123.0.0.0'
    }

    urls = [
        f"http://8.138.123.116:9080/a/{requests.utils.quote(title)}",
        f"https://abbreviso.toolforge.org/abbreviso/a/{requests.utils.quote(title)}"
    ]

    for url in urls:
        try:
            response = requests.get(url, headers=headers)
            if response.status_code == 200:
                return response.text  # Use `.text` instead of `.content.decode()` for simplicity
        except requests.RequestException as e:
            print(f"Error accessing {url}: {str(e)}")  # Better error handling

    raise ValueError("Error: Unable to retrieve abbreviation\n" +
                     "Please deploy your server according to the guidances\n" +
                     "1. install node.js and npm [e.g. sudo apt install nodejs npm or https://nodejs.org/en/download]\n"
                     "2. git clone https://github.com/marcinwrochna/abbrevIso.git && cd abbrevIso\n" + 
                     "3. npm install express\n" +
                     "4. node server.js\n" +
                     "5. add \"http://0.0.0.0:5000/a/{requests.utils.quote(title)}\" in urls" 
                     )  # General error message if all requests fail

def abbreviate_journal_booktitle(entry):
    if 'booktitle' in entry.keys():
        info = entry['booktitle']
        key = 'booktitle'
    elif 'journal' in entry.keys():
        info = entry['journal']
        key = 'journal'
    else:
        info = None
    if info:
        lang, _ = classify(info)
        if lang not in ['zh', 'ja', 'ko']:
            entry[key] = get_abbreviated_title(info)
        else:
            pass
    return entry