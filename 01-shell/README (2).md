# Complete Theory of Linux Shell --- Beginner to Advanced

A practical learning guide to Linux Shell and Bash, designed for Linux
administration, DevOps, and Site Reliability Engineering (SRE).

This README covers shell fundamentals, command execution, Bash
programming, process management, text processing, automation, and a
30-day learning roadmap.

------------------------------------------------------------------------

## Table of Contents

1.  [What Is a Shell?](#1-what-is-a-shell)
2.  [Linux
    Architecture](#2-linux-architecture--where-does-the-shell-fit)
3.  [Terminal vs Shell](#3-what-is-a-terminal)
4.  [What Is Bash?](#4-what-is-bash)
5.  [How a Shell Executes a
    Command](#5-how-does-a-shell-execute-a-command)
6.  [Types of Shell Commands](#6-types-of-shell-commands)
7.  [How the Shell Finds Commands](#7-how-does-the-shell-find-commands)
8.  [Command Structure](#8-understanding-command-structure)
9.  [How Bash Processes Commands](#9-how-does-bash-process-commands)
10. [Variables](#10-variables-in-bash)
11. [Quoting](#11-quoting-in-bash)
12. [Standard Input and Output](#12-input-and-output-in-the-shell)
13. [Pipes](#13-pipes-in-the-shell)
14. [Command Substitution](#14-command-substitution)
15. [Arithmetic](#15-arithmetic-operations)
16. [Conditional Statements](#16-conditional-statements)
17. [Loops](#17-loops-in-bash)
18. [Functions](#18-functions-in-bash)
19. [Processes and Job Control](#19-processes-and-job-control)
20. [Shell Startup Files](#20-shell-startup-and-configuration-files)
21. [Shell Types](#21-shell-types)
22. [Shell Scripts](#22-what-is-a-shell-script)
23. [Error Handling](#23-error-handling-in-bash)
24. [Advanced Bash Concepts](#24-advanced-bash-concepts)
25. [Shell in DevOps and SRE](#25-how-shell-is-used-in-devops-and-sre)
26. [Command Operators](#26-command-operators)
27. [Subshell vs Current Shell](#27-subshell-vs-current-shell)
28. [Arrays](#28-arrays-in-bash)
29. [Text Processing](#29-text-processing-tools)
30. [Environment Variables](#30-shell-and-environment-variables)
31. [Permissions and Execution](#31-shell-permissions-and-execution)
32. [Cron and SSH](#32-shell-in-automation-cron-and-ssh)
33. [Shell vs Bash vs Kernel](#33-shell-vs-bash-vs-linux-kernel)
34. [30-Day Learning
    Roadmap](#34-30-day-shell-and-bash-learning-roadmap)
35. [Practice Exercises](#35-practice-exercises)
36. [Quick Reference](#36-quick-reference)

------------------------------------------------------------------------

## 1. What Is a Shell?

A **shell is a command-line interpreter that provides an interface
between a user and the operating system**.

It accepts commands, interprets them, and arranges for the operating
system to execute them.

Examples:

``` bash
ls
pwd
mkdir devops
```

When you enter `ls`, the shell interprets the command and starts the
corresponding program. The program may then request services from the
Linux kernel.

### Why do we need a shell?

-   Users need a convenient way to interact with the operating system.
-   The Linux kernel manages hardware and system resources.
-   The shell provides a command interface and scripting environment.
-   Programs use system calls to request services from the kernel.

**Important:** The shell does not directly control hardware. Programs
request kernel services through system calls, and the kernel manages
access to hardware.

## 2. Linux Architecture --- Where Does the Shell Fit?

A simplified view:

``` text
+-----------------------------+
|            User             |
|       Enters commands       |
+-----------------------------+
              |
              v
+-----------------------------+
|     Terminal / Emulator     |
|  Displays input and output  |
+-----------------------------+
              |
              v
+-----------------------------+
|       Shell (Bash)          |
| Parses commands and starts  |
|          programs           |
+-----------------------------+
              |
              v
+-----------------------------+
|        Applications         |
| ls, grep, curl, scripts     |
+-----------------------------+
              |
       System calls
              |
              v
+-----------------------------+
|        Linux Kernel         |
| Processes, memory, files,   |
| networking, device access   |
+-----------------------------+
              |
              v
+-----------------------------+
|          Hardware           |
| CPU, RAM, disk, NIC, etc.   |
+-----------------------------+
```

The shell is a user-space program. The kernel is the core of the
operating system and manages resources such as CPU time, memory,
filesystems, networking, and devices.

## 3. What Is a Terminal?

A **terminal** is the interface through which you enter commands and see
output. Today, terminals are usually terminal-emulator applications.

Examples:

-   GNOME Terminal
-   macOS Terminal
-   iTerm2
-   Windows Terminal
-   VS Code integrated terminal

### Terminal vs Shell

  Terminal                              Shell
  ------------------------------------- --------------------------------------
  Provides the input/output interface   Interprets commands
  Displays command output               Runs shell logic and starts programs
  Accepts keyboard input                Processes commands
  Example: GNOME Terminal               Example: Bash or Zsh

Remember:

-   **Terminal:** Where you type.
-   **Shell:** The program that interprets your commands.

A terminal emulator commonly starts a shell when you open a terminal
window.

## 4. What Is Bash?

**Bash** stands for **Bourne Again Shell**. It is a widely used Unix
shell and command language interpreter.

Bash is both:

1.  An interactive command interpreter.
2.  A scripting language.

Interactive example:

``` bash
echo "Hello Linux"
```

Script example:

``` bash
#!/usr/bin/env bash

echo "Hello Linux"
echo "Learning Bash scripting"
```

### Other common shells

  Shell    Description
  -------- ---------------------------------------------------------
  `sh`     Bourne-compatible shell interface; implementations vary
  `bash`   Bourne Again Shell
  `zsh`    Z Shell
  `fish`   Friendly Interactive Shell
  `ksh`    Korn Shell
  `csh`    C Shell

Check your current shell:

``` bash
echo "$SHELL"
ps -p "$$" -o comm=
```

`$SHELL` usually identifies your configured login shell; the process
command shows the shell process running now.

## 5. How Does a Shell Execute a Command?

Suppose you run:

``` bash
ls -l /var/log
```

A simplified execution sequence is:

1.  The shell reads the command.
2.  It parses the command and its arguments.
3.  It determines whether the command is a built-in, function, alias, or
    external program.
4.  For an external command, it searches the directories in `PATH`
    (unless a path was specified).
5.  It creates or arranges a process to run the program.
6.  The child process replaces its program image with the requested
    executable using an `exec`-family system call.
7.  The program requests kernel services when needed.
8.  Output is written to standard output or standard error.
9.  The shell waits for a foreground command, unless execution is
    asynchronous or in the background.
10. The shell makes the command's exit status available.

On Unix-like systems, process creation often involves `fork()` followed
by an `exec`-family call. Implementations may use other mechanisms, so
this is a conceptual model rather than a guarantee for every command.

Useful commands:

``` bash
type ls
command -v ls
which ls
echo "$PATH"
```

## 6. Types of Shell Commands

Not every command is a separate executable. Common categories include:

### A. Shell built-ins

Implemented by the shell itself.

Examples:

``` bash
cd
echo
pwd
export
alias
history
read
exit
```

Check a command:

``` bash
type cd
type echo
```

**Why is `cd` a built-in?**

The current working directory belongs to a process. If `cd` ran only in
a child process, it would change that child's directory, not the parent
interactive shell's directory. Implementing `cd` as a shell built-in
lets it change the shell's own working directory.

### B. External commands

Separate executable programs stored on the filesystem.

Examples:

``` bash
ls
cat
grep
find
ps
top
curl
```

Check:

``` bash
type ls
command -v ls
```

### C. Shell functions

Reusable commands defined by the user:

``` bash
hello() {
    echo "Hello from Linux"
}

hello
```

### D. Aliases

Shortcuts for commands:

``` bash
alias ll='ls -lah'
alias update='sudo apt update'
```

Remove an alias:

``` bash
unalias ll
```

Aliases are mainly intended for interactive convenience. For scripts,
functions are generally more predictable.

## 7. How Does the Shell Find Commands?

When you type:

``` bash
ls
```

Bash searches for an executable using command-resolution rules. For an
external command without a slash in its name, it searches directories
listed in the `PATH` environment variable after considering applicable
aliases, functions, and built-ins.

Inspect `PATH`:

``` bash
echo "$PATH"
printf '%s\n' "$PATH" | tr ':' '\n'
```

Example:

``` text
/usr/local/bin
/usr/bin
/bin
/usr/local/sbin
/usr/sbin
```

Find an executable:

``` bash
command -v ls
type -a ls
```

Run an executable by absolute path:

``` bash
/usr/bin/ls
```

If a command cannot be resolved, the shell typically reports:

``` text
command not found
```

## 8. Understanding Command Structure

A command commonly has:

-   Command name
-   Options
-   Arguments

Example:

``` bash
ls -l /var/log
```

  Component    Meaning
  ------------ ----------
  `ls`         Command
  `-l`         Option
  `/var/log`   Argument

Another example:

``` bash
grep -i error application.log
```

-   `grep`: command
-   `-i`: case-insensitive option
-   `error`: search pattern
-   `application.log`: input file

Options may have short or long forms:

``` bash
ls -l
ls --all
```

Exact options depend on the command and its implementation. Consult
documentation with:

``` bash
man ls
ls --help
```

## 9. How Does Bash Process Commands?

Bash performs several stages before and during command execution. A
useful simplified order is:

1.  **Read and parse:** Identify commands, arguments, operators, and
    syntax.
2.  **Brace expansion:** Expand expressions such as `{1..5}`.
3.  **Tilde expansion:** Expand `~` to a home directory.
4.  **Parameter and variable expansion:** Expand `$NAME`.
5.  **Arithmetic expansion:** Evaluate `$((...))`.
6.  **Command substitution:** Replace `$(command)` with command output.
7.  **Word splitting:** Split unquoted expansion results according to
    `IFS`.
8.  **Filename expansion (globbing):** Expand patterns such as `*.log`.
9.  **Redirections:** Set up input and output destinations.
10. **Execution:** Run a built-in, function, or external program.
11. **Exit status:** Make the result status available.

The exact details and ordering have nuances; Bash's manual documents the
full rules.

Example:

``` bash
NAME="Manoj"
echo "Hello $NAME"
```

The shell expands `$NAME` before invoking the `echo` built-in.

## 10. Variables in Bash

Variables store values that can be reused.

``` bash
NAME="Manoj"
AGE=28

echo "$NAME"
echo "$AGE"
```

Do not put spaces around `=` when assigning a variable.

Correct:

``` bash
NAME="Manoj"
```

Incorrect:

``` bash
NAME = "Manoj"
```

### Shell variables and environment variables

A shell variable exists in the current shell:

``` bash
CITY="Berlin"
```

Export it so child processes inherit it:

``` bash
export CITY
```

Or assign and export in one command:

``` bash
export APP_ENV="production"
```

### Special parameters

  -----------------------------------------------------------------------
  Parameter                           Meaning
  ----------------------------------- -----------------------------------
  `$0`                                Name used to invoke the script or
                                      shell

  `$1`, `$2`, ...                     Positional arguments

  `$#`                                Number of positional parameters

  `$@`                                All positional parameters

  `$*`                                All positional parameters, with
                                      different quoting behavior from
                                      `"$@"`

  `$?`                                Exit status of the most recently
                                      completed foreground pipeline

  `$$`                                PID of the current shell (with
                                      subshell nuances)

  `$!`                                PID of the most recent asynchronous
                                      command
  -----------------------------------------------------------------------

Example script:

``` bash
#!/usr/bin/env bash

echo "Script: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Total arguments: $#"
```

Run:

``` bash
bash script.sh Linux DevOps
```

## 11. Quoting in Bash

Quoting controls how Bash interprets characters.

### A. Single quotes

Single quotes preserve the literal value of every character inside them,
except that a single quote cannot appear directly inside a single-quoted
string.

``` bash
NAME="Manoj"
echo '$NAME'
```

Output:

``` text
$NAME
```

### B. Double quotes

Double quotes allow parameter expansion, command substitution, and
certain other expansions. They prevent ordinary word splitting and
filename expansion of the quoted result.

``` bash
NAME="Manoj"
echo "Hello $NAME"
```

Output:

``` text
Hello Manoj
```

### C. Backslash

A backslash escapes a character in contexts where it is active.

``` bash
echo \$HOME
```

Output:

``` text
$HOME
```

### Why quote variables?

Suppose a filename contains spaces:

``` bash
FILE="my application.log"
cat "$FILE"
```

Quoting protects the filename from being split into multiple arguments.

A strong Bash habit is to quote variable expansions unless you
specifically need splitting or globbing:

``` bash
"$variable"
"${array[@]}"
```

## 12. Input and Output in the Shell

Unix processes conventionally use three standard file descriptors:

  Stream       File descriptor Purpose
  ---------- ----------------- -----------------
  `stdin`                    0 Standard input
  `stdout`                   1 Standard output
  `stderr`                   2 Standard error

### Output redirection

Overwrite a file with standard output:

``` bash
ls > output.txt
```

Append standard output:

``` bash
ls >> output.txt
```

Redirect standard error:

``` bash
ls /wrong-directory 2> error.log
```

Redirect both standard output and standard error:

``` bash
command > output.log 2>&1
```

In Bash, a concise equivalent is:

``` bash
command &> output.log
```

Discard both streams:

``` bash
command > /dev/null 2>&1
```

### Input redirection

``` bash
sort < names.txt
```

The file becomes the command's standard input.

### Here document

Pass multiple lines as input:

``` bash
cat <<EOF
Hello
This is a here document.
EOF
```

Quoting the delimiter prevents parameter and command expansion in the
body:

``` bash
cat <<'EOF'
$HOME is printed literally.
EOF
```

### Here string

Pass a string as standard input:

``` bash
grep "error" <<< "application error detected"
```

## 13. Pipes in the Shell

A pipe connects the standard output of one command to the standard input
of another.

Operator:

``` bash
|
```

Example:

``` bash
ps aux | grep nginx
```

Conceptually:

1.  `ps aux` produces process information.
2.  The pipe carries its standard output.
3.  `grep nginx` reads that data.
4.  Matching lines are printed.

Count lines containing `500`:

``` bash
grep "500" access.log | wc -l
```

Find recent error entries:

``` bash
grep "ERROR" application.log | tail -20
```

Pipelines are useful for log analysis and troubleshooting. Remember that
a pipeline normally runs each component as a separate process, with
shell-specific exceptions and optimizations.

## 14. Command Substitution

Command substitution captures a command's standard output.

Preferred syntax:

``` bash
DATE=$(date)
echo "$DATE"
```

Another example:

``` bash
TOTAL_FILES=$(find . -maxdepth 1 -type f | wc -l)
echo "Total files: $TOTAL_FILES"
```

Older syntax:

``` bash
DATE=`date`
```

Prefer `$(...)` because it is easier to read and nest.

## 15. Arithmetic Operations

Bash supports integer arithmetic.

``` bash
A=10
B=20

echo $((A + B))
echo $((A - B))
echo $((A * B))
echo $((A / B))
echo $((A % B))
```

Bash arithmetic uses integer values by default. For decimal
calculations, use a suitable tool such as `awk` or `bc`.

Example:

``` bash
echo "scale=2; 10 / 3" | bc
```

## 16. Conditional Statements

Conditionals allow a script to make decisions.

### `if` / `else`

``` bash
#!/usr/bin/env bash

CPU=90

if [ "$CPU" -gt 80 ]; then
    echo "High CPU usage"
else
    echo "CPU usage is normal"
fi
```

### Numeric comparison operators

  Operator   Meaning
  ---------- -----------------------
  `-eq`      Equal
  `-ne`      Not equal
  `-gt`      Greater than
  `-lt`      Less than
  `-ge`      Greater than or equal
  `-le`      Less than or equal

### String comparison

``` bash
if [ "$NAME" = "Manoj" ]; then
    echo "Match"
fi
```

For Bash-specific scripts, `[[ ... ]]` is often a safer and more
flexible conditional construct:

``` bash
if [[ "$NAME" == "Manoj" ]]; then
    echo "Match"
fi
```

### File tests

  Test        Meaning
  ----------- ------------------------------
  `-e path`   Path exists
  `-f file`   Regular file exists
  `-d dir`    Directory exists
  `-r file`   File is readable
  `-w file`   File is writable
  `-x file`   File is executable
  `-s file`   File exists and is non-empty

Example:

``` bash
if [[ -f "application.log" ]]; then
    echo "Log file exists"
else
    echo "Log file is missing"
fi
```

## 17. Loops in Bash

Loops repeat commands.

### For loop

``` bash
for i in 1 2 3 4 5; do
    echo "$i"
done
```

Brace expansion:

``` bash
for i in {1..5}; do
    echo "$i"
done
```

Loop through files:

``` bash
for file in ./*.log; do
    [[ -e "$file" ]] || continue
    echo "$file"
done
```

### While loop

``` bash
COUNT=1

while [[ "$COUNT" -le 5 ]]; do
    echo "$COUNT"
    COUNT=$((COUNT + 1))
done
```

### Until loop

``` bash
COUNT=1

until [[ "$COUNT" -gt 5 ]]; do
    echo "$COUNT"
    COUNT=$((COUNT + 1))
done
```

### Break and continue

-   `break` exits the loop.
-   `continue` skips the rest of the current iteration.

``` bash
for i in 1 2 3 4 5; do
    if [[ "$i" -eq 3 ]]; then
        continue
    fi

    echo "$i"
done
```

## 18. Functions in Bash

Functions group reusable logic.

``` bash
#!/usr/bin/env bash

check_service() {
    echo "Checking service: $1"
}

check_service nginx
check_service docker
```

Functions can return an exit status:

``` bash
is_root() {
    [[ "$EUID" -eq 0 ]]
}

if is_root; then
    echo "Running as root"
else
    echo "Not running as root"
fi
```

Use `return` for a function's status code. To produce data, print it and
capture it with command substitution:

``` bash
get_hostname() {
    hostname
}

HOST=$(get_hostname)
echo "$HOST"
```

## 19. Processes and Job Control

A process is an instance of a running program.

Start a foreground process:

``` bash
sleep 100
```

Inspect processes from another terminal:

``` bash
ps aux
pgrep -a sleep
```

### Foreground process

``` bash
sleep 100
```

The shell waits for it to finish.

### Background process

``` bash
sleep 100 &
```

The shell returns a prompt while the process runs asynchronously.

### Job management

``` bash
jobs
fg
bg
```

-   `jobs`: list jobs started by the current shell.
-   `fg`: bring a job to the foreground.
-   `bg`: resume a stopped job in the background.

### Signals and termination

``` bash
kill PID
kill -TERM PID
kill -KILL PID
```

Prefer graceful termination with SIGTERM before using SIGKILL.

  Signal                Common number on Linux Purpose
  --------- ---------------------------------- ------------------------------------------------
  SIGHUP                                     1 Hangup
  SIGINT                                     2 Interrupt, commonly Ctrl+C
  SIGKILL                                    9 Force termination; cannot be caught or ignored
  SIGTERM                                   15 Request graceful termination
  SIGSTOP     19 on common Linux architectures Stop a process

Signal numbers can vary by platform. Signal names are more portable.

## 20. Shell Startup and Configuration Files

Bash reads different startup files depending on whether it is a login
shell, interactive shell, or non-interactive shell.

  -----------------------------------------------------------------------
  File                                Purpose
  ----------------------------------- -----------------------------------
  `/etc/profile`                      System-wide login-shell
                                      configuration

  `~/.bash_profile`                   User login configuration

  `~/.bash_login`                     Alternative user login
                                      configuration

  `~/.profile`                        Another login configuration option

  `~/.bashrc`                         Interactive non-login Bash
                                      configuration, commonly used for
                                      aliases and prompts

  `~/.bash_logout`                    Commands run when a login Bash
                                      shell exits
  -----------------------------------------------------------------------

For a login Bash shell, Bash reads the first available user login file
from `~/.bash_profile`, `~/.bash_login`, and `~/.profile`.

For an interactive non-login Bash shell, it reads `~/.bashrc`.

Edit your configuration:

``` bash
nano ~/.bashrc
```

Add:

``` bash
alias ll='ls -lah'
```

Reload it in the current shell:

``` bash
source ~/.bashrc
```

Now run:

``` bash
ll
```

## 21. Shell Types: Interactive, Non-interactive, Login

### Interactive shell

An interactive shell reads commands from the user and supports
interactive features such as prompts and job control.

### Non-interactive shell

A non-interactive shell runs commands or scripts without an interactive
prompt.

### Login shell

A login shell is started as a login session and reads the applicable
login startup configuration.

Examples:

``` bash
bash -l
bash -c 'echo Hello'
```

-   `bash -l`: starts a login Bash shell.
-   `bash -c`: executes a command string.

These distinctions matter for SSH sessions, cron jobs, scripts, and
CI/CD runners because environment variables and startup files may
differ.

## 22. What Is a Shell Script?

A shell script is a text file containing shell commands and language
constructs.

Example, `monitor.sh`:

``` bash
#!/usr/bin/env bash

echo "Starting system monitoring"

uptime
free -h
df -h

echo "Monitoring completed"
```

Make it executable:

``` bash
chmod +x monitor.sh
```

Run it:

``` bash
./monitor.sh
```

You can also explicitly invoke Bash:

``` bash
bash monitor.sh
```

### What is a shebang?

``` bash
#!/usr/bin/env bash
```

The shebang identifies the interpreter used when the script is launched
directly as an executable. `/usr/bin/env` locates Bash through `PATH`.

## 23. Error Handling in Bash

Reliable scripts should detect and handle failures.

Common shell options:

  -----------------------------------------------------------------------
  Option                              Purpose
  ----------------------------------- -----------------------------------
  `set -e`                            Exit on many unhandled command
                                      failures, with important exceptions

  `set -u`                            Treat unset variables as errors

  `set -o pipefail`                   Make a pipeline's status reflect a
                                      failing component rather than only
                                      the last command

  `set -x`                            Print commands and expansions as
                                      they execute
  -----------------------------------------------------------------------

A common starting point is:

``` bash
set -Eeuo pipefail
```

However, `set -e` has exceptions and surprising behavior in
conditionals, functions, and pipelines. It is not a substitute for
checking critical operations explicitly.

Example:

``` bash
#!/usr/bin/env bash

set -Eeuo pipefail

if ! systemctl is-active --quiet nginx; then
    echo "ERROR: Nginx is not running" >&2
    exit 1
fi

echo "Nginx is running"
```

Check a command's status:

``` bash
if command; then
    echo "Command succeeded"
else
    echo "Command failed"
fi
```

Debug a script:

``` bash
bash -x script.sh
```

## 24. Advanced Bash Concepts

  -----------------------------------------------------------------------
  Concept                 Purpose                 Example
  ----------------------- ----------------------- -----------------------
  Globbing                Match filenames         `*.log`

  Brace expansion         Generate strings        `{1..10}`

  Here document           Pass multiline input    `<<EOF`

  Here string             Pass a string as input  `<<< "$VAR"`

  Process substitution    Present command output  `<(command)`
                          like a file             

  `trap`                  Handle signals and      `trap cleanup EXIT`
                          cleanup                 

  `getopts`               Parse short script      `getopts "f:v"`
                          options                 

  `read`                  Read user input         `read -r NAME`

  `shift`                 Shift positional        `shift`
                          parameters              

  `eval`                  Parse and execute       `eval "$COMMAND"`
                          constructed shell code  

  `source`                Execute a file in the   `source config.sh`
                          current shell           

  `exec`                  Replace the shell       `exec > app.log`
                          process or change file  
                          descriptors             

  `wait`                  Wait for asynchronous   `wait "$PID"`
                          processes               
  -----------------------------------------------------------------------

### Trap example

Use `trap` to clean up a temporary file when a script exits:

``` bash
#!/usr/bin/env bash

set -Eeuo pipefail

TEMP_FILE=$(mktemp)

cleanup() {
    rm -f "$TEMP_FILE"
}

trap cleanup EXIT

echo "Temporary data" > "$TEMP_FILE"
cat "$TEMP_FILE"
```

### Process substitution example

``` bash
diff <(sort file1.txt) <(sort file2.txt)
```

### Parse script options with getopts

``` bash
#!/usr/bin/env bash

while getopts ":f:v" option; do
    case "$option" in
        f) FILE="$OPTARG" ;;
        v) VERBOSE=true ;;
        :)
            echo "Option -$OPTARG requires an argument" >&2
            exit 1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

echo "File: ${FILE:-not provided}"
echo "Verbose: ${VERBOSE:-false}"
```

**Security warning:** Avoid using `eval` with untrusted input. It can
execute arbitrary shell commands.

## 25. How Shell Is Used in DevOps and SRE

Shell scripting is widely used in infrastructure operations and
automation.

  -----------------------------------------------------------------------
  Area                    Typical tasks           Useful tools
  ----------------------- ----------------------- -----------------------
  Linux administration    Check CPU, memory,      `top`, `free`, `df`,
                          disk, and processes     `ps`, `uptime`

  CI/CD                   Build, test, package,   Bash, Jenkins, GitLab
                          and deploy applications CI

  Kubernetes              Automate cluster checks `kubectl`, `grep`,
                          and troubleshooting     `awk`, `jq`

  Log analysis            Find errors and         `grep`, `sed`, `awk`,
                          investigate incidents   `tail`, `journalctl`

  Backup and maintenance  Backups and scheduled   `tar`, `rsync`, `cron`,
                          jobs                    `find`

  Cloud operations        Automate command-line   AWS CLI, Azure CLI,
                          cloud tasks             `gcloud`

  Monitoring              Collect metrics and     Shell scripts, `curl`,
                          check service health    monitoring APIs
  -----------------------------------------------------------------------

Example: quick Linux health check

``` bash
#!/usr/bin/env bash

set -Eeuo pipefail

echo "===== HOST ====="
hostname
uptime

echo "===== MEMORY ====="
free -h

echo "===== DISK ====="
df -h

echo "===== TOP PROCESSES ====="
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head
```

## 26. Command Operators

Bash operators control how commands are executed.

  -----------------------------------------------------------------------------
  Operator                Meaning                 Example
  ----------------------- ----------------------- -----------------------------
  `;`                     Run commands            `pwd; ls`
                          sequentially            

  `&&`                    Run next command only   `mkdir test && cd test`
                          if previous succeeds    

  `||`                    Run next command if     `mkdir test || echo failed`
                          previous fails          

  `&`                     Run asynchronously in   `sleep 100 &`
                          the background          

  `|`                     Connect command output  `ps aux \| grep nginx`
                          to next command input   

  `()`                    Run a command group in  `(cd /tmp; pwd)`
                          a subshell              

  `{}`                    Group commands in the   `{ pwd; ls; }`
                          current shell           
  -----------------------------------------------------------------------------

Example:

``` bash
mkdir devops && cd devops && touch test.txt
```

Each command runs only if the previous command succeeds.

## 27. Subshell vs Current Shell

A subshell is a separate shell environment. Changes made inside it
generally do not change the parent shell's environment.

Example:

``` bash
cd /home

(
    cd /tmp
    pwd
)

pwd
```

Expected output resembles:

``` text
/tmp
/home
```

The first `pwd` runs inside the subshell. The second runs in the
original shell.

Compare with:

``` bash
cd /tmp
pwd
```

This changes the current shell's working directory.

## 28. Arrays in Bash

Arrays store multiple values in one variable.

### Indexed arrays

``` bash
SERVICES=("nginx" "docker" "ssh")

echo "${SERVICES[0]}"
echo "${SERVICES[1]}"
```

Loop through an array:

``` bash
for service in "${SERVICES[@]}"; do
    echo "$service"
done
```

Use `"${array[@]}"` to preserve each array element as a separate
argument, including elements containing spaces.

### Associative arrays

Associative arrays store key-value pairs:

``` bash
declare -A SERVER

SERVER[name]="web01"
SERVER[ip]="192.168.1.10"

echo "${SERVER[name]}"
echo "${SERVER[ip]}"
```

Associative arrays require Bash 4 or later.

## 29. Text Processing Tools

Linux administrators frequently process logs and command output.

  Command   Purpose
  --------- ------------------------------------------
  `cat`     Display or concatenate files
  `less`    Read files interactively
  `head`    Display first lines
  `tail`    Display last lines
  `grep`    Search text
  `sed`     Stream editing
  `awk`     Pattern scanning and text processing
  `cut`     Extract fields
  `sort`    Sort lines
  `uniq`    Report or filter adjacent repeated lines
  `wc`      Count lines, words, and bytes
  `tr`      Translate or delete characters

Examples:

Find errors:

``` bash
grep "ERROR" application.log
```

Find the latest 20 error lines:

``` bash
grep "ERROR" application.log | tail -20
```

Count lines containing HTTP 500:

``` bash
grep -c "500" access.log
```

Extract the first whitespace-separated field:

``` bash
awk '{print $1}' access.log
```

Follow a log file:

``` bash
tail -f application.log
```

Search recursively:

``` bash
grep -Rni "connection refused" /var/log
```

## 30. Shell and Environment Variables

The shell maintains an environment that is inherited by child processes.

Export a variable:

``` bash
export APP_ENV=production
```

A child Bash process can read it:

``` bash
bash -c 'echo "$APP_ENV"'
```

Inspect environment variables:

``` bash
env
printenv
printenv APP_ENV
```

Remove a variable:

``` bash
unset APP_ENV
```

Remember:

-   A shell variable is available in the current shell.
-   An exported environment variable is also available to child
    processes.
-   Changes made by a child process do not normally modify the parent
    shell's environment.

## 31. Shell Permissions and Execution

Linux file permissions control who can read, write, and execute files.

Inspect permissions:

``` bash
ls -l script.sh
```

Example:

``` text
-rw-r--r-- 1 user user 100 Nov 12 10:00 script.sh
```

Make the script executable:

``` bash
chmod +x script.sh
```

Execute it:

``` bash
./script.sh
```

### `bash script.sh` vs `./script.sh`

``` bash
bash script.sh
```

-   Starts Bash and asks it to interpret the file.
-   The script itself does not need its execute bit set, but it must be
    readable.

``` bash
./script.sh
```

-   Asks the operating system to execute the file.
-   The file needs execute permission.
-   The shebang identifies the interpreter.

## 32. Shell in Automation: Cron and SSH

### Cron

Cron is a scheduler that runs commands at specified times.

Edit your crontab:

``` bash
crontab -e
```

Run a script every day at 2:00 AM:

``` cron
0 2 * * * /home/user/backup.sh
```

A cron job may have a limited environment. Use absolute paths, set
required environment variables explicitly, and log output when
appropriate.

Example:

``` cron
0 2 * * * /home/user/backup.sh >> /home/user/backup.log 2>&1
```

### SSH

SSH provides secure remote access to another machine:

``` bash
ssh user@192.168.1.10
```

Run a remote command:

``` bash
ssh user@192.168.1.10 "uptime"
```

Copy a file to a remote host:

``` bash
scp backup.tar user@192.168.1.10:/tmp/
```

These are common building blocks for remote administration and
automation.

## 33. Shell vs Bash vs Linux Kernel

  -----------------------------------------------------------------------
  Component                           Responsibility
  ----------------------------------- -----------------------------------
  Linux kernel                        Manages system resources and
                                      hardware

  Shell                               Interprets commands and provides a
                                      user interface

  Bash                                A particular shell implementation
                                      and scripting language

  Terminal                            Provides the input/output interface

  Shell script                        A file containing shell commands

  System call                         Interface through which programs
                                      request kernel services

  Command                             An instruction interpreted or
                                      executed by the shell
  -----------------------------------------------------------------------

Simplified architecture:

``` text
User
 |
 v
Terminal emulator
 |
 v
Shell (Bash)
 |
 v
Commands / Applications
 |
 v
System calls
 |
 v
Linux Kernel
 |
 v
Hardware
```

------------------------------------------------------------------------

## 34. 30-Day Shell and Bash Learning Roadmap

Suggested daily study time: **40 minutes**.

### Week 1 --- Shell fundamentals

    Day Topic
  ----- -----------------------------------------------
      1 Shell, terminal, Bash, and Linux architecture
      2 Command execution and `PATH`
      3 Built-in vs external commands
      4 Variables and environment variables
      5 Quoting and expansions
      6 Redirection and pipes
      7 Exit status and command operators

### Week 2 --- Bash programming

    Day Topic
  ----- -------------------------------
      8 Input and output
      9 Conditional statements
     10 For, while, and until loops
     11 Functions
     12 Positional arguments
     13 Arrays and arithmetic
     14 File and directory operations

### Week 3 --- Advanced Bash

    Day Topic
  ----- ------------------------------------
     15 `grep`, `sed`, and `awk`
     16 Process and job management
     17 Signals and `trap`
     18 Subshells and process substitution
     19 Error handling and debugging
     20 Shell startup files
     21 `getopts` and script arguments

### Week 4 --- DevOps/SRE automation

    Day Topic
  ----- -------------------------------------
     22 Linux health monitoring script
     23 Disk and memory monitoring
     24 Service health-check script
     25 Log analysis automation
     26 Backup automation
     27 Kubernetes health-check script
     28 CI/CD Bash integration
     29 Production troubleshooting script
     30 Final automation project and review

### Suggested daily routine

-   10 minutes: Learn the concept.
-   20 minutes: Execute commands and write code.
-   10 minutes: Solve a practical exercise.

------------------------------------------------------------------------

## 35. Practice Exercises

Try these exercises in a Linux environment.

### Beginner

1.  Display your current working directory.
2.  List all files, including hidden files.
3.  Create a directory named `devops-lab`.
4.  Create a file named `notes.txt`.
5.  Store your name in a variable and print it.
6.  Print the current date and time.
7.  Find the location of the `ls` executable.
8.  Check the exit status of a successful and a failing command.

### Intermediate

1.  Write a script that checks whether a file exists.
2.  Write a script that checks whether a number is greater than 50.
3.  Print numbers from 1 to 100 using a loop.
4.  Read a username from standard input.
5.  Write a function that checks whether a service is active.
6.  Count the number of error lines in a log file.
7.  Redirect standard output and standard error to separate files.
8.  Accept a filename as the first script argument.

### Advanced

1.  Write a script that checks CPU and memory usage.
2.  Write a script that checks disk usage and warns above a threshold.
3.  Write a script that checks whether Nginx is running.
4.  Create a script that archives a directory with a timestamp.
5.  Write a log-analysis script using `grep`, `awk`, and `sort`.
6.  Use `trap` to clean up temporary files.
7.  Write a script that accepts command-line options using `getopts`.
8.  Run a script from cron and capture its output.

### DevOps/SRE mini-projects

1.  **Linux health checker:** Report hostname, uptime, CPU-related
    information, memory, and disk usage.
2.  **Service monitor:** Check a list of services and report failures.
3.  **Log analyzer:** Find HTTP 5xx responses and summarize counts.
4.  **Backup automation:** Create timestamped archives and manage
    retention.
5.  **Kubernetes health checker:** Check nodes, pods, deployments, and
    failed workloads using `kubectl`.
6.  **CI/CD helper:** Validate required environment variables and run
    build or deployment steps safely.

------------------------------------------------------------------------

## 36. Quick Reference

### Important commands

``` bash
pwd                 # Current directory
ls -lah             # List files, including hidden files
cd /path            # Change directory
mkdir directory     # Create directory
touch file.txt      # Create an empty file
cp source dest      # Copy
mv source dest      # Move or rename
rm file.txt         # Remove a file
cat file.txt        # Display file
less file.txt       # Read file interactively
grep "text" file    # Search file
find . -name "*.log" # Find matching files
ps aux              # Process list
top                 # Interactive process monitor
free -h             # Memory information
df -h               # Filesystem disk usage
du -sh directory    # Directory size
uptime              # System uptime and load averages
```

### Important Bash parameters

``` bash
$0       # Script name
$1       # First argument
$2       # Second argument
$#       # Number of arguments
$@       # All arguments
$?       # Last command/pipeline exit status
$$       # Current shell PID
$!       # Most recent background process PID
```

### Important operators

``` bash
;        # Sequential commands
&&       # Run next if previous succeeds
||       # Run next if previous fails
|        # Pipe
>        # Redirect stdout, overwrite
>>       # Redirect stdout, append
2>       # Redirect stderr
&        # Run asynchronously
$(...)   # Command substitution
$((...)) # Arithmetic expansion
```

### Recommended documentation

-   [GNU Bash Reference
    Manual](https://www.gnu.org/software/bash/manual/bash.html)
-   [GNU Coreutils
    Manual](https://www.gnu.org/software/coreutils/manual/coreutils.html)
-   [Linux man-pages project](https://www.kernel.org/doc/man-pages/)
-   [ShellCheck](https://www.shellcheck.net/) --- static analysis for
    shell scripts
-   [Google Shell Style
    Guide](https://google.github.io/styleguide/shellguide.html)

------------------------------------------------------------------------

## Final Learning Advice

Do not try to memorize every command in one day. Understand the
architecture first, then learn commands, scripting, process management,
and automation through practice.

A good learning sequence is:

1.  Understand Shell vs Terminal vs Bash vs Kernel.
2.  Understand how Linux executes a command.
3.  Learn everyday Linux commands.
4.  Learn Bash variables, conditions, loops, and functions.
5.  Learn pipes, redirection, and text processing.
6.  Learn process management and error handling.
7.  Build practical DevOps/SRE automation scripts.

**Goal:** Become comfortable writing safe, maintainable Bash scripts
that solve real Linux administration and production troubleshooting
problems.

Happy learning! 🚀
