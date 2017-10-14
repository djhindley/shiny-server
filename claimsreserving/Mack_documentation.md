## User notes for Mack module

This module implements the Mack method, including an allowance for tail factors and the additional functionality of a cross-product term, as explained further in Section 4.2.

**A. Input items**

The input box on the left hand side allows the user to enter the following items: 

*1. Data triangle*
This allows the user to select one of six data triangles, as explained in the introduction on the first page of the app. Whenever the selection is changed, all the graphs and results in the output section on the right hand side are updated immediately.  

The units for the data and results can also be selected, with the default being thousands. 

*2. Link Ratio estimator*

Three options are available here - Column Sum, Simple Average and "Regression-type".   The first two of these are as for the Chain Ladder module, and the output section shows both the simple average of all values in each column in the table ("smpl") and the volume weighted average or column-sum average ("vwtd"), as explained in Section 3.2.2.  The "Regression-type" link ratio estimator refers to the link ratio estimators being derived from an ordinary regression of each of the pairs of values in successive columns of the triangle, with an intercept of zero. This is explained further in Section 4.2.9 (i.e. with alpha=2, as explained there).  

The Selected value below the "smpl" and "vwtd" rows shows the value of the chosen link ratio estimators.
 
The data and link ratios for the Taylor and Ashe data triangle are the same as the worked example given in Section 3.2.8.

*3. Tail factor*

As well as the default option of no tail factor (i.e. value of 1.0), an Exponential curve can be fitted to the link ratio estimators, or alternatively, a user-defined value can be selected.  This uses the curve-fitting procedure built into the "MackChainLadder" function within the ChainLadder R package, and hence, unlike the Chain Ladder module of the app', there is no Inverse Power option, and there is no need to select the number of future tail projection periods.

If a user-defined tail factor is selected, as well as being asked to enter the tail factor itself, the user is asked to select the Coefficient of Variation of the tail factor (as a %) and the value of sigma for the tail.  This is explained further in Section 4.2.6.   The default values for these two items are set to 1% and 27.5 (as per Section 4.2.6), so that when the Reserving book data is selected and a tail factor of 1.029 is entered, the results will be the same as those in Table 4.20. 


*4. Cross-product term*

This option allows the cross-product term, as explained in Section 4.2.8, to be included in the formulation of the Mack model.  If the Reserving book data is used, with a CSA link ratio estimator and no tail factor, then the results are the same as those given in that section (e.g. the total parameter risk error is 1,569,349 - select units as the unit for display purposes to show this in the Summary Results table). 

----------

**B. Output items**

The three output items on the right hand side can be selected using the tabbed menu items as follows:

*1. Data and Link Ratios*

This shows the selected data triangle in cumulative format and below it the triangle of individual link ratios, along with the simple average link ratio estimator ("smpl"), the column-sum average link ratio estimator ("vwtd") and the selected link ratio estimator.

*2. Results*

There are four types of results tables shown for the Mack model.

The first ("Summary") gives a summary of the results, with the Standard Error split between Process and Parameter (i.e. Estimation) risk, along with the Coefficient of Variation (=Total SE/Reserve).  Using the Reserving book data, with a CSA link ratio estimator and no tail factor or cross-product term will produce results as per Table 4.4.  With the same data and a user-defined tail factor of 1.029, along with a CV for the tail factor of 1% and a sigma value of 27.5, will produce results as per Table 4.20.

The next type of results are the Variance parameters.  This shows the Sigma^2 values, as per the Mack formulae, the Standard Error of the development factors, and the corresponding Coefficient of Variation. Using the Reserving book data, with no tail factor, these results will be the same as the corresponding items in Table 4.17.

The final two results tables show the Process and Parameter risk on a cumulative basis across each future development periods in the triangle.  The final column is labelled "Inf" if a tail factor has been selected.  Using the Reserving book data, with no tail factor, the Process and Parameter Risk tables correspond to Tables 4.16 and 4.18 respectively, as per the recursive formulation of Mack's method.


*3. Graphs*

The third item allows five different types of graph to be shown. The first is a histogram summary of the results for each cohort (or origin period), showing the latest and forecast values (=reserve or IBNR, depending on data type), and an interval line representing +/- one standard error according to Mack's model.

The remaining four graphs are standardised residual plots against fitted values, origin (i.e. cohort) period, calendar period and development period. These can be used to test the validity of the underlying Chain Ladder model used in Mack's method, as explained further in the relevant paragraphs of Section 4.10.3, which also shows graphs that will be the same as those in the app, if the Reserving book data is used (with no tail factor and CSA estimators).





