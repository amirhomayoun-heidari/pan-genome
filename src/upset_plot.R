
library(data.table)
sv <- fread("goat_pg_SV_biallelic_header.tsv")
dim(sv)
View(sv)


#my data contains NA so I have to use as.numeric for the further calculation otherwise these NA would be problems.
# sample columns in your table
sample_cols <- names(sv)[5:40]

#this code considers all the rows and columns from 5 to 40 and make them numeric
sv[, (sample_cols) := lapply(.SD, function(x) as.numeric(as.character(x))), .SDcols = sample_cols]
 
#count how many missing genotype do we have 
table(is.na(sv[, ..sample_cols]))
#result  FALSE= 3545464   TRUE=88052 


#I compute SV length by calculating between ALT and REF allele length and I make 4 new columns here 
sv[, ref_len := nchar(REF)]
sv[, alt_len := nchar(ALT)]
sv[, sv_length := alt_len - ref_len]
sv[, abs_sv_length := abs(sv_length)]

#determine if its an insertion or deletion
sv[, sv_type := ifelse(sv_length > 0, "INS", "DEL")]


# now I calculate how many samples contain these SV the numbers must be between 0(none: sometimes possible) to 36(all breeds have this SV)
# I should use this because I have already used some new columns to the table but I should not count them as genotypes
# also should not forget that I have some NA is my table and should use na.rm

sample_cols <- names(sv)[5:40]

sv[, sv_carriers := rowSums(.SD, na.rm = TRUE), .SDcols = sample_cols]


# barplot for having an idea about the dispretion of SVs.
barplot(table(sv$sv_carriers))

# now lets make a classification by ourselves and imagine if SV is present in only one sample is private if between 2-5 samples rare 
# if more than 20 common

sv[, sv_class :=
     fifelse(sv_carriers == 1, "private",
             fifelse(sv_carriers <= 5, "rare",
                     fifelse(sv_carriers <= 20, "common",
                             "core")))]


#################################################
#Lets go with classification


italian_haps <- c(
  "Bionda_dell_adamello_cp095_001p0002_hap1",
  "Bionda_dell_adamello_cp095_001p0002_hap2",
  "giorgintana_ca669_s09_001p0003_hap1",
  "giorgintana_ca669_s09_001p0003_hap2",
  "nicastrese_cp095_001p0001_hap1",
  "nicastrese_cp095_001p0001_hap2",
  "orobica_ca669_s09_001p0002_hap1",
  "orobica_ca669_s09_001p0002_hap2",
  "valdostana_ca669_s09_001p0001_hap1",
  "valdostana_ca669_s09_001p0001_hap2"
)


domestic_public <- c(
  "alpine_milk_goat2_hap1",
  "alpine_milk_goat2_hap2",
  "boer2_hap1",
  "boer2_hap2",
  "guanzhong_milk_goat2_hap1",
  "guanzhong_milk_goat2_hap2",
  "hanian_black_goat2_hap1",
  "hanian_black_goat2_hap2",
  "inner_mongolia_cashmere_aebs_806099",
  "inner_mongolia_cashmere_t2t_goat2",
  "nguni",
  "nubian2_hap1",
  "nubian2_hap2",
  "saanen_diary_goat",
  "shanbei_cashmere",
  "shannan_white_goat2_hap1",
  "shannan_white_goat2_hap2",
  "shannan_white_goat3_hap1",
  "shannan_white_goat3_hap2",
  "tibetan2_hap1",
  "tibetan2_hap2",
  "xiong_saanen_dairy_goat",
  "yunna_black_goat"
)


wild_samples <- c(
  "capra_ibex",
  "capra_nubiana_hap1",
  "capra_nubiana_hap2"
)



#COLLAPSING
# I want to merge the haplotypes and each 2 haplotypes would become 1 individuls meaning that    presence = 1. if any haplotype has the SV

library(data.table)
library(ComplexUpset)
library(ggplot2)

# sample columns in my table
sample_cols <- names(sv)[5:40]

# I have to make sure genotype columns are numeric for the 10th time
sv[, (sample_cols) := lapply(.SD, function(x) as.numeric(as.character(x))), .SDcols = sample_cols]

