time -> string :
  time := Time.now.local
  ms := time.ns / Duration.NANOSECONDS_PER_MILLISECOND
  precise_ms := "$(%02d time.h):$(%02d time.m):$(%02d time.s).$(%03d ms)"
  return precise_ms
