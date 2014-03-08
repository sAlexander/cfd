# Simple Python scripting example.
#
# This assumes that you've pre-compiled the cfd code, and you're calling this script from the directory
# where ./cfd is located.
#
#

import os
import random
import string

from multiprocessing import Pool
from numpy import np

Ndisks = 20
Nthreads = 4
Ngenerations = 5

def run(A):
    # A: actuator locations
    # dA: petubation size

    # make up a string, and then make a directory for the run
    token = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(10))
    os.mkdir(token)

    # Pertubate the actuator locations
    return A

def pertubate(A,dA):
    for i in range(0,Ndisks):
        A[i][0] = A[i][0]+ dA*random.random()
        A[i][1] = A[i][1]+ dA*random.random()

    # make sure things are between 0 and 1
    return A



if __name__ == '__main__':

    random.seed()

    # create the initial A
    A = []
    for _ in range(0,Ndisks):
        A.append([random.random(), random.random()])

    # we'll do this many improved sets of Nthread guesses
    for igen in range(0,Ngenerations):

        # Let's take A, and create four random pertubations. This pertubation
        # will decrease on each iteration.
        generation = []
        for _ in range(0,Nthreads):
            dA = 2^(-igen)
            generation.append(pertubate(A,dA))
        result = pool.map(run,generation)

        # take the best generation, and make it A.
