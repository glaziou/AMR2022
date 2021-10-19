#' ---
#' title: 01-import
#' author: Philippe Glaziou
#' date: 2021/10/19
#' output:
#'    html_document:
#'      mode: selfcontained
#'      toc: true
#'      toc_depth: 3
#'      toc_float: true
#'      number_sections: true
#'      theme: flatly
#'      highlight: zenburn
#'      df_print: paged
#'      code_folding: hide
#' ---

#' Last updated: `r Sys.Date()`
#'
#'
#'
#' # Import Glass data
#'
library(data.table)
library(here)
library(readxl)


# load three GLASS data files shared by Barbara on 13 October 2021
gfreq <- as.data.table(read_excel(here('input/GLASS_Frequencies_2012_19.xlsx')))
gprop <- as.data.table(read_excel(here('input/GLASS_Proportions_2012_19.xlsx')))
gimp <- as.data.table(read_excel(here('input/GLASS_implementation_2017_20.xlsx')))


# standardize key variable names
setnames(gfreq, "country", "iso3")
setnames(gprop, "country", "iso3")
setnames(gimp, c('region_code','region-number','country_code'), c('whoregion','regioncode','iso3'))


# set var names to lowercase, replace underscores and spaces in var names with "."
dtlst <- c('gfreq', 'gprop', 'gimp')
dtlst2 <- lapply(mget(lst), function(x){
  setnames(x, names(x), tolower(names(x)))
  setnames(x, names(x), gsub('_', '.', names(x)))
  setnames(x, names(x), gsub(' ', '.', names(x)))
})
list2env(dtlst2, .GlobalEnv)


# set keys
setkey(gfreq, iso3, year)
setkey(gprop, iso3, year)
setkey(gimp, iso3, year)


# save binaries and csv
dtlist <- mget(dtlst)

invisible(lapply(names(dtlist), function(u) {
  assign(u, dtlist[[u]])
  save(list = u, file = here(paste0("data", "/", u, ".rda")))
  fwrite(dtlist[[u]], file = here(paste0("csv", "/", u, '_', Sys.Date(), '.csv')))
}))


# clean-up
rm(dtlst, dtlst2, dtlist)






