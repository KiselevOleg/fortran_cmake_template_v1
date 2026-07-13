submodule(integration_path_part_custom_curve) integration_path_part_custom_curve_impl
use system_exception___assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not, &
  equals
implicit none (type, external)

  contains

  module procedure integration_path_part_custom_curve_constructor
    call error_assert_not(location = module_name // &
      ".constructor", &
      message = "a start and an end points must be different", &
      condition = equals(start, end, 1d-7) &
    )
    !if (.not. present(without_checking_curve) .or. without_checking_curve) then
    if (.not. present(without_checking_curve)) then
      call check_curve(curve)
    else if (without_checking_curve) then
      call check_curve(curve)
    end if
    call error_assert(location = module_name // &
      ".constructor", &
      message = "scale must be > 1d-9", &
      condition = scale > 1d-9 &
    )

    call this%set_boundary_points(start, end)

    this%form => curve
    this%scale = scale
  end procedure integration_path_part_custom_curve_constructor

  module procedure projection_function_obj
    complex(dp) :: v, n

    interface
      function func(x)
      import :: dp
      implicit none (type, external)
        complex(dp), intent(in) :: x
      end function func
    end interface

    associate(a => this%get_start_point(), b => this%get_end_point())
      n = (b - a) / abs(b - a)

      v = a + (b - a) * (x + 1d0) * 0.5d0
      v = v + (0d0, 1d0) * n * this%form(x) * this%scale

      res = func(v) * abs(b - a) * 0.5d0
    end associate
  end procedure projection_function_obj
  module procedure normalized_delta_obj
    call error_assert(location = module_name // &
      ".normalized_delta_obj", &
      message = "dx > 0d0", &
      condition = dx > 0d0 &
    )

    associate( &
      a => this%get_start_point(), &
      b => this%get_end_point(), &
      scale => this%scale, &
      dt => dx, t => x &
    )
      associate(n => (b - a) / abs(b - a))
        res = cmplx(dt * abs(b - a), (this%form(t + dt) - this%form(t)) * scale, dp)
        res = res / real(res)
        res = res * n
        !res = res / abs(res)
      end associate
    end associate
  end procedure normalized_delta_obj
  module procedure start_projection_point
    associate(a => this%get_start_point(), b => this%get_end_point())
      res = - 1d0
    end associate
  end procedure start_projection_point
  module procedure end_projection_point
    associate(a => this%get_start_point(), b => this%get_end_point())
      res = 1d0
    end associate
  end procedure end_projection_point

  module procedure set_boundary_points_preparate
  end procedure set_boundary_points_preparate












  ! allow(implicit-external-procedures)
  pure subroutine check_curve(f)
  !implicit none (type, external)
  implicit none
    procedure(curve_form) :: f

    integer(i4) :: i

    call error_assert(location = module_name // &
      ".check_curve", &
      message = "curve(- 1d0) == 0d0 .and. curve(1d0) == 0d0", &
      condition = equals(f(- 1d0), 0d0, 1d-12) .and. equals(f(1d0), 0d0, 1d-12) &
    )

    call error_assert(location = module_name // &
      ".check_curve", &
      message = "abs(max(curve(x))) == 1", &
      condition = equals(maxval(abs([(f(i * 1d-2 - 1d0), i = 1, 200)])), 1d0, 1d-2) &
    )
  end subroutine check_curve
end submodule integration_path_part_custom_curve_impl
