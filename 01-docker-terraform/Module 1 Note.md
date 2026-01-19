# 01-docker-terraform
1. docker
    * check docker if install properly
2. python -V
    * check python version
    * Note: -V and -v are different! 
    * Command	Meaning	What happens
    * python3 -v: verbose mode; Prints every module imported during startup and then starts the REPL
    * python3 -V: version; Prints Python version and exits
    * ctrl+D to exit verbose mode
3. PS1="> "
    * to changes terminal prompt to simply '> '
    * echo 'PS1="> "' > ~/.bashrc: apply to new terminal
4. docker run hello-world
    * see 'Hello from Docker!' meaning docker is runnning properly
5. docker run xxxx
    * run docker image.
    * e.g.: docker run ubuntu
6. docker run -it  ubuntu
    * root@2c6193587d2a:/# 
    * -it: interactive terminal 
once we see 'root@xxxx:', we are inside of image
7. inside image, type 'python3' to check if we install image.
    * apt update
    * apt install python3
    * but we exit and open a new image, python will not be there.
    * so we do this:
8. docker run -it python:3.13.11
    * this is a python image. 
    * (installation might take a bit while, can use docker run -it python:3.13.11-slim instead)
9. docker run -it --entrypoint=bash  python:3.13.11
    * “Start a Python 3.13.11 container and drop me directly into a Bash shell instead of running Python.”
10. Bash
    1. Why Bash Matters in Docker: Docker containers start with a process. Every container runs ONE main process.
        * Example: ``` docker run python:3.13.11 ```
            * Main process: ``` python3 ```
            * When you override: ``` --entrypoint=bash ```
            * Main process becomes: ``` bash ```
        * That means:
            * Bash is PID 1
            * Bash controls everything in the container
            * When Bash exits → container stops
    2. Why Engineers Use Bash Instead of Python REPL
        * Without Bash, You can’t:
            * Inspect files
            * Run ```ls```
            * Check environment variables
            * Install packages
            * Debug
        * With Bash, You can:
            * ``` ls ```
            * ``` env ```
            * ``` cat /etc/os-release ```
            * ``` pip install something ```
        * This is mandatory for debugging real systems.
    3. Key: 
        * Bash is the operating layer
        * Python is the application layer
        * SQL is the data layer
11. echo 123 > file
    * Write the text 123 into a file named file
    * '>' overwrite
    * '>>' append 
12. docker ps -a (docker ps -aq: no headers, etc.)
    * List all Docker containers on your machine — running and stopped
13. docker ps -aq 
14. Volume
    * What Is a Volume?
        * A Docker volume is a way to store data outside of a container, so that:
            * Data persists after the container stops
            * Data can be shared between containers
            * Data can be mounted into containers
        * > “A folder on the host machine that the container can see.”
    * Example:
        ```
        docker run -it \
        --rm \
        -v $(pwd)/test:/app/test \
        --entrypoint=bash \
        python:3.9.16-slim
        ```
        * > Start a lightweight Python 3.9 container, mount a specific host folder into it, and drop me into a Bash shell so I can explore and debug interactively.
        * notes
            * $(pwd): current working directory
            * A:B -> mapping A to B 

# 02-virtual-environment