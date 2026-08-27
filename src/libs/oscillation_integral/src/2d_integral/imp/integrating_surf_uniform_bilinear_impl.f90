submodule (integrating_surf_uniform_bilinear) integrating_surf_uniform_bilinear_impl
use system_io___hdf5_api, only: hdf5_api_type, &
  OPEN_FILE_TYPE_WRITE, OPEN_FILE_TYPE_READ, OPEN_FILE_TYPE_WRITE_READ, string_type
use system_exception___assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not, &
  equals
implicit none (type, external)

  contains

  module procedure init_from_function
    character(len = *), parameter :: procedure_name = "init_from_function"

    interface
      complex(dp) function f(x, y) result(res)
      import :: dp
      implicit none (type, external)
        real(dp), intent(in) :: x
        real(dp), intent(in) :: y
      end function f
      logical function mask_f(x, y) result(res)
      import :: dp
      implicit none (type, external)
        real(dp), intent(in) :: x
        real(dp), intent(in) :: y
      end function mask_f
    end interface

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "a_x < b_x is requiered", &
        ! code = 0_i4, &
        condition = a_x < b_x .and. .not. equals(a_x, b_x, 1.0e-5_dp) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "a_y < b_y is requiered", &
        ! code = 0_i4, &
        condition = a_y < b_y .and. .not. equals(a_y, b_y, 1.0e-5_dp) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "N_x > 5 is requiered", &
        ! code = 0_i4, &
        condition = N_x > 5_i4 &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "N_y > 5 is requiered", &
        ! code = 0_i4, &
        condition = N_y > 5_i4 &
      )

      if (error%has_thrown()) return
    end block validation

    block
      call clear(this)
    end block

    block
      integer(i4) :: N_x_actual, N_y_actual

      real(dp) :: x, y
      integer(i4) :: i, j

      N_x_actual = N_x
      N_y_actual = N_y

      allocate(this%x(N_x_actual))
      allocate(this%y(N_y_actual))
      allocate(this%f(N_x_actual, N_y_actual))
      allocate(this%considering_mask(N_x_actual, N_y_actual))
      this%a_x = a_x
      this%b_x = b_x
      this%a_y = a_y
      this%b_y = b_y

      do i = 1_i4, N_x_actual
        x = a_x + (b_x - a_x) / (N_x_actual - 1_i4) * (i - 1_i4)

        this%x(i) = x
      end do
      do j = 1_i4, N_y_actual
        y = a_y + (b_y - a_y) / (N_y_actual - 1_i4) * (j - 1_i4)

        this%y(j) = y
      end do
      do i = 1_i4, N_x_actual
        do j = 1_i4, N_y_actual
          if (present(mask_f)) then
            this%considering_mask(i, j) = mask_f(this%x(i), this%y(j))
          else
            this%considering_mask(i, j) = .true.
          end if
          if (this%considering_mask(i, j)) this%f(i, j) = f(this%x(i), this%y(j))
        end do
      end do
    end block
  end procedure init_from_function
  module procedure init_from_file
    character(len = *), parameter :: procedure_name = "init_from_file"

    type(hdf5_api_type) :: h

    validation: block
      if (error%has_thrown()) return

      call h%init(error)
      call h%open_file(file, OPEN_FILE_TYPE_READ, error)

      if (error%has_thrown()) return
    end block validation

    block
      call clear(this)
    end block

    block
      real(dp), allocatable :: real_f(:, :), imag_f(:, :)
      integer(i4), allocatable :: mask(:, :)

      real(dp) :: x, y
      integer(i4) :: i, j

      call h%dataset_get(path = "f_data.real", value = real_f, error = error)
      call h%dataset_get(path = "f_data.imag", value = imag_f, error = error)
      call h%dataset_get(path = "f_data.considering_mask", &
        value = mask, error = error)
      call h%attribute_get(path = "f_data", attribute_name = "a_x", &
        value = this%a_x, error = error)
      call h%attribute_get(path = "f_data", attribute_name = "b_x", &
        value = this%b_x, error = error)
      call h%attribute_get(path = "f_data", attribute_name = "a_y", &
        value = this%a_y, error = error)
      call h%attribute_get(path = "f_data", attribute_name = "b_y", &
        value = this%b_y, error = error)
      if (error%has_thrown()) return
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "a_x < b_x is requiered", &
        ! code = 0_i4, &
        condition = this%a_x < this%b_x .and. .not. equals(this%a_x, this%b_x, 1.0e-5_dp) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "a_y < b_y is requiered", &
        ! code = 0_i4, &
        condition = this%a_y < this%b_y .and. .not. equals(this%a_y, this%b_y, 1.0e-5_dp) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file structure", &
        ! code = 0_i4, &
        condition = size(real_f) == size(imag_f) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file structure", &
        ! code = 0_i4, &
        condition = all(shape(real_f) == shape(imag_f)) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file structure", &
        ! code = 0_i4, &
        condition = size(shape(real_f)) == size(shape(imag_f)) &
      )
      if (error%has_thrown()) return

      this%f = cmplx(real_f, imag_f, dp)
      this%considering_mask = .not. (mask == 0_i4)

      allocate(this%x(size(this%f(:, 1))))
      do i = 1_i4, size(this%f(:, 1))
        x = this%a_x + (this%b_x - this%a_x) / (size(this%f(:, 1)) - 1_i4) * (i - 1_i4)

        this%x(i) = x
      end do
      allocate(this%y(size(this%f(1, :))))
      do j = 1_i4, size(this%f(1, :))
        y = this%a_y + (this%b_y - this%a_y) / (size(this%f(1, :)) - 1_i4) * (j - 1_i4)

        this%y(j) = y
      end do

      call h%close_file(error)
      if (error%has_thrown()) return
    end block
  end procedure init_from_file

  module procedure integrate
    character(len = *), parameter :: procedure_name = "integrate"

    validation: block
      call error_assert( &
        location = module_name // "." // procedure_name, &
        message = "incorrect initialization", &
        condition = allocated(this%f) &
      )
    end block validation

    block
      complex(dp) :: q11, q12, q21, q22
      real(dp) :: x1, x2, y1, y2

      complex(dp) :: Int, Intx, Inty, Intxy

      integer(i4) :: i, j

      complex(dp), parameter :: ci = (0.0_dp, 1.0_dp)

      res = 0.0_dp
      do i = 1_i4, size(this%x) - 1_i4
        do j = 1_i4, size(this%y) - 1_i4
          if (.not. this%considering_mask(i, j)) cycle
          if (.not. this%considering_mask(i + 1_i4, j)) cycle
          if (.not. this%considering_mask(i, j + 1_i4)) cycle
          if (.not. this%considering_mask(i + 1_i4, j + 1_i4)) cycle

          q11 = this%f(i, j)
          q12 = this%f(i, j + 1_i4)
          q21 = this%f(i + 1_i4, j)
          q22 = this%f(i + 1_i4, j + 1_i4)

          x1 = this%x(i)
          x2 = this%x(i + 1_i4)
          y1 = this%y(j)
          y2 = this%y(j + 1_i4)

          Int = 0.0_dp
          Int = Int + (exp(ci * omega_x * x2) - exp(ci * omega_x * x1)) / (ci * omega_x)
          Int = Int * (exp(ci * omega_y * y2) - exp(ci * omega_y * y1)) / (ci * omega_y)

          Intx = 0.0_dp
          Intx = Intx + &
            ( &
              (ci * omega_x * x2 - 1.0_dp) * exp(ci * omega_x * x2) + &
              (1.0_dp - ci * omega_x * x1) * exp(ci * omega_x * x1) &
            ) &
            / (- omega_x * omega_x)
          Intx = Intx * (exp(ci * omega_y * y2) - exp(ci * omega_y * y1)) / (ci * omega_y)

          Inty = 0.0_dp
          Inty = Inty + (exp(ci * omega_x * x2) - exp(ci * omega_x * x1)) / (ci * omega_x)
          Inty = Inty * &
            ( &
              (ci * omega_y * y2 - 1.0_dp) * exp(ci * omega_y * y2) + &
              (1.0_dp - ci * omega_y * y1) * exp(ci * omega_y * y1) &
            ) &
            / (- omega_y * omega_y)

          Intxy = 0.0_dp
          Intxy = Intxy + &
            ( &
              (ci * omega_x * x2 - 1.0_dp) * exp(ci * omega_x * x2) + &
              (1.0_dp - ci * omega_x * x1) * exp(ci * omega_x * x1) &
            ) &
            / (- omega_x * omega_x)
          Intxy = Intxy * &
            ( &
              (ci * omega_y * y2 - 1.0_dp) * exp(ci * omega_y * y2) + &
              (1.0_dp - ci * omega_y * y1) * exp(ci * omega_y * y1) &
            ) &
            / (- omega_y * omega_y)

          res = res &
            + (q11 - q12 - q21 + q22) * Intxy &
            + (- q11 * y2 + q21 * y2 + q12 * y1 - q22 * y1) * Intx &
            + (- q11 * x2 + q21 * x1 + q12 * x2 - q22 * x1) * Inty &
            + (q11 * x2 * y2 - q21 * x1 * y2 - q12 * x2 * y1 + q22 * x1 * y1) * Int
        end do
      end do
      res = res / (this%x(2) - this%x(1)) / (this%y(2) - this%y(1))
    end block
  end procedure integrate

  module procedure save_to_file
    character(len = *), parameter :: procedure_name = "save_to_file"

    type(hdf5_api_type) :: h

    validation: block
      if (error%has_thrown()) return

      call h%init(error)
      call h%open_file(file, OPEN_FILE_TYPE_WRITE, error)

      if (error%has_thrown()) return
    end block validation

    block
      call h%dataset_put(path = "f_data.real", value = real(this%f), error = error)
      call h%dataset_put(path = "f_data.imag", value = aimag(this%f), error = error)
      call h%dataset_put(path = "f_data.considering_mask", &
        value = merge(1_i4, 0_i4, this%considering_mask), error = error)
      call h%attribute_put(path = "f_data", attribute_name = "a_x", &
        value = this%a_x, error = error)
      call h%attribute_put(path = "f_data", attribute_name = "b_x", &
        value = this%b_x, error = error)
      call h%attribute_put(path = "f_data", attribute_name = "a_y", &
        value = this%a_y, error = error)
      call h%attribute_put(path = "f_data", attribute_name = "b_y", &
        value = this%b_y, error = error)

      call h%dataset_put(path = "f_data.x", value = this%x, error = error)
      call h%dataset_put(path = "f_data.y", value = this%y, error = error)

      call h%close_file(error)

      if (error%has_thrown()) return
    end block
  end procedure save_to_file




  subroutine clear(this)
  implicit none (type, external)
    type(filon_like_integrating_uniform_bilinear_type), intent(inout) :: this

    if (allocated(this%f)) deallocate(this%f)
    if (allocated(this%considering_mask)) deallocate(this%considering_mask)
    if (allocated(this%x)) deallocate(this%x)
    if (allocated(this%y)) deallocate(this%y)
  end subroutine clear
end submodule integrating_surf_uniform_bilinear_impl
