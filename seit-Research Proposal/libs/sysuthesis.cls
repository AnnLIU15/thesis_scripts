% 定义模板样式
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{sysuthesis}[2024/11/11 v0.1 Sun Yat-Sen University proposal document class]
\newcommand{\newclearpage}{\clearpage} % 设置文章为电子版格式（不添加多余空白页）
\DeclareOption{print-both-sides}{ % 设置文章为双面打印格式（添加多余空白页保证每个表格、章节开头为奇数页面）
    \renewcommand{\newclearpage}{
        \clearpage{
            \pagestyle{empty}
            \cleardoublepage
        }
    }
}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}
\ProcessOptions\relax

\LoadClass[
    % fontset=adobe2, % 可手动下载adobe，并选用此项
    fontset=fandol,    % texlive自带，可移植字体库，只有常用的6763个汉字
    %fontset=ubuntu,
    %fontset=mac,
    %fontset=windows, % 在windows系统下使用这一行的命令以显示生僻字
    a4paper,
    %openright,
    openany,
    zihao=-4
]{ctexbook}



% 配置英文字体
\RequirePackage{fontspec}
% 如果\RequirePackage{newtxtext}能正常通过编译请注释以下三行，并取消第四行的注释
\renewcommand*{\rmdefault}{ntxtlf} % always TLF for math
\renewcommand*{\familydefault}{\rmdefault}
\setmainfont{Times New Roman} % 如果注释掉能正常编译，请注释
%\RequirePackage{newtxtext} % 文本自动采用新罗马字体
\setCJKfamilyfont{song}[Path = ./fonts/,AutoFakeBold = {2.17}]{SimSun.ttf}
\renewcommand*{\songti}{\CJKfamily{song}}
\setCJKfamilyfont{heiti}[Path = ./fonts/,AutoFakeBold = {2.17}]{simhei.ttf}
\renewcommand*{\heiti}{\CJKfamily{heiti}}
\setCJKmainfont[Path = ./fonts/,AutoFakeBold = {2.17}]{SimSun.ttf}
% \RequirePackage[margin=1in,headsep=.2in, headheight=2in]{geometry}
\RequirePackage[top=25mm, bottom=20mm, left=30mm, right=30mm,a4paper]{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{booktabs}
\RequirePackage{calc}
\RequirePackage{tikz}
\RequirePackage{graphicx}
% \RequirePackage{eso-pic} % 用于居中和背景定位
\RequirePackage[labelsep=space]{caption}
\RequirePackage[font=footnotesize]{subcaption}
\RequirePackage{amsmath,amssymb,amsthm}
\RequirePackage{newtxmath,bm} % 公式使用新罗马字体
\RequirePackage{ragged2e} % 实现两端对齐
\RequirePackage{listings}
\RequirePackage{longtable}
\RequirePackage[section]{placeins}
% \usepackage[caption=false,font=scriptsize,labelfont=rm,textfont=rm,subrefformat=parens]{subfig}

% TODO: 伪代码要用中文吗？
% \RequirePackage[onelanguage,linesnumbered,algochapter,ruled,vlined]{algorithm2e}
\RequirePackage[chinese, onelanguage,linesnumbered,algochapter,ruled,vlined]{packages/algorithm2e}
\RequirePackage{enumitem}
\RequirePackage{bbm}
\RequirePackage{bm}
\RequirePackage[notlof,notlot,nottoc,numbib]{tocbibind} %table of content
\RequirePackage{tocloft}
\RequirePackage{wrapfig}
\RequirePackage{colortbl}
\RequirePackage{xcolor}
\RequirePackage{array}
\RequirePackage{makecell}
\RequirePackage[bottom, perpage]{footmisc}
\RequirePackage{setspace}
\RequirePackage{datetime}
\RequirePackage{nth}
\RequirePackage{tabu}
\RequirePackage{multirow}
% 引入调整段落整体宽度的宏包
\RequirePackage{changepage}
% 作图宏包
\RequirePackage{pgfplots}

% Fix <https://github.com/SYSU-SCC/sysu-thesis/issues/71>
\RequirePackage{notoccite}

% 设定时间为中文日期
\ctexset{today=small}

% 定义英文日期格式
\newcommand\etoday{
    \hspace{0.5\ccwd} \monthname[\the\month]\hspace{2\ccwd} \nth{\the\day}{\hspace{1\ccwd}} \the\year
}

\AtBeginDocument{
    \hypersetup{
        citecolor=green,
        filecolor=black,
        linkcolor=black,
        urlcolor=black,
        CJKbookmarks=true,
        pdftitle={\@ctitle},
        pdfauthor={\@cauthor},
        % pdfkeywords={\@ckeywords},
        pdfcreator={LaTeX with hyperref package, using SYSU undergraduate Thesis LaTeX Template}
    }
}
\pagestyle{fancy}
% 1.5倍行距 TODO
\renewcommand{\baselinestretch}{1.5}

% 有序与无序列表环境
\setlist[enumerate]{nosep}
\renewcommand\labelenumi{\theenumi)}
%\renewcommand\labelenumi{\theenumi.}
\setlist[itemize]{nosep}
\setlist[description]{nosep}

