module save
    use parameters

    implicit none

    contains

    subroutine save_parameters()
    ! Save all of the parameters as a JSON file

        integer :: uid

        character(*), parameter :: filename = 'parameters.json'
        open(newunit=uid,file=write_dir//filename)

        write(uid,'(A)') '{'

        write(uid,'(A,I4,A)') '"nnx": ', nnx, ','
        write(uid,'(A,I4,A)') '"nny": ', nny, ','
        write(uid,'(A,f11.8,A)') '"lx": ', lx, ','
        write(uid,'(A,f11.8,A)') '"ly": ', ly, ','
        write(uid,'(A,f11.8,A)') '"hx": ', hx, ','
        write(uid,'(A,f11.8,A)') '"hy": ', hy, ','

        write(uid,'(A,f11.8,A)') '"uvel": ', uvel, ','
        write(uid,'(A,f11.9,A)') '"dpg": ', dpg, ','

        write(uid,'(A,f11.8,A)') '"cfl": ', cfl, ','
        write(uid,'(A,f11.8,A)') '"dt": ', dt, ','
        write(uid,'(A,f11.8,A)') '"tf": ', tf, ','
        write(uid,'(A,I8,A)') '"nts": ', nts, ','

        write(uid,'(A,I4,A)') '"niter": ', niter, ','

        write(uid,'(A,I4,A)') '"write_freq": ', write_freq, ','
        write(uid,'(A,A,A)') '"write_dir": "', write_dir, '",'

        write(uid,'(A,I4,A)') '"ndisks": ', ndisks, ','
        write(uid,'(A,A,A)') '"adisk_fname": "', adisk_fname, '",'
        write(uid,'(A,I4,A)') '"r": ', r, ','
        write(uid,'(A,f11.8,A)') '"alpha": ', alpha



        write(uid,'(A)') '}'

        close(uid)


    end subroutine

    subroutine save_vel(it,u,v)
    ! Save the velocity raw binary files, u followed by v

        integer, intent(in) :: it
        real, dimension(:,:), intent(in) :: u
        real, dimension(:,:), intent(in) :: v
        integer, parameter :: sizeofreal=4
        integer :: uid
        logical :: exist
        character*9 :: filename

        !! Save the full variables
        WRITE(filename,'(I0.5,A)') it,'.raw'
        open(newunit=uid,file=write_dir//filename, form='unformatted', &
             access='direct',recl=nnx*nny*sizeofreal*2)
        write(uid,rec=1) u,v
        close(uid)
    end subroutine

    subroutine save_pow(it,pow)
    ! Save the power production for the timestep

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
