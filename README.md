# The_CSLS_model

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

## Requirements:

Matlab needs to be installed before running the scripts (Version >= R2014a)


## Introduction

This is a context-sensitive level set model for green algae detection.


## Test the model:

There is one investigated green algae image named demo.tif. You can run the main function The_CSLS_model.m for test.

The following four dynamic maps show the processes of green algae detection by our context-sensitive level sets (CSLS) model.

Specifically, we use the dynamic map showing the evolution of our CSLS model which encourages converged level set contours to tightly surround green algae regions. Furthermore, the zero level set of our model form red contours that are expected to separate the green algae region and the background region.

![image](https://github.com/DongdongMeng/The_CSLS_model/blob/master/Sample%201.gif)
![image](https://github.com/DongdongMeng/The_CSLS_model/blob/master/Sample%202.gif)
![image](https://github.com/DongdongMeng/The_CSLS_model/blob/master/Sample%203.gif)
![image](https://github.com/DongdongMeng/The_CSLS_model/blob/master/Sample%204.gif)

## Acknowledgement

We acknowledge the authors for the code released at ''http://www.imagecomputing.org/~cmli/'' and ''http://kaihuazhang.net/'', which provide effective means for green algae detection in remote sensing images.
