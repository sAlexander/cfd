module parameters
    implicit none

    !! Problem Size
    integer, parameter :: nnx = 50
    integer, parameter :: nny = 50
    real, parameter :: lx = 1.0
    real, parameter :: ly = 1.0
    real, parameter :: h = lx/nnx

    !! Flow Parameters
    real, parameter :: uvel = 4.0

    !! Time Step and TF
    real, parameter :: cfl = 0.5
    real, parameter :: dt = h/uvel*cfl
    real, parameter :: tf = 1.0
    integer, parameter :: nts = tf/dt
    integer, parameter :: niter = 50

end module

