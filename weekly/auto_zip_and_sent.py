import os
import smtplib
from datetime import datetime, timedelta
from email.mime.application import MIMEApplication
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from glob import glob
import numpy as np
import pandas as pd
from cryptography.fernet import Fernet
from PyPDF2 import PdfReader, PdfMerger, PdfWriter
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from PyPDF2.generic import AnnotationBuilder
import io
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
import time
import sxtwl

jqmc = ["冬至", "小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏",
     "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑","白露", "秋分", "寒露", "霜降", 
     "立冬", "小雪", "大雪"]

# 获取当前脚本文件所在目录
current_script_directory = os.path.dirname(os.path.abspath(__file__))
os.chdir(current_script_directory)


# 定义函数：解密密码
def decrypt_password(encrypted_password):
    decrypted_password = cipher_suite.decrypt(encrypted_password)
    return decrypted_password.decode("utf-8")


# 定义函数：查找最旧的日期
def find_oldest(x, s):
    return datetime.strptime(x, f"{s}%Y%m%d")


# 定义函数：发送邮件
def send_email(
    origin_msg,
    cur_folder,
    pdf_filename,
    decrypted_password,
    smtp_server,
    smtp_port,
    sender_email,
    receiver_email,
):
    # 创建邮件对象
    message = MIMEMultipart()
    message["From"] = sender_email
    if type(receiver_email) == list:
        message["To"] = ", ".join(receiver_email)
    else:
        message["To"] = receiver_email
    message["Subject"] = cur_folder

    # 添加邮件正文
    message.attach(MIMEText(origin_msg, "html"))

    # 添加压缩文件作为附件
    attachment = open(pdf_filename, "rb").read()
    attach_part = MIMEApplication(attachment)
    attach_part.add_header(
        "Content-Disposition", "attachment", filename=f"{cur_folder}.pdf"
    )
    message.attach(attach_part)

    # 使用SSL连接SMTP服务器并发送邮件
    try:
        server = smtplib.SMTP_SSL(smtp_server, smtp_port)
        server.login(sender_email, decrypted_password)
        server.sendmail(sender_email, receiver_email, message.as_string())
        server.quit()
        print("邮件发送成功")
    except Exception as e:
        print(f"邮件发送失败: {str(e)}")


# 定义函数：加密密码
def encrypt_password(password):
    encrypted_password = cipher_suite.encrypt(password.encode("utf-8"))
    return encrypted_password


# 是否进行加密和解密操作
encode_flag = False
password = "add_ur_pwd"  # if encode_flag == True
des_path = "D:/CourseData/"
# 邮件发送配置
smtp_server = "smtp.exmail.qq.com"  # 使用QQ邮箱的SMTP服务器
smtp_port = 465  # 使用SSL的端口号
sender_email = "xxxxxxxxxxxx@mail2.sysu.edu.cn"  # 发件人邮箱地址
receiver_email = [
    "xxxxxxxxxx@mail.sysu.edu.cn",
    "xxxxxxxxx@mail.sysu.edu.cn",
]  # 收件人邮箱地址

# 获取所有名字
all_name = ["xxxxxxxx"]
# "叶彤",
# 使用glob模块获取匹配的文件夹
prefix = "周报_xxxxxxx组_"

matching_key = "周报"
# allowed_extensions = ["pdf", "docx", "txt", "doc", "md"]  # 可以匹配的文件格式列表
allowed_extensions = ["pdf"]  # 可以匹配的文件格式列表

# 生成/读取密钥
if encode_flag:
    key = Fernet.generate_key()
    with open(f"{des_path}/key", "wb") as key_file:
        key_file.write(key)
else:
    with open(f"{des_path}/key", "rb") as key_file:
        key = key_file.read()

# 创建一个 Fernet 密钥对象
cipher_suite = Fernet(key)

# 加密密码
if encode_flag:
    encrypted_password = encrypt_password(password)
    with open(f"{des_path}/password", "wb") as f:
        f.write(encrypted_password)
else:
    with open(f"{des_path}/password", "rb") as f:
        encrypted_password = f.read()

# 解密密码
decrypted_password = decrypt_password(encrypted_password)


matching_folders = glob(f"{prefix}*")
num_of_week = len(matching_folders)

if matching_folders == []:
    # 获取当前日期
    begin_date = datetime.now()
    cur_date = begin_date
    cur_folder = f'{prefix}{cur_date.strftime("%Y%m%d")}'
else:
    date_list = [find_oldest(folder, prefix) for folder in matching_folders]
    begin_date = min(date_list)
    cur_date = max(date_list)
    cur_folder = matching_folders[np.argmax(date_list)]
cur_day_4_sxtwl = sxtwl.fromSolar(begin_date.year, begin_date.month, begin_date.day)
next_day_4_sxtwl = cur_day_4_sxtwl.after(1)
seven_days_ago = cur_date - timedelta(days=6)
begin_year = begin_date.year
begin_month = begin_date.month

# 判断学期
if 7 <= begin_month <= 10:
    season = "秋"
elif 1 <= begin_month <= 3:
    season = "春"
else:
    raise ValueError(f"起始日期为：{begin_date} -- 未知学期")

# 匹配文件
matching_files = []
for ext in allowed_extensions:
    matching_files.extend(glob(os.path.join(cur_folder, f"*.{ext}")))

# 获取每个PDF文件的页数
pdf_pages = []
submitted_name = []

