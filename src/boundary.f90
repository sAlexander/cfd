module boundary
    use parameters
    implicit none
    real, parameter :: pi=3.14159

    contains

        subroutine apply_boundary(u,v,lev,it)
            real, dimension(:,:), intent(inout) :: u,v
            integer, intent(in) :: lev
            integer, intent(in) :: it
            integer :: iy
            real :: yvel

            if (lev == 1) then ! steady winds
                yvel = 0.125*sin(pi*it*dt/tf*10)
                do iy=1,nny
                    u(1,iy) = 4.0 + rand()/4.0
                    v(1,iy) = yvel
                end do

                u(nnx,:) = u(nnx-1,:)
                v(nny,:) = v(nnx-1,:)
            end if
        end subroutine


end module

