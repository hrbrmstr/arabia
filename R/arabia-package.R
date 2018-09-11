#' Tools to Read 'Lowrance' Binary Track Files
#'
#' Lowrance' (<http://www.lowrance.com/>) chart plotters use an ugly
#' but straightforward binary format to encode their tracks. Tools are provided
#' to read 'SL2' files (and, very likely 'SLG' and 'SL3' files, too).
#'
#' - URL: <https://gitlab.com/hrbrmstr/arabia>
#' - BugReports: <https://gitlab.com/hrbrmstr/arabia/issues>
#'
#' @md
#' @name arabia
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @importFrom dplyr case_when bind_rows data_frame mutate
#' @importFrom purrr flatten_df set_names %>%
#' @importFrom tidyr unnest
#' @references
#' - <http://www.lowrance.com/>
#' - <https://wiki.openstreetmap.org/wiki/SL2>
#' - <https://github.com/kmpm/node-sl2format> (very helpful additional field breakdown)
#' - <https://stackoverflow.com/q/52280751/1457051>
NULL
