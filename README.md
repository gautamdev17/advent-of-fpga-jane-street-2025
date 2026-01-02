# Advent of FPGA – Day 4: Printing Department
## Why Day 4?

I picked Day 4 because it fits hardware thinking really well.  
The problem works on a fixed 2D grid, and every decision depends only on the
8 neighboring cells.
That makes it easy to reason about in RTL, where behavior
is explicit and local.

Instead of complex algorithms, the solution is driven by repeated scans and
state updates. 
This maps naturally to a finite state machine operating on a
stored grid which feels very close to how real hardware is designed.
