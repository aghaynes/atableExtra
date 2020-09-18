context("numeric_stats")



dat <- rnorm(50, 10)

ns <- numeric_stats(dat)
n <- 10
ns2 <- numeric_stats(c(dat, NA), seq(0, 1, length.out = n))



test_that("number of elements", {
  expect_equal(length(ns), 12)
  expect_equal(length(ns2), n+6)
})

test_that("results as expected", {
  expect_equal(ns$mean, mean(dat))
  expect_equal(ns$sd, sd(dat))
  expect_equal(ns$q0.5, median(dat))
  expect_equal(ns$q0.25, quantile(dat, 0.25, names = FALSE))
  expect_equal(ns$q0, min(dat))
  expect_equal(ns$q1, max(dat))
})

test_that("NAs", {
  expect_equal(ns$Nvalid, 50)
  expect_equal(ns2$Nvalid, 50)
  expect_equal(ns$Nmissing, 0)
  expect_equal(ns2$Nmissing, 1)
  expect_equal(ns$N, 50)
  expect_equal(ns2$N, 51)
})

test_that("numeric", {
  expect_error(numeric_stats("foo"))
})

test_that("agreeable to atable", {
  expect_error(atable:::check_statistics(ns), NA)
  expect_error(atable:::check_statistics(ns2), NA)
})