# ---- define biological individuals ----
sample_map <- list(
  Bionda = c("Bionda_dell_adamello_cp095_001p0002_hap1",
             "Bionda_dell_adamello_cp095_001p0002_hap2"),
  
  Girgentana = c("giorgintana_ca669_s09_001p0003_hap1",
                 "giorgintana_ca669_s09_001p0003_hap2"),
  
  Nicastrese = c("nicastrese_cp095_001p0001_hap1",
                 "nicastrese_cp095_001p0001_hap2"),
  
  Orobica = c("orobica_ca669_s09_001p0002_hap1",
              "orobica_ca669_s09_001p0002_hap2"),
  
  Valdostana = c("valdostana_ca669_s09_001p0001_hap1",
                 "valdostana_ca669_s09_001p0001_hap2"),
  
  Alpine_milk = c("alpine_milk_goat2_hap1",
                  "alpine_milk_goat2_hap2"),
  
  Boer = c("boer2_hap1",
           "boer2_hap2"),
  
  Guanzhong_milk = c("guanzhong_milk_goat2_hap1",
                     "guanzhong_milk_goat2_hap2"),
  
  Hanian_black = c("hanian_black_goat2_hap1",
                   "hanian_black_goat2_hap2"),
  
  Inner_Mongolia_AEBS = c("inner_mongolia_cashmere_aebs_806099"),
  Inner_Mongolia_T2T = c("inner_mongolia_cashmere_t2t_goat2"),
  Nguni = c("nguni"),
  
  Nubian = c("nubian2_hap1",
             "nubian2_hap2"),
  
  Saanen_dairy = c("saanen_diary_goat"),
  Shanbei_cashmere = c("shanbei_cashmere"),
  
  Shannan_white_2 = c("shannan_white_goat2_hap1",
                      "shannan_white_goat2_hap2"),
  
  Shannan_white_3 = c("shannan_white_goat3_hap1",
                      "shannan_white_goat3_hap2"),
  
  Tibetan = c("tibetan2_hap1",
              "tibetan2_hap2"),
  
  Xiong_Saanen = c("xiong_saanen_dairy_goat"),
  Yunnan_black = c("yunna_black_goat"),
  
  Capra_ibex = c("capra_ibex"),
  Capra_nubiana = c("capra_nubiana_hap1",
                    "capra_nubiana_hap2")
)



# Then I collaps them to one column per biological individuals

# build collapsed individual-level matrix

library(data.table)
library(ComplexUpset)
library(ggplot2)

# keep only basic variant columns for now then later will add  it
collapsed_dt <- copy(sv[, .(CHROM, POS, REF, ALT)])

# build collapsed individual level columns from sv
for (nm in names(sample_map)) {
  cols <- sample_map[[nm]]
  cols <- cols[cols %in% names(sv)]
  
  if (length(cols) == 0) {
    message("No matching columns found for: ", nm)
    next
  }
  
  collapsed_dt[, (nm) := as.integer(rowSums(sv[, ..cols], na.rm = TRUE) > 0)]
}

########################################### its a bit tuff code i should work on it more 


################################################
# Italian-only upset plot
italian_individuals <- c("Bionda", "Girgentana", "Nicastrese", "Orobica", "Valdostana")

sv_it <- copy(collapsed_dt)

sv_it[, carriers := rowSums(.SD, na.rm = TRUE), .SDcols = italian_individuals]

sv_it_plot <- sv_it[carriers >= 1 & carriers <= length(italian_individuals)]

sv_it_plot[, (italian_individuals) := lapply(.SD, function(x) x == 1), .SDcols = italian_individuals]

upset(
  sv_it_plot,
  intersect = italian_individuals,
  min_size = 3,
  sort_intersections_by = "cardinality",
  base_annotations = list(
    "Intersection size" = intersection_size()
  )
)

##################################################################






library(data.table)
library(ComplexUpset)
library(ggplot2)

