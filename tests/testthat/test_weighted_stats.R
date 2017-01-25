library(matrixStats)
context("w_* unweighted")

set.seed(123)
x = round(c(NA, runif(8, 1,2), NA), 5)
w = round(c(runif(6, 1,2), -1, NA, NA, 0), 5)
w2 = 2.5



expect_identical(w_mean(x), mean(x, na.rm = TRUE))
expect_identical(w_sum(x), sum(x, na.rm = TRUE))
expect_identical(w_median(x), median(x, na.rm = TRUE))
expect_identical(w_mad(x), matrixStats:::weightedMad(x, na.rm = TRUE))
expect_identical(w_sd(x), sd(x, na.rm = TRUE))
expect_equal(w_var(x), var(x, na.rm = TRUE))
expect_identical(w_n(x), sum(!is.na(x)))


expect_equal(w_se(x), 0.1167701830205)


##############

x = x[-1]

expect_identical(w_mean(x, na.rm = FALSE), as.numeric(NA))
expect_identical(w_sum(x, na.rm = FALSE), as.numeric(NA))
expect_identical(w_median(x, na.rm = FALSE), as.numeric(NA))
expect_identical(w_mad(x, na.rm = FALSE), as.numeric(NA))
expect_identical(w_sd(x, na.rm = FALSE), as.numeric(NA))
expect_equal(w_var(x, na.rm = FALSE), as.numeric(NA))
expect_identical(w_n(x, na.rm = FALSE), length(x))
expect_equal(w_se(x, na.rm = FALSE), NA*1)


##########################


expect_equal(w_mean(numeric(0)), as.numeric(NA))
expect_equal(w_sum(numeric(0)), 0)
expect_identical(w_median(numeric(0)), as.numeric(NA))
expect_identical(w_mad(numeric(0)), as.numeric(NA))
expect_identical(w_sd(numeric(0)), as.numeric(NA))
expect_equal(w_var(numeric(0)), as.numeric(NA))
expect_equal(w_n(numeric(0)), 0)
expect_equal(w_se(numeric(0)), NA*1)

#####################

x = na.omit(x)

expect_identical(w_mean(x, na.rm = FALSE), mean(x, na.rm = TRUE))
expect_identical(w_sum(x, na.rm = FALSE), sum(x, na.rm = TRUE))
expect_identical(w_median(x, na.rm = FALSE), median(x, na.rm = TRUE))
expect_identical(w_mad(x, na.rm = FALSE), matrixStats:::weightedMad(x, na.rm = TRUE))
expect_identical(w_sd(x, na.rm = FALSE), sd(x, na.rm = TRUE))
expect_equal(w_var(x, na.rm = FALSE), var(x, na.rm = TRUE))
expect_identical(w_n(x, na.rm = FALSE), sum(!is.na(x)))
expect_equal(w_se(x, na.rm = FALSE), sd(x)/sqrt(length(x)))

##############################
context("w_* weighted")

set.seed(123)
x = round(c(NA, runif(8, 1,2), NA), 5)
w = round(c(runif(6, 1,2), -1, NA, NA, 0), 5)
w2 = 2.5

w_prep = if_val(w, NA ~ 0, lt(0) ~ 0, other ~ copy)
w_prep2 = rep(w2, length(x))
expect_equal(w_mean(x, w), weighted.mean(x, w_prep, na.rm = TRUE))
expect_identical(w_sum(x, w), sum(x*w_prep, na.rm = TRUE))
expect_identical(w_median(x, w),
                 matrixStats:::weightedMedian(x, w, na.rm = TRUE, interpolate = FALSE, ties = "weighted"))
expect_identical(w_mad(x, w),
                 matrixStats:::weightedMad(x, w, na.rm = TRUE, center = w_median(x, w, na.rm = TRUE)))
expect_identical(w_sd(x, w), matrixStats:::weightedSd(x, w_prep, na.rm = TRUE))
expect_equal(w_var(x, w), matrixStats:::weightedVar(x, w_prep, na.rm = TRUE))
expect_identical(w_n(x, w), sum((!is.na(x))*w_prep))
expect_equal(w_se(x, w), 0.09577068)

##### data.frame
x = as.matrix(x)
w = as.matrix(w)

expect_equal(w_mean(x, w), weighted.mean(x, w_prep, na.rm = TRUE))
expect_identical(w_sum(x, w), sum(x*w_prep, na.rm = TRUE))
expect_identical(w_median(x, w),
                 matrixStats:::weightedMedian(x, w, na.rm = TRUE, interpolate = FALSE, ties = "weighted"))
