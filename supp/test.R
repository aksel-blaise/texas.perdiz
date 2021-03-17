---
  title: "Analysis of Perdiz arrow point morphology"
author: "Robert Z. Selden Jr. and Bonnie L. Etter"
date: "`r format(Sys.time(), '%d %B, %Y')`"
output: github_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Load packages

```{r load, out.width = "100%", dpi = 300, echo = TRUE, warning=FALSE}
library(here)
library(StereoMorph)
library(geomorph)
library(wesanderson)
library(tidyverse)
```

## Digitize images

```{r digitize, out.width = "100%", dpi = 300, echo = TRUE, warning=FALSE, eval = FALSE}

digitizeImages(image.file='points', 
               shapes.file='shapes', 
               landmarks.ref='landmarks.txt', 
               curves.ref = 'curves.txt'
)
```

## Read data and define sLMs

```{r read, out.width = "100%", dpi = 300, echo = TRUE, warning=FALSE}
shapes <- readShapes("shapes")
shapesGM <- readland.shapes(shapes, nCurvePts = c(10, 10, 10, 10))
```

## Read qualitative data

```{r read qual, out.width = "100%", dpi = 300, echo = TRUE, warning=FALSE}
qdata <- read.csv("qdata.csv",
                  header = TRUE,
                  row.names = 1)
```

## GPA

```{r gp, out.width = "100%", dpi = 300, echo = TRUE, warning=FALSE}
Y.gpa <- gpagen(shapesGM, print.progress = FALSE)
plot(Y.gpa)

# dataframe
gdf <- geomorph.data.frame(shape = Y.gpa$coords,
                           size = Y.gpa$Csize,
                           region = qdata$region)

# add centroid size to qdata
qdata$csz <- Y.gpa$Csize

# revised table of attributes
knitr::kable(qdata,
             align = "lccc",
             caption = "Attributes of Perdiz arrow points included in the sample.")
```

## Boxplot

```{r box, out.width = "100%", dpi = 300, echo = TRUE, warning=FALSE}
#attributes
csz <- qdata$csz
region <- qdata$region

# palette
pal = wes_palette("FantasticFox1", 5, type = "continuous")

#boxplot of Perdiz arrow points by region
csz.reg <- ggplot(qdata, aes(x = region, y = csz, color = region)) +
  geom_boxplot() +
  geom_dotplot(binaxis = 'y', stackdir = 'center', dotsize = 0.3) +
  scale_color_manual(values = pal) +
  theme(legend.position = "none") +
  labs(x = 'Region', y = 'Centroid Size')

# render plot
csz.reg
```

## Principal Components Analysis

```{r pc, out.width = "100%", dpi = 300, echo = TRUE, warning=FALSE}
pca <- gm.prcomp(Y.gpa$coords)
summary(pca)

# set plot parameters
pch.gps <- c(3,15:18)[as.factor(region)]
col.gps <- pal[as.factor(region)]
col.hull <- c("#46ACC8","#DD8D29","#E2D200","#B40F20","#E58601")

# pca plot
pc.plot <- plot(pca,
                asp = 1,
                pch = pch.gps,
                col = col.gps)
shapeHulls(pc.plot,
           groups = region,
           group.cols = col.hull)

# identify shapes at x/y extremes
picknplot.shape(pc.plot)
```