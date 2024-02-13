# tests/testthat/test-TestAndTransform.R
library(testthat)
library(TestAndTransform)

test_that("TestAndTransform runs without error", {
  data(iris)
  captured <- capture_output(TestAndTransform(iris))
  expect_true(TRUE) # The test is considered passed if no error is thrown
})
