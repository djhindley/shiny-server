## User notes for GLM module

This module includes the ODP Model described in Section 4.3 and 
the other GLM-type models described in Section 4.7.11.  It uses the glm.Reserve function from the ChainLadder R package.

**A. Input items**

The input box on the left hand side allows the user to enter the following items: 

*1. Data triangle*
This allows the user to select one of six data triangles, as explained in the introduction on the first page of the app. Whenever the selection is changed, all the graphs and results in the output section on the right hand side are updated immediately.  

For this module, the data is displayed in the output panel in incremental form by default, as this is the form of data to which the GLM models are fitted. There is, however, an option in the input panel to show the cumulative data, if required.

The units for the data and results can also be selected, with the default being thousands. 

*2. Model type*

Four types of model can be selected  - ODP, Gamma, Gaussian and Inverse Gaussian.  These are all analytical stochastic reserving methods, as described in Section 4.3 (ODP) and Section 4.7.11 (the other models).

*3. Residual definition*

Four types of residual can be selected - Pearson, Deviance, Working and Response.  For further details, see [https://stat.ethz.ch/R-manual/R-devel/library/stats/html/glm.summaries.html](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/glm.summaries.html).  


----------

**B. Output items**

The six output items on the right hand side can be selected using the tabbed menu items as follows:


*1. Data*

This simply shows the data triangle, in either incremental form (by default) or in cumulative form.  

*2. Summary of Results*

This summary shows the latest data (i.e. leading diagonal from the triangle), the estimated ultimate using the chosen GLM, the implied reserve (or IBNR if the data is claims incurred), the estimated Standard Error and the implied Coefficient of Variation.  Selecting the Reserving book data and the ODP model will produce the same results as the ODP worked example in Section 4.3.8 (Table 4.29).  Similarly, with the same dataset, the results for the other three types of GLM will agree with those in Section 4.7.11 (Table 4.65).

*3. Fitted values*

This shows a triangle of the fitted incremental values, according to the selected GLM model. Using the Reserving book data and an ODP model will produce the same fitted values as in Section 4.3.8 (Table 4.31).


*4. Residuals*
This shows the residuals according to the fitted GLM model, and the chosen residual definition.  The Pearson residuals for the ODP model will be the same as shown in the ODP Bootstrap method worked example in Section 4.4.4 (Table 4.38) -that is the residuals before the degrees of freedom adjustment is applied.

*5. Fitted parameters*

This shows the raw output from the underlying R glm.Reserve function in the ChainLadder R package.  The fitted paramaters for the ODP model using the Reserving book data will be the same as those shown in Section 4.3.8 (Table 4.30).

*6. Graphs*

The final item allows two different types of graph to be shown. The first is a residual plot against the fitted values and the second is a Q-Q plot, the latter of which is referred to in Section 4.10.3 (under "Statistical tests").  For the ODP model using the Reserving book data, the Q-Q plot will be the same as that shown in this section of the book.

----------

