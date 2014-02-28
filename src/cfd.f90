program cfd

use parameters
use diff
use save
use actuator
implicit none

integer,parameter :: seed = 86456
real,parameter :: pi = 3.14159
integer :: ix, iy, it, ii


real :: gamma

real, allocatable,dimension(:,:) :: u,v,p,ua,va,ud,vd,uvx,uvy,u2x,v2y,rhs

call save_parameters()

allocate( u(nnx,nny), &
          v(nnx,nny), &
          p(nnx,nny), &
          ua(nnx,nny), &
          va(nnx,nny), &
          ud(nnx,nny), &
          vd(nnx,nny), &
          uvx(nnx,nny), &
          uvy(nnx,nny), &
          u2x(nnx,nny), &
          v2y(nnx,nny), &
          rhs(nnx,nny) &
)

!!
print *, 'Time Step: ', dt

! create random initial pertubation
call srand(seed)
do ix=1,nnx
    do iy=1,nny
        p(ix,iy) = rand()/1000.0
    end do
end do

! seed u and v off this initial pertubation
u = p
v = p
call ddy(u,1.0)
call ddx(v,1.0)
u = u + uvel
p = p*0.0
call initialize_actuator(10)

do it=1,nts

    !! Calculate the uvx and uvy with upwinding
    gamma = min(1.2*dt*max(maxval(abs(u))/h,maxval(abs(v))/h),1.0);
    ua = u; call yavg(ua); ua = cshift(ua,shift=-1,dim=2);
    ud = u; call ddy(ud,2.0); ud = cshift(ud,shift=-1,dim=2);
    va = v; call xavg(va); va = cshift(va,shift=-1,dim=1);
    vd = v; call ddx(vd,2.0); vd = cshift(vd,shift=-1,dim=1);

    uvx = (ua * va) - (gamma * abs(ua) * vd)
    call ddx(uvx,h);

    uvy = (ua * va) - (gamma * abs(va) * ud)
    call ddy(uvy,h);

    !! Calculate the u2x and v2y terms
    ua = u; call xavg(ua);
    ud = u; call ddx(ud,2.0);
    va = v; call yavg(va);
    vd = v; call ddy(vd,2.0);

    u2x = ua*ua - gamma*abs(ua)*ud
    call ddx(u2x,h); u2x = cshift(u2x,shift=-1,dim=1)

    v2y = va*va - gamma*abs(va)*vd
    call ddy(v2y,h); v2y = cshift(v2y,shift=-1,dim=2)


    !! update the u and v variables
    u = u - dt*(uvy+u2x)
    v = v - dt*(uvx+v2y)

    !! Pressure

    ud = u; call ddx(ud,h)
    vd = v; call ddy(vd,h)
    rhs = ud + vd
    do ii=1,niter
        p = 0.25*(myiter(p,h) - h**2*rhs)
    end do
    ud = cshift(p,shift=-1,dim=1); call ddx(ud,h)
    vd = cshift(p,shift=-1,dim=2); call ddy(vd,h)
    u = u - ud
    v = v - vd

    call update_actuator(u)
    call apply_actuator(u,dt,h)

    if (mod(it,10) == 0) then
        call save_vel(it,u,v)
    end if 

end do



end program