expect_identical(w_mad(x, w),
                 matrixStats:::weightedMad(x, w, na.rm = TRUE, center = w_median(x, w, na.rm = TRUE)))
expect_identical(w_sd(x, w), matrixStats:::weightedSd(x, w_prep, na.rm = TRUE))
expect_equal(w_var(x, w), matrixStats:::weightedVar(x, w_prep, na.rm = TRUE))
expect_identical(w_n(x, w), sum((!is.na(x))*w_prep))
expect_equal(w_se(x, w), 0.09577068)

#### errors

x = data.frame(x, x)

expect_error(w_mean(x, w))
expect_error(w_sum(x, w))
expect_error(w_median(x, w))
expect_error(w_mad(x, w))
expect_error(w_sd(x, w))
expect_error(w_var(x, w))
expect_error(w_n(x, w))
expect_error(w_se(x, w))

x = 1:3
w = 1:2

expect_error(w_mean(x, w))
expect_error(w_sum(x, w))
expect_error(w_median(x, w))
expect_error(w_mad(x, w))
expect_error(w_sd(x, w))
expect_error(w_var(x, w))
expect_error(w_n(x, w))
expect_error(w_se(x, w))

####################

set.seed(123)
x = round(c(NA, runif(8, 1,2), NA), 5)
w = round(c(runif(6, 1,2), -1, NA, NA, 0), 5)
w2 = 2.5

w_prep = if_val(w, NA ~ 0, lt(0) ~ 0, other ~ copy)
w_prep2 = rep(w2, length(x))

expect_equal(w_mean(x, w2), weighted.mean(x, w_prep2, na.rm = TRUE))
expect_identical(w_sum(x, w2), sum(x*w_prep2, na.rm = TRUE))
expect_identical(w_median(x, w2),
                 matrixStats:::weightedMedian(x, w_prep2, na.rm = TRUE, interpolate = FALSE, ties = "weighted"))
expect_identical(w_mad(x, w2),
                 matrixStats:::weightedMad(x, w_prep2, na.rm = TRUE, center = w_median(x, w_prep2, na.rm = TRUE)))
expect_identical(w_sd(x, w2), matrixStats:::weightedSd(x, w_prep2, na.rm = TRUE))
expect_equal(w_var(x, w2), matrixStats:::weightedVar(x, w_prep2, na.rm = TRUE))
expect_identical(w_n(x, w2), sum((!is.na(x))*w_prep2))
expect_identical(w_se(x, w2),
                 weightedSd(x, rep(w2, length(x)), na.rm = TRUE)/sqrt(sum(w2*sum(!is.na(x)), na.rm = TRUE))
                 )

### SPSS compatibility
expect_equal(w_mean(x, w), 1.679588893639)
expect_equal(w_sum(x, w), 13.633172662)
expect_equal(w_median(x, w), 1.78831)
# expect_equal(w_mad(x, w), ???))
expect_equal(w_sd(x, w), 0.2728535109892)
expect_equal(w_var(x, w), 0.07444903845913)
expect_identical(w_n(x, w), 8.11697)

############################


w_prep = w_prep[-1]
x = x[-1]
w = w[-1]
expect_equal(w_mean(x, w, na.rm = FALSE), weighted.mean(x, w_prep, na.rm = TRUE))
expect_identical(w_sum(x, w, na.rm = FALSE), sum(x*w_prep, na.rm = TRUE))
expect_identical(w_median(x, w, na.rm = FALSE),
                 matrixStats:::weightedMedian(x, w, na.rm = TRUE, interpolate = FALSE, ties = "weighted"))
expect_identical(w_mad(x, w, na.rm = FALSE),
                 matrixStats:::weightedMad(x, w, na.rm = TRUE, center = w_median(x, w, na.rm = FALSE)))
expect_identical(w_sd(x, w, na.rm = FALSE), matrixStats:::weightedSd(x, w_prep, na.rm = TRUE))
expect_equal(w_var(x, w, na.rm = FALSE), matrixStats:::weightedVar(x, w_prep, na.rm = TRUE))
expect_identical(w_n(x, w, na.rm = FALSE), sum((!is.na(x))*w_prep))

###################################################
context("w_* unweighted corr")

set.seed(123)
x = round(c(NA, runif(8, 1,2), NA), 5)
w = round(c(runif(6, 1,2), -1, NA, NA, 0), 5)
w2 = 2.5
y = round(runif(10, 1,2), 5)
z = round(c(runif(4, 1,2), NA, runif(5, 1,2)), 5)
mat = cbind(x, y, z)


