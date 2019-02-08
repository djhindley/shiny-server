## GIRA - General Insurance Claims Reserving Application

> *Copyright 2017 David Hindley*

**If you have not already read the Notice and License information relating to this application, please do so by reading the NoticeLicense.md file and the accompanying LICENSE file (or a later version of GPL). These files explain the terms under which the software code and application are distributed.**

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This documentation and all the other help files are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.  Please read this before making any further use of the documentation.

### Table of contents

- [Source Code and web application](#sourcecode)
- [Introduction to GIRA](#intro)
- [Overall functionality and usage](#overallfunc)
- [Data used in the application](#data)
- [Credits](#credits)
- [Contributions and Contact details](#contact)


## Source Code and web application

You are viewing the Readme.md file for this application located along with the underlying source code on Github, written in R, using Shiny.  If you just want to run the application from a web browser, follow this [link](https://goo.gl/ZrEcM5).  The web-based version of the application is stored on a virtual server at [Digital Ocean](https://www.digitalocean.com/), managed by the application's author.  This server has limited capacity and may not always provide reasonable performance.  

If you want to run the application locally on your own device or server, you can do so, subject to the above referenced notice and license conditions, by downloading all the relevant R and Markdown files located in this Github repository and proceeding from there.  You will need to be familiar with R and Shiny to do this. Further details of Shiny are available [here](https://shiny.rstudio.com/).  GIRA is a Shiny application stored in ui.R and server.R files, which each reference several other R files and Markdown files, all of which are located in this Github repository.

## Introduction to GIRA

This application is designed as a learning aid to accompany the book published in 2017 by Cambridge University Press, entitled "Claims reserving in general insurance", written by David Hindley.  This book is referred to as the Claims Reserving book in the rest of the documentation in the app', with any references to "Sections" being to sections within the book.

The application includes the following claims reserving methods:

* Chain Ladder
* BF
* Mack
* GLM
* Bootstrap (of Chain Ladder)
* Merz-Wüthrich

It also contains a simple example to show the effect of using different assumptions when aggregating stochastic results across reserving classes. 

As with the R code included in an appendix to the Claims Reserving book, this app makes use of the ChainLadder R package, further details of which are available [here](https://cran.r-project.org/web/packages/ChainLadder/ChainLadder.pdf).

The overall design of the app is intended to enable the user to experiment with using the relevant reserving methods.  The default assumptions used when the app is first loaded will produce results that are consistent, where relevant, with the corresponding worked examples in the book. By selecting alternative datasets and/or alternative input assumptions, the app can be used to understand the effect on the corresponding results.

The app is not intended to be a substitute for either a bespoke internal reserving system or for any of the commercially available proprietary specialist reserving packages. Other important caveats regarding the software usage, including the license details are given at the end of this document. 
 

## Overall functionality and usage

Each menu item at the top of the page accesses a separate module. 

Clicking on a menu item brings up a display page with an input panel down the left hand side, and an output panel on the right hand side (except on a device with a small screen, in which case the output panel will be displayed below the input panel).  The content of these input and output panels will vary between modules, and in some cases there will be further tabs showing different input and output components. 

Each module has an option in the input panel to select the units for display of data and results (units, thousands etc.), with the default set to thousands.  All output pages showing numerical tables of data and results include buttons to enable the contents to be copied (to the clipboard), printed or downloaded.  Depending on the web browser being used, the "Download" button will allow three options - CSV, MS-Excel and pdf.

Many of the modules do not require a "run" or similar option to be selected before updated results are displayed. Simply change the relevant inputs and the results will change dynamically.  If no input values are changed, the results will be based on the initially selected default values.

An "Info" button is shown at the bottom of each input panel, which when clicked will show information about the relevant menu item that has been selected.  After displaying the information, just click anywhere outside the information box to return to the previous screen.

## Data used in the application

Currently, each method can only be applied to a limited number of specific triangles, as supplied with the ChainLadder package in R. These are as follows:

1. Reserving book: The Taylor and Ashe dataset used for most of the examples in the Claims Reserving book and in many other papers on claims reserving.  The cohorts and development periods are both indexed from 0 to 9, to be consistent with many of the worked examples in the book. The data is referred to as *"GenIns"* in the ChainLadder package (as per the final dateset listed below).
2. RAA: Automatic Facultative General Liability business from *"Historical Loss Development. Reinsurance Association of America 1991, p96."*
3. UK Motor: UK Motor dataset taken from the UK Claims Reserving manual, available [here](http://www.actuaries.org.uk/research-and-resources/documents/claims-reserving-manual-vol2-section-d5-regression-models-based-lo-0 "Claims reserving manual").
4. MW2008: Taken from the journal article: *Modelling the claim development result for solvency purposes* by Wüthrich, M and Merz, M. Casualty Actuarial Society E-forum 2008.
5. MW2014: Taken from the journal article: *Claims Run-Off Uncertainty. The full picture* by Wüthrich, M and Merz, M., Swiss Finance Institute Research paper No. 14-69. 2014. Available [here](http://ssrn.com/abstract=2524352).
6. GenIns: The same as the Reserving book data (i.e. GenIns from the ChainLadder package), except that the cohorts and development periods are labelled as per the dataset in the ChainLadder package. Although this is exactly the same as the first data triangle listed above, it is included to accommodate users who prefer the cohort and development periods used in the ChainLadder package. 

Further details of this data are available in the [ChainLadder R package documentation](https://cran.r-project.org/web/packages/ChainLadder/ChainLadder.pdf).

## Credits

I use Digital Ocean to host the web application.  Further details are available at [Digital Ocean](https://m.do.co/c/55032fedbb01). Using this link will give you a $10 credit for creating your own server at Digital Ocean (and possibly, subject to usage, gives me a small referral fee).  To set up my Digital Ocean server and the associated shiny web application, I made extensive use of materials provided by [Dean Attali](http://deanattali.com/). See this [link](http://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/) for further details of his instructions for setting up your own Digital Ocean Shiny server.

As noted above, parts of the application use the ChainLadder package in R.  Thanks to the authors (Markus Gesmann, Daniel Murphy, Yanwei (Wayne) Zhang, Alessandro Carrato, Giuseppe Crupi, Mario Wuthrich and Fabio Concina) of this package.  Further details are available at [ChainLadder R package](https://github.com/mages/ChainLadder).

Thanks to Andrew Katz at [Moorcrofts](http://www.moorcrofts.com) for help with the open source licensing.

## Contributions and Contact details

This software is provided at no cost and in open source format, to encourage others to contribute.  In the Issues part of this repo', there are a selected list of known issues and additional features that could be added. If you are familiar with Github and wish to contribute in any way, please feel free to create a pull request, open a new issue, or suggest a solution for one of the already identified issues/  Alternatively, just contact me by email using dhindley@djhindley.com.  Any contributions and comments are welcome!

----------

