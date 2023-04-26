Hello


In this "paper", I'm trying to figure out 1) how to describe Jack Antonoff's sound, 2) see if there is, indeed, a Jack Antonoff-ification of pop music and 3) get to the bottom of what the Spotify variables "danceability" and "valence" are capturing.


## File Structure

The repo is structured as the following:

-   `inputs/data` contains the data used in the paper.

-   `outputs/paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper.

-   `scripts` contains the R scripts used to download, clean, validate and explore the data, along with the model script.

## How to Run

1.  Run `scripts/01-download_data_spotify.R`  to download the data from Spotify

2.  Run `scripts/02-data_cleaning.R` to generate cleaned data, merge artists discographies into one dataset, and add the "jack" binary variable.

3.  Run `scripts/03-test_data.R` to validate the jack variable

4.  Run `06-models.R` to apply the model to the data.

5.  Run `outputs/paper/paper.qmd` to generate the PDF of the paper


`05-graphs.R`, `07-valencetesting.R`, and `08-understandingthevariables.R` are all EDA artifacts.
