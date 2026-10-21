#!/usr/bin/env python3
"""Write the toy data and draw every example with plotipus.

    python run_examples.py              # all command lists and tables
    python run_examples.py dune         # one list (input/plots/dune_scripts.txt)

Figures go to output/plots, tables to output/tables.
"""

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
LISTS = ["dune", "showcase"]


def run(*command):
    print("$", " ".join(command), flush=True)
    return subprocess.call(command, cwd=ROOT)


def main():
    lists = sys.argv[1:] or LISTS
    failed = run(sys.executable, "scripts/make_example_data.py")
    for name in lists:
        failed += run("plotipus", "run", name)
        if (ROOT / "input" / "tables" / f"{name}_scripts.txt").is_file():
            failed += run("plotipus", "run", name, "--tables")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
