module utils

    implicit none
    contains

        subroutine echo(u)
            real, dimension(:,:),intent(in) :: u
            integer :: ix,iy

            do iy=1,5
                write(*,*) u(1:5,iy)
            end do

        end subroutine

end module
