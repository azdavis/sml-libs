(*!
 * The Array2 structure provides polymorphic mutable 2-dimensional arrays. As with 1-dimensional
 * arrays, these arrays have the equality property that two arrays are equal if they are the same
 * array, i.e., created by the same call to a primitive array constructor such as array, fromList,
 * etc.; otherwise they are not equal. This also holds for arrays of zero length. Thus, the type ty
 * array admits equality even if ty does not.
 *
 * The elements of 2-dimensional arrays are indexed by pair of integers (i,j) where i gives the row
 * index, and i gives the column index. As usual, indices start at 0, with increasing indices going
 * from left to right and, in the case of rows, from top to bottom.
 *)
signature ARRAY2 (* OPTIONAL *) = sig
  eqtype 'a array
  (*!
   * This type specifies a rectangular subregion of a 2-dimensional array. If ncols equals SOME(w),
   * with 0 <= w, the region includes only those elements in columns with indices in the range from
   * col to col + (w - 1), inclusively. If ncols is NONE, the region includes only those elements
   * lying on or to the right of column col. A similar interpretation holds for the row and nrows
   * fields. Thus, the region corresponds to all those elements with position (i,j) such that i lies
   * in the specified range of rows and j lies in the specified range of columns. A region reg is
   * said to be valid if it denotes a legal subarray of its base array. More specifically, reg is
   * valid if 0 <= #row reg <= nRows (#base reg) when #nrows reg = NONE, or 0 <= #row reg <= (#row
   * reg)+nr <= nRows (#base reg) when #nrows reg = SOME(nr), and the analogous conditions hold for
   * columns.
   *)
  type 'a region = { base : 'a array, row : int, col : int, nrows : int option, ncols : int option }
  (*!
   * This type specifies a way of traversing a region. Specifically, RowMajor indicates that, given
   * a region, the rows are traversed from left to right (smallest column index to largest column
   * index), starting with the first row in the region, then the second, and so on until the last
   * row is traversed. ColMajor reverses the roles of row and column, traversing the columns from
   * top down (smallest row index to largest row index), starting with the first column, then the
   * second, and so on until the last column is traversed.
   *)
  datatype traversal = RowMajor | ColMajor
  (*!
   * array (r, c, init) creates a new array with r rows and c columns, with each element initialized
   * to the value init. If r < 0, c < 0 or the resulting array would be too large, the Size
   * exception is raised.
   *)
  val array : int * int * 'a -> 'a array
  (*!
   * fromList l creates a new array from a list of a list of elements. The elements should be
   * presented in row major form, i.e., hd l gives the first row, hd (tl l) gives the second row,
   * etc. This raises the Size exception if the resulting array would be too large or if the lists
   * in l do not all have the same length.
   *)
  val fromList : 'a list list -> 'a array
  (*!
   * tabulate trv (r, c, f) creates a new array with r rows and c columns, with the (i,j)(th)
   * element initialized to f (i,j). The elements are initialized in the traversal order specified
   * by trv. If r < 0, c < 0 or the resulting array would be too large, the Size exception is
   * raised.
   *)
  val tabulate : traversal -> int * int * (int * int -> 'a) -> 'a array
  (*!
   * sub (arr, i, j) returns the (i,j)(th) element of the array arr. If i < 0, j < 0, nRows arr <=
   * i, or nCols arr <= j, then the Subscript exception is raised.
   *)
  val sub : 'a array * int * int -> 'a
  (*!
   * update (arr, i, j, a) sets the (i,j)(th) element of the array arr to a. If i < 0, j < 0, nRows
   * arr <= i, or nCols arr <= j, then the Subscript exception is raised.
   *)
  val update : 'a array * int * int * 'a -> unit
  (*!
   * These functions return size information concerning an array. nCols returns the number of
   * columns, nRows returns the number of rows, and dimension returns a pair containing the number
   * of rows and the number of columns of the array. The functions nRows and nCols are respectively
   * equivalent to #1 o dimensions and #2 o dimensions
   *)
  val dimensions : 'a array -> int * int
  val nCols : 'a array -> int
  val nRows : 'a array -> int
  (*!
   * row (arr, i) returns row i of arr. If (nRows arr) <= i or i < 0, this raises Subscript.
   *)
  val row : 'a array * int -> 'a Vector.vector
  (*!
   * column (arr, j) returns column j of arr. This raises Subscript if j < 0 or nCols arr <= j.
   *)
  val column : 'a array * int -> 'a Vector.vector
  (*!
   * copy {src, dst, dst_row, dst_col} copies the region src into the array dst, with the element at
   * position (#row src, #col src) copied into the destination array at position (dst_row,dst_col).
   * If the source region is not valid, then the Subscript exception is raised. Similarly, if the
   * derived destination region (the source region src translated to (dst_row,dst_col)) is not valid
   * in dst, then the Subscript exception is raised. Implementation note: The copy function must
   * correctly handle the case in which the #base src and the dst arrays are equal, and the source
   * and destination regions overlap.
   *)
  val copy : { src : 'a region, dst : 'a array, dst_row : int, dst_col : int } -> unit
  (*!
   * These functions apply the function f to the elements of an array in the order specified by tr.
   * The more general appi function applies f to the elements of the region reg and supplies both
   * the element and the element's coordinates in the base array to the function f. If reg is not
   * valid, then the exception Subscript is raised. The function app applies f to the whole array
   * and does not supply the element's coordinates to f. Thus, the expression app tr f arr is
   * equivalent to: let val range = {base=arr,row=0,col=0,nrows=NONE,ncols=NONE} in appi tr (f o #3)
   * range end
   *)
  val appi : traversal -> (int * int * 'a -> unit) -> 'a region -> unit
  (*!
   * See appi.
   *)
  val app : traversal -> ('a -> unit) -> 'a array -> unit
  (*!
   * These functions fold the function f over the elements of an array arr, traversing the elements
   * in tr order, and using the value init as the initial value. The more general foldi function
   * applies f to the elements of the region reg and supplies both the element and the element's
   * coordinates in the base array to the function f. If reg is not valid, then the exception
   * Subscript is raised. The function fold applies f to the whole array and does not supply the
   * element's coordinates to f. Thus, the expression fold tr f init arr is equivalent to: foldi tr
   * (fn (_,_,a,b) => f (a,b)) init {base=arr, row=0, col=0, nrows=NONE, ncols=NONE}
   *)
  val foldi : traversal -> (int * int * 'a * 'b -> 'b) -> 'b -> 'a region -> 'b
  (*!
   * See foldi.
   *)
  val fold : traversal -> ('a * 'b -> 'b) -> 'b -> 'a array -> 'b
  (*!
   * These functions apply the function f to the elements of an array in the order specified by tr,
   * and replace each element with the result of f. The more general modifyi function applies f to
   * the elements of the region reg and supplies both the element and the element's coordinates in
   * the base array to the function f. If reg is not valid, then the exception Subscript is raised.
   * The function modify applies f to the whole array and does not supply the element's coordinates
   * to f. Thus, the expression modify tr f arr is equivalent to: let val range =
   * {base=arr,row=0,col=0,nrows=NONE,ncols=NONE} in modifyi tr (f o #3) end
   *)
  val modifyi : traversal -> (int * int * 'a -> 'a) -> 'a region -> unit
  (*!
   * See modifyi.
   *)
  val modify : traversal -> ('a -> 'a) -> 'a array -> unit
end

structure Array2 :> ARRAY2 (* OPTIONAL *) = struct end
