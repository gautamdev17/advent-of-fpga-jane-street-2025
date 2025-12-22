## Why Day 4 (Printing Department)

I chose **Day 4** because the problem maps naturally to hardware. It operates on a fixed 2D grid with simple, local rules based on neighboring cells, which makes it well-suited for a deterministic, synthesizable RTL implementation.

Rather than relying on complex algorithms or data structures, the solution is driven by explicit state and iteration. This allows the design to be expressed as a small FSM operating over a grid stored in registers or memory, keeping behavior predictable and resource usage bounded.

The problem also scales cleanly with grid size, making it a good candidate to explore trade-offs between area, latency, and parallelism.

## High-Level Design States

- **LOAD**  
  Load the input grid into internal storage.

- **SCAN**  
  Iterate over the grid and evaluate each cell’s 8 neighbors.

- **MARK / REMOVE**  
  Identify accessible cells and mark them for removal.

- **UPDATE**  
  Apply removals and update the grid state.

- **CHECK_DONE**  
  Detect convergence when no more cells can be removed.

- **DONE**  
  Output the final count and halt execution.