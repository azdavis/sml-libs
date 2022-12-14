(*!
 * The structure Posix.TTY specifies a model of a general terminal interface, as described in
 * Section 7 of the POSIX standard 1003.1,1996[CITE].
 *)
signature POSIX_TTY = sig
  (*!
   * A process identifier.
   *)
  eqtype pid
  (*!
   * An open file descriptor.
   *)
  eqtype file_desc
  structure V : sig
    val eof : int
    val eol : int
    val erase : int
    val intr : int
    val kill : int
    val min : int
    val quit : int
    val susp : int
    val time : int
    val start : int
    val stop : int
    val nccs : int
    type cc
    val cc : (int * char) list -> cc
    val update : cc * (int * char) list -> cc
    val sub : cc * int -> char
  end
  structure I : sig
    include BIT_FLAGS
    val brkint : flags
    val icrnl : flags
    val ignbrk : flags
    val igncr : flags
    val ignpar : flags
    val inlcr : flags
    val inpck : flags
    val istrip : flags
    val ixoff : flags
    val ixon : flags
    val parmrk : flags
  end
  (*!
   * The O substructure contains flags for specifying output control.
   *)
  structure O : sig
    include BIT_FLAGS
    (*!
     * Perform output processing.
     *)
    val opost : flags
  end
  structure C : sig
    include BIT_FLAGS
    val clocal : flags
    val cread : flags
    val cs5 : flags
    val cs6 : flags
    val cs7 : flags
    val cs8 : flags
    val csize : flags
    val cstopb : flags
    val hupcl : flags
    val parenb : flags
    val parodd : flags
  end
  structure L : sig
    include BIT_FLAGS
    val echo : flags
    val echoe : flags
    val echok : flags
    val echonl : flags
    val icanon : flags
    val iexten : flags
    val isig : flags
    val noflsh : flags
    val tostop : flags
  end
  (*!
   * Terminal input and output baud rates.
   *)
  eqtype speed
  (*!
   * compareSpeed (sp, sp') returns LESS, EQUAL, or GREATER when the baud rate sp is less than,
   * equal to, or greater than that of sp', respectively.
   *)
  val compareSpeed : speed * speed -> order
  (*!
   * These converts between a speed value and its underlying word representation. No checking is
   * performed by wordToSpeed to ensure the resulting value corresponds to an allowed speed in the
   * given system.
   *)
  val speedToWord : speed -> SysWord.word
  val wordToSpeed : SysWord.word -> speed
  val b0 : speed
  val b50 : speed
  val b75 : speed
  val b110 : speed
  val b134 : speed
  val b150 : speed
  val b200 : speed
  val b300 : speed
  val b600 : speed
  val b1200 : speed
  val b1800 : speed
  val b2400 : speed
  val b4800 : speed
  val b9600 : speed
  val b19200 : speed
  val b38400 : speed
  (*!
   * This creates a termios value using the given flags, special characters, and speeds.
   *)
  type termios
  (*!
   * This creates a termios value using the given flags, special characters, and speeds.
   *)
  val termios : { iflag : I.flags, oflag : O.flags, cflag : C.flags, lflag : L.flags, cc : V.cc, ispeed : speed, ospeed : speed } -> termios
  (*!
   * This returns a concrete representation of a termios value.
   *)
  val fieldsOf : termios -> { iflag : I.flags, oflag : O.flags, cflag : C.flags, lflag : L.flags, cc : V.cc, ispeed : speed, ospeed : speed }
  (*!
   * These are the obvious projection functions from a termios value to its constituent fields.
   *)
  val getiflag : termios -> I.flags
  val getoflag : termios -> O.flags
  val getcflag : termios -> C.flags
  val getlflag : termios -> L.flags
  val getcc : termios -> V.cc
  structure CF : sig
    val getospeed : termios -> speed
    val getispeed : termios -> speed
    val setospeed : termios * speed -> termios
    val setispeed : termios * speed -> termios
  end
  structure TC : sig
    eqtype set_action
    val sanow : set_action
    val sadrain : set_action
    val saflush : set_action
    eqtype flow_action
    val ooff : flow_action
    val oon : flow_action
    val ioff : flow_action
    val ion : flow_action
    eqtype queue_sel
    val iflush : queue_sel
    val oflush : queue_sel
    val ioflush : queue_sel
    val getattr : file_desc -> termios
    val setattr : file_desc * set_action * termios -> unit
    val sendbreak : file_desc * int -> unit
    val drain : file_desc -> unit
    val flush : file_desc * queue_sel -> unit
    val flow : file_desc * flow_action -> unit
    val getpgrp : file_desc -> pid
    val setpgrp : file_desc * pid -> unit
  end
end

structure TTY : POSIX_TTY = struct end
