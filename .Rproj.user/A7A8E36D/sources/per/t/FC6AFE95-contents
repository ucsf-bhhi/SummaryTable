
# Evaluates if input is character or factor var
is_categorical <- function(var){
  is.character(var) + is.factor(var)
}


# Generate counts and percent
#' Generate table with summary statistics
#'
#' @param dat data.frame with data to summarise
#' @param var variable or list of variables to summarise
#' @param treatment variable to stratify summary variables by
#' @param nonparametric bolean to indicate if median and IQR should be calculated instead of mean
#'
#' @return A tibble with data summary statistics is returned.
#' @export
#'
#' @examples SummaryTable::var_summarise(iris, var = "Petal.Length", treatment = "Species")

var_summarise <- function(dat, var = NULL, treatment = NULL, nonparametric = NULL){


  if(missing(var)){
    var <- dat %>%
      dplyr::select(-{{treatment}}) %>%
      names()
    message("No variables specified, all applicable variables will be used.")
  }


  if (!missing(var)) {
    var <- dat %>%
      dplyr::select(all_of({{var}})) %>%
      colnames()
  }

  #print(paste("Variables to analyze:", var))

  assertthat::assert_that(is.data.frame(dat))

  if(!is.null(treatment)) {
    if(!is_categorical(dat[[treatment]]))  {
      stop("Treatment is expected as as.factor or as.character type.")
    }
  }

  if(!missing(nonparametric)){
    if (!all(purrr::map_lgl(dat[nonparametric], is.numeric)))
        stop("Nonparametric argument should be typeof double.")
  }

cat_vars <- dat %>%
  dplyr::select(all_of(var)) %>%
  dplyr::select_if(is.character) %>%
  names() %>%
  append(
    dat %>%
      dplyr::select(all_of(var)) %>%
      dplyr::select_if(is.factor) %>%
      names()
  )

cont_vars <- dat %>%
  dplyr::select(all_of(var)) %>%
  dplyr::select(-all_of(nonparametric)) %>%
  dplyr::select_if(is.numeric) %>%
  names() %>%
  append(
    dat %>%
      dplyr::select(all_of(var)) %>%
      dplyr::select_if(is.integer) %>%
      names()
  )

np_vars <- dat %>% # nonparametric variables
  dplyr::select(all_of(nonparametric)) %>%
  dplyr::select_if(is.numeric) %>%
  names() %>%
  append(
    dat %>%
      dplyr::select(all_of(nonparametric)) %>%
      dplyr::select_if(is.integer) %>%
      names()
  )

#print(paste("Categorical vars are:", cat_vars))
#print(paste("Continuous vars are:", cont_vars))
#print(paste("Nonparametric vars are:", np_vars))

# Create table with descriptive statistics of categorical data with no grouping var

if(length(cat_vars) > 0 & is.null(treatment)){

cat_tbl <- dat %>%
              dplyr::select(all_of(cat_vars)) %>%
              dplyr::mutate(dplyr::across(.cols = everything(), as.factor)) %>%
              tidyr::pivot_longer(cols = all_of(cat_vars),
                           names_to = "Variable",
                           values_to = "Label") %>%
              dplyr::group_by(Variable, Label) %>%
              summarise(statistic = n(),
                        .groups = "keep") %>%
              ungroup(Label) %>%
              dplyr::mutate(per = (statistic/sum(statistic))*100) %>%
              dplyr::mutate(dplyr::across(where(is.numeric), ~round(.x, 2))) %>%
              dplyr::mutate(statistic = paste(statistic, " (", per, "%)",sep = "")) %>%
              dplyr::mutate(statistic = as.character(statistic)) %>%
              dplyr::select(-per)

}

# Create table with descriptive statistics of categorical data with grouping var

if(length(cat_vars) > 0 & !missing(treatment)){

  treat_quo <- sym(treatment)

  cat_tbl <- dat %>%
    dplyr::select(all_of(cat_vars), all_of(treatment)) %>%
    dplyr::mutate(dplyr::across(.cols = everything(), as.factor)) %>%
    tidyr::pivot_longer(cols = all_of(cat_vars),
                 names_to = "Variable",
                 values_to = "Label") %>%
    dplyr::group_by(Variable, Label, !!treat_quo) %>%
    summarise(statistic = n(),
              .groups = "keep") %>%
    ungroup(Label) %>%
    dplyr::mutate(per = (statistic/sum(statistic))*100) %>%
    dplyr::mutate(dplyr::across(where(is.numeric), ~round(.x, 2))) %>%
    dplyr::mutate(statistic = paste(statistic, " (", per, "%)",sep = "")) %>%
    dplyr::mutate(statistic = as.character(statistic)) %>%
    dplyr::select(-per)

}

# Create table with descriptive statistics of continuous data with no grouping var

if(length(cont_vars) > 0 & is.null(treatment)){
  cont_tbl <- dat %>%
    dplyr::select(all_of(cont_vars)) %>%
    dplyr::mutate(dplyr::across(.cols = everything(), as.numeric)) %>%
    tidyr::pivot_longer(cols = all_of(cont_vars),
                 names_to = "Variable") %>%
    dplyr::group_by(Variable) %>%

  summarise(statistic = mean(value, na.rm = T),
            sd = sd(value, na.rm = T),
            .groups = "keep") %>%
    dplyr::mutate(dplyr::across(where(is.numeric), ~round(.x, 2))) %>%
    dplyr::mutate(statistic = paste(statistic, " (", sd, ")", sep = "")) %>%
    dplyr::mutate(Label = "") %>%
    dplyr::select(Variable, Label, statistic)
}

# Create table with descriptive statistics of continuous data with grouping var

if(length(cont_vars) > 0 & !is.null(treatment)){
  treat_quo <- sym(treatment)

  cont_tbl <- dat %>%
    dplyr::select(all_of(cont_vars), all_of(treatment)) %>%
    dplyr::mutate(dplyr::across(all_of(cont_vars), as.numeric)) %>%
    tidyr::pivot_longer(cols = all_of(cont_vars),
                 names_to = "Variable") %>%
    dplyr::group_by(Variable, !!treat_quo) %>%
    summarise(statistic = mean(value, na.rm = T),
              sd = sd(value, na.rm = T),
              .groups = "keep") %>%
    dplyr::mutate(dplyr::across(where(is.numeric), ~round(.x, 2))) %>%
    dplyr::mutate(statistic = paste(statistic, " (", sd, ")", sep = "")) %>%
    dplyr::mutate(Label = "") %>%
    dplyr::select(Variable, Label, all_of(treatment), statistic)
}

# Create table with descriptive statistics of nonparametric data with no grouping var

if(length(np_vars) > 0 & is.null(treatment)){
  np_tbl <- dat %>%
    dplyr::select(all_of(np_vars)) %>%
    dplyr::mutate(dplyr::across(.cols = everything(), as.numeric)) %>%
    tidyr::pivot_longer(cols = all_of(np_vars),
                 names_to = "Variable") %>%
    dplyr::group_by(Variable) %>%

    summarise(statistic = median(value, na.rm = T),
              iqr1 = quantile(value, probs = 0.25, na.rm = T),
              iqr2 = quantile(value, probs = 0.75, na.rm = T),
                              .groups = "keep") %>%
    dplyr::mutate(dplyr::across(where(is.numeric), ~round(.x, 2))) %>%
    dplyr::mutate(statistic = paste(statistic, " [", iqr1, ",", iqr2, "]", sep = "")) %>%
    dplyr::mutate(Label = "") %>%
    dplyr::select(Variable, Label, statistic)
}

# Create table with descriptive statistics of nonparametric data with grouping var

if(length(np_vars) > 0 & !is.null(treatment)){
  treat_quo <- sym(treatment)

  np_tbl <- dat %>%
    dplyr::select(all_of(np_vars), all_of(treatment)) %>%
    dplyr::mutate(dplyr::across(all_of(np_vars), as.numeric)) %>%
    tidyr::pivot_longer(cols = all_of(np_vars),
                 names_to = "Variable") %>%
    dplyr::group_by(Variable, !!treat_quo) %>%
    summarise(statistic = median(value, na.rm = T),
               iqr1 = quantile(value, probs = 0.25, na.rm = T),
               iqr2 = quantile(value, probs = 0.75, na.rm = T),
                               .groups = "keep") %>%
    dplyr::mutate(dplyr::across(where(is.numeric), ~round(.x, 2))) %>%
    dplyr::mutate(statistic = paste(statistic, " [", iqr1, ",", iqr2, "]", sep = "")) %>%
    dplyr::mutate(Label = "") %>%
    dplyr::select(Variable, Label, all_of(treatment), statistic)
}

# Save output

if(length(np_vars) == 0){
  np_tbl <- NULL
}

if(length(cat_vars) == 0){
  cat_tbl <- NULL
}

if(length(cont_vars) == 0){
  cont_tbl <- NULL
}


return(bind_rows(cat_tbl, cont_tbl) %>%
         bind_rows(np_tbl))
}
