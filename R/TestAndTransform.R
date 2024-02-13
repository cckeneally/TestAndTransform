#' Test and Transform Numeric Columns in a Dataframe
#'
#' Iterates over each numeric column in a dataframe, tests each for normality using the Shapiro-Wilk test,
#' applies the best normalization transformation if needed, based on a user-specified minimum proportion of non-NA values,
#' and allows excluding specific columns by name. Returns a new dataframe with transformed columns.
#'
#' @param dataframe A dataframe to process.
#' @param min_non_na_prop The minimum proportion of non-NA values required in a column for it to be considered for testing and transformation.
#'        Default is 0.5, meaning at least 50% of the values in the column must be non-NA.
#' @param exclude A vector of column names to exclude from testing and transformation.
#' @return A dataframe with numeric columns transformed as necessary, excluding specified columns.
#' @importFrom bestNormalize bestNormalize
#' @importFrom stats shapiro.test
#' @examples
#' data(iris)
#' # Transform iris dataset with the default minimum non-NA proportion, excluding the 'Species' column
#' transformed_iris_excluded <- TestAndTransform(iris, exclude = c("Species"))
#' @export
TestAndTransform <- function(dataframe, min_non_na_prop = 0.5, exclude = c()) {
  # Initialize a copy of the dataframe to store transformed data
  transformed_data <- dataframe

  # Internal function to test and transform a single column
  test_and_transform <- function(column, col_name) {
    # Check if the column is to be excluded
    if(col_name %in% exclude) {
      cat(sprintf("Column '%s' excluded.\n", col_name))
      return(column)
    }

    # Check if the column is numeric
    if(is.numeric(column)) {
      # Calculate the proportion of non-NA values
      prop_non_na <- sum(!is.na(column)) / length(column)

      # Proceed only if the proportion of non-NA values meets or exceeds min_non_na_prop
      if(prop_non_na >= min_non_na_prop) {
        # Shapiro-Wilk normality test on non-NA values
        shapiro_test_result <- shapiro.test(column[!is.na(column)])

        # If the p-value is less than 0.05, indicating non-normality
        if(shapiro_test_result$p.value < 0.05) {
          # Apply bestNormalize, excluding NA values for this step
          best_norm_result <- bestNormalize(column[!is.na(column)])
          # Transform the column using the best normalization method
          transformed_column <- predict(best_norm_result, newdata = column)

          # Extract the name of the chosen transformation
          chosen_transformation_name <- class(best_norm_result$chosen_transform)[1]
          cat(sprintf("Column '%s' transformed using: %s\n", col_name, chosen_transformation_name))

          return(transformed_column)
        } else {
          cat(sprintf("Column '%s' is normally distributed; no transformation applied.\n", col_name))
        }
      } else {
        cat(sprintf("Column '%s' does not meet the non-NA proportion threshold (%.2f); no test or transformation applied.\n", col_name, min_non_na_prop))
      }
    } else {
      cat(sprintf("Column '%s' is not numeric; no test or transformation applied.\n", col_name))
    }
    # Return the original column if no transformation is applied
    return(column)
  }

  # Iterate over each column in the dataframe, applying test_and_transform
  for(col_name in names(transformed_data)) {
    transformed_data[[col_name]] <- test_and_transform(transformed_data[[col_name]], col_name)
  }

  return(transformed_data)
}