for pdf_file in matching_files:
    if pdf_file.endswith(".pdf"):
        name = None
        file_extension = os.path.splitext(pdf_file)[1]
        for cur_name in all_name:
            if cur_name in pdf_file:
                name = cur_name
                submitted_name.append(name)
                break
        if name is None:
            continue
        try:
            with open(pdf_file, "rb") as file:
                reader = PdfReader(file)
                num_pages = len(reader.pages)
                pdf_pages.append((pdf_file, num_pages))
        except Exception as e:
            print(f"Error reading {pdf_file}: {e}")

# 按页数逆序排序
pdf_pages.sort(key=lambda x: x[1])
# 注册中文字体，这里以“微软雅黑”为例
pdfmetrics.registerFont(TTFont("YaHei", "msyh.ttc"))
# 创建一个新的PDF页面
packet = io.BytesIO()
can = canvas.Canvas(packet, pagesize=A4)
can.setFont("YaHei", 18)  # 使用中文字体

can.drawString(72, 720, "周报文件顺序 | 点击文字有跳转 (每个页左上角有回跳)：")
cur_page = 2
for i, (pdf_file, num_pages) in enumerate(pdf_pages, start=1):
    next_page = cur_page + num_pages
    prefix_name = f"{i}. {os.path.basename(pdf_file)}"
    postfix_name = f" (Page {cur_page}-{next_page-1})"
    text_width = pdfmetrics.stringWidth(postfix_name, "YaHei", 18)
    x_pos = A4[0] - text_width - 72  # 72为页面右边距
    # 绘制文本
    can.drawString(72, 720 - 60 * i, prefix_name[:-4])
    can.drawString(x_pos, 720 - 60 * i, postfix_name)
    # 递增当前页码
    cur_page = next_page
can.save()
# 将新创建的页面转换为PDF
packet.seek(0)
new_pdf = PdfReader(packet)
# 创建一个新的PDF文件用于存储拼接后的内容
merger = PdfMerger()

# 将新页面添加到合并器
merger.append(new_pdf)

# 按排序后的顺序添加每个PDF文件
for pdf_file, _ in pdf_pages:
    try:
        merger.append(pdf_file)
    except Exception as e:
        print(f"Error merging {pdf_file}: {e}")

# 保存拼接后的PDF文件
pdf_filename = f"{cur_folder}/周报_xxxxxxxx组_{cur_date.strftime('%Y%m%d')}.pdf"
merger.write(pdf_filename)
merger.close()
print(f"Merged PDF saved as {pdf_filename}")
reader = PdfReader(open(pdf_filename, "rb"))
merger = PdfWriter()
num_of_pages = len(reader.pages)
for page in range(num_of_pages):
    current_page = reader.pages[page]
    merger.add_page(current_page)
x1, y1, x2, y2 = merger.pages[0].mediabox
cur_page = 1

for i, (pdf_file, num_pages) in enumerate(pdf_pages, start=1):
    next_page = cur_page + num_pages
    prefix_name = f"{i}. {os.path.basename(pdf_file)}"[:-4]
    postfix_name = f" (Page {cur_page}-{next_page-1})"
    annotation = AnnotationBuilder.link(
        rect=(72, 720 - 60 * i + 20, x2 - 60, 720 - 60 * i - 10),
        target_page_index=cur_page,
    )
    merger.add_annotation(page_number=0, annotation=annotation)
    # 递增当前页码
    cur_page = next_page
for idx, val in enumerate(merger.pages):
    if idx == 0:
        continue
    x1_t, y1_t, x2_t, y2_t = merger.pages[idx].mediabox
    annotation = AnnotationBuilder.free_text(
        "Back to contents",
        rect=(20, y2_t - 5, 170, y2_t - 27),
        font="Microsoft Yahei",
        bold=True,
        italic=True,
        font_size="20pt",
        # font_color="00ff00",border_color="0000ff",
        # background_color="cdcdcd",
    )
    merger.add_annotation(page_number=idx, annotation=annotation)
    annotation = AnnotationBuilder.link(
        rect=(20, y2_t - 5, 170, y2_t - 27),
        target_page_index=0,
    )
    merger.add_annotation(page_number=idx, annotation=annotation)
with open(pdf_filename, "wb") as link_pdf:
    merger.write(link_pdf)
# 创建一个空的数据帧
df = pd.DataFrame()

# 将所有名字添加到数据帧中的列
for name in all_name:
    df[name] = ""

# 在提交的名字下打勾
for name in submitted_name:
    df.loc["提交情况", name] = "✓"

# 将空白单元格填充为 NaN
df = df.fillna("")

# 将数据帧转换为 HTML 表格
html_table = df.to_html(classes="table table-striped")

if cur_day_4_sxtwl.hasJieQi():
    jq = jqmc[cur_day_4_sxtwl.getJieQi()]
    jq = f"{jq}节安康!"
elif next_day_4_sxtwl.hasJieQi():
    jq = jqmc[next_day_4_sxtwl.getJieQi()]
    jq = f"{jq}节安康!"
else:
    jq = ""
origin_msg = (
    f"x老师、x老师:<br><br>下午好! {jq}<br><br>"
    + f"{begin_year}{season}季学期第{num_of_week}周"
    + f'({seven_days_ago.strftime("%Y%m%d")}-{cur_date.strftime("%Y%m%d")}) '
    + f"xxxxxx组收集到的周报 ({len(submitted_name)}/{len(all_name)})，提交情况如表所示：<br><br>{html_table}<br>"
    + "具体文件可见于本邮件附件，请审阅！<br><br>xxxxxx"
)
print(origin_msg)
# 发送邮件
send_email(
    origin_msg,
    cur_folder,
    pdf_filename,
    decrypted_password,
    smtp_server,
    smtp_port,
    sender_email,
    receiver_email,
)
print("发送成功!")
time.sleep(10)
