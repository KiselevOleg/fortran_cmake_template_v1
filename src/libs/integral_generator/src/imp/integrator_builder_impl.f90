submodule(integrator) integrator_builder_impl
use system___assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not, &
  equals
use, intrinsic :: ieee_arithmetic, only: ieee_value, ieee_quiet_nan, ieee_signaling_nan, &
  ieee_is_nan
implicit none (type, external)
  real(dp), parameter :: MAX_ABS_POINT_COORDINATE_VALUE_DEFAULT = 1000d0
  real(dp), parameter :: EPS_DEFAULT = 1d-3
  real(dp), parameter :: MIN_ABS_POINT_DIFFERENCE_BETWEEN_START_AND_END_POINTS_DEFAULT = 1d-7

  contains

  module procedure integrator_builder_constructor
    if (present(reserve)) call error_assert(location = module_name // &
      ".builder_constructor", &
      message = "reserve > 0", &
      condition = reserve > 0 &
    )

    this%path_part_size = 1
    if (present(reserve)) this%path_part_size = reserve
    allocate(this%part(this%path_part_size))

    this%eps = EPS_DEFAULT
    this%max_abs_point_coordinate_value = MAX_ABS_POINT_COORDINATE_VALUE_DEFAULT

    this%path_part_size = 0
  end procedure integrator_builder_constructor

  module procedure build
    integer(i4) :: i

    call check_correct(this)

    associate(size => this%path_part_size)
      !call move_alloc(from = this%part, to = res%part)
      allocate(res%part(size))

      do concurrent(i = 1:size)
        res%part(i) = this%part(i)
      end do
    end associate

    res%eps = this%eps
  end procedure build


  module procedure add_new_path_part
    this%path_part_size = this%path_part_size + 1

    associate(part_size => this%path_part_size)
      if (part_size > size(this%part)) then
        block
          type(part_obj), allocatable :: tmp(:)
          call move_alloc(from = this%part, to = tmp)

          allocate(this%part(max(part_size, size(tmp) + size(tmp))))
          this%part(1:size(tmp)) = tmp
        end block
      end if

      this%part(part_size)%path_part = path_part
      if (part_size > 1) then
        this%part(part_size)%integrate_template = this%part(part_size - 1)%integrate_template
        this%part(part_size)%integrate_element = this%part(part_size - 1)%integrate_element
      end if
      this%part(part_size)%min_abs_point_difference_between_start_and_end_points = &
        MIN_ABS_POINT_DIFFERENCE_BETWEEN_START_AND_END_POINTS_DEFAULT
      if (part_size > 1) then
        this%part(part_size)%min_abs_point_difference_between_start_and_end_points = &
          this%part(part_size - 1)%min_abs_point_difference_between_start_and_end_points
      end if
    end associate
  end procedure add_new_path_part
  module procedure part_integration_strategy
    call error_assert_not(location = module_name // &
      ".part_integration_strategy", &
      message = "path part size == 0", &
      condition = this%path_part_size == 0 &
    )

    associate(part_size => this%path_part_size)
      this%part(part_size)%integrate_template = template
      this%part(part_size)%integrate_element = element
    end associate
  end procedure part_integration_strategy

  module procedure last_start_previous
    call error_assert_not(location = module_name // &
      ".last_start_previous", &
      message = "path part size == 0", &
      condition = this%path_part_size == 0 &
    )

    res = this%part(this%path_part_size)%path_part%get_start_point()
  end procedure last_start_previous
  module procedure last_start_new
    res = value
  end procedure last_start_new
  module procedure last_end_previous
    call error_assert_not(location = module_name // &
      ".last_end_previous", &
      message = "path part size == 0", &
      condition = this%path_part_size == 0 &
    )

    res = this%part(this%path_part_size)%path_part%get_end_point()
  end procedure last_end_previous
  module procedure last_end_new
    res = value
  end procedure last_end_new

  module procedure set_boundary_points
    call this%part(this%path_part_size)%path_part%set_boundary_points(start, end)
  end procedure set_boundary_points

  module procedure set_min_abs_point_difference_between_boundary_points
    call error_assert_not(location = module_name // &
      ".set_min_abs_point_difference_between_boundary_points", &
      message = "path part size == 0", &
      condition = this%path_part_size == 0 &
    )

    this%part%min_abs_point_difference_between_start_and_end_points = value
  end procedure set_min_abs_point_difference_between_boundary_points

  module procedure set_accuration
    this%eps = eps
  end procedure set_accuration





  pure subroutine check_correct(this)
  implicit none (type, external)
    class(integrator_builder_obj), intent (in) :: this

    integer(i4) :: i

    associate( &
      part_size => this%path_part_size, &
      eps => this%eps, &
      max_abs_point_coordinate_value => this%max_abs_point_coordinate_value, &
      start_point => &
        [(this%part(i)%path_part%get_start_point(), i = 1, this%path_part_size)], &
      end_point => &
        [(this%part(i)%path_part%get_end_point(), i = 1, this%path_part_size)], &
      min_abs_point_difference => &
        [( &
          this%part(i)%min_abs_point_difference_between_start_and_end_points, &
          i = 1, this%path_part_size &
        )] &
    )
      call error_assert_not(location = module_name // &
        ".check_correct", &
        message = "path part size == 0", &
        condition = part_size == 0 &
      )
      call error_assert(location = module_name // &
        ".check_correct", &
        message = "1d-9 <= eps .and. eps <= 1d0", &
        condition = 1d-9 <= eps .and. eps <= 1d0 &
      )
      call error_assert(location = module_name // &
        ".check_correct", &
        message = "max_abs_point_coordinate_value > 0d0", &
        condition = max_abs_point_coordinate_value > 0d0 &
      )
      call error_assert(location = module_name // &
        ".check_correct", &
        message = "max_abs_point_coordinate_value < 1d100", &
        condition = max_abs_point_coordinate_value < 1d100 &
      )
      do concurrent (i = 1:part_size)
        call error_assert(location = module_name // &
          ".check_correct", &
          message = "at least 1 path part is not setted", &
          condition = allocated(this%part(i)%path_part) &
        )
        call error_assert(location = module_name // &
          ".check_correct", &
          message = "at least 1 integrate strategy is not setted", &
          condition = allocated(this%part(i)%integrate_template) &
        )
        call error_assert(location = module_name // &
          ".check_correct", &
          message = "at least 1 integrate strategy is not setted", &
          condition = allocated(this%part(i)%integrate_element) &
        )

        call error_assert_not(location = module_name // &
          ".check_correct", &
          message = "at least 1 integrate path part has too close boundary points", &
          condition = equals (start_point(i), end_point(i), min_abs_point_difference(i)) &
        )
      end do
    end associate
  end subroutine check_correct
end submodule integrator_builder_impl
