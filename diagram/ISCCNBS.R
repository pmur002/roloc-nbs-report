
## Attempt to draw my own 3D diagram of ISCC-NBS colour blocks

## For ISCC-NBS colour block boundaries
library(colorscience)
## For rendering
library(rgl)
## For converting block to R colour
library(colorspace)
library(rolocISCCNBS)

## Describe an ISCC-NBS block 
blockMesh <- function(block, n=10) {
    ## hue-chroma plane
    a1 <- block$Hmin/100*2*pi
    a2 <- block$Hmax/100*2*pi
    r1 <- max(0, block$Cmin/20)
    r2 <- min(1, block$Cmax/20)
    angle <- seq(a1, a2, length.out=n)
    cosa <- cos(angle)
    sina <- sin(angle)
    x <- c(r1*cosa, r2*rev(cosa))
    y <- c(r1*sina, r2*rev(sina))
    translate3d(extrude3d(x, y, (block$Vmax - block$Vmin)/10),
                0, 0, block$Vmin/10)
}

blockColour <- function(block) {
    name <- CentralsISCCNBS[block$Number, "Name"]
    rgb <- coords(ISCCNBScolours$colours)[ISCCNBScolours$name == name]
    rgb(rgb[1], rgb[2], rgb[3])
}

drawBlock <- function(block) {
    for (i in 1:nrow(block)) {
        shade3d(blockMesh(block[i,]), col=blockColour(block[i,]))
    }
}

captureView <- function(i) {
    um <- par3d()$userMatrix
    dump("um", paste0("view-", i, ".R"))
    view3d(userMatrix=um)
}

clear3d()
for (i in 130:160) {
    block <- SystemISCCNBS[SystemISCCNBS$Number == i, ]
    drawBlock(block)
}

## captureView(1)
## captureView(2)
## captureView(3)

for (i in 1:3) {
    source(paste0("view-", i, ".R"))
    view3d(userMatrix=um)
    snapshot3d(paste0("ISCCNBS-", i, ".png"))
    system(paste0("convert -trim ISCCNBS-", i, ".png ISCCNBS-", i, "-trim.png"))
}
