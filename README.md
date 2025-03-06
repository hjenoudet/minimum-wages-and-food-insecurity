# minimum-wages-and-food-insecurity
Analyzing the impact of minimum wage policies on food insecurity using difference-in-differences and two-way fixed effects models in R. Includes data summaries, visualizations, and formal statistical tests.

## Project Details

This project:
- Loads household consumption and basket data from California (and across multiple states).
- Explores trends in key variables (Calories, BasketScore) visually.
- Tests for parallel trends in pre-treatment data.
- Runs difference-in-differences and two-way fixed effects regressions to identify policy impacts.

**Data:**  
All data is located in the [`data/`](data/) folder. The primary dataset is in `HW2.Rdata`. The scripts assume the `.Rdata` file is located there.

**Scripts:**  
The core analysis is located in [`scripts/analysis.R`](scripts/analysis.R).

**Dependencies:**  
See [`requirements.txt`](requirements.txt) for a minimal list of R packages used.

## Contributing

If you’d like to contribute or report any issues, please open a Pull Request or file an Issue on this repository.

## Acknowledgments

I would like to thank Professor Mike Palazzolo (Assistant Professor of Marketing, UC Davis Graduate School of Management, Research Affiliate, Center for Poverty & Inequality Research) for their guidance and for allowing me to share this project. Their insights and support were invaluable in completing this analysis.
