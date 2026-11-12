# Linux Shell, Bash, Command Execution and Processes

A beginner-friendly guide to understanding how commands and shell
scripts execute in Linux, and how processes fit into that flow.

## 1. What is a Shell?

A **shell** is a command-line interpreter. It provides an interface
through which a user can interact with the operating system.

For example, when you type:

``` bash
ls
pwd
mkdir demo
```

the shell interprets your commands and runs the requested programs or
built-in operations.

Common shells include:

  Shell    Description
  -------- ----------------------------
  `sh`     Bourne-style / POSIX shell
  `bash`   Bourne Again Shell
  `zsh`    Z Shell
  `ksh`    Korn Shell
  `fish`   Friendly Interactive Shell

## 2. What is Bash?

**Bash (Bourne Again Shell) is one type of shell.**

It can: - Execute Linux commands. - Work with variables. - Use
conditions and loops. - Define functions. - Run shell scripts. -
Automate system administration tasks.

Remember:

-   Shell is the general category.
-   Bash is one implementation of a shell.
-   Every Bash is a shell, but not every shell is Bash.

## 3. What is a Process?

A **process is a program that is currently running**.

Examples:

-   Bash on disk is a program. When it runs, it is a process.
-   Python on disk is a program. When it runs, it is a process.
-   Nginx on disk is a program. When it runs, it is a process.

Each process has a Process ID (PID), which identifies it while it is
running.

  Term             Meaning
  ---------------- ------------------------------------------
  Program          Executable instructions stored in a file
  Process          A running instance of a program
  PID              Process ID assigned to a process
  Parent process   A process that creates another process
  Child process    A process created by another process

## 4. What happens when you run `bash shell.sh`?

Suppose you have a script named `shell.sh`:

``` bash
#!/bin/bash

echo "Hello Linux"
date
pwd
```

You execute it:

``` bash
bash shell.sh
```

In simple terms, you are asking Bash to read the file and execute the
commands in it.

### Execution flow

``` text
User
 |
 | types: bash shell.sh
 v
Existing shell process
 |
 | finds the Bash executable and requests it to run
 v
Linux kernel
 |
 | creates a new process for Bash
 v
New Bash process
 |
 | opens and reads shell.sh
 v
Executes commands one by one
 |
 +----> echo "Hello Linux"
 |
 +----> date
 |
 +----> pwd
 |
 v
Script finishes
 |
 v
New Bash process exits
 |
 v
Existing shell is ready for the next command
```

### Step-by-step explanation

1.  **User:** Types `bash shell.sh` in the terminal.
2.  **Existing shell:** Receives the command and locates the Bash
    executable.
3.  **Kernel:** The existing shell requests process creation and
    execution. On typical Unix-like systems, this involves
    process-creation and program-execution system calls.
4.  **New Bash process:** Bash starts as a new process and receives
    `shell.sh` as an argument.
5.  **Read the script:** Bash opens the file and interprets its
    commands.
6.  **Execute commands:** Bash processes the commands in order.
7.  **Finish:** When the script ends, the new Bash process exits. The
    original shell continues running.

The kernel manages process creation, scheduling, memory, and access to
system resources.

## 5. Parent and child processes

When you run:

``` bash
bash shell.sh
```

the existing shell normally starts another Bash process to run the
script.

``` text
Existing Bash process
        |
        | creates
        v
New Bash process
        |
        | reads and runs
        v
shell.sh
```

-   The existing shell is the **parent process**.
-   The new Bash process is the **child process**.
-   Each process has its own PID.
-   The child process normally exits when the script finishes.
-   The parent shell remains available for your next command.

The exact process-creation details depend on the shell and operating
system. A common Unix pattern is to create a child process and then
replace the child's program image with the requested executable.

## 6. Built-in commands vs external commands

Not every command in a script creates a separate process.

Example:

``` bash
#!/bin/bash

echo "Hello Linux"
date
sleep 5
```

### `echo`

`echo` is commonly a Bash built-in. Bash executes it within the Bash
process, so a separate external program process is not normally needed.

### `date` and `sleep`

These are generally external programs. Bash normally starts child
processes to run them.

For a foreground external command, Bash waits for it to finish before
moving to the next command.

Simplified view:

``` text
New Bash process
    |
    +---- executes built-in: echo
    |
    +---- starts child process: date
    |         |
    |         +---- date finishes
    |
    +---- starts child process: sleep
              |
              +---- waits 5 seconds, then finishes
```

## 7. Three ways to run a shell script

### Method 1: Run with Bash

