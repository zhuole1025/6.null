# Command-line Environment
### Job Control
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
* alias : remap long command with shorter command
    * `alias ll="ls -lah"` : make shorthands for common flags
    * `alias mv="mv -i"` : overwrite existing commands for better defaults
    * `alias gs="git status"` : save a lot of typing for common commands
    * `alias sl=ls` : save you from mistyping
    * `\ls` : to ignore am alias run it prepended with \ or `unalias la`
    * `alias ll` : to get an alias definition
    * Alias takes in one argument, so there is no space around `=`.
* dotfiles
    * bash : `~/.bashrc`, `~/.bash_profile`
    * git : `~/.gitconfig`
    * vim : `~/.vimrc` and the `~/.vim` folder
    * ssh : `~/.ssh/config`
    * tmux : `~/.tmux.conf`
* organization: creat a folder to collect all dotfiles, use git and symlinks
* portability
    * use the equivalent of if-statements to apply machine specific customizations  
        ```shell
        if [[ "$(uname)" == "Linux" ]]; then {do_something}; fi
        
        # Check before using shell-specific features
        if [[ "$SHELL" == "zsh" ]]; then {do_something}; fi
        
        # You can also make it machine-specific
        if [[ "$(hostname)" == "myServer" ]]; then {do_something}; fi
        ```

### Remote Machines
* ssh
    * start shh : `jjgo@192.168.246.142` or `jjgo@foobar.mit.edu`
    * execute commands : `jjgo@192.168.246.142 ls -la | grep primes`
    * ssh keys
        * key generation: `ssh-keygen -o -a 100 -t ed25519 -f +/.ssh/id_ed25519` (use `ssh-agent` or `gpg-agent` to avoid typing passphrase every time)
        * key based authentication : `ssh-copy-id -i .ssh/id-ed25519.pub foobar@remote`
    * copy files
        * `scp path/to/local_file remote_host:path/to/remote_file`
        * `rsync` : improves upon `scp` by detecting identical files in local and remote, and preventing copying them again. It also provides more fine grained control over symlinks, permissions and has extra features like the `--partial` flag that can resume from a previously interrupted copy.
        * `cat localfile | ssh remote_server tee serverfile`
    * configuration : `~/.ssh/config`
    * miscellaneous
        * [Mosh](https://mosh.org), the mobile shell, improves upon ssh, allowing roaming connections, intermittent connectivity and providing intelligent local echo.
        * [.sshfs](https://github.com/libfuse/sshfs) can mount a folder on a remote server locally, and then you can use a local editor.
---

### Exercises
#### Job control
1. From what we have seen, we can use some `ps aux | grep` commands to get our jobs’ pids and then kill them, but there are better ways to do it. Start a `sleep 10000` job in a terminal, background it with `Ctrl-Z` and continue its execution with `bg`. Now use `pgrep` to find its pid and `pkill` to kill it without ever typing the pid itself. (Hint: use the `-af` flags).  
    **solution** :  
  ```shell
  slepp 10000
  Ctrl-Z
  bg %1
  pgrep sleep
  pkill -af sleep
  ```
2. Say you don’t want to start a process until another completes. How would you go about it? In this exercise, our limiting process will always be `sleep 60 &`. One way to achieve this is to use the `wait` command. Try launching the sleep command and having an `ls` wait until the background process finishes.

  However, this strategy will fail if we start in a different bash session, since `wait` only works for child processes. One feature we did not discuss in the notes is that the `kill` command’s exit status will be zero on success and nonzero otherwise. `kill -0` does not send a signal but will give a nonzero exit status if the process does not exist. Write a bash function called `pidwait` that takes a pid and waits until the given process completes. You should use `sleep` to avoid wasting CPU unnecessarily.  
  **solution** :  
  ```shell
  sleep 60 &
  pgrep sleep | xargs wait && ls
  ```
  * see `pidwait.sh`

#### Terminal multiplexer
1. Follow this `tmux` [tutorial](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/) and then learn how to do some basic customizations following [these steps](https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/).  

#### Aliases
1. Create an alias dc that resolves to cd for when you type it wrongly.  
 **solution** :  
    `alias dc=cd`
2. Run `history | awk '{$1="";print substr($0,2)}' | sort | uniq -c | sort -n | tail -n 10` to get your top 10 most used commands and consider writing shorter aliases for them.

#### Dotfiles  
Let’s get you up to speed with dotfiles.

1. Create a folder for your dotfiles and set up version control.
2. Add a configuration for at least one program, e.g. your shell, with some customization (to start off, it can be something as simple as customizing your shell prompt by setting `$PS1`).
3. Set up a method to install your dotfiles quickly (and without manual effort) on a new machine. This can be as simple as a shell script that calls ln -s for each file, or you could use a [specialized utility](https://dotfiles.github.io/utilities/).
4. Test your installation script on a fresh virtual machine.
5. Migrate all of your current tool configurations to your dotfiles repository.
6. Publish your dotfiles on GitHub.  
    [See my github pages](https://github.com/zhuole1025/dotfiles)

#### Remote Macgines  
Install a Linux virtual machine (or use an already existing one) for this exercise. If you are not familiar with virtual machines check out this tutorial for installing one.

1. Go to `~/.ssh/` and check if you have a pair of SSH keys there. If not, generate them with `ssh-keygen -o -a 100 -t ed25519`. It is recommended that you use a password and use ssh-agent.
2. Edit `.ssh/config` to have an entry as follows
    ```shell
    Host vm
        User username_goes_here
        HostName ip_goes_here
        IdentityFile ~/.ssh/id_ed25519
        LocalForward 9999 localhost:8888
    ```
  1. Use ssh-copy-id vm to copy your ssh key to the server.
  2. Start a webserver in your VM by executing python -m http.server 8888. Access the VM webserver by navigating to http://localhost:9999 in your machine.
  3. Edit your SSH server config by doing sudo vim /etc/ssh/sshd_config and disable password authentication by editing the value of PasswordAuthentication. Disable root login by editing the value of PermitRootLogin. Restart the ssh service with sudo service sshd restart. Try sshing in again.
  4. (Challenge) Install mosh in the VM and establish a connection. Then disconnect the network adapter of the server/VM. Can mosh properly recover from it?
  5. (Challenge) Look into what the -N and -f flags do in ssh and figure out a command to achieve background port forwarding.
