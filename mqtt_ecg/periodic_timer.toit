class PeriodicTimer :
  period_/Duration ::= Duration --s=1  // Period 1s
  task_ := null  // Variable for store task
  is_running_/bool := false

  // Method for start timer
  start callback/Lambda -> none:
    if is_running_: return  // No run if timer already running
    is_running_ = true
    // Run task
    task_ = task:: 
      while is_running_:
        //print "Timer tick -- ($time)"
        callback.call
        sleep period_  // Wait 1s

  // Method for stop timer
  final -> none:
    if not is_running_ : return
    is_running_ = false
    task_.cancel
    task_ = null  // Clear task

// main:
//   timer := PeriodicTimer
//   timer.start
//   sleep --ms=10000  // Wait 10s
//   timer.final

//   timer.start
//   sleep --ms=8000   // Wait 8s
//   timer.final
