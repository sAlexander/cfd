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
        write(uid,'(A,f11.8,A)') '"h": ', h, ','

        write(uid,'(A,f11.8,A)') '"uvel": ', uvel, ','

        write(uid,'(A,f11.8,A)') '"cfl": ', cfl, ','
        write(uid,'(A,f11.8,A)') '"dt": ', dt, ','
        write(uid,'(A,f11.8,A)') '"tf": ', tf, ','
        write(uid,'(A,I8,A)') '"nts": ', nts, ','

        write(uid,'(A,I4)') '"niter": ', niter



        write(uid,'(A)') '}'


    end subroutine

    subroutine save_vel(it,u,v)
        integer, intent(in) :: it
        real, dimension(:,:), intent(in) :: u
        real, dimension(:,:), intent(in) :: v
        integer, parameter :: sizeofreal=4
        integer :: uid
        character*15 :: filename

        WRITE(filename,'(A,I0.4,A)') './data/',it,'.raw'

        open(newunit=uid,file=filename, form='unformatted', &
             access='direct',recl=nnx*nny*sizeofreal*2)

        write(uid,rec=1) u,v
        close(uid)
    end subroutine



end module
