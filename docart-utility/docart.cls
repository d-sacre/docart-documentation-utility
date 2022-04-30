%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% docART Utility - A Python/Lua(LaTeX) based tool for semi-automated documentation %%
%% Source: https://github.com/d-sacre/docart-documentation-utility/                 %%
%% Version: alpha-2022-04-30                                                        %%
%% License: GNU General Public License (GPLv3)                                      %%
%% Copyright (C) 2022 Martin Stimpfl, Daniel Sacré                                  %%
%%                                                                                  %%
%% This program is free software: you can redistribute it and/or modify             %%
%% it under the terms of the GNU General Public License as published by             %%
%% the Free Software Foundation, either version 3 of the License, or                %%
%% (at your option) any later version.                                              %%
%%                                                                                  %%
%% This program is distributed in the hope that it will be useful,                  %%
%% but WITHOUT ANY WARRANTY; without even the implied warranty of                   %%
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                    %%
%% GNU General Public License for more details.                                     %%
%%                                                                                  %%
%% You should have received a copy of the GNU General Public License                %%
%% along with this program.  If not, see <https://www.gnu.org/licenses/>.           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%+++Complete+++

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{docart-utility/docart}[docart LaTeX class]

% Loading the scr-komascript base class
\LoadClass[12pt, a4paper, oneside,parskip=half,no indent]{scrreprt}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Packages %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if Settings File Exists and Load it
\RequirePackage{etoolbox}
\RequirePackage{xifthen}
\newcommand{\daCheckAndLoadSetting}[1]{
	\IfFileExists{#1}
	{\input{#1}}
	{
		\ClassError{docart}%
		{File #1 not found. An essential file could not be loaded}%
		{Please check if all required files are located in the correct position\MessageBreak according to the docart documentation.}%
	}
}

% Loading the project details at the begining, so that all the defined macros can be used 
% by other dcmts/user setting files
\daCheckAndLoadSetting{settings/projectDetails.tex}

% Syntax Highlighting
\RequirePackage[procnames]{listings} %% alt: listings, pygment, listingsutf8
\RequirePackage{shellesc} % to be able to execute Python scripts via shell
\RequirePackage{luacode} % to be able to use Lua code directly within LuaLaTeX

\daCheckAndLoadSetting{settings/listingsSettings.tex}
\daCheckAndLoadSetting{./docart-utility/class-master-theme/listing.dcmts}

%% Including Pictures
\RequirePackage{graphicx}

%% Colors
\RequirePackage[table,dvipsnames]{xcolor}
\daCheckAndLoadSetting{docart-utility/class-master-theme/default-colors.dcmts}
\daCheckAndLoadSetting{settings/colorSettings.tex}

\RequirePackage{tikz}
\usetikzlibrary{calc,positioning,decorations.text}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Formating the page, general typsetting options %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fonts
\RequirePackage{fontspec}
\daCheckAndLoadSetting{docart-utility/class-master-theme/fontSettings.dcmts}

%% page margins and typearea
\RequirePackage[top=1.25cm,bottom=1.25cm,left=2cm,right=2cm,headheight=2.5cm,includeheadfoot]{geometry}

\RequirePackage[automark]{scrlayer-scrpage}
\daCheckAndLoadSetting{docart-utility/class-master-theme/header.dcmts}
\daCheckAndLoadSetting{docart-utility/class-master-theme/footer.dcmts}

\pagestyle{scrheadings}
\renewcommand*{\chapterpagestyle}{scrheadings}

%% Settings for distance chapter to header
\renewcommand*{\chapterheadstartvskip}{\vspace*{-0.5cm}}
\renewcommand*{\chapterheadendvskip}{\vspace*{0.425cm}}

%% Settings for distance section and subsection
\RedeclareSectionCommand[beforeskip=-12.5ex,afterskip=2ex plus -.2ex]{section}

%% Formating the headlines
\setkomafont{disposition}{\color{headlinecolor}\bfseries}

%% Formating the captions
\RequirePackage[labelfont={bf}]{caption}
\captionsetup{format=plain,labelformat=simple,font=small,labelsep = colon}

%% Control over Bulletpoint Lists
\RequirePackage{enumitem}
\renewcommand\labelitemi{\textbf{\textbullet}}
\renewcommand\labelitemii{\textbullet}
\renewcommand\labelitemiii{\textbullet}

%% Titlepage
\daCheckAndLoadSetting{settings/titlepageContent.tex}
\daCheckAndLoadSetting{docart-utility/class-master-theme/titlepage.dcmts}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Highlight boxes
\daCheckAndLoadSetting{docart-utility/class-master-theme/highlightboxes.dcmts}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Tables  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{colortbl} % color in tables
\RequirePackage{multirow}

\RequirePackage{pgfplotstable}
\pgfplotsset{compat=1.17}

% %% Multipage Tables
\RequirePackage{longtable,tabu} % using tabu tables did clash with longtable/tabularx
% tabu at the moment just for table separator line command used

\daCheckAndLoadSetting{docart-utility/class-master-theme/tables.dcmts}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pictures  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{graphicx}
\RequirePackage[]{subcaption}
\RequirePackage{xspace}


\daCheckAndLoadSetting{docart-utility/class-master-theme/figures.dcmts}

\RequirePackage[tikz]{bclogo} % only used for some icons
\RequirePackage{ccicons} % provides Creative Commons License Icons

\daCheckAndLoadSetting{docart-utility/class-master-theme/icons.dcmts}

%\daCheckAndLoadSetting{settings/pictureSettings.tex} % currently not needed; but in a later release
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{csquotes}
\RequirePackage{xspace}

% For ensuring better copiability within pdfreader
\RequirePackage{cmap}

%% References and Links
\RequirePackage[hidelinks]{hyperref}
\daCheckAndLoadSetting{settings/pdfMetadata.tex}

%+++Complete+++

