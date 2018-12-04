## Combination rules for classifier ensembles 

[[L. Kuncheva. Combining Pattern Classifiers. Methods and Algorithms, 
Wiley, second edition, 
2014]](http://eu.wiley.com/WileyCDA/WileyTitle/productCd-1118315235.html)

`ExampleClassifierCombinationRules` is an interactive demo 
where different combination rules are applied to a toy data set. 

#### The “fish” data set

The data set is a 2D grid of points labelled into two classes. 
Without noise, the data looks like this: [>> Fish Data <<](FishDataNoNoise.png) 
– a little bit like a tropical fish nibbling on a seaweed, doesn’t it? 
The two classes are perfectly separable with a boundary which follows the 
outline of the fish and the seaweed. Adding 30% noise (say, sea pollution) 
makes the fish barely recognisable: 
[>> Fish Data with 30% Noise <<](FishDataNoise30.png)
Plot it for yourself with `PlotFishData.m`.

#### Try the combination rules

When you run `ExampleClassifierCombinationRules.m`, you will see two identical 
plots of the fish data next to one another. Click on the slider in the bottom 
left corner to generate two classifier ensembles. On the left is a _random_ 
ensemble, and on the right, a bootstrap ensemble (like Bagging). The 
classifiers are the red lines. For the random ensemble each classifier is 
trained by choosing among the two possible labellings the one with the smaller 
training error. For the bootstrap ensemble, each linear classifier is trained 
on a bootstrap sample of the data. [[Two Ensembles]](TwoEnsembleView.png)

Click on the radio buttons to find out how different combination rules fare 
on the two ensembles (Section 5.6 An example of nine combiners for 
continuous-valued outputs, p. 178). Ideally, the fish should be “discovered” 
and labelled correctly by the ensemble. Now increase the noise using the 
slider and check again. Some combination rules are amazingly bad with these 
ensembles while others are amazingly good even with large noise. 

Notably, diversity plays a role. Check the ridge regression combiner for 
50% noise. [[click here]](TwoEnsemblesRidge50.png) A diverse ensemble 
(left) is a lot better than the bootstrap one (right).
