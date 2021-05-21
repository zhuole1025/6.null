# Command-line Environment
### Job Control
#### 
* `sleep {number}`
* signals
    * Press `Ctrl c` to terminate a process, but actually we sand a signal called `SIGINT` to the terminal
    * Use `man signal` to check other signals
* `nohup sleep 2000 & `  
     * `&` makes the process running at the background
* `jobs`
* `bg %1`
* `kill -STOP %1`
### Terminal Multiplexer
* Sessions > Windows > P
* tmux
    * `tmux new`: create a new session
    * `tmux ls`
    * `<C-B> c
