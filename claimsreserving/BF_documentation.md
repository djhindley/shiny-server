## User notes for Bornhuetter-Ferguson module

This module applies the Bornhuetter-Ferguson (BF) method to the selected data triangle. Default % developed and prior assumptions are pre-programmed for all cohorts, as described below.  In addition, user-defined assumptions can be selected for individual cohorts. The BF method used here is implemented using the data item in the relevant data triangle, rather than using another basis such as loss ratio.

**A. Input items**

The input box on the left hand side allows the user to enter the following items: 

*1. Data triangle*
This allows the user to select one of six data triangles, as explained in the introduction on the first page of the app'. Whenever the selection is changed, all the results in the output section on the right hand side are updated immediately.  

The units for the data and results can also be selected, with the default being thousands. 

*2. Tail factor for % developed*

The BF module derives default % developed assumptions for use in the calculations, using a standard CSA Chain Ladder method. In applying this method, the approach used to derive the tail factor, if required, can be selected.  As for the Chain Ladder module, if Exponential or Inverse Power are selected, the application then shows a further option to enter the number of future projection periods to be selected. A user-defined tail factor can also be selected.  The CL % developed for each cohort implied by the choices made here will be shown on the BF Results output tab.

*3. Individual cohort BF assumptions*

First, the individual cohort is selected, followed by the % developed and prior ultimate assumptions for use in the BF method.  The prior entered must be in the same units as chosen for the relevant data triangle. The default values for cohort, % developed and prior may not necessarily be appropriate for particular data triangles, but can just be overwritten with suitable assumptions, as required.

    
----------

**B. Output items**

The two output items on the right hand side can be selected using the tabbed menu items as follows:

*1. Data*

This just shows the selected data triangle in cumulative format, for reference purposes.

*2. BF Results*

This shows two tables - results using the default assumptions and results using the user-defined input assumptions.  

The default assumptions table shows results for all cohorts.  The CL % developed shown will depend on the tail factor assumptions specified by the user.  The Prior ultimate values are pre-programmed for each data triangle and cannot be changed by the user.  For the "Reserving book" data, these priors are the same as used in the worked example in Section 3.4.3, and so if no tail factor is used, the results will be the same as shown in Table 3.25.  For the other data triangles, default priors are defined using approximately similar values to those derived using a standard CSA Chain Ladder method.

The user-defined table shows results for the specified cohort. The ultimate based on the % developed is calculated as the latest value for the cohort divided by the % developed.






