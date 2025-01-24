#' @importFrom ggplot2 is.ggplot

JASPgraphsPlot <- R6::R6Class(
  classname = "JASPgraphsPlot",
  public = list(
    initialize = function(subplots, plotFunction = reDrawJASPgraphsPlot, ...) {

      if (!all(vapply(subplots, is.ggplot, TRUE)))
        stop2("all subplots should be of class ggplot!")
      if (!is.function(plotFunction))
        stop2("plotFunction should be a function!")
      plotArgs <- list(...)
      if (!length(names(plotArgs)) == length(plotArgs))
        stop2("all arguments in ... should be named.")
      if (is.null(plotArgs[["names"]]) && identical(plotFunction, reDrawJASPgraphsPlot))
        plotArgs[["names"]] <- paste0("plot", seq_along(subplots))

      self$subplots     <- subplots
      self$plotFunction <- plotFunction
      self$plotArgs     <- plotArgs
    },
    plot = function(...) self$plotFunction(self$subplots, self$plotArgs, ...),
    plotFunction = NULL,
    plotArgs     = NULL,
    subplots     = NULL
  )
)

#' Methods for interacting with a JASPgraphsplot
#'
#' @name JASPgraphsPlotMethods
#' @param x an object of class JASPgraphsPlot
#' @param field the name or index of a subplot
#' @param value the value that should be assigned
#'
#' @description These methods are mainly convenience functions that ensure things like seq_along work.
#'

#' @export
#' @rdname JASPgraphsPlotMethods
`[[.JASPgraphsPlot` <- function(x, field) x$subplots[[field]]

#' @export
#' @rdname JASPgraphsPlotMethods
`[[<-.JASPgraphsPlot` <- function(x, field, value) {
  x$subplots[[field]] <- value
  return(x)
}

#' @export
#' @rdname JASPgraphsPlotMethods
is.JASPgraphsPlot <- function(x) {
  inherits(x, "JASPgraphsPlot")
}

#' @export
#' @rdname jaspGraphsPlotMethods
length.JASPgraphsPlot <- function(x) {
  length(x$subplots)
}

#' @export
#' @rdname jaspGraphsPlotMethods
names.JASPgraphsPlot <- function(x) {
  names(x$subplots)
}


reDrawJASPgraphsPlot <- function(subplots, args, grob = FALSE, newpage = TRUE,
                                 decodeplotFun = get0("decodeplot"), ...) {
  # redraws plots from PlotPriorAndPosterior, PlotRobustnessSequential, and ggMatrixplot
  g <- gridExtra::arrangeGrob(
    grobs         = subplots,
    heights       = args[["heights"]],
    layout_matrix = args[["layout"]],
    widths        = args[["widths"]],
    names         = args[["names"]]
  )
  if (!is.null(decodeplotFun))
    g <- decodeplotFun(g)

  if (grob)
    return(g)
  else
    return(gridExtra::grid.arrange(g, ..., newpage = newpage))
}

reDrawAlignedPlot <- function(subplots, args, grob = FALSE, newpage = TRUE,
                              decodeplotFun = get0("decodeplot"), ...) {
  # redraws plots from JASPScatterPlot
  g <- makeGrobAlignedPlots(
    mainplot   = subplots[["mainPlot"]],
    abovePlot  = subplots[["topPlot"]],
    rightPlot  = subplots[["rightPlot"]],
    showLegend = args[["showLegend"]],
    size       = args[["size"]]
  )
  if (!is.null(decodeplotFun))
    g <- decodeplotFun(g)

  if (grob) {
    return(g)
  } else {
    if (newpage)
      grid::grid.newpage()
    return(grid::grid.draw(g, ...))
  }
}

currentDevIsSvg <- function() isTRUE(try(attr(grDevices::dev.cur(), "names") == "devSVG"))
