module diff
    implicit none

    contains

    subroutine ddx(u,h)
        real, dimension(:,:), intent(inout) :: u
        real, intent(in) :: h

            !$OMP WORKSHARE
                u = (cshift(u,shift=1,dim=1) - u)/h
            !$OMP END WORKSHARE
    end subroutine

    subroutine ddy(u,h)
        real, dimension(:,:), intent(inout) :: u
        real, intent(in) :: h

        !$OMP WORKSHARE
            u = (cshift(u,shift=1,dim=2) - u)/h
        !$OMP END WORKSHARE
    end subroutine

    subroutine lap(u,h)
        real, dimension(:,:), intent(inout) :: u
        real, intent(in) :: h

        u = ( cshift(u,shift=+1, dim=2) &
             +cshift(u,shift=-1,dim=2) &
             +cshift(u,shift=+1,dim=1) &
             +cshift(u,shift=-1,dim=1) &
             -4*u) / h**2
              
    end subroutine

    function myiter(p,h)
        real, dimension(:,:), intent(in) :: p
        real, intent(in) :: h
        real, dimension(size(p,1),size(p,2)) :: myiter

        !$OMP WORKSHARE
        myiter = (cshift(p,shift=+1, dim=2) &
             +cshift(p,shift=-1,dim=2) &
             +cshift(p,shift=+1,dim=1) &
             +cshift(p,shift=-1,dim=1))
        !$OMP END WORKSHARE
    end function

    subroutine xavg(u)
        real, dimension(:,:), intent(inout) :: u
        u = (cshift(u,shift=1,dim=1) + u)/2
    end subroutine

    subroutine yavg(u)
        real, dimension(:,:), intent(inout) :: u
        u = (cshift(u,shift=1,dim=2) + u)/2
    end subroutine

end

