module actuator
    use parameters

    implicit none


    ! xlocs:  The x coordinate of the actuator disk
    ! ylocs:  The y coordinate of the actuator disk
    ! speed:  The exponentially averaged velocity at the disk
    integer, save, dimension(:), allocatable :: xlocs
    integer, save, dimension(:), allocatable :: ylocs
    real,    save, dimension(:), allocatable :: speed

    contains

    subroutine initialize_actuator()
    ! Initialize the actuator disk with the file located at adisk_fname (found
    ! in the parameter file)


        ! idisk:   counter for looping over disks
        ! j:       temp variable for reading files
        ! temp:    temp variable for holding each pair of coordinates
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
    ! Use the velocity to update the speeds experienced at each actuator disk

        ! u (in):   downstream velocity field
        ! ulocal:   temp variable to store the local velocity at each disk
        ! ix,iy,idisk: iteration variables
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
    ! Remove the appropriate energy from the u velocity field from the disk
    ! power production, and return the resulting production

        ! u(inout):  downstream velocity field
        ! dt (in):   current time step
        ! h (in):    the spacing in the direction of flow (ie hx)
        ! pow (out): the power produced this timestep by the turbine. note that
        !            it is a positive quantity, unlike the aforce
        ! aforce:    force exerted on the fluid by the actuator disk. It should
        !            always be negative
        ! ix,iy,idisk: iteration variables
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

