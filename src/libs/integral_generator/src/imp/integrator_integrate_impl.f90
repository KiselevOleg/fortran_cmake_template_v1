submodule(integrator) integrator_integrate_impl
use system_exception___assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not, &
  equals
implicit none (type, external)

  contains

  module procedure integrate
    integer(i4) :: i

    res = 0d0

    !do concurrent (i = 1:size(this%part)) reduce(+:res)
    do i = 1, size(this%part)
      res = res + this%part(i)%integrate_template%run( &
        func = projection_func, &
        a = this%part(i)%path_part%start_projection_point(), &
        b = this%part(i)%path_part%end_projection_point(), &
        integration_element = this%part(i)%integrate_element, &
        eps = this%eps, &
        normalized_delta = normalized_delta_func &
      )
    end do

    contains
    pure complex(dp) function normalized_delta_func(x, dx) result(res)
    implicit none (type, external)
      real(dp), intent(in) :: x
      real(dp), intent(in) :: dx

      res = this%part(i)%path_part%normalized_delta(x = x, dx = dx)
    end function normalized_delta_func
    recursive complex(dp) function projection_func(x) result(res)
    implicit none (type, external)
      real(dp), intent(in) :: x

      res = this%part(i)%path_part%projection_function(func = func, x = x)
    end function projection_func
  end procedure integrate
end submodule integrator_integrate_impl