``` bash
bash shell.sh
```

-   Starts Bash to interpret the script.
-   The script does not need execute permission.
-   The script's variable changes do not normally affect the parent
    shell.

### Method 2: Execute the script directly

First, make it executable:

``` bash
chmod +x shell.sh
```

Then run:

``` bash
./shell.sh
```

-   The operating system starts the script's interpreter using its
    shebang, such as `#!/bin/bash`.
-   The file needs execute permission.
-   The script runs in a separate process.

### Method 3: Source the script

``` bash
source shell.sh
```

Or:

``` bash
. shell.sh
```

-   Runs the script in the current shell.
-   Does not start a separate Bash process just to interpret the script.
-   Variable changes and other shell-state changes can remain in the
    current shell.
-   Use care: commands in the sourced file can affect your current
    shell.

### Quick comparison

  Command             Where the script runs     Needs execute permission?
  ------------------- ------------------------- ---------------------------
  `bash shell.sh`     New Bash process          No
  `./shell.sh`        New interpreter process   Yes
  `source shell.sh`   Current shell             No

## 8. Useful Linux process commands

### Show processes associated with your terminal

``` bash
ps
```

### Show processes across the system

``` bash
ps -ef
```

### Show a process tree

``` bash
pstree -p
```

### Monitor processes in real time

``` bash
top
```

### Find a process by name

``` bash
pgrep -a bash
```

### Show the PID of the current shell

``` bash
echo $$
```

### Show the parent PID of the current shell

``` bash
echo $PPID
```

### Show the configured login shell

``` bash
echo "$SHELL"
```

Note: `$SHELL` usually shows the configured login shell, not necessarily
the shell currently interpreting your commands.

## 9. Try it yourself

Create a script:

``` bash
nano shell.sh
```

Add:

``` bash
#!/bin/bash

echo "Hello Linux"
echo "My current shell process ID is: $$"
echo "My parent process ID is: $PPID"

date
pwd

echo "Script completed"
```

Run it:

``` bash
bash shell.sh
```

Then compare the process IDs:

``` bash
echo "Current shell PID: $$"
```

The PID printed inside the script should normally differ from the PID
printed in your original shell because `bash shell.sh` runs the script
in a separate Bash process.

You can also inspect processes while a script is running. For example,
add this to a script:

``` bash
sleep 30
```

Run it in one terminal:

``` bash
bash shell.sh
```

While it is sleeping, open another terminal and inspect:

``` bash
ps -ef | grep '[s]leep'
pstree -p
```

## 10. Important concepts to remember

1.  **Shell:** A command interpreter and user interface to the operating
    system.
2.  **Bash:** One type of shell.
3.  **Program:** Instructions stored in a file.
4.  **Process:** A running program.
5.  **PID:** An identifier for a process.
6.  **Kernel:** Manages processes and system resources, and provides
    services through system calls.
7.  **Parent and child:** A process can create another process.
8.  **Built-in command:** A command implemented inside the shell.
9.  **External command:** A separate executable that the shell normally
    runs as another process.
10. **`source`:** Runs a script in the current shell rather than a
    separate Bash process.

## 11. Interview questions

**Q1. What is a shell?**

A shell is a command-line interpreter that lets users interact with the
operating system.

**Q2. What is Bash?**

Bash stands for Bourne Again Shell. It is a widely used shell in Linux.

**Q3. What is a process?**

A process is a running instance of a program.

**Q4. What is a PID?**

PID stands for Process ID. It identifies a process.

**Q5. What happens when you run `bash shell.sh`?**

The existing shell starts a new Bash process. That Bash process reads
and executes the script. When the script finishes, the new Bash process
exits.

**Q6. Does every command create a new process?**

No. Shell built-ins such as `cd` and `echo` can run inside the shell.
External programs such as `date` are normally run as separate processes.

**Q7. What is the difference between `bash shell.sh` and
`source shell.sh`?**

`bash shell.sh` runs the script in a new Bash process. `source shell.sh`
runs it in the current shell, so changes to shell variables and the
current directory can persist.

------------------------------------------------------------------------

## Summary

``` text
User
  |
  v
Terminal
  |
  v
Existing shell
  |
  v
Kernel creates/starts a new Bash process
  |
  v
Bash reads the script
  |
  v
Commands execute
  |
  v
Script finishes; child Bash exits
  |
  v
Existing shell continues
```

**Core idea:** The shell interprets your command, Bash can interpret
your script, processes represent running programs, and the Linux kernel
manages those processes and their access to system resources.
