# Simple Python scripting example for the cfd code.
#
# This assumes that you've pre-compiled the cfd code.
#
#

# global libraries
import os
import random
import string
import re
from copy import deepcopy
from multiprocessing import Pool


###### PARAMETERS ####
## NDISKS: The number of actuator disks to use. This should match the parameter in the cfd executable
## NTHREADS: The number of jobs to run simultaneously
## NGENERATIONS: The number of new generations to run
## EXECUTABLE: The location of the cfd executable.
## RUNPREFIX: The prefered location for storing runtime information
## Verbose: Do you want to know what's going on?
NDISKS = 20
NTHREADS = 4
NGENERATIONS = 5
EXECUTABLE = './src/cfd'
RUNPREFIX = './run'
VERBOSE = True
##
##




# Set all of the path information
EXEPATH = os.path.abspath(EXECUTABLE)
RUNPREFIXPATH = os.path.abspath(RUNPREFIX)
if not os.path.isdir(RUNPREFIXPATH):
    os.mkdir(RUNPREFIXPATH)





def execute(A):
    """EXECUTE: Take the disk locations, and run the CFD simulator. 
    This is called by the start function
   
    Inputs:
          A: Actuator disk layout
    Outputs:
          power: The power produced by the layout
    """

    # make up a string where we'll keep all of the files, and set up absolute paths
    token = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(10))
    runpath = os.path.abspath(os.path.join(RUNPREFIXPATH,token))
    exepath = EXEPATH

    log('Starting a job with token %s' % token)

    # make the run path
    os.mkdir(runpath)


    # write the actuator disk locations to file
    with open(os.path.join(runpath,'adisk.txt'),'w') as f:
        for a in A:
            f.write('%f %f\n' % tuple(a))

    # change into the run directory
    os.chdir(runpath)

    # run the executable
    results = os.popen(exepath).read()

    # Parse the results for the power using a regular expression
    regex = re.compile('Total Power Produced:[\s]*([\d.-]*)')
    r = regex.search(results)
    power = r.groups()[0]
    power = float(power)

    log('Job with token %s completed with production %f' % (token,power))

    # return the results
    return power




def pertubate(A,dA,i):
    """PERTUBATE: Take a layout A, and pertubate it with magnitude dA. This is a very simple, random pertubation
    This is called by the start function

    Inputs:
        A: Initial layout
        dA: Pertubation magnitude
        i: The ith pertubation... used to get a more random seed for the random number generator
    Outputs:
        A: Perturbed layout
    """

    r = random.SystemRandom()


    for i in range(0,NDISKS):
        # pertubate the disks
        A[i][0] = A[i][0]+ r.uniform(-dA,dA)
        A[i][1] = A[i][1]+ r.uniform(-dA,dA)

        # make sure the disks are located between 0 and 1
        A[i][0] = min(1,max(0,A[i][0]))
        A[i][1] = min(1,max(0,A[i][1]))

    # make sure things are between 0 and 1
    return A




def log(message):
    """LOG: Log the given message if VERBOSE is set to True"""

    if VERBOSE == True:
        print message





def start(A = None):
    """START: This is where the magic happens
    create a random layout, run a generation with random pertubations
    and take the best of the generation to create a new generation
    """

    log('--------------------------------------')
    log('----------- STARTING -----------------')
    log('-- Number of Generations: %d' % NGENERATIONS)
    log('-- Number of Threads: %d' % NTHREADS)
    log('--------------------------------------')
    log('')


    # randcount is used to seed the random number generator
    randcount = 0

    # define an A if one isn't given
    if A == None:
        A = []
        for _ in range(0,NDISKS):
            A.append([random.uniform(0,1), random.uniform(0,1)])

    # we'll do this many improved sets of Nthread guesses
    for igen in range(0,NGENERATIONS):

        # start a pool of workers
        pool = Pool(NTHREADS)

        # Let's take A, and create four random pertubations. This pertubation
        # will decrease on each iteration.
        dA = 2**(-igen-1)

        log('-------- Generation %d-----------------' % (igen + 1))
        log('-------- Pertubation %7.4f --------' % dA)

        # create a list of layouts, one for each individual in our generation
        generation = []
        for _ in range(0,NTHREADS):
            new = pertubate(A,dA,randcount)
            generation.append(deepcopy(new))
            randcount = randcount + 1

        # run the full generation
        results = pool.map_async(execute,generation).get(9999999)

        # close the pool
        pool.close()
        pool.join()

        log('-------- Generation %d Results -------' % (igen + 1))
        for i, result in enumerate(results):
            log('-- Individual %d: %f' % (i,result))
        log('-- --------')
        log('-- Best Result: %f' % max(results))

        # take the best generation, and make it the base A for the new generation.
        Aind = results.index(max(results))
        A = generation[Aind]

        if NGENERATIONS > igen + 1:
            log('-- Starting new generation from previous best')
            log('')





# if called from the command line, start 'er up.
if __name__ == '__main__':
    start()
