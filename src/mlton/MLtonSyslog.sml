signature MLTON_SYSLOG = sig
  type openflag
  val CONS : openflag
  val NDELAY : openflag
  val NOWAIT : openflag
  val ODELAY : openflag
  val PERROR : openflag
  val PID : openflag
  type facility
  val AUTHPRIV : facility
  val CRON : facility
  val DAEMON : facility
  val KERN : facility
  val LOCAL0 : facility
  val LOCAL1 : facility
  val LOCAL2 : facility
  val LOCAL3 : facility
  val LOCAL4 : facility
  val LOCAL5 : facility
  val LOCAL6 : facility
  val LOCAL7 : facility
  val LPR : facility
  val MAIL : facility
  val NEWS : facility
  val SYSLOG : facility
  val USER : facility
  val UUCP : facility
  type loglevel
  val EMERG : loglevel
  val ALERT : loglevel
  val CRIT : loglevel
  val ERR : loglevel
  val WARNING : loglevel
  val NOTICE : loglevel
  val INFO : loglevel
  val DEBUG : loglevel
  val closelog : unit -> unit
  val log : loglevel * string -> unit
  val openlog : string * openflag list * facility -> unit
end
