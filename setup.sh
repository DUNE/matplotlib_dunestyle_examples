#!/bin/bash
# Create .venv with the official DUNE plot style and plotipus.
#   source setup.sh            # pinned dune_plot_style release (requirements.txt)
#   source setup.sh --latest   # latest dune_plot_style release instead
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install --quiet --upgrade pip
python3 -m pip install --quiet -r requirements.txt
if [ "$1" == "--latest" ]; then
    TAG=$(curl --silent "https://api.github.com/repos/DUNE/dune_plot_style/releases" \
        | python3 -c "import json, sys; print(next(r['tag_name'] for r in json.load(sys.stdin) if not r['prerelease']))")
    python3 -m pip install --quiet --force-reinstall --no-deps \
        "dune_plot_style @ https://github.com/DUNE/dune_plot_style/archive/refs/tags/${TAG}.tar.gz"
    echo "dune_plot_style ${TAG} installed"
fi
echo "Environment ready: run 'python run_examples.py'"
