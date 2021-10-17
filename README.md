# A saliency map for Working Memory and Number Processing

Code for the working memory model in Endress, A.D. & Szabó, S. (2020). Sequential presentation protects memory from catastrophic interference. Cognitive Science, 44(5), e12828, doi: 10.1111/cogs.12828

The files below are matlab reimplimentations for the model that appear in
* Knops, A., Piazza, M., Sengupta, R., Eger, E., & Melcher, D. (2014). A shared, flexible neural map architecture reflects capacity limits in both visual short-term memory and enumeration. *Journal of Neuroscience*, 34(30), 9857–9866. doi: 10.1523/JNEUROSCI.2758-13.2014
* Sengupta, R., Surampudi, B. R., & Melcher, D. (2014). A visual sense of number emerges from the dynamics of a recurrent on-center off-surround neural network. *Brain Research*, 1582, 114–124. doi: 10.1016/j.brainres.2014.03.014

There are 3 kinds of *m* files:

1. Basic network functions. These functions provide the basic model. Instead of having different m files, this could be thought of as different arguments to the function.
2. Wrapper functions. These function just launch the basic network functions, but collect their output so the network function can be used in a parfor loop using the paralellel processing toolbox. 
3. Launching functions. These functions call the basic network functions or the wrappers, and generate some figures


## 1. Basic network functions 

knops.m
	This is the basic model. It provides a function that runs that the simulations, and returns the mean activation, the mean faithfulness, and the summed inhibition
	The simulation is run on a 10 x 7 grid of neurons
	Last modified: Nov  1  2016

There are a number of variations of these functions. 
      	  knops_large_network.m
		Identical to knops.m, but runs on a 20 x 20 grid of neurons.
	        Last modified: Nov  1  2016

	  knops_track_memory_contents.m
		Also returns the mean activation in the the last (S_max-1)/2 active input neurons and 
		a (randomly chosen) subset of a (S_max-1)/2 neurons that were active earlier.
	        Last modified: Dec 23  2016

	knops_track_memory_contents_last_.5smax.m
		knops_track_memory_contents.m, but track the last S_max units. 
		*** Probably unused ***
		Last modified: Oct 21  2016 

          knops_track_memory_contents_and_number_of_activated_units.m
		Calculates the number of active neurons and their mean activation.
	        Last modified: Dec  9  2016
		*** If we need to do extra work, modify this one ***

          knops_track_memory_contents_and_n_activated_units_sigm.m
		Similar to knops_track_memory_contents_and_number_of_activated_units.m but uses sigmoid activation function.
		Does not calculate activation in first and last units when s_max is too large for this and returns the std instead.
	        Last modified: May  22  2019

	  knops_number_comparison.m
		Runs the number comparison simulations
	        Last modified: Nov  4  2016 

	  knops_multiple_activation_functions.m
		Identical to knops.m, but supports additional activation functions 
	        Last modified: May 19 2019

## 2. Wrapper functions

knops_wrapper.m
	Calls knops.m

knops_large_network_wrapper.m
	Calls knops_large_network.m


knops_multiple_activation_functions_wrapper.m
	Calls knops_multiple_activation_functions.m

## 3. Launching functions 


   knops_launcher.m
	Starts knops.m and generates some figures
	Saves results in knops.mat

    knops_max_distance_launcher.m
	Starts knops.m through knops_wrapper.m (for parellel processing), and generates some figures
	This simulation varies the maximal distances through which neurons interact
	Saves results in knops_max_dist.mat

    knops_large_network.m
	Starts knops_large_network.m and generates some figures


    knops_max_distance_large_network_launcher.m
	Starts knops_large_network.m trhough knops_large_network_wrapper.m (for parallel processing) and generates some figures
	This simulation varies the maximal distances through which neurons interact
	Saves results in knops_max_dist_large_network.mat

    knops_number_comparison_launcher.m
	Starts knops_number_comparison.m and generates some figures
	Saves results in knops_number_comparison.mat

    knops_track_memory_contents_launcher.m
	Starts knops_track_memory_contents.m and generates some figures

     knops_track_memory_contents_and_n_active_units_launcher.m
	Starts knops_track_memory_contents_and_number_of_activated_units.m and generates some figures     

     knops_track_memory_contents_and_n_active_units_launcher_sigm
	Starts knops_track_memory_contents_and_n_activated_units_sigm.m

     knops_multiple_activation_functions_launcher
        Starts knops_multiple_activation_functions and generates some figures
