(*!
 * `use` is available in some SML implementations, like [SML/NJ][smlnj], but not others, like
 * [MLton][]. It is also not available in [Millet][].
 *
 * When it is available, usually, the approximate semantics of calling `use f2` from a file `f1` is
 * to "load" the contents of `f2`, and bring everything defined by that file `f2` into the scope of
 * `f1`.
 *
 * A small example:
 *
 * ```sml
 * (* f1.sml *)
 * val x = 3
 * (* f2.sml *)
 * use "f1.sml";
 * val y = x + 4
 * ```
 *
 * `use` is sometimes used for small-scale multi-file SML projects. For larger projects, consider:
 *
 * - [SML/NJ Compilation Manager][cm]
 * - [ML Basis][mlb]
 *
 * [smlnj]: https://www.smlnj.org
 * [MLton]: http://mlton.org
 * [Millet]: https://azdavis.net/posts/millet/
 * [cm]: https://www.smlnj.org/doc/CM/new.pdf
 * [mlb]: http://mlton.org/MLBasis
 *)
fun use (_ : string) = ()
