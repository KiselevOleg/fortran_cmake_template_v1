submodule(integration_path_part) integration_path_part_impl
use system_exception___assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not, &
  equals
implicit none (type, external)

  contains

  module procedure set_boundary_points
    call error_assert_not(location = module_name // ".set_boundary_points", &
        message = "|start - end| > 1d-12", &
        condition = equals(start, end, 1d-12) &
    )

    call this%set_boundary_points_preparate(start = start, end = end)

    this%start_point = start
    this%end_point = end
  end procedure set_boundary_points
  module procedure get_start_point
    res = this%start_point
  end procedure get_start_point
  module procedure get_end_point
    res = this%end_point
  end procedure get_end_point
end submodule integration_path_part_impl
