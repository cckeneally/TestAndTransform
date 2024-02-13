# TestAndTransform
Package for iterating the `bestNormalize` package by Peterson, R. A. (2021) over a dataframe.
Please refer to the original [package website](https://petersonr.github.io/bestNormalize/) for more info.
`TestAndTransform` is a basic function which iterates over each numeric column in a dataframe, tests each for normality using the Shapiro-Wilk test,
and applies the best normalization transformation if needed, based on a user-specified minimum proportion of non-NA values and excluded variables.
Returns a new dataframe with transformed columns.

# Installation
Install from GitHub with:
```r
# install.packages("devtools")
devtools::install_github("cckeneally/TestAndTransform")
```

# References
Peterson, Ryan A. "Finding Optimal Normalizing Transformations via best Normalize." R Journal 13.1 (2021). [ISSN 2073-4859](https://journal.r-project.org/articles/RJ-2021-041/RJ-2021-041.pdf)
