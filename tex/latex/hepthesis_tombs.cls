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
%%
%% Modified by Rupert Tombs 2022


%% ========================================================================
%% Admin
%% ========================================================================
\def\fileversion{1.5.1}
\def\filedate{2017/09/20}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{hepthesis_tombs}[\filedate\space HEP thesis class by Andy Buckley (v\fileversion)]

%% ========================================================================
%% Option parsing
%% ========================================================================
%% Conditional packages (can be disabled)
\def\@empty{}
\def\@yes{yes}
\def\@requirebooktabs{yes}
\def\@requiremakeidx{}
\def\@requiretitling{}
\def\@requiredraft{}
\def\@useAFour{yes}
\def\@requireAFourWide{}
\def\@useTwelvePt{yes}
\def\@oneside{}
\def\@sftitles{}
\def\@bindmargins{yes}
\def\@hidefrontmatter{}
\def\@hidebackmatter{}

%% Part-wise spacing commands and definitions
\def\@frontmatterspacing{onehalfspacing}
\def\@mainmatterspacing{onehalfspacing}
\def\@appendixspacing{onehalfspacing}
\def\@backmatterspacing{onehalfspacing}

%% One-sided or two-sided (bound copies may have to be single-sided)
\DeclareOption{oneside}{%
  \def\@oneside{yes}
  \PassOptionsToClass{oneside}{scrbook}}
\DeclareOption{twoside}{%
  \def\@oneside{}
  \PassOptionsToClass{twoside}{scrbook}}

%% Sans serif titles?
\DeclareOption{sftitles}{%
  \def\@sftitles{yes}}
\DeclareOption{rmtitles}{%
  \def\@sftitles{}}

%% Pad inner margins for binding
\DeclareOption{bind}{%
  \def\@bindmargins{yes}}
\DeclareOption{nobind}{%
  \def\@bindmargins{}}
%% Use binding margins if output is not PDF
\DeclareOption{bindnopdf}{
  \ifx\pdfoutput\undefined%
  \def\@bindmargins{yes}%
  \else%
  \def\@bindmargins{}%
  \fi%
}

%% Change footnote markers to alphabetic
\DeclareOption{alphafoot}{%
  \DeclareRobustCommand{\thefootnote}{\alph{footnote}}%
}

%% Draft mode with line numbers and draft over-print
\DeclareOption{draft}{%
  \def\@requiredraft{yes}
  \AtEndOfPackage{%
    \let\@oldermainmatter\mainmatter%
    \DeclareRobustCommand{\mainmatter}{\@oldermainmatter\linenumbers}%
  }
}

%% Disable the frontmatter
\DeclareOption{hidefront}{%
  \def\@hidefrontmatter{yes}
}
\DeclareOption{hideback}{%
  \def\@hidebackmatter{yes}
}
\DeclareOption{hidefrontback}{%
  \def\@hidefrontmatter{yes}
  \def\@hidebackmatter{yes}
}

%% Don't break enumerations (etc.) across pages in
%% an ugly manner
\clubpenalty = 10000
\widowpenalty = 10000

%% Use nice-looking tables
\DeclareOption{booktabs}{%
  \def\@requirebooktabs{yes}}
\DeclareOption{nobooktabs}{%
  \def\@requirebooktabs{}}

%% control over titles?
\DeclareOption{titling}{%
  \def\@requiretitling{yes}
}

%% Particle physics options
\DeclareOption{hep}{%
  \def\@requirehep{yes}
}

%% Paper size (wide A4 is default)
\DeclareOption{a4paper}{%
  \def\@useAFour{yes}%
  \def\@requireAFourWide{yes}%
}
\DeclareOption{a4narrow}{%
  \def\@useAFour{yes}%
  \def\@requireAFourWide{}%
}

%% Handle the A4 default paper size
\ifx\@useAFour\@empty\else%
  \PassOptionsToClass{a4paper}{scrbook}%
\fi