% 页眉、页脚、脚注设定
\renewcommand{\headrulewidth}{1pt}
\renewcommand{\footrulewidth}{0pt}
\renewcommand{\chaptermark}[1]{ \markboth{#1}{} }
% 采用带圈数字符号代替*号脚注
\xeCJKsetcharclass{`①}{`⑩}{1}
\usepackage{xeCJKfntef}

% 默认页面页眉页脚样式
\fancypagestyle{plain}{
    \fancyhf{}
    % F18 页眉与页脚 宋体五号居中
    \fancyfoot[C]{\zihao{5}\thepage} % 页码位于页脚居中

    % 左右两栏页眉，左为论文题目右为当前章
    % \fancyhead[L]{\zihao{-5}\@ctitle}
    % \fancyhead[R]{\zihao{-5}\leftmark}

    % 居中式页眉，可以选择为论文题目或当前章
    \fancyhead[C]{\zihao{5}\@ctitle}
    %\fancyhead[C]{\zihao{-5}\leftmark}
}
\pagestyle{plain}



\fancypagestyle{listoffiguretable}{\fancyhead[R]{\zihao{-5}插图与表格目录}}

% 表格与图片标题设定
% https://blog.csdn.net/uncle_gy/article/details/78313861
% https://tex.stackexchange.com/questions/101591/setting-font-size-for-caption-package
\renewcommand{\thefigure}{\thechapter.\arabic{figure}}
\setlength\heavyrulewidth{0.2em}
% F19 图题表题 宋体五号
\DeclareCaptionFormat{sysucaption}{\fontsize{10.5}{10.5}\selectfont#1#2#3}
\captionsetup{format=sysucaption}


% 目录设定，使用tocloft宏包
\setcounter{secnumdepth}{3} % depth of toc, 2
% \setcounter{tocdepth}{1}
% 如果要在目录中显示子章节请换用下面这行(目录中显示到x.y.z章)，如果不用这行默认显示到x.y章。
\setcounter{tocdepth}{2}

% F8 目录标题：3号黑体居中
\renewcommand{\cfttoctitlefont}{\hfill\zihao{3}\heiti}
\renewcommand{\cftlottitlefont}{\hfill\zihao{3}\heiti}
\renewcommand{\cftloftitlefont}{\hfill\zihao{3}\heiti}

% 如果要加粗，放 \bfseries
% 目录中章节标题：小四号宋体
% F9 目录内容：宋体小四号
\renewcommand{\cftchapfont}{\zihao{-4}\songti}
\renewcommand{\cftchappagefont}{\zihao{-4}\songti}

% 目录中其他内容：小四号宋体
\renewcommand{\cftsecfont}{\zihao{-4}\songti}
\renewcommand{\cftsecpagefont}{\zihao{-4}\songti}
\renewcommand{\cftsubsecfont}{\zihao{-4}\songti}
\renewcommand{\cftsubsecpagefont}{\zihao{-4}\songti}
\setlength{\cftsecindent}{0.5em}        % 小节缩进, 对齐章标题空隙

% 插图目录
\renewcommand{\listfigurename}{插图目录}
\renewcommand{\cftfigfont}{\zihao{-4}\songti}
\renewcommand{\cftfigpagefont}{\zihao{-4}\songti}

% 表格目录
\renewcommand{\listtablename}{表格目录}
\renewcommand{\cfttabfont}{\zihao{-4}\songti}
\renewcommand{\cfttabpagefont}{\zihao{-4}\songti}

\renewcommand{\cftaftertoctitle}{\hfill}
\renewcommand{\cftafterlottitle}{\hfill}
\renewcommand{\cftafterloftitle}{\hfill}
\renewcommand{\cftnodots}{\cftdotsep}     % 使用点指示页数

% \addtolength{\cftchapnumwidth}{3\ccwd} % 用来设置目录中章节标题离数字的距离
\newcommand\mybold[1]{\textit{\textbf{#1}}}

\newcommand{\norm}[1]{\left\lVert#1\right\rVert}
\newtheoremstyle{dotless}{3pt}{3pt}{\kaishu}{2em}{\heiti}{}{\ccwd}{}
\theoremstyle{dotless}
\newtheorem{theorem}{{定理}}[chapter]
\newtheorem{proposition}{{命题}}[chapter]
\newtheorem{lemma}{{引理}}[chapter]
\newtheorem{corollary}{{推论}}[chapter]
\newtheorem{definition}{{定义}}[chapter]
\newtheorem{remark}{{注记}}[chapter]
\newtheorem{eg}{例}[chapter]
\newtheorem{assumption}{假设}[chapter]

\renewcommand{\proofname}{{\heiti 证明}}
\renewcommand{\@biblabel}[1]{[#1]\hfill}

\renewenvironment{proof}[1][\proofname]{\par
    \pushQED{\qed}
    \kaishu \topsep6\p@\@plus6\p@\relax
    \trivlist
    \item[\hskip\labelsep
                \itshape
                #1]\ignorespaces
}{
    \popQED\endtrivlist\@endpefalse
}

% 参考文献引用标记格式：右上角，带方括号
\RequirePackage{gbt7714}

% 相关信息宏定义
\newcommand\ctitle[1]{\def\@ctitle{#1}}
\newcommand\eabstracttitlesecond[1]{\def\@eabstracttitlesecond{#1}}
\newcommand\cschool[1]{\def\@cschool{#1}} % 学校名字
\newcommand\cdegree[1]{\def\@cdegree{#1}} % 等级
\newcommand\cauthor[1]{\def\@cauthor{#1}} % 默认中文名为封面作者名字
\newcommand\studentid[1]{\def\@studentid{#1}}
\newcommand\ccollege[1]{\def\@ccollege{#1}}
\newcommand\cmajor[1]{\def\@cmajor{#1}}
\newcommand\cdirection[1]{\def\@cdirection{#1}}
\newcommand\cmentor[1]{\def\@cmentor{#1}}
\newcommand\underlinewidth[1]{\def\@underlinewidth{#1}}
\newlength{\myunderlinewidth}

\renewcommand{\baselinestretch}{1}
\newcommand\makeUndergraduateCover {
    \begin{titlepage}
        \begin{tikzpicture}[remember picture, overlay]
            \node[
                anchor=center, % 将节点的中心对齐到定位点
                inner sep=0pt,
                outer sep=0pt 
            ] at ( 6.6cm, -5.4cm) { % X 坐标为 0.5\paperwidth, Y 坐标保持不变
                \includegraphics[width=11.51cm]{libs/image1.png} 
            };
       \end{tikzpicture}
        \begin{center}
            {\heiti\bfseries\zihao{-2}\;}
            \\\vspace{0.3\baselineskip}
            {\heiti\bfseries\zihao{-0}\@cschool}
            \\\vspace{1.7\baselineskip}
            {\heiti\bfseries\zihao{-0}{研究生}}
            \\\vspace{1.7\baselineskip}
            {\heiti\bfseries\zihao{-0}{学位论文开题报告}} 
            \\\zihao{3}\vspace{1.5\baselineskip}
            {\songti\bfseries\zihao{-2} 题\hspace{0.5\ccwd}目: \CJKunderline{\hspace{0.5\ccwd}\@ctitle\hspace{0.5\ccwd}}}
            \\\vspace{2.2\baselineskip}
            {\fontsize{16}{25.8}\selectfont\songti\bfseries
            \begin{tabular}{l}
                   \makebox[2.7cm]{姓\hspace{2\ccwd}名:\hfill} \underline{\makebox[\myunderlinewidth]{\hfill\@cauthor\hfill}}\\
                %    \vspace{8pt} \\
                   \makebox[2.7cm]{学\hspace{2\ccwd}号:\hfill}
                   \underline{\makebox[\myunderlinewidth]{\hfill\@studentid\hfill}}\\
                %    \vspace{8pt} \\
                    % \makebox[2.7cm]{院\hspace{2\ccwd}系:\hfill}
                    % \underline{\makebox[\myunderlinewidth]{\hfill\@ccollege\hfill}}\\
                    % \vspace{8pt} \\
                    % \vspace{8pt} \\
                    % \makebox[2.7cm]{研究方向:\hfill}
                    % \underline{\makebox[\myunderlinewidth]{\hfill\@cdirection\hfill}}\\
                    % \vspace{8pt} \\
                    \makebox[2.7cm]{导\hspace{2\ccwd}师:\hfill}  \underline{\makebox[\myunderlinewidth]{\hfill\@cmentor\hfill}}\\
                    \makebox[2.7cm]{专\hspace{2\ccwd}业:\hfill}
                    \underline{\makebox[\myunderlinewidth]{\hfill\@cmajor\hfill}}\\
                    \makebox[2.7cm]{\hfill}{\hfill\hfill}\\
                    \underline{\makebox[2.7cm]{导师签名：\hfill}}{\hfill\hfill}
            \end{tabular}
            }
            % \vfill
            % \centering{\zihao{4}\selectfont\lishu
            %     % \ctexset{today=big}         % 汉字数字形式日期
            %     % 中山大学研究生院\\
            %     时间：\today     \\ % 使用最后一次编译的日期, 实现日期的自动化
            % }
        \end{center}
        % \AddToShipoutPictureBG{
        %     \put(0.5\paperwidth - 5.755cm, 15.63cm){
        %         \includegraphics[width=11.51cm]{libs/image1.png} % 居中的图片
        %     }
        % }
        % \AtNextShipoutClear
        
    \end{titlepage}
    \newclearpage
}
\renewcommand{\baselinestretch}{1.5}

\newcommand{\maketableofappendix}{
    % 清除页眉页脚
    \thispagestyle{empty}
    \vspace{-2em}
    \begin{center}
        \zihao{-2}\heiti\bfseries 考核意见
    \end{center}
    {\zihao{-3}{\heiti {题目：}} \@ctitle}\\
    {\zihao{-3}{\heiti {姓名：}} \@cauthor}\\
    {\zihao{-3}{\heiti {导师：}} \@cmentor}\\

    \noindent\includegraphics[width=\columnwidth]{libs/table.pdf}
}



% 摘要

\newcommand\maketableofcontents{

    \pagestyle{plain}
    \pagenumbering{gobble}
    \tableofcontents
    \newclearpage
}
\newcommand\makelistoffiguretable{
    \listoffigures
    \newclearpage
    \listoftables
    % \thispagestyle{listoffiguretable}
    \newclearpage
}

\renewcommand\mainmatter{
    \@mainmattertrue
    \pagenumbering{arabic}
    \ctexset {
        chapter = {
            beforeskip = {0pt},
            afterskip = {\baselineskip},
            format = {\centering},
            nameformat = {\zihao{-2}\heiti\bfseries},
            titleformat = {\zihao{-2}\heiti\bfseries}
        },
        section = {
            beforeskip = {0.5\baselineskip},
            afterskip = {0.5\baselineskip},
            format = {},
            indent = {30pt}, % \zihao{-3} = 15pt
            nameformat = {\zihao{-3}\songti\bfseries},
            titleformat = {\zihao{-3}\songti\bfseries}
        },
        subsection = {
            beforeskip = {0.5\baselineskip},
            afterskip = {0.5\baselineskip},
            format = {},
            indent = {30pt}, % \zihao{4} = 14pt
            nameformat = {\zihao{4}\songti\bfseries},
            titleformat = {\zihao{4}\songti\bfseries}
        },
        subsubsection = {
            beforeskip = {0pt},
            afterskip = {0pt},
            format = {},
            indent = {30pt}, % \zihao{-4} = 12pt
            nameformat = {\zihao{-4}\songti\bfseries},
            titleformat = {\zihao{-4}\songti\bfseries},
            number = {（\arabic{subsubsection}）} % 设置为（1）（2）（3）格式
        }
    }
    \renewcommand{\baselinestretch}{1.5} % 设置行距为1.5倍
    \setlength{\baselineskip}{22pt} % 设置固定行距为22pt
    \zihao{-4}\songti % 设置正文为小四号宋体
    \pagestyle{plain}
}

\renewcommand\backmatter{
    \@mainmatterfalse
    % \fancypagestyle{plain}{ \fancyhead[R]{\zihao{-5} \leftmark} }
    \pagestyle{plain}
}

% 参考文献
% 标题小五号黑体加冒号
% 内容小五号宋体
\newcommand\makereferences{
    \begingroup
    \ctexset {
        chapter = {
            beforeskip = {0pt},
            afterskip = {\baselineskip},
            format = {\centering},
            nameformat = {\zihao{-2}\heiti\bfseries},
            titleformat = {\zihao{-2}\heiti\bfseries}
        },
    }

    % 引用样式
    \setlength{\bibsep}{0em}
    \bibliographystyle{gbt7714-numerical}
    % F15 参考文献内容 宋体五号
    {\zihao{5}\rmfamily\songti\bibliography{bibtex-style/Reference}}    % 引用文献列表
    \endgroup
}

% 附录样式
\renewcommand\appendix{\par
    \@mainmattertrue
    % \fancypagestyle{plain}{
    %     \fancyhead[R]{\zihao{-5} 附录\thechapter \leftmark}
    % }
    \pagestyle{plain}
    \setcounter{chapter}{0}
    \setcounter{section}{0}
    \gdef\@chapapp{\appendixname}
    \gdef\thechapter{\@Alph\c@chapter}
    \gdef\CTEX@prechapter{\CTEX@preappendix}
    \gdef\CTEX@thechapter{\CTEX@appendix@number}
    \gdef\CTEX@postchapter{}
    % \ctexset {
    %     chapter = {
    %       % F16 附录标题 黑体三号居中
    %       format = {\centering},
    %       nameformat = {\zihao{3}\heiti},
    %       titleformat = {\zihao{3}\heiti},
    %      },
    %     section = {
    %       format = {},
    %       nameformat = {\zihao{4}\heiti},
    %       titleformat = {\zihao{4}\heiti}
    %      },
    %     subsection = {
    %             format = {},
    %             indent = {24pt},
    %             nameformat = {\zihao{-4}\songti\bfseries},
    %             titleformat = {\zihao{-4}\songti\bfseries}
    %         }
    % }
    \ctexset {
        chapter = {
            beforeskip = {0pt},
            afterskip = {\baselineskip},
            format = {\centering},
            nameformat = {\zihao{-2}\heiti\bfseries},
            titleformat = {\zihao{-2}\heiti\bfseries}
        },
        section = {
            beforeskip = {0.5\baselineskip},
            afterskip = {0.5\baselineskip},
            format = {},
            indent = {30pt}, % \zihao{-3} = 15pt
            nameformat = {\zihao{-3}\songti\bfseries},
            titleformat = {\zihao{-3}\songti\bfseries}
        },
        subsection = {
            beforeskip = {0.5\baselineskip},
            afterskip = {0.5\baselineskip},
            format = {},
            indent = {30pt}, % \zihao{4} = 14pt
            nameformat = {\zihao{4}\songti\bfseries},
            titleformat = {\zihao{4}\songti\bfseries}
        },
        subsubsection = {
            beforeskip = {0pt},
            afterskip = {0pt},
            format = {},
            indent = {30pt}, % \zihao{-4} = 12pt
            nameformat = {\zihao{-4}\songti\bfseries},
            titleformat = {\zihao{-4}\songti\bfseries},
            number = {（\arabic{subsubsection}）} % 设置为（1）（2）（3）格式
        }
    }
    \renewcommand{\baselinestretch}{1.5} % 设置行距为1.5倍
    \setlength{\baselineskip}{22pt} % 设置固定行距为22pt
    \zihao{-4}\songti % 设置正文为小四号宋体
    \pagestyle{plain}
}


% 配置超链接。
% hyperref一般要求是导言区最后一个宏包，才能正常工作
% 若把该宏包提前，则会引起附录列表跳转到第一章的问题
% TODO: 重构宏包引入顺序以让代码语义聚集
\RequirePackage[hidelinks, hyperfootnotes=true]{hyperref}
\RequirePackage{footnotebackref}
\RequirePackage{pdfpages}
\def\equationautorefname{式}%
\def\footnoteautorefname{脚注}%
\def\itemautorefname{项}%
\def\figureautorefname{图}%
\def\tableautorefname{表}%
\def\partautorefname{篇}%
\def\appendixautorefname{附录}%
\def\chapterautorefname{章}%
\def\sectionautorefname{节}%
\def\subsectionautorefname{小节}%
\def\subsubsectionautorefname{小小节}%
\def\paragraphautorefname{段落}%
\def\subparagraphautorefname{子段落}%
\def\FancyVerbLineautorefname{行}%
\def\theoremautorefname{定理}%
% 暂时不能处理引理，推论


\renewcommand{\@fnsymbol}[1]{
    \ifcase#1\or \text{①}\or \text{②}\or \text{③}\or    \text{④}\or \text{⑤}\or \text{⑥}\or \text{⑦}\or \text{⑧} \or \text{⑨} \or \text{⑩}
    \else
        \@ctrerr
    \fi
}
\renewcommand{\thefootnote}{\fnsymbol{footnote}}
