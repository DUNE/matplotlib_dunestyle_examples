# DUNE matplotlib style examples

Template repository for DUNE plots and tables that follow the official
[dune_plot_style](https://github.com/DUNE/dune_plot_style), drawn with
[plotipus](https://github.com/mantheys/plotipus).

The analysis writes its results as pickled pandas DataFrames; every figure is
then **one line** in a plain-text command list:

```bash
hist --datafile Hist1D -x Values --hue Sample --bins 50 --rangex -5 5 --dune_label simulation
```

Styling (DUNE style sheet, Okabe-Ito colours, `DUNE Simulation` /
`DUNE Preliminary` watermarks) is applied by a small plotipus plugin, so the
command lists only describe *what* to draw.

| | | |
|---|---|---|
| ![](docs/gallery/hist1d.png) | ![](docs/gallery/datafit.png) | ![](docs/gallery/hist2d.png) |
| ![](docs/gallery/contour.png) | ![](docs/gallery/stacked.png) | ![](docs/gallery/overlay.png) |
| ![](docs/gallery/efficiency.png) | ![](docs/gallery/resolution.png) | ![](docs/gallery/reco_vs_true.png) |

The first six reproduce the examples shipped with dune_plot_style
(`examples/matplotlib/example.py`); the last row shows typical analysis
figures (one curve per detector configuration and sample, binned estimators,
per-configuration 2D maps).

## Quick start

```bash
git clone https://github.com/DUNE/matplotlib_dunestyle_examples.git
cd matplotlib_dunestyle_examples
source setup.sh             # .venv with dune_plot_style + plotipus
python run_examples.py      # toy data, then every figure and table
```

Figures land in `output/plots`, LaTeX/HTML tables in `output/tables`.
`source setup.sh --latest` installs the newest dune_plot_style release
instead of the pinned one.

Once the data exist, single lists or commands run directly:

```bash
plotipus run dune                    # input/plots/dune_scripts.txt
plotipus run showcase --match Events # only the matching commands
plotipus run dune --tables           # input/tables/dune_scripts.txt
plotipus line --help                 # every option of a plot kind
```

## Layout

```
plotipus.toml                 project: data root, command lists, style, plugin
config/style.json             label/colour mappings, legend conventions
src/dune_plotipus/            plugin: DUNE style sheet + watermark options
scripts/make_example_data.py  stand-in for an analysis: writes input/data/*.pkl
input/plots/*_scripts.txt     one figure per line
input/tables/*_scripts.txt    one table per line
output/                       generated (git-ignored)
docs/gallery/                 the figures shown above
```

## Making your own plots

1. **Store results as DataFrames**, one row per series, whole arrays in the
   cells (see `scripts/make_example_data.py`):

   ```python
   pd.DataFrame([{"Energy": energy, "Efficiency": eff, "EfficiencyError": err,
                  "Config": "hd_1x2x6", "Name": "marley", "Variable": "Efficiency"}]
                ).to_pickle("input/data/hd_1x2x6_marley_Efficiency.pkl")
   ```

   A `<Column>Error` column is picked up by `--errory`; `Config`/`Name`
   columns (and the `{config}_{name}_{datafile}.pkl` file names) let one
   command overlay detector configurations and samples.

2. **Add a line** to a command list in `input/plots/`. The six plot kinds
   are `line`, `scatter`, `hist`, `map`, `cat` and `table`; lower panels
   (`--lower ratio`, `--lower residual`, ...), stored fits (`--fit`),
   binned estimators (`--binned --estimator rms`) and per-panel variables
   are options of the same commands. See the
   [plotipus README](https://github.com/mantheys/plotipus#readme).

3. **Name things once** in `config/style.json`: `config_dict`/`name_dict`
   give legend labels, `config_color`/`config_line` colours and line styles.

## DUNE options

The plugin (`src/dune_plotipus`) enables `dune.mplstyle` and adds these
options to every plot kind:

| Option | Default | |
|---|---|---|
| `--dune_label {simulation,preliminary,wip,official,simulation_side,none}` | `[settings] dune_label` | watermark on the first panel |
| `--dune_label_position X Y` | dunestyle's upper left | axes coordinates of the watermark |
| `--dune_label_size SIZE` | `xx-large` | watermark font size |
| `--dune_headroom FRACTION` | `0.2` | y range added on top so the watermark does not cover data |

`[settings] dune_colors = "logo"` in `plotipus.toml` switches to the
DUNE-logo subset of the Okabe-Ito palette. Approved results only may carry
the bare `official` watermark; follow the
[DUNE plot guidelines](https://github.com/DUNE/dune_plot_style/blob/main/guidelines.md).

## Using this template

Click *Use this template* on GitHub (or copy the repository), then replace
`scripts/make_example_data.py` with your analysis output (or point
`data_root` in `plotipus.toml` at it), and write your own command lists.
Extra output directories per list (e.g. a paper's `Figures/` folder) go in
`plotipus.toml`:

```toml
[outputs.plots]
paper = ["../my_paper/Figures"]
```

## License

MIT, see [LICENSE](LICENSE).
