% vim: ft=tex
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{beeper}[2020/07/21]

\DeclareOption{handout}{\PassOptionsToClass{\CurrentOption}{beamer}} 
\ProcessOptions\relax
\LoadClass{beamer}

% Define colors
\definecolor{beeperorange}{RGB}{255, 155, 113}
\definecolor{beeperlightpink}{RGB}{219, 72, 243}
\definecolor{beeperpink}{RGB}{181, 71, 233}
\definecolor{beeperblue}{RGB}{73, 88, 245}

\usetheme[progressbar=frametitle,
          block=fill]{metropolis}
% \setbeamercolor{normal text}{fg=beeperblue}
% \setbeamercolor{altered text}{fg=red}
% \setbeamercolor{example text}{fg=red}
\setbeamercolor{palette primary}{bg=beeperblue}
\setbeamercolor{progress bar}{fg=beeperlightpink}
\setbeamercolor{title separator}{fg=beeperlightpink}

\RequirePackage{pgfpages}
\setbeamerfont{note page}{size=\tiny}
\addtobeamertemplate{note page}{\setbeamerfont{itemize/enumerate subbody}{size=\tiny}}{}
%\setbeameroption{hide notes} % Only slides
%\setbeameroption{show only notes} % Only notes
\setbeameroption{show notes on second screen=right} % Both
\setbeamersize
{
    text margin left=0.5cm,
    text margin right=0.5cm
}

\makeatletter
\setlength{\metropolis@titleseparator@linewidth}{2pt}
\setlength{\metropolis@progressonsectionpage@linewidth}{2pt}
\setlength{\metropolis@progressinheadfoot@linewidth}{1.5pt}
\makeatother

\setbeamercovered{dynamic}
\RequirePackage{graphicx}

\RequirePackage{ifxetex}
\ifxetex\RequirePackage{fontspec}\fi

\RequirePackage{xcolor}
\RequirePackage{hyperref}

\renewcommand*\footnoterule{}

\beamertemplatenavigationsymbolsempty%
\def\logoimage{graphics/lug}

\setlength\parindent{0pt}
