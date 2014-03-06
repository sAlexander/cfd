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

# prepare the expected data directory
mkdir data

# run the code
./cfd
```


