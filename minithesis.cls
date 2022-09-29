% minithesis
%
% modified by Rupert Tombs 2022
%
% Based on:
%% hepthesis
%%   LaTeX class for writing PhD theses, particularly those for
%%   high energy physics (HEP)
%% Author: Andy Buckley <andy@insectnation.org>
%%
%% This material is subject to the LaTeX Project Public License.
%% See http://www.ctan.org/tex-archive/help/Catalogue/licenses.lppl.html
%% or the details of that license.
%%
%% Please let me know if you use hepthesis and what you think of it.
%% I'll try to implement any suggested options or geometry changes,
%% provided I think they're a good idea!

\def\fileversion{0.0.0}
\def\filedate{2022/09/29}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{minithesis}[\filedate\space a thesis template (v\fileversion)]


% option parsing

\def\@empty{}
\def\@oneside{}
\def\@bindmargins{yes}

% one-sided or two-sided (bound copies may have to be single-sided)
\DeclareOption{oneside}{%
    \def\@oneside{yes}
    \PassOptionsToClass{oneside}{scrbook}
}


\DeclareOption{twoside}{%
    \def\@oneside{}
    \PassOptionsToClass{twoside}{scrbook}
}

% pad inner margins for binding
\DeclareOption{bind}{%
    \def\@bindmargins{yes}
}

\DeclareOption{nobind}{%
    \def\@bindmargins{}
}

% use a standard font size
\PassOptionsToClass{12pt}{scrbook}
% no full stops after titles
\PassOptionsToClass{numbers=noenddot}{scrbook}
% add items to table of contnets
\PassOptionsToClass{bibliography=totoc}{scrbook}
\PassOptionsToClass{listof=totoc}{scrbook}

% process the options (no package requirement allowed above here)
\ProcessOptions


% base class

\LoadClass[chapterprefix]{scrbook}


% packages

% useful tools for building this class
\RequirePackage{etoolbox}
% need to be able to locally change the text width.
\RequirePackage{changepage}
% funky headers
\RequirePackage{fancyhdr}
% ability to specify a hook for after a page is completed
\RequirePackage{afterpage}
% text spacing
\RequirePackage{setspace}
% make maths in titles go automatically bold
\AtEndOfClass{%
    \g@addto@macro\bfseries{\boldmath}
}


% styling