expect_identical(w_cov(mat), cov(mat, use = "pairwise", method = "pearson"))
expect_identical(w_cor(mat, use = "complete.obs"), cor(mat, use = "complete.obs", method = "pearson"))
expect_identical(w_spearman(mat, use = "complete.obs"), cor(mat, use = "complete.obs", method = "spearman"))

expect_identical(w_cov(mat, use = "complete.obs"), cov(mat, use = "complete.obs", method = "pearson"))
expect_identical(w_cor(mat, use = "pairwise"), cor(mat, use = "pairwise", method = "pearson"))
expect_identical(w_spearman(mat, use = "pairwise"), cor(mat, use = "pairwise", method = "spearman"))

no_na = complete.cases(mat)
no_na_mat = mat[no_na,]
no_na_weight = w[no_na]

spss_test = matrix(c(
0.0813215278408235, 0.0168017068808824, -0.0409740241110934,
0.0168017068808824, 0.181237036099309, -0.0216736154022414,
-0.0409740241110934, -0.0216736154022414, 0.0264754938663131
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")

expect_equal(w_cov(no_na_mat, weight = no_na_weight, use = "pairwise"), spss_test)

### spss compatibility



### listwise

spss_test = matrix(c(
0.111659084914286000,	-0.013518452721428600,	0.026995377314285700,
-0.013518452721428600,	0.123715589957143000,	-0.023094107421428600,
0.026995377314285700,	-0.023094107421428600,	0.089909922514285700
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")

expect_equal(w_cov(mat, use = "complete.obs"), spss_test)

spss_test = matrix(c(
    1, -0.115018510487387, 0.269425413538416,
    -0.115018510487387, 1, -0.218970270395182,
    0.269425413538416, -0.218970270395182, 1
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")

expect_equal(w_cor(mat, use = "complete.obs"), spss_test)

spss_test = matrix(c(
    1, 0.0357142857142857, 0.142857142857143,
    0.0357142857142857, 1, -0.25,
    0.142857142857143, -0.25, 1
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")

expect_equal(w_spearman(mat, use = "complete.obs"), spss_test)

#### pairwise

spss_test = matrix(c(
    0.109082205141071, -0.0236776149214286, 0.0269953773142857,
    -0.0236776149214286, 0.135374539223333, -0.0165463910986111,
    0.0269953773142857, -0.0165463910986111, 0.0687719168444444
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")

expect_equal(w_cov(mat, use = "pairwise"), spss_test)

spss_test = matrix(c(
    1.0000000000000000,	-0.2096142992350900,	0.2694254135384160,
    -0.2096142992350900,	1.0000000000000000,	-0.1665385657747600,
    0.2694254135384160,	-0.1665385657747600,	1.0000000000000000
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")

expect_equal(w_cor(mat, use = "pairwise"), spss_test)

spss_test = matrix(c(
    1, 0.0238095238095238, 0.142857142857143,
    0.0238095238095238, 1, 0,
    0.142857142857143, 0, 1
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")

expect_equal(w_spearman(mat, use = "pairwise"), spss_test)

#############################################################
#############################################################
#############################################################
#############################################################

context("w_* weighted corr")

### listwise

spss_test = matrix(c(
    0.0813215278408235, 0.0168017068808824, -0.0409740241110934,
    0.0168017068808824, 0.181237036099309, -0.0216736154022414,
    -0.0409740241110934, -0.0216736154022414, 0.0264754938663131
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")

expect_equal(w_cov(mat, weight = w, use = "complete.obs"), spss_test)

spss_test = matrix(c(
    1, 0.138397155314081, -0.883046998969516,
    0.138397155314081, 1, -0.312885798792214,
    -0.883046998969516, -0.312885798792214, 1
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")

expect_equal(w_cor(mat, weight = w, use = "complete.obs"), spss_test)

spss_test = matrix(c(
    1, 0.0357142857142857, 0.142857142857143,
    0.0357142857142857, 1, -0.25,
    0.142857142857143, -0.25, 1
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")


spss_test = matrix(c(
    1, 0.636363636363636, -1,
    0.636363636363636, 1, -0.636363636363636,
    -1, -0.636363636363636, 1
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")
expect_equal(w_spearman(mat, weight = round(w), use = "complete.obs"), spss_test)

#### pairwise

spss_test = matrix(c(
    0.0744490384591274, 0.00358640648902608, -0.0409740241110934,
    0.00358640648902608, 0.140927285583942, -0.0262374089953692,
    -0.0409740241110934, -0.0262374089953692, 0.0234118327104263
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")

expect_equal(w_cov(mat, weight = w, use = "pairwise"), spss_test)

spss_test = matrix(c(
    1, 0.0344607062288188, -0.883046998969516,
    0.0344607062288188, 1, -0.413148259010213,
    -0.883046998969516, -0.413148259010213, 1
), nrow = 3)

colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")

expect_equal(w_cor(mat, weight = w, use = "pairwise"), spss_test)

spss_test = matrix(c(
    1, 0.62962962962963, -1,
    0.62962962962963, 1, -0.555555555555556,
    -1, -0.555555555555556, 1
), nrow = 3)


colnames(spss_test) = c("x", "y", "z")
rownames(spss_test) = c("x", "y", "z")

expect_equal(w_spearman(mat, weight = w, use = "pairwise"), spss_test)

######################################
#####################################
context("weight = 1")
set.seed(123)
x = round(c(NA, runif(8, 1,2), NA), 5)
w = round(c(runif(6, 1,2), -1, NA, NA, 0), 5)
w2 = 2.5
y = round(runif(10, 1,2), 5)
z = round(c(runif(4, 1,2), NA, runif(5, 1,2)), 5)
mat = cbind(x, y, z)

expect_identical(w_mean(x, weight = 1), w_mean(x))
expect_identical(w_sum(x, weight = 1), w_sum(x))
expect_identical(w_median(x, weight = 1), w_median(x))
expect_identical(w_mad(x, weight = 1), w_mad(x))
expect_identical(w_sd(x, weight = 1), w_sd(x))
expect_identical(w_var(x, weight = 1), w_var(x))
expect_equal(w_n(x, weight = 1), w_n(x))
expect_identical(w_se(x, weight = 1), w_se(x))


expect_equal(w_cov(mat, weight = 1, use = "pairwise"), w_cov(mat, use = "pairwise"))
expect_equal(w_cor(mat, weight = 1, use = "pairwise"), w_cor(mat, use = "pairwise"))
expect_equal(w_spearman(mat, weight = 1, use = "pairwise"), w_spearman(mat, use = "pairwise"))

expect_equal(w_cov(mat, weight = 1, use = "complete.obs"), w_cov(mat, use = "complete.obs"))
expect_equal(w_cor(mat, weight = 1, use = "complete.obs"), w_cor(mat, use = "complete.obs"))
expect_equal(w_spearman(mat, weight = 1, use = "complete.obs"), w_spearman(mat, use = "complete.obs"))

#############


expect_equal(w_sd(x, weight = w/100), NA)
expect_equal(w_var(x, weight = w/100), NA)
expect_equal(w_se(x, weight = w/100), NA)

na_mat = matrix(NA, 3, 3)*1.2
colnames(na_mat) = c("x", "y", "z")
rownames(na_mat) = c("x", "y", "z")
expect_equal(w_cov(mat, weight = w/100, use = "pairwise"), na_mat)
expect_equal(w_cor(mat, weight = w/100, use = "pairwise"), na_mat)
expect_equal(w_spearman(mat, weight = w/100, use = "pairwise"), na_mat)

expect_equal(w_cov(mat, weight = w/100, use = "complete.obs"), na_mat)
expect_equal(w_cor(mat, weight = w/100, use = "complete.obs"), na_mat)
expect_equal(w_spearman(mat, weight = w/100, use = "complete.obs"), na_mat)


#########
context("weighted statistics labels")


data(mtcars)
dfs = mtcars %keep% qc(mpg, disp, hp, wt)

# apply labels
dfs = modify(dfs, {
    var_lab(mpg) = "Miles/(US) gallon"
    var_lab(disp) = "Displacement (cu.in.)"
    var_lab(hp) = "Gross horsepower"
    var_lab(wt) = "Weight (1000 lbs)"
})

labs =    c("Miles/(US) gallon"
            ,"Displacement (cu.in.)"
            ,"Gross horsepower"
            ,"Weight (1000 lbs)"
)
# weighted correlations with labels
res = w_cor(dfs)

expect_identical(
    colnames(res),
    labs
)

expect_identical(
    rownames(res),
    labs
)

res = w_cov(dfs)

expect_identical(
    colnames(res),
    labs
)
expect_identical(
    rownames(res),
    labs
)

res = w_spearman(dfs)

expect_identical(
    colnames(res),
    labs
)
expect_identical(
    rownames(res),
    labs
)