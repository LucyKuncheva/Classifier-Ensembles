File `TryOutCombiners.m` shows examples of the work of different ensemble combiners on s 2D data set with 3 Gaussian classes. Uncomment the chosen combiner model to see the output. The following combination methods are included as MATLAB functions:

For label outputs from the individual classifiers in the ensemble:

- Majority vote
- BKS (Behaviour Knowledge Space)
- Naïve Bayes

For continuous-valued outputs:
- Average
- Median
- Minimum
- Maximum
- Product
- Weighted average (with random weights)
- Ridge regression
- Decision template
- LDC combiner
- Tree combiner

The code gives the training and the testing accuracy for an ensemble of 50 classifiers. Optionally, a plot of the classification regions can be generated as shown [here](TreeCombinerRegions.png) for the Tree combiner.

File `TryOutCombiners.m` shows examples of the work of different ensemble combiners on a 
2D data set with 3 Gaussian classes. Uncomment the chosen combiner model to see the 
output. The following combination methods are included as MATLAB functions:

For label outputs from the individual classifiers in the ensemble:

- Majority vote
- BKS (Behaviour Knowledge Space)
- Naïve Bayes

For continuous-valued outputs:

- Average
- Median
- Minimum
- Maximum
- Product
- Weighted average (with random weights)
- Ridge regression
- Decision template
- LDC combiner
- Tree combiner

The code gives the training and the testing accuracy for an ensemble of 50 classifiers.
The individual classifiers are decision trees, each one built on a bootstrap sample from
the data (like in Bagging). Optionally, a plot of the classification regions can be 
generated as shown [here](TreeCombinerRegions.png) for the Tree combiner.

