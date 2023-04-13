# Macroalgae monitoring from satellite optical images using Context-sensitive level set (CSLS) model

## Introduction

This is a context-sensitive level set model for macroalgae detection.

## Paper

This paper has been accepted to Ecological Indicators.

If you use this code for your reasearch, please cite:

```
@article{CSLS2023,
title = {Macroalgae monitoring from satellite optical images using Context-sensitive level set (CSLS) model},
journal = {Ecological Indicators},
volume = {149},
pages = {110160},
year = {2023},
issn = {1470-160X},
doi = {https://doi.org/10.1016/j.ecolind.2023.110160},
url = {https://www.sciencedirect.com/science/article/pii/S1470160X23003023},
author = {Xinliang Pan and Dongdong Meng and Peng Ren and Yanfang Xiao and Keunyong Kim and Bing Mu and Xuanwen Tao and Rongjie Liu and Quanbin Wang and Joo-Hyung Ryu and Tingwei Cui},
}
```

## Requirement

Matlab needs to be installed before running the scripts (Version >= R2014a)


## Demo

The following four dynamic maps show the processes of macroalgae detection by our context-sensitive level sets (CSLS) model.

Specifically, we use the dynamic map showing the evolution of our CSLS model which encourages converged level set contours to tightly surround macroalgae regions. Furthermore, the zero level set of our model form red contours that are expected to separate the macroalgae region and the background region.

![image](https://github.com/DongdongMeng/The_CSLS_model/blob/master/Sample%201.gif)
![image](https://github.com/DongdongMeng/The_CSLS_model/blob/master/Sample%202.gif)
![image](https://github.com/DongdongMeng/The_CSLS_model/blob/master/Sample%203.gif)
![image](https://github.com/DongdongMeng/The_CSLS_model/blob/master/Sample%204.gif)

## Run your own dataset

This unsupervised detection method taking NDVI as input can be applied directly to the GF series data, Landsat-8 data, Aqua data without the need for labels. You can go directly to the corresponding satellite data folder (GF-4, Landsat-8, Aqua) and run the main function The_CSLS_model.m for testing. Note that the The_CSLS_model.m and the CSLS.m should be in the same path. 

In addition, you can also replace with your own data for testing. Note that the test data needs to be grayscale. We also provide some optimization parameter options that can be set:

* Iteration_number: 20 or more are recommended

* k (Eq.14): Can be adjusted within the range of [0,2]

* timestep_t (Eq.25): Can be adjusted within the range of [0,1]

* timestep_T (Eq.22): Can be adjusted within the range of [0,1]


## Acknowledgement

We acknowledge the authors for the code released at ''http://www.imagecomputing.org/~cmli/'' and ''http://kaihuazhang.net/'', which provide effective means for macroalgae detection in remote sensing images.
