context("format_statistics.numeric_stats")

dat <- rnorm(50, 10)

ns <- numeric_stats(dat)
n <- 10
ns2 <- numeric_stats(c(dat, NA), seq(0, 1, length.out = n))

numfmt <- atable_options("format_numbers")

test_that("errors issued", {
  expect_error(format_statistics.numeric_stats(ns, 4))
  expect_error(format_statistics.numeric_stats(ns, missingformat = 2))
  expect_error(format_statistics.numeric_stats(ns, c("X" = "{foo}")))
  expect_error(format_statistics.numeric_stats(ns, c("X" = "{mean(mean)}")))
  expect_error(format_statistics(ns), NA)
})

test_that("aggreeable to atable", {
  expect_error(atable:::check_format_statistics(format_statistics.numeric_stats(ns)), NA)
  expect_error(atable:::check_format_statistics(format_statistics(ns)), NA)
})

test_that("expected output (default)", {
  fns <- format_statistics(ns)
  expect_equal(nrow(fns), 2)
  expect_equal(ncol(fns), 2)
  expect_equal(as.character(fns[1, 1]), "Mean (SD)")
  expect_equal(as.character(fns[2, 1]), "Valid (missing)")
  expect_equal(fns[1, 2], sprintf("%s (%s)", numfmt(mean(dat)), numfmt(sd(dat))))
})

test_that("expected output (min - max)", {
  fns <- format_statistics(ns, 2)
  expect_equal(nrow(fns), 2)
  expect_equal(ncol(fns), 2)
  expect_equal(as.character(fns[1, 1]), "Min - Max")
  expect_equal(as.character(fns[2, 1]), "Valid (missing)")
  expect_equal(fns[1, 2], sprintf("%s - %s", numfmt(min(dat)), numfmt(max(dat))))
})

test_that("expected output (median)", {
  fns <- format_statistics(ns, 3)
  expect_equal(nrow(fns), 2)
  expect_equal(ncol(fns), 2)
  expect_equal(as.character(fns[1, 1]), "Median [Quartiles]")
  expect_equal(as.character(fns[2, 1]), "Valid (missing)")
  expect_equal(fns[1, 2],
               sprintf("%s [%s; %s]",
                       numfmt(median(dat)),
                       numfmt(quantile(dat, .25)),
                       numfmt(quantile(dat, .75))))
})

test_that("expected outcome (all)", {
  fns <- format_statistics(ns, 1:3)
  expect_equal(nrow(fns), 4)
  expect_equal(ncol(fns), 2)
  expect_equal(as.character(fns[1, 1]), "Mean (SD)")
  expect_equal(as.character(fns[2, 1]), "Min - Max")
  expect_equal(as.character(fns[3, 1]), "Median [Quartiles]")
  expect_equal(as.character(fns[4, 1]), "Valid (missing)")

  fns <- format_statistics(ns, 1:3, FALSE)
  expect_equal(nrow(fns), 3)

})

test_that("expected outcome (custom)", {
  fns <- format_statistics(ns, c("Mean" = "{mean}"))
  expect_equal(nrow(fns), 2)
  expect_equal(ncol(fns), 2)

  fns <- format_statistics(ns, c("Mean" = "{mean}"), FALSE)
  expect_equal(nrow(fns), 1)
  expect_equal(ncol(fns), 2)

  fns <- format_statistics(ns, c("Mean" = "{mean}", "Missing" = "{Nmissing}"), FALSE)
  expect_equal(nrow(fns), 1)
  expect_equal(ncol(fns), 2)

  fns2 <- format_statistics(ns, c("Mean" = "{mean}"), c("Missing" = "{Nmissing}"))
  expect_equal(fns, fns2)
})


