# Advent of FPGA – Day 4: Printing Department

## Why Day 4?

I chose **Day 4 (Printing Department)** because the problem maps very cleanly to hardware thinking.

At its core, the task operates on a **fixed-size 2D grid** with **local, deterministic rules**: whether a paper roll can be removed depends only on its eight immediate neighbors. This makes the problem naturally suited for an RTL-style solution, where behavior is explicit, bounded, and predictable.

Unlike problems that rely on complex data structures or recursion, this one is driven by:
- simple arithmetic,
- local neighborhood checks, and
- repeated iteration until convergence.

That structure translates well into a **finite state machine (FSM)** operating over a grid stored in registers or memory.

The problem also scales cleanly with grid size, which makes it useful for thinking about hardware trade-offs such as:
- area vs. parallelism,
- latency vs. throughput,
- full parallel scans vs. row/column iteration.

Overall, Day 4 felt like a problem that could be *designed*, not just *coded*.

---

## Problem Summary

- The grid contains rolls of paper (`@`) and empty spaces (`.`).
- A roll is **accessible** if **fewer than 4 of its 8 neighbors** are also rolls.
- In **Part 1**, we count all accessible rolls in a single scan.
- In **Part 2**, accessible rolls are removed, which may expose new rolls.
- The process repeats until **no more rolls can be removed**.
- The final output is the **total number of removed rolls**.

---
