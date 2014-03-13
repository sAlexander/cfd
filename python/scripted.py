# Simple Python scripting example.
#
# This assumes that you've pre-compiled the cfd code, and you're calling this script from the directory
# where ./cfd is located.
#
#

import os
import random
import string
import re

from multiprocessing import Pool
import numpy as np

## NDISKS: The number of actuator disks to use. This should match the parameter in the cfd executable
## NTHREADS: The number of jobs to run simultaneously
## NGENERATIONS: The number of new generations to run
## EXECUTABLE: The location of the cfd executable.
## RUNPREFIX: The prefered location for storing runtime information
NDISKS = 20
NTHREADS = 4
NGENERATIONS = 5
EXECUTABLE = './src/cfd'
RUNPREFIX = './run'

def execute(A):
    """EXECUTE: Take the disk locations, and run the CFD simulator
   
    Inputs:
          A: Actuator disk layout
    Outputs:
          power: The power produced by the layout
    """

    # make up a string, and set up absolute paths
    token = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(10))
    runpath = os.path.abspath(os.path.join(RUNPREFIX,token))
    exepath = os.path.abspath(EXECUTABLE)

    # make the run path
    os.mkdir(runpath)


    # write the actuator disk locations to file
    with open(os.path.join(runpath,'actuator.txt'),'w') as f:
        for a in A:
            f.write('%f %f' % a)

    # change into the run directory
    os.chdir(runpath)

    # run the executable
    results = os.popen(exepath).read()

    # Parse the results for the power
    regex = re.compile('Total Power Produced: ([\d.-]*)')
    r = regex.search(results)
    power = r.groups()[0]
    power = float(power)

    # return the results
    return power

def pertubate(A,dA):
    """PERTUBATE: Take a layout A, and pertubate it with magnitude dA

    Inputs:
        A: Initial layout
        dA: Pertubation magnitude
    Outputs:
        A: Perturbed layout
    """

    for i in range(0,NDISKS):
        # pertubate the disks
        A[i][0] = A[i][0]+ dA*random.random()
        A[i][1] = A[i][1]+ dA*random.random()

        # make sure the disks are located between 0 and 1
        A[i][0] = min(1,max(0,A[i][0]))
        A[i][1] = min(1,max(0,A[i][1]))

    # make sure things are between 0 and 1
    return A



def start():
    """START: This is where the magic happens
    create a random layout, run a generation with random pertubations
    and take the best of the generation to create a new generation
    """

    random.seed()

    pool = Pool(NTHREADS)

    # create the initial A
    A = []
    for _ in range(0,NDISKS):
        A.append([random.random(), random.random()])

    # we'll do this many improved sets of Nthread guesses
    for igen in range(0,NGENERATIONS):

        # Let's take A, and create four random pertubations. This pertubation
        # will decrease on each iteration.
        generation = []
        for _ in range(0,NTHREADS):
            dA = 2^(-igen)
            generation.append(pertubate(A,dA))
        result = pool.map(execute,generation)

        # take the best generation, and make it A.

if __name__ == '__main__':
    start()
