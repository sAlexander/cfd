module diff
    implicit none

    contains

    subroutine ddx(u,h)
    ! take the forward derivative wrt x

        real, dimension(:,:), intent(inout) :: u
        real, intent(in) :: h

        u = (cshift(u,shift=1,dim=1) - u)/h
    end subroutine

    subroutine ddy(u,h)
    ! take the forward derivative wrt y

        real, dimension(:,:), intent(inout) :: u
        real, intent(in) :: h

        u = (cshift(u,shift=1,dim=2) - u)/h
    end subroutine

    subroutine lap(u,h)
    ! calculate the finite difference approximation to the laplacian

        real, dimension(:,:), intent(inout) :: u
        real, intent(in) :: h

        u = ( cshift(u,shift=+1, dim=2) &
             +cshift(u,shift=-1,dim=2) &
             +cshift(u,shift=+1,dim=1) &
             +cshift(u,shift=-1,dim=1) &
             -4*u) / h**2
              
    end subroutine

    function myiter(p,h)
    ! calculate the iteration for the Poisson solver. Note that this is exactly
    ! the same as the laplacian, but without the final -4*u term, and
    ! non-periodic boundaries on the left and right (it uses Neumann BCs
    ! instead)

        real, dimension(:,:), intent(in) :: p
        real, intent(in) :: h
        real, dimension(size(p,1),size(p,2)) :: myiter
        integer :: nnx

        nnx = size(p,1)

        myiter = (cshift(p,shift=+1, dim=2) &
             +cshift(p,shift=-1,dim=2) &
             +cshift(p,shift=+1,dim=1) &
             +cshift(p,shift=-1,dim=1))
        myiter(1,:) = myiter(1,:)-p(nnx,:)
        myiter(nnx,:) = myiter(nnx,:)-p(1,:)
    end function

    subroutine xavg(u)
    ! calculate the forward average wrt x

        real, dimension(:,:), intent(inout) :: u
        u = (cshift(u,shift=1,dim=1) + u)/2
    end subroutine

    subroutine yavg(u)
    ! calculate the forward averate wrt y

        real, dimension(:,:), intent(inout) :: u

        u = (cshift(u,shift=1,dim=2) + u)/2
    end subroutine

end

