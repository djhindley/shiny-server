## User notes for Chain Ladder module

**A. Input items**

The input box on the left hand side allows the user to enter the following items: 

*1. Data triangle*
This allows the user to select one of six data triangles, as explained in the introduction on the first page of the app'. Whenever the selection is changed, all the graphs and results in the output section on the right hand side are updated immediately.  

The units for the data and results can also be selected, with the default being thousands. 

*2. Link Ratio estimator*

A Column Sum or Simple Average estimator can be selected.  The values used are those shown below the individual link ratios in the output section, with "smpl" being the simple average of all values in each column in the table and "vwtd" being the volume weighted average or column-sum average ("CSA"), as explained in Section 3.2.2.  For ease of reference, the selected values are shown below the "smpl" and "vwtd" rows.

The data and link ratios for the Reserving book data triangle are the same as the worked example given in Section 3.2.8.

*3. Tail factor*

As well as the default option of no tail factor (i.e. value of 1.0), two curves can be fitted to the link ratio estimators - Exponential and Inverse Power - or alternatively, a user-defined value can be selected.  

If either of the two curves are selected, an additional user input is displayed relating to the number of future periods beyond the domain of the triangle which will be used from the fitted curve to derive the tail factor.  The default value for this is 7, simply so that the results for the Taylor and Ashe data reconcile with those in Table 3.22.  For the Exponential and Inverse Power curves respectively, these values are 1.029 and 1.129 (rounded as per the table).  As alternative values for the future periods are selected, the tail factor displayed will change accordingly.  The approach used to fit the curves is as per the Curve Fitting paragraphs in Section 3.2.6.

*4. First column for regression*

This item does not affect the CL results, but can be used to explore the relationship between the CL method and linear regression, as explained further in the Regression results section below.

----------

**B. Output items**

The four output items on the right hand side can be selected using the tabbed menu items as follows:

*1. Data and Link Ratios*

This shows the selected data triangle in cumulative format and below it the triangle of individual link ratios, along with the simple average link ratio estimator ("smpl"), the column-sum average link ratio estimator ("vwtd") and the selected link ratio estimator.

*2. Results*

Using the selected tail factor, the results are calculated and are shown (by cohort) in two tables - the first of which shows the full projected triangle, with the final column being the estimated ultimate including the selected tail factor. The second table shows the latest, reserve and ultimate values. The latest is simply the values from the leading diagonal.  The triangle is assumed to be a paid triangle; if it is actually an incurred triangle for example, then the reserve will represent the IBNR.  

For the Reserving book and GenIns data (i.e. the Taylor and Ashe dataset), with 7 future years of projection used for the tail factor, the Exponential results are very similar to those in the "CSA + TF" columns of Table 3.24. Any differences are due to the fact that the tail factor used in Table 3.24 is rounded to 1.029, whereas the app' does not round the value.  If a user-defined tail factor of 1.029 is used, then the results are the same as in Table 3.24.

With no tail factor, the results reconcile with those in the "CSA" columns of Table 3.24 and the full projected triangle reconciles with Table 3.20.  

*3. Graphs*

The third item allows four different types of grouped cohort graphs to be shown - cumulative and incremental on both a scaled and unscaled basis, as described in Section 3.27 and Section 5.8.

*4. Regression*

This part of the app shows how the Chain Ladder method can be represented as a regression model, as explained in the relevant paragraphs of Section 3.2.6.

The input item referred to above represents the first column to be selected for the regression calculation. The columns labels here begin with an index of 1, for convenience. This is in contrast to those in the worked examples in the book, which as explained there, begin with zero. 

The regression output shows a graph containing the individual pairs of values (as dots) and a straight line representing the fitted regression line, as explained further in Section 3.2.6.  The slope of the fitted line is also shown (as the coefficient in the regression formula).

If the Reserving book data is selected and a column sum average estimator used, then selecting column 4 as the first column will produce the same results as shown in Section 3.2.6 (i.e. a CSA Chain Ladder factor of 1.174).




