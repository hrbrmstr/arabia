context("We can read an example SL2 file")
test_that("we can do something", {

   xdf <- read_sl2(system.file("exdat", "example.sl2", package="arabia"), verbose = FALSE)

   expect_true(nrow(xdf) == 1308)
   expect_true(ncol(xdf) == 22)
   expect_equal(as.integer(sum(xdf$keelDepth)), 429L)

})