%% Font size (12pt is default)
\DeclareOption{12pt}{%
  \def\@useTwelvePt{yes}%
}
%% Handle the 12pt default font size
\ifx\@useTwelvePt\@empty\else%
  \PassOptionsToClass{12pt}{scrbook}%
\fi

%% Process the options (no package requirement allowed above here)
\ProcessOptions


%% ========================================================================
%% Base class and packages
%% ========================================================================

%% Base class
\LoadClass[chapterprefix]{scrbook}

%% Use wide format if using A4 paper
\ifx\@requireAFourWide\@empty\else\RequirePackage{a4wide}\fi

%% Useful tools
\RequirePackage{etoolbox}

%% Need to be able to locally change the text width.
\RequirePackage{changepage}

%% Used to center the variable width page quote (must be version >= 0.9a)
\RequirePackage{varwidth}[2003/03/10]

%% Use the \title and \author arguments to build the front page etc.
\ifx\@requiretitling\@empty%
%% Re-define \title and \author to store their args in \thetitle, \theauthor variables
  \renewcommand*\title[1]{\gdef\@title{#1}\global\let\thetitle\@title}%
  \renewcommand*\author[1]{\gdef\@author{#1}\global\let\theauthor\@author}%
\else%
  \RequirePackage{titling}%
\fi

%% Serif titles
\ifx\@sftitles\@empty
  \addtokomafont{sectioning}{\rmfamily\bfseries}
\fi


%% The right way to do custom spacing
% \RequirePackage{setspace}
%% \singlespacing, \onehalfspacing, \doublespacing
%% \begin{spacing}{2.5} ...

%% Funky headers
\RequirePackage{fancyhdr}

%% Make sure bibliography (but not ToC) appears in the ToC
\RequirePackage[nottoc]{tocbibind}

%% Special comments for block enabling/disabling
\RequirePackage{comment}

%% Rotated figures (used to define sidewaysfigure)
\RequirePackage{rotating}

%% Ability to specify a hook for after a page is completed
\RequirePackage{afterpage}

%% Misc tweaks
\AtEndOfClass{%
  %% Make maths in titles go automatically bold
  \g@addto@macro\bfseries{\boldmath}
  %% Declare a bold version of the typewriter font
  \DeclareFontShape{OT1}{cmtt}{bx}{n}{<5><6><7><8><9><10><10.95><12><14.4><17.28><20.74><24.88>cmttb10}{}
}


%% ========================================================================
%% Length definitions
%% ========================================================================

\setlength{\parindent}{0.6cm}          % tweak the initial indent in paras
\setlength{\parskip}{0.3cm}            % tweak the intra-para gap size
\setlength{\topmargin}{0in}
\setlength{\textheight}{9in}
\setlength{\footskip}{0.5in}
\setlength{\textwidth}{6.2in}
%% Increase inner margins for binding
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

%% Redefine bits of document shape
\renewcommand{\topfraction}{0.95}%
\renewcommand{\bottomfraction}{0.95}%
\renewcommand{\textfraction}{0.05}%
\renewcommand{\arraystretch}{1.25}%

%% Reset rule widths and the header width
\renewcommand{\headwidth}{\textwidth}%
\renewcommand{\headrulewidth}{0.5pt}%
\renewcommand{\footrulewidth}{0pt}%
\addtolength{\headheight}{2.5pt}%
\addtolength{\headsep}{20pt}%

%% Extra margins for various sections
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

%% Top vertical spacing in the front matter
\newlength{\@frontmattertopskip}%
\newlength{\@frontmattertitletopskip}%
\newlength{\frontmattertitleskip}%
\addtolength{\frontmattertitleskip}{2cm}%
\addtolength{\@frontmattertitletopskip}{0cm}%
\setlength{\@frontmattertopskip}{\frontmattertitleskip}%
\addtolength{\@frontmattertopskip}{\@frontmattertitletopskip}%

%% Figure widths
\newlength{\smallfigwidth}
\newlength{\mediumfigwidth}
\newlength{\largefigwidth}
\newlength{\hugefigwidth}
\setlength{\smallfigwidth}{0.45\textwidth}
\setlength{\mediumfigwidth}{0.6\textwidth}
\setlength{\largefigwidth}{0.75\textwidth}
\setlength{\hugefigwidth}{0.9\textwidth}

%% Figure width aliases
\newlength{\littlefigwidth}
\newlength{\bigfigwidth}
\setlength{\littlefigwidth}{\smallfigwidth}
\setlength{\bigfigwidth}{\largefigwidth}


%% ========================================================================
%% Headers and footers
%% ========================================================================
%% No header or footer on the title page
\AtBeginDocument{\thispagestyle{plain}}
%% Use funky headers and footers
\pagestyle{fancy}


%% Normal headers and footers (headers are all like RH pages for oneside)
\ifx\@oneside\@empty%
  \fancyhead[RO,LE]{\bfseries\thepage}%
  \fancyhead[LO,RE]{\bfseries\leftmark}%
\else%
  \fancyhead[RO,R]{\bfseries\thepage}%
  \fancyhead[LO,L]{\bfseries\leftmark}%
\fi%
\fancyfoot{}%
%% Lower case header content
\renewcommand{\chaptermark}[1]{%
  \markboth{#1}{}%
}


%% Headers and footers for plain (blank) pages
\fancypagestyle{plain}{%
  \fancyhf{}%
  %\fancyhead[RO,LE]{\bfseries \thepage}%
  \fancyfoot[C]{\bfseries \thepage}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}%
}


%% Treat forced blank pages in the same way as chapter title pages
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else%
  \hbox{}%
  %\thispagestyle{empty}%
  \thispagestyle{plain}%
  \newpage%
  \if@twocolumn\hbox{}\newpage\fi\fi\fi}%

%% Commenting out front and back matter
\ifx\@hidefrontmatter\@yes\AtBeginDocument{\excludecomment{frontmatter}}\fi
\ifx\@hidebackmatter\@yes\AtBeginDocument{\excludecomment{backmatter}}\fi


%% ========================================================================
%% Internal environments and commands
%% ========================================================================

\AtEndPreamble{%
  \RequirePackage[autostyle]{csquotes}[2007/03/25]
  %% Provide dumb quoting commands in case the csquotes package hasn't been used.
  \providecommand{\enquote}[1]{``#1''}%
  \providecommand{\foreignquote}[1]{``#1''}%

  %% Provide mixed-case versions of the Table of contents,
  %% List of tables, List of figures, Bibliography etc. header names
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


%% ========================================================================
%% Public environments and commands
%% ========================================================================


%% An environment for the rubbish at the front of a typical thesis
\let\@oldfrontmatter\frontmatter
\specialcomment{frontmatter}{%
  \setcounter{tocdepth}{2}% show down to subsections in contents
  \setcounter{secnumdepth}{2}% number down to subsections
  \newcounter{iterlist}%
  \@oldfrontmatter%
  \adjustwidth{\@frontmatterextramargin}{\@frontmatterextramargin}%
  \begin{\@frontmatterspacing}%
}{%
  \end{\@frontmatterspacing}%
  \endadjustwidth%
  \ignorespacesafterend%
}


%% Environment for the thesis main body
\let\@oldmainmatter\mainmatter
\specialcomment{mainmatter}{%
  %\@oldmainmatter%
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


%% Environment for appendices
\specialcomment{appendices}{%
  \adjustwidth{\@appendixextramargin}{\@appendixextramargin}%
  \begin{\@appendixspacing}%
  \appendix%
}{%
  \end{\@appendixspacing}%
  \endadjustwidth%
  \ignorespacesafterend%
}


%% Environment for all the junk at the end of the thesis
\let\@oldbackmatter\backmatter
\specialcomment{backmatter}{%
  %\thispagestyle{plain}%
  %pagestyle{plain}%
  %\@oldbackmatter%
  \adjustwidth{\@backmatterextramargin}{\@backmatterextramargin}%
  \begin{\@backmatterspacing}%
  \appendix%
}{%
  \end{\@backmatterspacing}%
  \endadjustwidth%
  \ignorespacesafterend%
}


%% Environment for acknowledgements page in frontmatter
\newenvironment{acknowledgements}{%
  \cleardoublepage%
  \adjustwidth{\@acknowledgementsextramargin}{\@acknowledgementsextramargin}%
  \vspace*{\@frontmattertopskip}%
  \begin{center}%
    \begingroup
    \ifx\@sftitles\@empty\else\sffamily\fi
    {\LARGE{\textbf{Acknowledgements}}}%
    \endgroup
  \end{center}%
  \vspace*{1cm}%
}{%
  \endadjustwidth%
  \ignorespacesafterend%
}


%% Environment for preface page in frontmatter
\newenvironment{preface}{%
  \cleardoublepage%
  \adjustwidth{\@prefaceextramargin}{\@prefaceextramargin}%
  \vspace*{\@frontmattertopskip}%
  \begin{center}%
    \begingroup
    \ifx\@sftitles\@empty\else\sffamily\fi
    {\LARGE{\textbf{Preface}}}%
    \endgroup
  \end{center}%
  \vspace*{1cm}%
}{%
  \endadjustwidth%
  \ignorespacesafterend %
}


%% Environment for declaration rubrik page in frontmatter
%% (flushright doesn't work in this macro for some reason,
%% so you'll have to do that bit yourself like in the
%% example file)
\newenvironment{declaration}{%
  \cleardoublepage%
  \adjustwidth{\@declarationextramargin}{\@declarationextramargin}%
  \vspace*{\@frontmattertopskip}%
  \begin{center}%
    \begingroup
    \ifx\@sftitles\@empty\else\sffamily\fi
    {\LARGE\textbf{Declaration}}%
    \endgroup
  \end{center}%
  \vspace*{1cm}%
}{%
  \endadjustwidth%
  \ignorespacesafterend%
}


%% Environment for thesis abstract in frontmatter
%% (argument is the thesis title)
\newenvironment{abstract}[1][Abstract]{%
  \adjustwidth{\@abstractextramargin}{\@abstractextramargin}%
  \cleardoublepage%
  \vspace*{\@frontmattertopskip}%
  \begin{center}%
    \begingroup
    \ifx\@sftitles\@empty\else\sffamily\fi
    {\LARGE\textbf{#1}}%
    \endgroup
  \end{center}%
  \vspace*{1cm}%
}{%
  \endadjustwidth%
  \ignorespacesafterend%
}


%% Makes a thesis title page
\let\@oldtitlepage\titlepage
\let\@oldendtitlepage\endtitlepage
\DeclareRobustCommand{\titlepage}[2][]{%
  %\@oldtitlepage%
  \thispagestyle{empty}%
  \begingroup%
  \ifx\@sftitles\@empty\else\sffamily\fi%
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


%% A quote on its own page
\newlength{\@oldparindent}
\setlength{\@oldparindent}{\parindent}
\DeclareRobustCommand{\pagequote}[3][same]{%
  \cleardoublepage%
  \vspace*{\stretch{2}}%
  \thispagestyle{empty}%
  % \thispagestyle{plain}%
  % \pagestyle{plain}%
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

%% A quote on its own page
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


%% Environment for colophon in backmatter
% TODO remove
\newenvironment{colophon}{%
  \chapter*{Colophon}%
  \@mkboth{\MakeUppercase{Colophon}}{\MakeUppercase{Colophon}}%
}{%
  \ignorespacesafterend %
}


%% Typesets a chapter quote
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

%% Typesets the first para of a chapter slightly differently
%% (I don't use it, so maybe it needs some work)
\newenvironment{chapterintro}[1][blah]{%
  %\begingroup
  \def\thearg{#1}%
  \def\sans{sf}%
  \def\italic{it}%
  \def\sansit{sfit}%
  \ifx\thearg\sans%
    \sffamily%
  \else%
  \ifx\thearg\italic%
    \itshape%
  \else%
  \ifx\thearg\sansit%
    \sffamily%
    \itshape%
  \fi\fi\fi%
}{%
  \ignorespacesafterend%
}