# -----------------------------
# INPUT: collapsed_dt already created
# It should contain:
# CHROM, POS, REF, ALT
# and collapsed individual columns such as:
# Nicastrese, Girgentana, Bionda, Valdostana, Orobica,
# Guanzhong_milk, Hanian_black, Tibetan, Shanbei_cashmere, Yunnan_black,
# Capra_ibex, Capra_nubiana
# -----------------------------

# -----------------------------
# GROUP DEFINITIONS
# -----------------------------
italian <- c(
  "Nicastrese",
  "Girgentana",
  "Bionda",
  "Valdostana",
  "Orobica"
)

wild <- c(
  "Capra_ibex",
  "Capra_nubiana"
)

chinese <- c(
  "Guanzhong_milk",
  "Hanian_black",
  "Tibetan",
  "Shanbei_cashmere",
  "Yunnan_black"
)

# -----------------------------
# PLOT 2: Italian vs Wild
# -----------------------------
italian_wild <- c(wild, italian)

sv_iw <- copy(collapsed_dt)

sv_iw[, carriers := rowSums(.SD, na.rm = TRUE), .SDcols = italian_wild]

sv_iw_plot <- sv_iw[
  carriers >= 1 &
  carriers < length(italian_wild)
]

sv_iw_plot[, (italian_wild) := lapply(.SD, function(x) x == 1),
           .SDcols = italian_wild]

p_iw <- upset(
  sv_iw_plot,
  intersect = italian_wild,
  min_size = 50,
  n_intersections = 15,
  sort_intersections_by = "cardinality",
  width_ratio = 0.20,
  base_annotations = list(
    "Intersection size" = intersection_size(
      text = list(size = 3)
    )
  )
)

ggsave("upset_italian_vs_wild.png", p_iw, width = 12, height = 8, dpi = 300)

# -----------------------------
# PLOT 3: Italian vs Chinese domestic
# -----------------------------
italian_chinese <- c(
  "Yunnan_black",
  "Nicastrese",
  "Girgentana",
  "Tibetan",
  "Bionda",
  "Hanian_black",
  "Guanzhong_milk",
  "Valdostana",
  "Orobica",
  "Shanbei_cashmere"
)

sv_ic <- copy(collapsed_dt)

sv_ic[, carriers := rowSums(.SD, na.rm = TRUE), .SDcols = italian_chinese]

sv_ic_plot <- sv_ic[
  carriers >= 1 &
  carriers < length(italian_chinese)
]

sv_ic_plot[, (italian_chinese) := lapply(.SD, function(x) x == 1),
           .SDcols = italian_chinese]

p_ic <- upset(
  sv_ic_plot,
  intersect = italian_chinese,
  min_size = 100,
  n_intersections = 15,
  sort_intersections_by = "cardinality",
  width_ratio = 0.22,
  base_annotations = list(
    "Intersection size" = intersection_size(
      text = list(size = 3)
    )
  )
)

ggsave("upset_italian_vs_chinese.png", p_ic, width = 14, height = 8, dpi = 300)

# -----------------------------
# PLOT 4: Final representative 3-group comparison
# Italian + Chinese + Wild
# -----------------------------
three_group <- c(
  "Capra_nubiana",
  "Capra_ibex",
  "Nicastrese",
  "Girgentana",
  "Bionda",
  "Valdostana",
  "Orobica",
  "Guanzhong_milk",
  "Tibetan",
  "Yunnan_black"
)

sv_3g <- copy(collapsed_dt)

sv_3g[, carriers := rowSums(.SD, na.rm = TRUE), .SDcols = three_group]

sv_3g_plot <- sv_3g[
  carriers >= 1 &
  carriers < length(three_group)
]

sv_3g_plot[, (three_group) := lapply(.SD, function(x) x == 1),
           .SDcols = three_group]

p_3g <- upset(
  sv_3g_plot,
  intersect = three_group,
  min_size = 100,
  n_intersections = 18,
  sort_intersections_by = "cardinality",
  width_ratio = 0.22,
  base_annotations = list(
    "Intersection size" = intersection_size(
      text = list(size = 3)
    )
  )
)

ggsave("upset_italian_chinese_wild.png", p_3g, width = 14, height = 8, dpi = 300)






#################################################################
