# Debugging and Profiling
## Debugging
### Printf debugging and Logging
* Printf debugging is the basic way to debug
* Logging is a better approach
    ```shell
    python logger.py
    python logger.py log
    python logger.py log ERROR
    python logger.py log color
    ```
* Change color in shell: true color
* System log
    * Linux: place logs under `/var/log/journal` and use `journalctl` to display
    * macOS: place logs under `/var/log/system.log` and use `log show` to display
    * Unix: use `dmesg` command to access the kernel log
    ```shell
    logger "Hello Logs"
    # On macOS
    log show --last 1m | grep Hello
    log show --last 10s | wc -l
    # On Linux
    journalctl --since "1m ago" | grep Hello
    ```
    * `lnav` provides an imporved presentation and navigation for log files

### Debuggers
* `pdb` : Python Debugger
    * l(ist) - Displays 11 lines around the current line or continue the previous listing.
    * s(tep) - Execute the current line, stop at the first possible occasion.
    * n(ext) - Continue execution until the next line in the current function is reached or it returns.
    * b(reak) - Set a breakpoint (depending on the argument provided).
    * p(rint) - Evaluate the expression in the current context and print its value. There’s also pp to display using pprint instead.
    * r(eturn) - Continue execution until the current function returns.
    * q(uit) - Quit the debugger.
* `ipdb` : an improved `pdb` that uses the `IPython` REPL  
  `python -m ipdb bubble.py`
* `gdb`, `pwndbg` and `lldb` are optimized for C-like language denugging

### Specialized Tools
* Programs use System Calls to perform actions that only the kernel can
* Use `strace` in Linux and `dtrace` or `dtruss` in macOS and BSD
    ```shell
    # On Linux
    sudo strace -e lstat ls -l > /dev/null
    4
    # On macOS
    sudo dtruss -t lstat64_extended ls -l > /dev/null
    ```
### Static Analysis
* `pyflakes` and `mypy`
* code linting
    * vim: `ale` and `syntastic`
    * Python: `pylint`, `pep8` and `bandit`
    * Other language: [Awesome Static Analysis](https://github.com/mre/awesome-static-analysis) and [Awesome Linters](https://github.com/caramelomartins/awesome-linters)
* code formatter: `black` for Python
* `writegood`

---
## Profiling
### Timing
* Simply print the time it took your code between two points
    ```python
    import time, random
    n = random.randint(1, 10) * 100
    
    # Get current time
    start = time.time()
    
    # Do some work
    print("Sleeping for {} ms".format(n))
    time.sleep(n/1000)
    
    # Compute time between start and now
    print(time.time() - start)

    # Output
    # Sleeping for 500 ms
    # 0.5713930130004883
    ```

* Wall clock time can be misleading since your computer might be running other process at the same time or waiting for events to happen
* Make a distinction between **Real time** , **User time** and **Sys time**
    * Real - Wall clock elapsed time from start to finish of the program, including the time taken by other processes and time taken while blocked (e.g. waiting for I/O or network)
    * User - Amount of time spent in the CPU running user code
    * Sys - Amount of time spent in the CPU running kernel code
### Profilers
* CPU
    * Tracing profilers: keep a record of every function call your program makes
    * Sampling profilers: probe your program periodically (commonly every millisecond) and record the program's stack
    * `cProfile` in Python  
        * `python -m cProfile -s tottime grep.py 1000 '^(import|\s*def)[^,]*$' *.py`
        * A caveat of Python’s cProfile profiler (and many profilers for that matter) is that they display time per function call
    * `kernprof` : a line profiler that shows the time taken each line
        * `kernprof -l -v a.py`
* Memory
    * Python is garbage collected language, but as long as you have  pointers to objects in memory they won't be garbage collected
        * `python -m memory_profiler example.py`
    * C and C++ are not garbage collected languages. So languages like them memory leaks can cause your program to never release memory that it doesn't need anymore
        * Use tools like `Valgrind`
* Event Profiling
    * The `perf` command abstracts CPU differences away and does not report time or memory, but instead it reports system events related to your programs
        * `perf list` - List the events that can be traced with perf
        * `perf stat COMMAND ARG1 ARG2` - Gets counts of different events related a process or command
        * `perf record COMMAND ARG1 ARG2` - Records the run of a command and saves the statistical data into a file called perf.data
        * `perf report ` - Formats and prints the data collected in perf.data
* Visuaization
    * Flame Graph: display a hierarchy of function calls across the Y axis and time taken proportional to the X axis
    * Call Graph: display the relationships between subroutines within a program by including functions as nodes and functions calls between them as directed edges
        * Use `pycallgraph` in Python to generate call graphs
* Resource Monitoring
    * General Monitoring: `htop`, `glances`, `dstat`
    * I/O operations: `iotop`
    * Disk Usage: `df`, `du`, `ncdu`
    * Memory Usage: `free`
    * Open Files: `lsof`
    * Network Connections and Config: `ss`, `ip`
    * Network Usage: `nethogs` and `iftop`
    * Use `stress` command to impose loads on the machine to test these tools
* Specialized tools
    * `hyperfine` let you quickly benchmark command line programs  
    `hyperfine --warmup 3 'fd -e jpg' 'find . -iname "*.jpg"'`

---
## Exercise
### Debugging
1. `log show --last 1d | grep sudo`
2. Finish
3. Finish
4. Skip

### Profiling
5. Use `cProfile`: `python3 -m cProfile -s tottime sorts.py 1000`  
   Use `line_profiler`: `kernprof -l -v sorts.py`  
   Use `memory_profiler`: `python3 -m memory_profiler sorts.py`
6. 21 times
7. Finish
    ```shell
    python -m http.server 4444
    lsof | rg "LISTEN"
    kill <PID>
    ```
8. Skip
9. Skip

