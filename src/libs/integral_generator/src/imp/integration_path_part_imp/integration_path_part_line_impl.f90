submodule(integration_path_part_line) integration_path_part_line_impl
use system___assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not, &
  equals
implicit none (type, external)

  contains

  module procedure integration_path_part_line_constructor
    call error_assert_not(location = module_name // &
      ".constructor", &
      message = "a start and an end points must be different", &
      condition = equals(start, end, 1d-7) &
    )

    call this%set_boundary_points(start, end)
  end procedure integration_path_part_line_constructor

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
      v = a + x * (b - a) / abs(b - a)

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
      res = (b - a) / abs(b - a)
    end associate
  end procedure normalized_delta_obj
  module procedure start_projection_point
    associate(a => this%get_start_point(), b => this%get_end_point())
      res = 0d0
    end associate
  end procedure start_projection_point
  module procedure end_projection_point
    associate(a => this%get_start_point(), b => this%get_end_point())
      res = abs(b - a)
    end associate
  end procedure end_projection_point

  module procedure set_boundary_points_preparate
  end procedure set_boundary_points_preparate
end submodule integration_path_part_line_impl
