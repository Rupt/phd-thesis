# Two leptons, jets, and missing transverse momentum in ATLAS: yet more non-evidence for supersymmetry

My PhD thesis. Published online at https://doi.org/10.17863/CAM.96552.

- Centers on my contributions to
"Searches for new phenomena in events with two leptons, jets, and missing transverse momentum
in $139\\,\mathrm{fb}^{−1}$ of $\sqrt{s} = 13\\,\mathrm{T e\kern-0.15ex V}$ $pp$ collisions with the ATLAS detector"
([EPJC](https://doi.org/10.1140/epjc/s10052-023-11434-w))
([arXiv](https://arxiv.org/abs/2204.13072)).
- I felt thoroughly dissatisfied with the honesty and rigour of our collaboration's scientific procedures.
This thesis present various details that are not reported in the publication.

Submitted September 2022. Passed with minor corrections.

Get this thesis template at https://github.com/Rupt/minithesis.

Other publications from this PhD project:

- ["A method to challenge symmetries in data with self-supervised learning"](https://github.com/Rupt/paper-which-is-real)
- ["Hunting for vampires and other unlikely forms of parity violation at the Large Hadron Collider"](https://github.com/Rupt/paper-hunting-vampires")
- [Rupert Tombs on Inspire HEP](https://inspirehep.net/authors/1788318)

## Build this thesis

Build all versions:

```bash
make -j

```

- `main.pdf` is a draft without figures.
- `main.hard.pdf` is the hard-bound version.
- `main.soft.pdf` is the soft-bound version.
- `-j` makes all three versions in parallel.


Build the draft version only, for speed:

```bash
make draft

```

## Clean up after builds

```bash
make clean

```
