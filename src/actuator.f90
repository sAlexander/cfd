module actuator
    use parameters, only: nnx, nny

    implicit none

    integer, parameter :: r = nnx/32
    real, parameter :: alpha = 0.5

    integer, save :: ndisks
    integer, save, dimension(:), allocatable :: xlocs
    integer, save, dimension(:), allocatable :: ylocs
    real, save, dimension(:), allocatable   :: speed

    contains

    subroutine initialize_actuator(nd)
        integer, intent(in) :: nd
        integer :: idisk

        ! save the number of disks
        ndisks = nd
        print *, 'creating this many disks', ndisks

        allocate(xlocs(ndisks), &
                 ylocs(ndisks), &
                 speed(ndisks))

        create_disks: do idisk=1,ndisks
            xlocs(idisk) = int(rand()*nnx)
            ylocs(idisk) = int(rand()*(nny-2*r-2))+r+1
            speed(idisk) = 0.0
            print *, 'located at', xlocs(idisk), ylocs(idisk)
        end do create_disks

    end subroutine

    subroutine update_actuator(u)
        real, intent(in), dimension(:,:) :: u
        real :: ulocal
        integer :: ix,iy,idisk

        update_velocity: do idisk=1,ndisks
            ix = xlocs(idisk)
            iy = ylocs(idisk)
            ulocal = sum(u(ix,(iy-r):(iy+r)))/(2*r+1)
            speed(idisk) = speed(idisk) + alpha*(ulocal - speed(idisk))
        end do update_velocity

    end subroutine

    subroutine apply_actuator(u,dt,h)
        real, intent(inout), dimension(:,:) :: u
        real, intent(in) :: dt, h

        real :: aforce
        integer :: ix,iy,idisk

        apply_force: do idisk=1,ndisks
            ix = xlocs(idisk)
            iy = ylocs(idisk)
            aforce = (-1.0/2.0)*(4.0/3.0)*(1.0-1.0/4.0)*speed(idisk)**2/h;
            u(ix,(iy-r):(iy+r)) = u(ix,(iy-r):(iy+r)) + dt*aforce
        end do apply_force
    end subroutine

            


end module

