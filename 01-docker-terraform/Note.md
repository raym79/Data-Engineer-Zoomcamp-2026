
1. docker
check docker if install properly
2. python -V
check python version
Note: -V and -v are different! 
Command	Meaning	What happens
python3 -v: verbose mode; Prints every module imported during startup and then starts the REPL
python3 -V: version; Prints Python version and exits
ctrl+D to exit verbose mode
3. PS1="> "
to changes terminal prompt to simply '> '
echo 'PS1="> "' > ~/.bashrc: apply to new terminal
4. docker run hello-world
see 'Hello from Docker!' meaning docker is runnning properly
5. docker run xxxx
run docker image.
e.g.: docker run ubuntu
6. docker run -it  ubuntu
root@2c6193587d2a:/# 
-it: interactive terminal 
once we see 'root@xxxx:', we are inside of image
7. inside image, type 'python3' to check if we install image.
apt update
apt install python3
but we exit and open a new image, python will not be there.
so we do this:
8. docker run -it python:3.13.11
this is a python image. 
(installation might take a bit while, can use docker run -it python:3.13.11-slim instead)
9. docker run -it --entrypoint=bash  python:3.13.11
“Start a Python 3.13.11 container and drop me directly into a Bash shell instead of running Python.”
->19min
