# About
Modification of the friggeri-cv Latex template. Original was typeset in Helvetica and using colors inspired by Monokai. Modification uses extended colour palette and a choice of libre fonts.

Uses TikZ for the header and some pretty tricks, XeTeX and fontspec to use fonts, biblatex to print publications and textpos for the aside.

![Example how a CV with this template can look like](example.PNG)

# Features:

* Two Column
* Information-dense
* Fontawesome Icons
* Skill Scoring
* Publication List
* Multiple Fonts
* Student-Friendly

# Usage
Replace all things that need replacing.

Adding new things is easy:
 
Check Dante for [New Icons in Fontawesome](ftp://ftp.dante.de/tex-archive/fonts/fontawesome/doc/fontawesome.pdf)

## \score{n}
One input integer from 0-5 (inclusive).
### Example:
```
\score{3}
```

### Effect
Will fill number of circle out of five circles to indicate skill level.

## \courseentry{}{}{}{}{}{}
Six inputs

1. Years
1. Degree
1. University
1. Context
1. Thesis
1. Courses

### Example
```
\courseentry
{2011--2012}
{Bachelor {\normalfont of Commerce}}
{The University of California, Berkeley}
{This thesis explored the idea that money has been the cause of untold anguish and suffering in the world. I found that it has, in fact, not.}
{Money Is The Root Of All Evil -- Or Is It?}
{Business for Business Gurus, Money 101}
```

### Effect
Creates a special education-focused \entry in the the entrylist environment.