# 2D CFD 
## Solves the incompressible Euler equations.

The code solves the incompressible Euler equations. The code closely follows the derivation here:
http://www-math.mit.edu/cse/codes/mit18086_navierstokes.pdf

## Running the code.

Running the code is as simple as:

```
# get the repository
git clone git@github.com:sAlexander/cfd.git
cd cfd/src

# compile all of the fortran
make

# run the code
./cfd
```

## Scripting with the code

A sample script has been added as `python/scripted.py`. This simple script will run a simple genetic algorithm in parallel -- parameters are explained in the file.

To run the script, the following will suffice:

```
# get the repository
git clone git@github.com:sAlexander/cfd.git
cd cfd/src

# compile all of the fortran
make

# move back up to the root directory
cd ..

# run the script
python python/scripted.py
```


