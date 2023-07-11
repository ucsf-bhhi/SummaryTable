tidy_stats_var <- function(stats_table, var_to_tidy){

  Incorp_label <- stats_table %>%
    slice(1) %>%
    pull({{var_to_tidy}})

  stats_table %>%
    mutate("{{var_to_tidy}}" := c(Incorp_label, rep("", n()-1)))


}

# Tidy var_summarise output
#' Generate table with summary statistics
#'
#' @importFrom magrittr %>%
#' @param dat stats table output from `var_summarise()`
#'
#' @return Stats output field_label tidydied
#' @export
#'
#' @examples SummaryTable::var_summarise(iris, var = "Petal.Length", treatment = "Species") %>% tidy_stats_table()
#'


tidy_stats_table <- function(stats_table, var){

  stats_table %>%
    group_by(Variable) %>%
    group_modify(
      ~tidy_stats_var(.x, {{var}})
    ) %>%
    ungroup()


}
