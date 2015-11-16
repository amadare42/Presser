SetTimerEx(period, func, params*)
{
    static s_timers, s_next_tick, s_timer, s_index, s_max_index
    
    if !s_timers  ; Init timers array and ensure script is #persistent.
        s_timers := Object(), n:="OnMessage",%n%(0)
    
    if (func = "!") ; Internal use.
    {
        ; This is a workaround for the timer-tick sub not being able to see itself
        ; in v2 (since it is local to the function, which is not running).
        SetTimer timer-tick, % period
        return
    }
    
    if !IsFunc(func)
        return
    
    ; Create a timer.
    timer           := {base: {stop: "Timer_Stop"}}
    timer.run_once  := period < 0
    timer.period    := period := Abs(period)
    timer.next_run  := next_run := A_TickCount + period
    timer.func      := func
    timer.params    := params
    
    ; If the timer is not set to run before next_run, set it:
    if (!s_next_tick || s_next_tick > next_run)
    {
        s_next_tick := next_run
        SetTimer timer-tick, % -period
    }
    
    return s_timers.Insert(timer) ? timer : 0
    
timer-tick:
    s_next_tick := "X" ; greater than any number
    s_index := 1
    While s_timer := s_timers[s_index]
    {
        if (s_timer.next_run <= A_TickCount)
        {
            if s_timer.next_run  ; Timer has not been disabled.
            {
                ; Update next run time before calling func in case it takes a while.
                s_timer.next_run := s_timer.run_once ? "" : A_TickCount + s_timer.period
                ; Call function.
                static s_f
                s_f := s_timer.func, %s_f%(s_timer.params*)
            }
            if !s_timer.next_run  ; Timer was run-once (disabled above) or previously disabled.
            {
                ; Remove both our references to this timer:
                s_timers._Remove(s_index)
                s_timer := ""
                ; Continue without incrementing s_index.
                continue
            }
        }
        ; Determine when the next timer should fire.
        if (s_next_tick > s_timer.next_run)
            s_next_tick := s_timer.next_run
        s_index += 1
    }
    s_timer := ""
    ; Set main timer for next sub-timer which should be fired, if any.
    if (s_next_tick != "X")
        SetTimerEx(s_next_tick > A_TickCount ? A_TickCount-s_next_tick : -1, "!")
    return
}

Timer_Stop(timer) {
    timer.next_run := 0
}