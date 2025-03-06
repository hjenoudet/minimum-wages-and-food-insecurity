######################################################
# analysis.R
# 
# Difference-in-Differences and Two-Way Fixed Effects
# Analyses for Minimum Wages and Food Insecurity Data
######################################################

# Load the data
load("data/data.Rdata") 
# Make sure the .Rdata file is placed in the `data` folder
# or adjust the path if necessary.

# The data frame for the first set of analysis is "CAMW"
# The data frame for the second set of analysis is "USMW"

#########################################
# Libraries
#########################################
library(dplyr)
library(ggplot2)

#########################################
# DIFFERENCE-IN-DIFFERENCE ANALYSIS 
# For Two Groups of Households in California in 2014
#########################################

# Create treatment Period and Treatment Group variable
CAMW$TreatPer <- CAMW$Month > 6
CAMW$TreatGroup <- CAMW$Group == "MinWage"

# Summarize Calories by Group
Table_1 <- CAMW %>%
  group_by(TreatGroup, TreatPer) %>%
  summarize(Cals = mean(Calories, na.rm = TRUE),
            .groups = "drop")
print(Table_1)

# Summarize BasketScore by Group
Table_2 <- CAMW %>%
  group_by(TreatGroup, TreatPer) %>%
  summarize(BScore = mean(BasketScore, na.rm = TRUE),
            .groups = "drop")
print(Table_2)

#########################################
# PARALLEL TRENDS VISUALIZATIONS 
#########################################

# Parallel Trends for Calories
ggplot(CAMW, aes(x = Month, y = Calories, color = Group)) +
  stat_summary(fun = mean, geom = "line") +
  scale_x_continuous(breaks = seq(min(CAMW$Month), max(CAMW$Month), by = 1)) +
  labs(
    title = "Figure 1. Calories Per Household Per Person vs Month for Different Household Groups",
    x = "Month",
    y = "Calories Per Household Per Person"
  ) +
  theme_minimal()

# Parallel Trends for BasketScore 
ggplot(CAMW, aes(x = Month, y = BasketScore, color = Group)) +
  stat_summary(fun = mean, geom = "line") +
  scale_x_continuous(breaks = seq(min(CAMW$Month), max(CAMW$Month), by = 1)) +
  labs(
    title = "Figure 2. BasketScore Per Shopping Basket Per Household vs Month for Different Household Groups",
    x = "Month",
    y = "BasketScore Per Shopping Basket Per Household"
  ) +
  theme_minimal()

#########################################
# FORMAL PARALLEL TRENDS TESTS FOR CAMW
#########################################

# For Calories
CAMW_Test <- CAMW %>%
  filter(Month <= 6) %>%
  mutate(Month = factor(Month),
         Group = factor(Group))

Table_3 <- lm(data = CAMW_Test, Calories ~ Month * Group)
summary(Table_3)
# Multiple significant interactions, the lines are not parallel.

# For BasketScore
Table_4 <- lm(data = CAMW_Test, BasketScore ~ Month * Group)
summary(Table_4)
# Not a statistically significant interaction, the lines are parallel.

#########################################
# DIFFERENCE-IN-DIFFERENCE ANALYSIS
# For BasketScore 
#########################################

Table_5 <- lm(data = CAMW, BasketScore ~ TreatPer * TreatGroup)
summary(Table_5)

#########################################
# TWO-WAY FIXED EFFECTS ANALYSIS 
#########################################

# The data frame for this analysis is "USMW"
USMW_Tidy <- USMW %>%
  mutate(YearCode = dplyr::recode(Year, "2014" = 0, "2015" = 12, "2016" = 24),
         MonthID = YearCode + Month)

# Parallel Trends Visualizations
# For Calories
ggplot(USMW_Tidy, aes(x = MonthID, y = Calories, color = State)) +
  stat_summary(fun = mean, geom = "line") +
  scale_x_continuous(breaks = seq(min(USMW_Tidy$MonthID), max(USMW_Tidy$MonthID), by = 1)) +
  labs(
    title = "Figure 3. Calories Per Household Per Person vs MonthID for Different States",
    x = "MonthID",
    y = "Calories Per Household Per Person"
  ) +
  theme_minimal()

# For BasketScore
ggplot(USMW_Tidy, aes(x = MonthID, y = BasketScore, color = State)) +
  stat_summary(fun = mean, geom = "line") +
  scale_x_continuous(breaks = seq(min(USMW_Tidy$MonthID), max(USMW_Tidy$MonthID), by = 1)) +
  labs(
    title = "Figure 4. BasketScore Per Shopping Basket Per Household vs MonthID for Different States",
    x = "MonthID",
    y = "BasketScore Per Basket Per Household"
  ) +
  theme_minimal()

#########################################
# FORMAL PARALLEL TRENDS TEST FOR USMW
#########################################

USMW_Tidy$MonthID <- as.numeric(USMW_Tidy$MonthID)

USMW_Tidy_Test <- USMW_Tidy %>%
  filter(MonthID < 9) %>%
  mutate(MonthID = factor(MonthID), State = factor(State))

# For Calories
Table_6 <- lm(data = USMW_Tidy_Test, Calories ~ MonthID * State)
summary(Table_6)
# No significant interactions, the trends are parallel.

# For BasketScore
Table_7 <- lm(data = USMW_Tidy_Test, BasketScore ~ MonthID * State)
summary(Table_7)
# Multiple significant interactions, thus the trends are not parallel.

#########################################
# TWO-WAY FIXED EFFECT MODEL
# For Calories
#########################################
USMW_Tidy <- USMW_Tidy %>%
  mutate(MonthID = factor(MonthID),
         MinWage = as.numeric(MinWage))

Table_8 <- lm(data = USMW_Tidy, Calories ~ State + MonthID + MinWage)
summary(Table_8)