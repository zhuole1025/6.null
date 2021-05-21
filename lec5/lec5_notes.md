# Command-line Environment
### Job Control
#### 
* `sleep {number}`
* Signals: a UNIX communication mechanism (software interrupts)
    * Press `Ctrl c` to terminate a process, but actually we sand a signal called `SIGINT` to the process, the process deals with the signal and potentially changes the flow of execution based on the information that the signal delivered.
    * Use `man signal` to check other signals.
    * A python program that captures `SIGINT` ans ignores it. To quit the program we can use the `SIGQUIT`, by typing `Ctrl-\`.
        ```python
        #!/usr/bin/env python
        import signal, time

        def handler(signum, time):
            print("\nI got a SIGINT, but I am not stopping")

        signal.signal(signal.SIGINT, handler)
        i = 0
        while True:
            time.sleep(.1)
            print("\r{}".format(i), end="")
            i += 1
        ```
* Use `Ctrl-Z` to send a `SIGTSTP` signal to pause the jobs.
* Use `fg` or `bg` to continue the paused job in the foreground or in the background respectively.
* `nohup sleep 2000 & ` :  `&` makes the process running at the background.
* `jobs` lists the unfinished jobs associated with the current terminal session.
* Use pid or `%{job number}` to refer to jobs
* `kill -STOP %1` : thr `SIGTERM` signal
* `SIGKILL` cannot be captured by the process and it will always terminate it immediately. However, it can have bad side effects such as leaving orphaned children processes.
---


### Terminal Multiplexer
* Sessions > Windows > Panes
* Terminal multiplexers let you detach a current terminal session and reattach at some point later in time.
* tmux: using keybindings of `<C-b> x`
    * Sessions -  A session is an independent workspace with one or more windows.
        * `tmux` : starts a new session
        * `tmux new -s NAME` : create a new session with given name
        * `tmux ls` : list the current sessions
        * `<C-b> d` : detach the current session
        * `tmux a` : attach the last session (use `-t` flag to specify which)
        * `tmux kill-session -t NAME` : close the specified session (or `<C-d>` )
        * `tmux switch -t NAME` : switch to the specified session
        * `tmux rename-session -t OLD_NAME NEW_NAME` : rename the specified session
    * Windows - Equivalent to tabs in editors or browsers, they are visually separate parts of the same session.
      * `<C-b> c` : when you are in a session, create a new window
      * `<C-d>` : close the window
      * `<C-b> (p|n|{number})` : switch window
      * `<C-b> ,` : rename the current window
      * `<C-b> w` : list current windows, and use `j` and `k` to select
    * Panes - Like vim splits, panes let you have multiple shells in the same visual display.
      * `<C-b> %` : split the current pane horizontally
      * `<C-b> "` : split the current pane vertically
      * `<C-b> <direnction>` : move to the pane in the specified direction
      * `<C-b> <space>` : cycle through pane arrangements
      * `<C-b> z` : first time to zoom in the current pane, and second time to go back
      * `<C-b> [` : start scrollback, press `<space>` to start a selection and `<enter>` to copy that selection
      * `<C-b> x` : kill the current pane
      * `<C-b> t` : display time in the current pane (press `<enter>` to quit)
* `~/.tmux.conf` : the configuration file ([see this](https://github.com/gpakosz/.tmux))
---

### Dotfiles
* alias : remap strings
    * `alias ll="ls -lah"`
    * `alias mv="mv -i"`
    * `alias gs="git status"`
    * alias takes in one argument
* `~/.bashrc`
* creat a folder to collect all dotfiles, so you can use git to save them. and you can create symlinks.
---

### Remote Machine
* ssh
    * `jjgo@192.168.246.142` or `jjgo@foobar.mit.edu`
    * `jjgo@192.168.246.142 ls -la | grep primes`
    * `ssh-copy-id jjgo@192.168.246.142`
    * copy files
        * `scp`
        * ``
    * `~/.ssh/config`
