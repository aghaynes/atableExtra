context("as.numeric_np")

x <- rnorm(10)

test_that("no error", {
  expect_error(as.numeric_np(x), NA)
})

z <- as.numeric_np(x)

test_that("class", {
  expect_equal(class(z)[1], "numeric_np")
})


test_that("class stats", {
  ns <- numeric_stats(z)
  expect_equal(class(ns)[1], "numeric_stats_np")
})

test_that("formatting", {
  ns <- numeric_stats(z)
  fs <- format_statistics(ns)
  expect_true(grepl("Median", fs[1,1]))
})


data(mtcars)
mtcars$cyl <- as.numeric_np(mtcars$cyl)

test_that("works with atable", {
  at <- atable(mtcars, target_cols = c("cyl", "mpg"),
               statistics.numeric = numeric_stats,
               format_to = "Console")
  expect_true(any(grepl("Median", at[grep("cyl", at$Group):grep("mpg", at$Group),1])))
  expect_true(any(grepl("Mean", at[grep("mpg", at$Group):nrow(at),1])))
})

