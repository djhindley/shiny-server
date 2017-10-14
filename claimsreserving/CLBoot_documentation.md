## User notes for Chain Ladder Bootstrap module

This module represents a version of the Chain Ladder ODP Bootstrap model, as described in Section 4.4.  Currently, only a constant scale parameter can be used. The module uses the BootChainLadder module (with a minor modification to show a progress bar in the application, when the bootstrap simulations are being processed).

**A. Input items**

The input box on the left hand side allows the user to enter the following items: 

*1. Data triangle*
This allows the user to select one of six data triangles, as explained in the introduction on the first page of the app. Whenever the selection is changed, the data and residuals in the output section on the right hand side are updated immediately. To update the bootstrap results, percentiles and graphs, the "Run bootstrap" button at the end of the input panel must be pressed.

The units for the data and results can also be selected, with the default being thousands. 

*2. Process distribution*

Two options for the process distribution are available - ODP and Gamma, as explained in the relevant paragraphs in Section 4.4.3. The default selection is Gamma, partly as the results are produced slightly faster than when using ODP.

*3. Number of simulations*

This specifies the number of bootstrap simulations that are used when the bootstrap model is run.

*4.Simulation seed option*

The default option here is for no seed to be specified, in which case the bootstrap simulation results are likely to vary if the bootstrap is re-run with the same input details.  However, if required, a seed value can be specified, which will mean the results will not change between runs with the same input details.  The initial value for the specified seed is set to be the same as in the R code in Appendix B, Section B.3.3, so that when the Reserving book data is selected with the ODP process distribution and 5000 simulations, the results (including the percentiles) are the same as in the CL Bootstrap worked example in Section 4.4.4 (Tables 4.42 and 4.43).

*5. Additional percentile value*

When the bootstrap model is run, one of the results tables will show the estimated reserve at a range of default percentile levels (60th, 75th,90th,99.5th and 99.9th). This input item allows the user to specify an additional precentile value (input as a %), for which results will also be displayed. The default value is 85.

After the input items, a **"Run bootstrap"** button is displayed, which must be clicked both initially when the module is first loaded, and whenever any input items are changed, so as to update the results and graphs.  If the user attempts to display results or graphs before this button is clicked, the relevant output panels will be blank. After the button has been clicked, the app' will not detect if any input options have subsequently changed, so the results and graphs may not always be up to date unless the button has been re-clicked.

When the bootstrap simulations are being processed, a progress bar is shown in the bottom right hand corner of the screen, with brief details being displayed of the various stages of the process. 


----------

**B. Output items**

The output items on the right hand side can be selected using the tabbed menu items as follows:


*1. Data*

This simply shows the data triangle in cumulative form.

*2. Residuals*

This shows the Pearson residuals according to the underlying ODP model, including the degrees of freedom adjustment, as explained in Section 4.4.3.  Using the Reserving book data, the residuals will be the same as shown in the ODP Bootstrap method worked example in Section 4.4.4 (Table 4.39).  

*3. Summary of Results*

This shows a summary of the bootstrap results, including the mean ultimate and mean reserve, as derived by taking the relevant averages across all the simulations.  The values for these items will not be the same as the underlying values according to the ODP (i.e. Chain Ladder) model, due to the use of simulation.  The Reserve SD (i.e. Standard Deviation or Error) and the implied Coefficient of Variation are also shown.  Using the Reserving book data with an ODP process error, 5000 simulations and the default selected seed value of 1328967780 (as per the R code in Appx B, Section B.3.3) will produce results as per the ODP Bootstrap worked example in Section 4.4.4 (Table 4.42). 

*4. Bootstrap percentiles*

The table here provides the estimated reserve at a range of default percentiles, by cohort and in total, across all cohorts combined. As noted above, the table also includes the estimated reserve at an additional percentile level, as selected by the user on the input panel. Using the Reserving book data with an ODP process error, 5000 simulations and the default selected seed value of 1328967780 (as per the R code in Appx B, Section B.3.3) will produce percentile results as per the ODP Bootstrap worked example in Section 4.4.4 (Table 4.43). 

*5. Graphs*

The final item allows four different types of graph to be shown. The first is a histogram of the total reserve (labelled as IBNR in all cases, as per the BootChainLadder "plot" function. The second shows the estimated cumulative distribution function of the total reserve. The next two graphs are box-whisker plots of the simulated ultimate claim cost (by cohort) and a form of "back-test" graph that compares the actual incremental claims on the leading diagonal with the simulated values. They may take a short period to load, depending on the number of simulations. The various types of graph are referred to in Section 4.10.4.

----------


