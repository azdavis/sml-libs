# sml-libs

Signatures for various SML libraries.

Originally a part of [Millet][] that I pulled out into its own repo.

Mostly scraped from public documentation websites using [sml-libs-scraper][], with some manual formatting tweaks.

## Licenses

Most of the the SML files within are basically just remixes/alternative presentations of content from various public websites.

Each directory in `src` came from different sources, and are covered by different licenses.

| Directory         | Source        | License                 |
| ----------------- | ------------- | ----------------------- |
| `mlton`           | [mlton][]     | `LICENSE-MLTON.txt`     |
| `sml_of_nj`       | [sml-of-nj][] | `LICENSE-SMLNJ.txt`     |
| `smlnj_lib`       | [smlnj-lib][] | `LICENSE-SMLNJ.txt`     |
| `std_basis`       | [basis][]     | `LICENSE-STD-BASIS.txt` |
| `std_basis_extra` | [extra][]     | Unknown                 |

[millet]: https://github.com/azdavis/millet
[sml-libs-scraper]: https://github.com/azdavis/sml-libs-scraper
[basis]: https://smlfamily.github.io/Basis
[smlnj-lib]: https://www.smlnj.org/doc/smlnj-lib
[sml-of-nj]: https://www.smlnj.org/doc/SMLofNJ/pages/index-all.html
[mlton]: http://mlton.org/MLtonStructure
[extra]: https://github.com/SMLFamily/BasisLibrary
