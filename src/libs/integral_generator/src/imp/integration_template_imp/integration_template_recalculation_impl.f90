submodule(integration_template_recalculation) integration_template_recalculation_impl
use system___assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not, &
  equals
implicit none (type, external)

  real(dp), parameter :: &
    MIN_STEP_DEFAULT = 1d-5, &
    MAX_STEP_DEFAULT = 0.4d0, &
    INIT_STEP_DEFAULT = 1d-2

  contains

  module procedure integration_template_recalculation_constructor
    if (present(min_step)) then
      this%min_step = min_step
    else
      this%min_step = MIN_STEP_DEFAULT
    end if
    if (present(max_step)) then
      this%max_step = max_step
    else
      this%max_step = MAX_STEP_DEFAULT
    end if
    if (present(init_step)) then
      this%init_step = init_step
    else
      this%init_step = INIT_STEP_DEFAULT
    end if

    associate(min_step => this%min_step, max_step => this%max_step, init_step => this%init_step)
      call error_assert(location = module_name // &
        ".constructor", &
        message = "0d0 < min_step .and. min_step <= init_step .and. init_step <= max_step", &
        condition = 0d0 < min_step .and. min_step <= init_step .and. init_step <= max_step &
      )
    end associate
  end procedure integration_template_recalculation_constructor

  module procedure run
    real(dp) :: max_step_half

    interface
      function func(x)
      import :: dp
      implicit none (type, external)
        real(dp), intent(in) :: x
      end function func
      function normalized_delta(x, dx)
      import :: dp
      implicit none (type, external)
        real(dp), intent(in) :: x
        real(dp), intent(in) :: dx
      end function normalized_delta
    end interface

    associate(min_step => this%min_step, max_step => this%max_step, init_step => this%init_step)
      call error_assert(location = module_name // &
        ".run", &
        message = "eps >= 1d-9", &
        condition = eps >= 1d-9 &
      )

      max_step_half = max_step * 0.5d0

      res = 0d0

      block
        real(dp) :: current_eps
        real(dp) :: x, h
        complex(dp) :: int_elem_1, int_elem_2

        x = a
        h = init_step
        do while (x < b)
          if (present(normalized_delta)) then
            int_elem_1 = &
              integration_element%run(func, x, x + min(h + h, b - x)) * &
              normalized_delta(x = x, dx = min(h + h, b - x))
            int_elem_2 = &
              integration_element%run(func, x, x + min(h + h, b - x) * 0.5d0) * &
              normalized_delta(x = x, dx = min(h + h, b - x) * 0.5d0)
            int_elem_2 = int_elem_2 + &
              integration_element%run( &
                func, x + min(h + h, b - x) * 0.5d0, x + min(h + h, b - x) &
              ) * normalized_delta( &
                x = x + min(h + h, b - x) * 0.5d0, &
                dx = min(h + h, b - x) * 0.5d0 &
              )
          else
            int_elem_1 = integration_element%run(func, x, x + min(h + h, b - x))
            int_elem_2 = integration_element%run(func, x, x + min(h + h, b - x) * 0.5d0)
            int_elem_2 = int_elem_2 + &
              integration_element%run(func, x + min(h + h, b - x) * 0.5d0, x + min(h + h, b - x))
          end if
          current_eps = abs(int_elem_2 - int_elem_1) * 1.5d0

          do while (h >= min_step .and. current_eps > eps)
            h = h * 0.5d0

            if (present(normalized_delta)) then
              int_elem_1 = &
                integration_element%run(func, x, x + min(h + h, b - x)) * &
                normalized_delta(x = x, dx = min(h + h, b - x))
              int_elem_2 = &
                integration_element%run(func, x, x + min(h + h, b - x) * 0.5d0) * &
                normalized_delta(x = x, dx = min(h + h, b - x) * 0.5d0)
              int_elem_2 = int_elem_2 + &
                integration_element%run( &
                  func, x + min(h + h, b - x) * 0.5d0, x + min(h + h, b - x) &
                ) * normalized_delta( &
                  x = x + min(h + h, b - x) * 0.5d0, &
                  dx = min(h + h, b - x) * 0.5d0 &
                )
            else
              int_elem_1 = integration_element%run(func, x, x + min(h + h, b - x))
              int_elem_2 = integration_element%run(func, x, x + min(h + h, b - x) * 0.5d0)
              int_elem_2 = int_elem_2 + &
                integration_element%run(func, x + min(h + h, b - x) * 0.5d0, x + min(h + h, b - x))
            end if
            current_eps = abs(int_elem_2 - int_elem_1) * 1.5d0
          end do

          res = res + int_elem_2
          x = x + min(h + h, b - x)

          if (current_eps < eps + eps + eps) h = min(max_step_half, h + h)
          if (abs(x - b) <= 1d-7) exit
        end do
      end block
    end associate
  end procedure run
end submodule integration_template_recalculation_impl
