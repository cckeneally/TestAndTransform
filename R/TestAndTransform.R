#' Test and Transform Numeric Columns in a Dataframe
#'
#' Iterates over each numeric column in a dataframe, tests each for normality using the Shapiro-Wilk test,
#' and applies the best normalization transformation if needed, based on a user-specified minimum proportion of non-NA values.
#' Returns a new dataframe with transformed columns.
#'
#' @param dataframe A dataframe to process.
#' @param min_non_na_prop The minimum proportion of non-NA values required in a column for it to be considered for testing and transformation.
#'        Default is 0.5, meaning at least 50% of the values in the column must be non-NA.
#' @return A dataframe with numeric columns transformed as necessary.
#' @importFrom bestNormalize bestNormalize
#' @importFrom stats shapiro.test
#' @examples
#' data(iris)
#' # Transform iris dataset with the default minimum non-NA proportion
#' transformed_iris_default <- TestAndTransform(iris)
#' # Transform iris dataset specifying a different minimum non-NA proportion
#' transformed_iris_custom <- TestAndTransform(iris, min_non_na_prop = 0.75)
#' @export
TestAndTransform <- function(dataframe, min_non_na_prop = 0.5) {
  # Initialize a copy of the dataframe to store transformed data
  transformed_data <- dataframe
  
  # Internal function to test and transform a single column
  test_and_transform <- function(column, col_name) {
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
          
          cat(sprintf("Column '%s' transformed using: %s\n", col_name, best_norm_result$method))
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