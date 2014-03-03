module parameters
    implicit none

    !! Problem Size
    !! NOTE: Pressure solver only works for hx==hy
    integer, parameter :: nnx = 100
    integer, parameter :: nny = 100
    real, parameter :: lx = 1.0
    real, parameter :: ly = 1.0
    real, parameter :: hx = lx/nnx
    real, parameter :: hy = ly/nny
    real, parameter :: hm = min(hx,hy)

    !! Flow Parameters
    real, parameter :: uvel = 4.0
    real, parameter :: dpg  = 2.00 ! works well for 10 turbines

    !! Time Step and TF
    real, parameter :: cfl = 0.5
    real, parameter :: dt = hm/(3*uvel)*cfl
    real, parameter :: tf = 4.0
    integer, parameter :: nts = tf/dt
    integer, parameter :: niter = 50

    !! Actuator disk setup
    integer, parameter :: ndisks = 20
    character (len=*), parameter :: adisk_fname = './adisk.txt'

end module

