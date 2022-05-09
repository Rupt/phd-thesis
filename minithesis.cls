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

\def\fileversion{0.0.1}
\def\filedate{2022/05/09}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{minithesis}[\filedate\space a thesis template (v\fileversion)]



% option parsing


\def\@empty{}
\def\@yes{yes}

\def\@oneside{}
\def\@bindmargins{yes}


% part-wise spacing commands and definitions
\def\@frontmatterspacing{onehalfspacing}
\def\@mainmatterspacing{onehalfspacing}
\def\@appendixspacing{onehalfspacing}
\def\@backmatterspacing{onehalfspacing}


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

% process the options (no package requirement allowed above here)
\ProcessOptions



% base class and packages


% base class
\LoadClass[chapterprefix]{scrbook}

% useful tools for building this class
\RequirePackage{etoolbox}

% need to be able to locally change the text width.
\RequirePackage{changepage}

% used to center the variable width page quote (must be version >= 0.9a)
\RequirePackage{varwidth}[2003/03/10]

% use the \title and \author arguments to build the front page etc.
\renewcommand*\title[1]{\gdef\@title{#1}\global\let\thetitle\@title}%
\renewcommand*\author[1]{\gdef\@author{#1}\global\let\theauthor\@author}%

% serif titles
\addtokomafont{sectioning}{\rmfamily\bfseries}

% funky headers
\RequirePackage{fancyhdr}

% make sure bibliography (but not ToC) appears in the ToC
\RequirePackage[nottoc]{tocbibind}

% ability to specify a hook for after a page is completed
\RequirePackage{afterpage}

% misc tweaks
\AtEndOfClass{%
    % make maths in titles go automatically bold
	\g@addto@macro\bfseries{\boldmath}
}



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
\renewcommand{\headrulewidth}{0.5pt}%
\renewcommand{\footrulewidth}{0pt}%
\addtolength{\headheight}{2.5pt}%
\addtolength{\headsep}{20pt}%

% extra margins for various sections
\newlength{\@mainmatterextramargin}%
\setlength{\@mainmatterextramargin}{0cm}%
\newlength{\@backmatterextramargin}%
\setlength{\@backmatterextramargin}{0cm}%
\newlength{\@frontmatterextramargin}%
\setlength{\@frontmatterextramargin}{0cm}%
\newlength{\@appendixextramargin}%
\setlength{\@appendixextramargin}{0cm}%
\newlength{\@abstractextramargin}%
\setlength{\@abstractextramargin}{1.5cm}%
\newlength{\@declarationextramargin}%
\setlength{\@declarationextramargin}{1cm}%
\newlength{\@acknowledgementsextramargin}%
\setlength{\@acknowledgementsextramargin}{0cm}%
\newlength{\@prefaceextramargin}%
\setlength{\@prefaceextramargin}{0cm}%
\newlength{\@pagequoteextramargin}%
\setlength{\@pagequoteextramargin}{2cm}%

% top vertical spacing in the front matter
\newlength{\@frontmattertopskip}%
\newlength{\@frontmattertitletopskip}%
\newlength{\frontmattertitleskip}%
\addtolength{\frontmattertitleskip}{2cm}%
\addtolength{\@frontmattertitletopskip}{0cm}%
\setlength{\@frontmattertopskip}{\frontmattertitleskip}%
\addtolength{\@frontmattertopskip}{\@frontmattertitletopskip}%



% headers and footers


% no header or footer on the title page
\AtBeginDocument{\thispagestyle{plain}}
% use funky headers and footers
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


% hide horizontal lines at the header and footer
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}


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


% internal environments and commands


\AtEndPreamble{%
	\RequirePackage[autostyle]{csquotes}[2007/03/25]
	% provide dumb quoting commands in case the csquotes package hasn't been used.
	\providecommand{\enquote}[1]{``#1''}%
	\providecommand{\foreignquote}[1]{``#1''}%

	% provide mixed-case versions of headings
	\@ifpackageloaded{babel}{\addto\captionsenglish{%
			\renewcommand*{\contentsname}{Contents}
			\renewcommand*{\bibname}{Bibliography}
			\renewcommand*{\listfigurename}{List of figures}
			\renewcommand*{\listtablename}{List of tables}
		}}{%
		\renewcommand*{\contentsname}{Contents}
		\renewcommand*{\bibname}{Bibliography}
		\renewcommand*{\listfigurename}{List of figures}
		\renewcommand*{\listtablename}{List of tables}
	}
}



% public environments and commands


% frontmatter
\renewenvironment{frontmatter}{%
	\setcounter{tocdepth}{2}% show down to subsections in contents
	\setcounter{secnumdepth}{2}% number down to subsections
	\newcounter{iterlist}%
	\adjustwidth{\@frontmatterextramargin}{\@frontmatterextramargin}%
	\begin{\@frontmatterspacing}%
		}{%
	\end{\@frontmatterspacing}%
	\endadjustwidth%
	\ignorespacesafterend%
}


% mainmatter
\renewenvironment{mainmatter}{%
	\if@twoside\clearpage\fi%
	\@mainmattertrue%
	\afterpage{\pagenumbering{arabic}}%
	\adjustwidth{\@mainmatterextramargin}{\@mainmatterextramargin}%
	\begin{\@mainmatterspacing}%
		}{%
	\end{\@mainmatterspacing}%
	\endadjustwidth%
	\ignorespacesafterend%
}


% appendices
\newenvironment{appendices}{%
	\adjustwidth{\@appendixextramargin}{\@appendixextramargin}%
	\begin{\@appendixspacing}%
		\appendix%
		}{%
	\end{\@appendixspacing}%
	\endadjustwidth%
	\ignorespacesafterend%
}


% backmatter
\renewenvironment{backmatter}{%
	\adjustwidth{\@backmatterextramargin}{\@backmatterextramargin}%
	\begin{\@backmatterspacing}%
		\appendix%
		}{%
	\end{\@backmatterspacing}%
	\endadjustwidth%
	\ignorespacesafterend%
}


% acknowledgements
\newenvironment{acknowledgements}{%
	\cleardoublepage%
	\adjustwidth{\@acknowledgementsextramargin}{\@acknowledgementsextramargin}%
	\vspace*{\@frontmattertopskip}%
	\begin{center}%
	\begingroup
	{\LARGE{\textbf{Acknowledgements}}}%
	\endgroup
	\end{center}%
	\vspace*{1cm}%
}{%
	\endadjustwidth%
	\ignorespacesafterend%
}


% preface
\newenvironment{preface}{%
	\cleardoublepage%
	\adjustwidth{\@prefaceextramargin}{\@prefaceextramargin}%
	\vspace*{\@frontmattertopskip}%
	\begin{center}%
	\begingroup
	{\LARGE{\textbf{Preface}}}%
	\endgroup
	\end{center}%
	\vspace*{1cm}%
}{%
	\endadjustwidth%
	\ignorespacesafterend %
}


% declaration
\newenvironment{declaration}{%
	\cleardoublepage%
	\adjustwidth{\@declarationextramargin}{\@declarationextramargin}%
	\vspace*{\@frontmattertopskip}%
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
	\adjustwidth{\@abstractextramargin}{\@abstractextramargin}%
	\cleardoublepage%
	\vspace*{\@frontmattertopskip}%
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
		\vspace*{\frontmattertitleskip}%
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


% pagequote
\DeclareRobustCommand{\pagequote}[3][same]{%
	\cleardoublepage%
	\vspace*{\stretch{2}}%
	\thispagestyle{empty}%
	\begin{center}%
		\begin{varwidth}{\textwidth}%
			\def\@samelang{same}%
			\def\@reqlang{#1}%
			\ifx\@samelang\@reqlang%
				\noindent\textsl{\enquote{\hspace{0.1ex}#2}}%
			\else%
				\noindent\textsl{\foreignquote{\@reqlang}{\hspace{0.1ex}#2}}%
			\fi%
			\newline%
			\setlength{\parindent}{\@oldparindent}
			\indent --- {#3}%
		\end{varwidth}%
	\end{center}%
	\vspace*{\stretch{4}}%
	\if@twoside\clearpage\fi%
	\thispagestyle{plain}%
}


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


% chapterquote
\DeclareRobustCommand{\chapterquote}[3][same]{%
	\def\@samelang{same}%
	\def\@reqlang{#1}%
	\begin{adjustwidth}{}{3cm}%
		\ifx\@samelang\@reqlang%
			\noindent\emph{\enquote{#2}}%
		\else%
			\noindent\emph{\foreignquote{\@reqlang}{#2}}%
		\fi%
		\newline%
		\indent --- #3%
	\end{adjustwidth}%
	\vspace{1cm}%
}