% use the \title and \author arguments to build the front page etc.
\renewcommand*\title[1]{\gdef\@title{#1}\global\let\thetitle\@title}%
\renewcommand*\author[1]{\gdef\@author{#1}\global\let\theauthor\@author}%
% serif titles
\addtokomafont{sectioning}{\rmfamily\bfseries}


% length definitions

% tweak the initial indent in paras
\setlength{\parindent}{0.6cm}

% tweak the intra-para gap size
\setlength{\parskip}{0.3cm}
\setlength{\topmargin}{0in}
\setlength{\textheight}{9in}
\setlength{\footskip}{0.5in}
\setlength{\textwidth}{6.2in}

% increase inner margins for binding
\newlength{\@bindextramargin}
\AtEndOfClass{%
    \ifx\@bindmargins\@empty%
        \setlength{\@bindextramargin}{0.0in}
    \else%
        \setlength{\@bindextramargin}{0.2in}
    \fi
    \setlength{\oddsidemargin}{\@bindextramargin}
    \setlength{\evensidemargin}{-\@bindextramargin}
}

% redefine bits of document shape
\renewcommand{\topfraction}{0.95}%
\renewcommand{\bottomfraction}{0.95}%
\renewcommand{\textfraction}{0.05}%
\renewcommand{\arraystretch}{1.25}%

% reset rule widths and the header width
\renewcommand{\headwidth}{\textwidth}%
\renewcommand{\headrulewidth}{0pt}%
\renewcommand{\footrulewidth}{0pt}%
\addtolength{\headheight}{2.5pt}%
\addtolength{\headsep}{20pt}%


% headers and footers

% no header or footer on the title page
\AtBeginDocument{\thispagestyle{plain}}

% use fancy headers and footers
\pagestyle{fancy}

% normal headers and footers (headers are all like RH pages for oneside)
\ifx\@oneside\@empty%
    \fancyhead[RO,LE]{\thepage}%
    \fancyhead[LO,RE]{\leftmark}%
\else%
    \fancyhead[RO,R]{\thepage}%
    \fancyhead[LO,L]{\leftmark}%
\fi%
\fancyfoot{}%
% lower case header content
\renewcommand{\chaptermark}[1]{%
    \markboth{#1}{}%
}

% headers and footers for plain (blank) pages
\fancypagestyle{plain}{%
    \fancyhf{}%
    \fancyfoot[C]{\thepage}%
}

% treat forced blank pages in the same way as chapter title pages
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else%
            \hbox{}%
            \thispagestyle{plain}%
            \newpage%
            \if@twocolumn\hbox{}\newpage\fi\fi\fi}%


% public environments and commands

% frontmatter
\renewenvironment{frontmatter}{%
    \pagenumbering{roman}
    \newcounter{iterlist}%
    \begin{onehalfspacing}%
        }{%
    \end{onehalfspacing}%
    \ignorespacesafterend%
}

% mainmatter
\renewenvironment{mainmatter}{%
    \if@twoside\clearpage\fi%
    \afterpage{\pagenumbering{arabic}}%
    \begin{onehalfspacing}%
        }{%
    \end{onehalfspacing}%
    \ignorespacesafterend%
}

% appendices
\newenvironment{appendices}{%
    \begin{onehalfspacing}%
        \appendix%
        }{%
    \end{onehalfspacing}%
    \ignorespacesafterend%
}

% backmatter
\renewenvironment{backmatter}{%
    \begin{onehalfspacing}%
        \appendix%
        }{%
    \end{onehalfspacing}%
    \ignorespacesafterend%
}

% acknowledgements
\newenvironment{acknowledgements}{%
    \cleardoublepage%
    \phantomsection
    \addcontentsline{toc}{chapter}{Acknowledgements}
    \vspace*{1.5cm}%
    \begin{center}%
    \begingroup
    {\LARGE{\textbf{Acknowledgements}}}%
    \endgroup
    \end{center}%
    \vspace*{1cm}%
}{%
    \ignorespacesafterend%
}

% preface
\newenvironment{preface}{%
    \cleardoublepage
    \phantomsection
    \addcontentsline{toc}{chapter}{Preface}
    \vspace*{1.5cm}%
    \begin{center}%
    \begingroup
    {\LARGE{\textbf{Preface}}}%
    \endgroup
    \end{center}%
}{%
    \ignorespacesafterend %
}

% declaration
\newenvironment{declaration}{%
    \cleardoublepage%
    \adjustwidth{1cm}{1cm}%
    \vspace*{1.5cm}%
    \begin{center}%
    \begingroup
    {\LARGE\textbf{Declaration}}%
    \endgroup
    \end{center}%
    \vspace*{1cm}%
}{%
    \endadjustwidth%
    \ignorespacesafterend%
}

% abstract
\newenvironment{abstract}[1][Abstract]{%
    \adjustwidth{1.5cm}{1.5cm}%
    \cleardoublepage%
    \phantomsection
    \addcontentsline{toc}{chapter}{Abstract}
    \vspace*{1.5cm}%
    \begin{center}%
    \begingroup
    {\LARGE\textbf{#1}}%
    \endgroup
    \end{center}%
    \vspace*{1cm}%
}{%
    \endadjustwidth%
    \ignorespacesafterend%
}

% titlepage
\DeclareRobustCommand{\titlepage}[2][]{%
    \thispagestyle{empty}%
    \begingroup%
    \begin{center}%
        \vspace*{2cm}%
        \begin{doublespace}%
            {\Huge\textbf{\thetitle}}\\%
        \end{doublespace}%
        \vspace*{3cm}%
        {\Large{{\theauthor} \\ {#1}}}\\%
        \vspace*{8cm}%
        {#2}%
    \end{center}%
    \endgroup%
}
\renewcommand{\maketitle}[1]{\titlepage{}}

% dedication
\DeclareRobustCommand{\dedication}[1]{%
    \cleardoublepage%
    \vspace*{\stretch{2}}%
    \thispagestyle{plain}%
    \pagestyle{plain}%
    \begin{center}%
        \begin{varwidth}{\textwidth}%
            \noindent\textsl{\enquote{#1}}%
        \end{varwidth}%
    \end{center}%
    \vspace*{\stretch{4}}%
    \pagestyle{plain}%
}
