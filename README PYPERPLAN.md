#Requisiti

Pyperplan requires [Python](https://python.org) >= 3.6.

# Installation

Installare pyperplan con pip

    pip install pyperplan

Eseguire questo comando nella cartella "Pyperplan"

    pip install --editable .

# Usage

For a list of available search algorithms and heuristics, run

    pyperplan --help

For more information on using the planner and how to extend it to do
more fancy stuff, see the [documentation](doc/documentation.md).

The `pyperplan` executable accepts two arguments: a PDDL domain file and a
PDDL problem file. Example:

    pyperplan benchmarks/tpp/domain.pddl benchmarks/tpp/instance1.pddl

The domain file can be omitted, in which case the planner will attempt
to guess its name based on the problem file. If a plan is found, it is
stored alongside the problem file with a .soln extension.

By default, the planner performs a blind breadth-first search, which
does not scale very well. Heuristic search algorithms are available. For
example, to use greedy-best-first search with the FF heuristic, run

    pyperplan -H hff -s gbf DOMAIN PROBLEM


