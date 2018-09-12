#' Read Lowrance binary track files
#'
#' Lowrance chart plotters use an ugly but straightforward binary format to encode
#' their tracks. This function reads "SL2" files and likely reads "SLG" & "SL3" files
#' as well.
#'
#' @md
#' @param path path to file
#' @param verbose if `TRUE` shows progress
#' @return data frame (tibble)
#' @references
#' - <http://www.lowrance.com/>
#' - <https://wiki.openstreetmap.org/wiki/SL2>
#' - <https://github.com/kmpm/node-sl2format> (very helpful additional field breakdown)
#' - <https://stackoverflow.com/q/52280751/1457051>
#' @export
#' @examples
#' read_sl2(system.file("exdat", "example.sl2", package="arabia"))
read_sl2 <- function(path, verbose=TRUE) {

  f <- file(path.expand(path), "rb")
  dat <- readBin(f, "raw", n = file.size(path.expand(path)), endian="little")
  close(f)

  # read in the header
  header <- readBin(dat, what = "raw", n = 10)

  format <- readBin(header[1:2], "int", size=2, endian="little", signed=FALSE)

  if (!(format %in% 1:3)) stop("Invalid 'format' in header; Likely not an slg/sl2/sl3 file")

  ok_formats <- c("slg", "sl2", "sl3")
  if (verbose) message("Format: ", ok_formats[format])

  version <- readBin(header[3:4], "int", size=2, endian="little", signed=FALSE)
  blockSize <- readBin(header[5:6], "int", size=2, endian="little", signed=FALSE)

  if (blockSize == 1970) {
    if (verbose) message("Block size: downscan")
  } else if (blockSize == 3200) {
    if (verbose) message("Block size: sidescan")
  } else {
    stop("Block size is not 'downscan' or 'sidescan'; Likely not an slg/sl2/sl3 file")
  }

  alwaysZero <- readBin(header[7:8], "int", size=2, endian="little", signed=FALSE)

  # yep, we're going to build a list the hard/slow way
  sl2_lst <- vector("list")
  idx <- 1
  pos <- 8 # keeping track of our place in the stream

  while (pos < length(dat)) {

    # if verbose mode echo a "." every 100 records
    if (verbose && ((idx %% 100) == 0)) cat(".")

    blockSize <- readBin(dat[(pos+29):(pos+30)], "int", size=2, endian="little", signed=FALSE)
    prevBlockSize <- readBin(dat[(pos+31):(pos+32)], "int", size=2, endian="little", signed=FALSE)
    packetSize <- readBin(dat[(pos+35):(pos+36)], "int", size=2, endian="little", signed=FALSE)
    frameIndex <- readBin(dat[(pos+37):(pos+40)], "int", size=4, endian="little")

    dplyr::data_frame(
      channel = readBin(dat[(pos+33):(pos+34)], "int", size=2,endian="little", signed=FALSE),
      upperLimit = readBin(dat[(pos+41):(pos+44)], "double", size=4, endian="little"),
      lowerLimit = readBin(dat[(pos+45):(pos+48)], "double", size=4, endian="little"),
      frequency = readBin(dat[(pos+51)], "int", size=1, endian="little", signed=FALSE),
      waterDepth = readBin(dat[(pos+65):(pos+68)], "double", size=4, endian="little"),
      keelDepth = readBin(dat[(pos+69):(pos+72)], "double", size=4, endian="little"),
      speedGps = readBin(dat[(pos+101):(pos+104)], "double", size=4, endian="little"),
      temperature = readBin(dat[(pos+105):(pos+108)], "double", size=4, endian="little"),
      lng_enc = readBin(dat[(pos+109):(pos+112)], "integer", size=4, endian="little"),
      lat_enc = readBin(dat[(pos+113):(pos+116)], "integer", size=4, endian="little"),
      speedWater = readBin(dat[(pos+117):(pos+120)], "double", size=4, endian="little"),
      track = readBin(dat[(pos+121):(pos+124)], "double", size=4, endian="little"),
      altitude = readBin(dat[(pos+125):(pos+128)], "double", size=4, endian="little"),
      heading = readBin(dat[(pos+129):(pos+132)], "double", size=4, endian="little"),
      timeOffset = readBin(dat[(pos+141):(pos+144)], "integer", size=4, endian="little"),
      flags = list(
        dat[(pos+133):(pos+134)] %>%
          rawToBits() %>%
          as.logical() %>%
          set_names(
            c(
              "headingValid", "altitudeValid", sprintf("unk%d", 1:7),
              "gpsSpeedValid", "waterTempValid", "unk8", "positionValid",
              "unk9", "waterSpeedValid", "trackValid"
            )
          ) %>%
          .[c(1:2, 10:11, 13, 15:16)] %>%
          as.list() %>%
          purrr::flatten_df()
      )
    ) -> sl2_lst[[idx]]

    idx <- idx + 1

    pos <- pos + (packetSize+145-1)

  }

  if (verbose) cat("\n")

  dplyr::bind_rows(sl2_lst) %>%
    dplyr::mutate(
      channel = dplyr::case_when(
        channel == 0 ~ "Primary",
        channel == 1 ~ "Secondary",
        channel == 2 ~ "DSI (Downscan)",
        channel == 3 ~ "Left (Sidescan)",
        channel == 4 ~ "Right (Sidescan)",
        channel == 5 ~ "Composite",
        TRUE ~ "Other/invalid"
      )
    ) %>%
    dplyr::mutate(
      frequency = dplyr::case_when(
        frequency == 0 ~ "200 KHz",
        frequency == 1 ~ "50 KHz",
        frequency == 2 ~ "83 KHz",
        frequency == 4 ~ "800 KHz",
        frequency == 5 ~ "38 KHz",
        frequency == 6 ~ "28 KHz",
        frequency == 7 ~ "130-210 KHz",
        frequency == 8 ~ "90-150 KHz",
        frequency == 9 ~ "40-60 KHz",
        frequency == 10~ "25-45 KHz",
        TRUE ~ "Other/invalid"
      )
    ) %>%
    tidyr::unnest(flags)

}