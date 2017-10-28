## User notes for Aggregation module

This module is designed to accompany an article that describes a worked example of the aggregation of results produced using stochastic reserving methods across classes of business.  The article is effectively an addendum to Section 4.9 - "Combining Results across classes" in the book "Claims Reserving in General Insurance" by David Hindley, published in October 2017.  Except where indicated, references to tables in this documentation are to those in the article.  The article is available [here](https://github.com/djhindley/shiny-server/blob/master/claimsreserving/Aggregationexample.pdf).

The module is designed to demonstrate the impact on results of using different assumptions for each class of business and to explore how different correlation and copula assumptions affect, for example, the diversification benefits produced when the results are aggregated across classes.

The module uses the "copula" R package, details of which are available [here](https://cran.r-project.org/web/packages/copula/index.html).

**A. Input items**

The input box on the left hand side allows the user to enter the following items: 

*1. Class assumptions*
The module has three classes of business, labelled A, B and C, details of which are explained in the article.  For each class, the following assumptions can be amended:

a) Distribution - Lognormal or Gamma.

b) Reserve value (entered in units of the user choosing).

c) Coefficient of Variation (as a %). 

The default assumptions for each class of business are the same as those shown in the article.

*2. Update Aggregation results*

This shows a button that can be clicked to update the aggregation simulation results. It will need to be clicked when this module is first selected, and then after any subsequent change to any of the input assumptions (including those such as the seed etc. which are listed below the button on the input panel).  There is no flag to indicate if results have changed, so if in doubt, the button should always be clicked to ensure the aggregation results are consistent with the input assumptions.  The class of business results (as opposed to the aggregation results) are not dependent on applying simulation, and hence these will update automatically without needing to click this button. 

If the user attempts to display aggregation results or the copula graph before this button is clicked, the relevant output panels will be blank.

After the button is clicked, a progress bar is shown in the bottom right hand corner of the screen, with brief details being displayed of the various stages of the process. 

*3. Number of simulations*

The module will simulate results using the selected copula (see below).  This input item specifies the number of simulations that will be used for that purpose.

*4.Simulation seed option*

The default option here is for the seed to be specified, with the default value being the same as that used to create the results in the article.  This will ensure that the results reconcile with those in the article when the same input assumptions are used.  Other seed values can be selected if required, and whenever the seed is selected the results will not change between runs with the same input details.  Alternatively, the option to "Not set" the seed can be chosen, in which case the results may vary between runs, even if the same input details are used; this can be used to test the sensitivity of the results (e.g in the tail of the aggregate distribution) to the seed value.

*5. Additional percentile value*

When the aggregation simulation results are derived, one of the results tables will show the estimated reserve at a range of default percentile levels (50th, 75th,90th,99.5th and 99.9th). This input item allows the user to specify an additional percentile value (input as a %), for which results will also be displayed. The default value is 85.

As for all other modules the information icon shown at the bottom of the input panel produces this documentation.  In addition, a button is shown which when clicked will show a pdf copy of the article referred to above.

----------

**B. Output items**

The output items on the right hand side can be selected using the tabbed menu items as follows:


*1. Class of business details*

This is designed to summarise the selected distributions for each class of business, and has five items:

a. Summary

For each class of business, this shows the distribution type, mean and Coefficient of Variation (CV) that have been selected, along with the implied Standard Deviation and distributional parameters.  The default input values are the same as shown in Table 1 of the article (although for the Gamma distribution, parameter 2 is shown as the inverse of Beta in the article).  The distributional parameters for the Lognormal are derived using the approach outlined in Section 6.9.4 and further explained in the appendix to the article referred to at the start of this document.

The table also shows the aggregate mean, standard deviation and implied CV for the aggregate distribution on an undiversified basis, as explained in the article.

b. Percentiles

This shows the distribution values for a range of default percentiles for each class, along with that for the user-defined additional percentile.  The corresponding values for the aggregate distribution on an undiversified basis are also shown. The default input assumptions will show the same results as in Table 2 in the article.

c. Ratio to mean

This is simply the ratio of the results in the previous percentile table to the mean value.  The default input assumptions will show the same results as in Table 2 in the article.

d. Density Graph

This shows a graph of the density function for the selected distributions. It will be the same as Figure 1 in the article, using the default input assumptions.

e. CDF Graphs

Here, a graph of the cumulative density function is shown for the relevant distribution (selected using the option underneath the graph), along with lines showing the values at the mean, user-defined additional percentile, and also the 99.5th percentile.  Annotations on the graph show the percentile for the chosen mean as well as the numerical values for the additional and 99.5th percentile.  

The results for the simple Lognormal example described in Section 6.9.4 of the book can also be displayed on a CDF graph, by selecting a Lognormal distribution for one of the classes, and then entering 100 as the reserve and 25% as the CV.  

*3. Aggregation Results*

This shows a summary table of the aggregation using the selected correlation and copula input assumptions (in the "Selected" column). The mean, SD and CV are shown, along with the values at the default and user-selected percentile values.  The undiversified percentile results are also shown, along with the implied diversification benefit derived from the Selected results (calculated as 100*[Undiversified-Selected]/Selected). 

Using the default seed value and the range of default input assumptions will produce the same results as in Tables 5 and 6 in the article (by amending the input correlation and copula assumptions and then updating the aggregation results by clicking the button, as explained above).  

*4. Copula graph*

The final item shows a scatter plot of the results for a selected pair of classes of business (which can be chosen using the Axis 1 and 2 radio buttons underneath the graph).  Using the default assumptions with a range of different copula and correlation assumptions will enable graphs to be derived as per Figures 3 and 4 in the article.

----------


