## GIRA - General Insurance Claims Reserving Application

**If you have not already read the Notice and License information relating to this application, please do so by reading the NoticeLicense.md file and the accompanying LICENSE file (or a later version of GPL).**

**Source Code and web application**

You are viewing the Readme.md file for this application located along with the underlying source code on Github, written in R, using Shiny.  If you just want to run the application from a web browser, follow this [link](https://davidjhindley.com/shiny/claimsreserving).

The web-based version of the application is stored on a virtual server managed by the application's author. This has limited capacity and may not always provide reasonable performance. If you want to run the application locally on your own device or server, you can upload all the relevant files located in this Github repository and proceed from there. Contact the author at info@claimsreserving.com if you have any questions or comments on GIRA.

**Introduction to GIRA**

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

The overall design of the app is intended to enable the user to experiment using the relevant reserving methods.  The default assumptions used when the app is first loaded will produce results that are consistent, where relevant, with the corresponding worked examples in the book. By selecting alternative datasets and/or alternative input assumptions, the app can be used to understand the effect on the corresponding results.

The app is not intended to be a substitute for either a bespoke internal reserving system or for any of the commercially available proprietary specialist reserving packages. Other important caveats regarding the software usage, including the license details are given at the end of this document. 
 

**Overall functionality and usage**

Each menu item at the top of the page accesses a separate module. 

Clicking on a menu item brings up a display page with an input panel down the left hand side, and an output panel on the right hand side (except on a device with a small screen, in which case the output panel will be displayed below the input panel).  The content of these input and output panels will vary between modules, and in some cases there will be further tabs showing different input and output components. 

Each module has an option in the input panel to select the units for display of data and results (units, thousands etc.), with the default set to thousands.  All output pages showing numerical tables of data and results include buttons to enable the contents to be copied (to the clipboard), printed or downloaded.  Depending on the web browser being used, the "Download" button will allow three options - CSV, MS-Excel and pdf.

Many of the modules do not require a "run" or similar option to be selected before updated results are displayed. Simply change the relevant inputs and the results will change dynamically.  If no input values are changed, the results will be based on the initially selected default values.

An "Info" button is shown at the bottom of each input panel, which when clicked will show information about the relevant menu item that has been selected.  After displaying the information, just click anywhere outside the information box to return to the previous screen.

**Data used in the application**

Currently, each method can only be applied to a limited number of specific triangles, as supplied with the ChainLadder package in R. These are as follows:

1. Reserving book: The Taylor and Ashe dataset used for most of the examples in the Claims Reserving book and in many other papers on claims reserving.  The cohorts and development periods are both indexed from 0 to 9, to be consistent with many of the worked examples in the book. The data is referred to as *"GenIns"* in the ChainLadder package (as per the final dateset listed below).
2. RAA: Automatic Facultative General Liability business from *"Historical Loss Development. Reinsurance Association of America 1991, p96."*
3. UK Motor: UK Motor dataset taken from the UK Claims Reserving manual, available [here](http://www.actuaries.org.uk/research-and-resources/documents/claims-reserving-manual-vol2-section-d5-regression-models-based-lo-0 "Claims reserving manual").
4. MW2008: Taken from the journal article: *Modelling the claim development result for solvency purposes* by Wüthrich, M and Merz, M. Casualty Actuarial Society E-forum 2008.
5. MW2014: Taken from the journal article: *Claims Run-Off Uncertainty. The full picture* by Wüthrich, M and Merz, M., Swiss Finance Institute Research paper No. 14-69. 2014. Available [here](http://ssrn.com/abstract=2524352).
6. GenIns: The same as the Reserving book data (i.e. GenIns from the ChainLadder package), except that the cohorts and development periods are labelled as per the dataset in the ChainLadder package. Although this is exactly the same as the first data triangle listed above, it is included to accommodate users who prefer the cohort and development periods used in the ChainLadder package. 

Further details are available in the [ChainLadder R package documentation](https://cran.r-project.org/web/packages/ChainLadder/ChainLadder.pdf).

----------

