module actuator
    use parameters, only: nnx, nny, ndisks, adisk_fname

    implicit none

    integer, parameter :: r = nnx/32
    real, parameter :: alpha = 0.5

    integer, save, dimension(:), allocatable :: xlocs
    integer, save, dimension(:), allocatable :: ylocs
    real, save, dimension(:), allocatable   :: speed

    contains

    subroutine initialize_actuator()

        integer :: idisk,j, uid
        real, dimension(2) :: temp

        ! Allocate room for the disks
        allocate(xlocs(ndisks), &
                 ylocs(ndisks), &
                 speed(ndisks))

        !! Read the disks
        open(newunit=uid, file=adisk_fname, status='old', action='read')
        read_disks: do idisk=1,ndisks
            read(uid,*) (temp(j), j=1,2)
            xlocs(idisk) = temp(1)*nnx
            ylocs(idisk) = temp(2)*nny
            
            ! make sure it's within bounds
            xlocs(idisk) = min(xlocs(idisk),nnx)
            xlocs(idisk) = max(xlocs(idisk),r)
            ylocs(idisk) = min(ylocs(idisk),nny-r-1)
            ylocs(idisk) = max(ylocs(idisk),r+1)

            speed(idisk) = 0.0
        end do read_disks
        close(uid)

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

    subroutine apply_actuator(u,dt,h,pow)
        real, intent(inout), dimension(:,:) :: u
        real, intent(in) :: dt, h
        real, intent(out) :: pow

        real :: aforce
        integer :: ix,iy,idisk

        pow = 0.0
        apply_force: do idisk=1,ndisks
            ix = xlocs(idisk)
            iy = ylocs(idisk)
            aforce = (-1.0/2.0)*(4.0/3.0)*(1.0-1.0/4.0)*speed(idisk)**2/h;
            pow = pow - aforce
            u(ix,(iy-r):(iy+r)) = u(ix,(iy-r):(iy+r)) + dt*aforce
        end do apply_force
    end subroutine

            


end module

