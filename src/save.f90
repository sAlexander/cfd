module save
    use parameters

    implicit none

    contains

    subroutine save_parameters()

        integer :: uid

        character*22 :: filename
        filename = './data/parameters.json'
        open(newunit=uid,file=filename)

        write(uid,'(A)') '{'

        write(uid,'(A,I4,A)') '"nnx": ', nnx, ','
        write(uid,'(A,I4,A)') '"nny": ', nny, ','
        write(uid,'(A,f11.8,A)') '"lx": ', lx, ','
        write(uid,'(A,f11.8,A)') '"ly": ', ly, ','
        write(uid,'(A,f11.8,A)') '"hx": ', hx, ','
        write(uid,'(A,f11.8,A)') '"hy": ', hy, ','

        write(uid,'(A,f11.8,A)') '"uvel": ', uvel, ','

        write(uid,'(A,f11.8,A)') '"cfl": ', cfl, ','
        write(uid,'(A,f11.8,A)') '"dt": ', dt, ','
        write(uid,'(A,f11.8,A)') '"tf": ', tf, ','
        write(uid,'(A,I8,A)') '"nts": ', nts, ','

        write(uid,'(A,I4)') '"niter": ', niter



        write(uid,'(A)') '}'

        close(uid)


    end subroutine

    subroutine save_vel(it,u,v)
        integer, intent(in) :: it
        real, dimension(:,:), intent(in) :: u
        real, dimension(:,:), intent(in) :: v
        integer, parameter :: sizeofreal=4
        integer :: uid
        logical :: exist
        character*16 :: filename

        !! Save the full variables
        WRITE(filename,'(A,I0.5,A)') './data/',it,'.raw'
        open(newunit=uid,file=filename, form='unformatted', &
             access='direct',recl=nnx*nny*sizeofreal*2)
        write(uid,rec=1) u,v
        close(uid)
    end subroutine

    subroutine save_pow(it,pow)
        integer, intent(in) :: it
        real, intent(in) :: pow
        integer :: uid
        logical :: exist
        character*16 :: filename

        !! Save the power output
        WRITE(filename,'(A)') './data/power.txt'
        inquire(file=filename, exist=exist)
        if (exist) then
            open(newunit=uid,file=filename, status="old", position="append", action="write")
        else
            open(newunit=uid,file=filename, status="new", action="write")
        end if
        write(uid,*) pow
        close(uid)

    end subroutine



end module
