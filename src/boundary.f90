module boundary
    use parameters
    implicit none

    contains

        subroutine apply_boundary(u,v,lev,it)
        ! update the boundary conditions for the flow. Currently only defined
        ! for steady winds from left to right (lev == 1)

            ! u (inout): downstream wind direction
            ! v (inout): crossstream wind direction
            ! lev (in):  the type of boundary condition
            !            (1) constant flow from left to right
            ! it (in):   current time level
            ! yvel:      temp storage for y velocity
            ! iy:        iteration variable
            real, dimension(:,:), intent(inout) :: u,v
            integer, intent(in) :: lev
            integer, intent(in) :: it
            real :: yvel
            integer :: iy

            if (lev == 1) then ! steady winds
                yvel = 0.125*sin(pi*it*dt/tf*10)
                do iy=1,nny
                    u(1,iy) = 4.0
                    v(1,iy) = yvel
                end do

                u(nnx,:) = u(nnx-1,:) ! periodic on top and bottom
                v(nny,:) = v(nnx-1,:)
            end if
        end subroutine


end module

