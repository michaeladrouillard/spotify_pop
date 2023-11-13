## Overview of Paper

This paper uses audio features data from the Spotify API to analyze patterns in contemporary pop prudction. Specifically, we build a logistic regression and a random forest to detect stylistic variation among artists and pop producers, with a focus on Jack Antonoff.

## File Structure

The repo is structured as the following:

-   `inputs/data` contains the raw data sources form GSS.

-   `outputs/paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper.

-   `scripts` contains the R scripts used to download, clean and validate data, as well as the models used in this paper.

## How to Run

1.  Run `scripts/01-download_data.R` to download raw data.

2.  Run `scripts/02-data_cleaning.R` to generate cleaned data.

3.  Run `scripts/03-test_data.R` to validate data integrity

4.  Run `outputs/paper/paper.qmd` to generate the PDF of the paper, or view the pre-generated PDF at paper.pdf.
