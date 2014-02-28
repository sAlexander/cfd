import os
import json
from matplotlib import pyplot as plt
import numpy as np

def printit(filename,plotname):
    res = np.fromfile(filename,dtype='f4',count=-1)
    var = np.reshape(res,(2,pars['nnx'],pars['nny']))
    plt.imshow(var[0,:,:],vmin=1.5,vmax=4.5)
    plt.colorbar()
    plt.savefig(plotname)
    plt.close()

if __name__ == '__main__':
    basedir = './src/data'
    plotdir = os.path.join(basedir,'plots')

    parsfname = os.path.join(basedir,'parameters.json')
    pars = json.loads(open(parsfname,'r').read())

    print pars

    filenames=  os.listdir(basedir)
    filenames.sort()
    for i,filename in enumerate(filenames):
        print i
        path = os.path.join(basedir,filename)
        plotpath = os.path.join(plotdir,'%04d.png' % i)
        printit(path,plotpath)

