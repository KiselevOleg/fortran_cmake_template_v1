submodule(integration_path_part_parallel_Re) integration_path_part_parallel_Re_impl
use system___assert, only: error_assert, error_not_assert, &
  warning_assert, warning_not_assert, &
  equals
implicit none (type, external)

  contains

  module procedure integration_path_part_parallel_Re_constructor
    call error_assert(location = module_name // &
      ".constructor", &
      message = "abs(delta_Re) > 0", &
      condition = abs(delta_Re) > 0d0 &
    )

    call this%set_boundary_points(start, start + delta_Re)
  end procedure integration_path_part_parallel_Re_constructor

  module procedure projection_function_obj
    complex(dp) :: v

    interface
      function func(x)
      import :: dp
      implicit none (type, external)
        complex(dp), intent(in) :: x
      end function func
    end interface

    associate(a => this%get_start_point(), b => this%get_end_point())
      v = x + aimag(a) * (0d0, 1d0)

      res = func(v)
    end associate
  end procedure projection_function_obj
  module procedure normalized_delta_obj
    call error_assert(location = module_name // &
      ".normalized_delta_obj", &
      message = "dx > 0d0", &
      condition = dx > 0d0 &
    )

    associate(a => this%get_start_point(), b => this%get_end_point())
      res = (1d0, 0d0)
      if (real(a) > real(b)) res = - res
    end associate
  end procedure normalized_delta_obj
  module procedure start_projection_point
    associate(a => this%get_start_point(), b => this%get_end_point())
      res = min(real(a), real(b))
    end associate
  end procedure start_projection_point
  module procedure end_projection_point
    associate(a => this%get_start_point(), b => this%get_end_point())
      res = max(real(a), real(b))
    end associate
  end procedure end_projection_point

  module procedure set_boundary_points_preparate
    call error_assert(location = module_name // ".set_boundary_points", &
      message = "|Im(start - end)| < 1d-12", &
      condition = equals(aimag(start - end), 0d0, 1d-12) &
    )
  end procedure set_boundary_points_preparate
end submodule integration_path_part_parallel_Re_impl
