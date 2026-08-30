submodule (integrating_on_uniform_5point) integrating_on_uniform_5point_impl
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
      complex(dp) function f(x) result(res)
      import :: dp
      implicit none (type, external)
        real(dp), intent(in) :: x
      end function f
    end interface

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "a < b is required", &
        ! code = 0_i4, &
        condition = a < b .and. .not. equals(a, b, 1.0e-5_dp) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "N > 5 is required", &
        ! code = 0_i4, &
        condition = N > 5_i4 &
      )

      if (error%has_thrown()) return
    end block validation

    block
      call clear(this)
    end block

    block
      integer(i4) :: N_actual

      real(dp) :: x
      integer(i4) :: i

      N_actual = N
      if (mod(N_actual - 1_i4, 4_i4) /= 0_i4) then
        N_actual = N_actual + 4_i4 - mod(N_actual - 1_i4, 4_i4)
      end if

      allocate(this%x(N_actual))
      allocate(this%f(N_actual))
      this%a = a
      this%b = b

      do i = 1_i4, N_actual
        x = a + (b - a) / (N_actual - 1_i4) * (i - 1_i4)

        this%x(i) = x
        this%f(i) = f(x)
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
      real(dp), allocatable :: real_f(:), imag_f(:)

      real(dp) :: x
      integer(i4) :: i

      call h%dataset_get(path = "f_data.real", value = real_f, error = error)
      call h%dataset_get(path = "f_data.imag", value = imag_f, error = error)
      call h%attribute_get(path = "f_data", attribute_name = "a", value = this%a, error = error)
      call h%attribute_get(path = "f_data", attribute_name = "b", value = this%b, error = error)
      if (error%has_thrown()) return
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "a < b is required", &
        ! code = 0_i4, &
        condition = this%a < this%b .and. .not. equals(this%a, this%b, 1.0e-5_dp) &
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
        condition = mod(size(real_f) - 1_i4, 4_i4) == 0_i4 &
      )
      if (error%has_thrown()) return

      allocate(this%f(size(real_f)))
      do i = 1, size(this%f)
        this%f(i) = cmplx(real_f(i), imag_f(i), dp)
      end do

      allocate(this%x(size(this%f)))
      do i = 1_i4, size(this%f)
        x = this%a + (this%b - this%a) / (size(this%f) - 1_i4) * (i - 1_i4)

        this%x(i) = x
      end do

      call h%close_file(error)
      if (error%has_thrown()) return
    end block
  end procedure init_from_file

  module procedure integrate
    character(len = *), parameter :: procedure_name = "integrate"

    validation: block
      call error_assert_not( &
        location = module_name // "." // procedure_name, &
        message = "omega <= 0d0", &
        condition = omega <= 0d0 &
      )
      call error_assert( &
        location = module_name // "." // procedure_name, &
        message = "incorrect initialization", &
        condition = allocated(this%f) &
      )
    end block validation

    block
      complex(dp) :: A, B, C, D, E
      complex(dp) :: a_, b_, c_, d_, e_
      integer(i4) :: i

      associate( &
        f => this%f, x => this%x, &
        theta => omega * (this%x(5) - this%x(1)), &
        theta_ci => omega * (this%x(5) - this%x(1)) * (0.0_dp, 1.0_dp), &
        exp_theta_ci => exp(omega * (this%x(5) - this%x(1)) * (0.0_dp, 1.0_dp)), &
        ci => (0.0_dp, 1.0_dp), &
        h => (this%x(5) - this%x(1)), &
        N => size(this%f) &
      )
        A = (- ci * exp_theta_ci + ci) / omega

        B = - ci * h / omega * exp_theta_ci + &
          1.0_dp / (omega * omega) * exp_theta_ci - &
          1.0_dp / (omega * omega)

        C = - ci * h * h / omega * exp_theta_ci + &
          2.0_dp * h / (omega * omega) * exp_theta_ci + &
          2.0_dp * ci / (omega ** 3_i4) * exp_theta_ci - &
          2.0_dp * ci / (omega ** 3_i4)

        D = &
          - ci * h ** 3_i4 / omega * exp_theta_ci &
          + 3.0_dp * h * h / (omega * omega) * exp_theta_ci &
          + 6.0_dp * h * ci / (omega ** 3_i4) * exp_theta_ci &
          - 6.0_dp / (omega ** 4_i4) * exp_theta_ci &
          + 6.0_dp / (omega ** 4_i4)

        E = &
          - ci * h ** 4_i4 / omega * exp_theta_ci &
          + 4.0_dp * h ** 3_i4 / (omega * omega) * exp_theta_ci &
          + 12.0_dp * h * h * ci / (omega ** 3_i4) * exp_theta_ci &
          - 24.0_dp * h / (omega ** 4_i4) * exp_theta_ci &
          - 24.0_dp * ci / (omega ** 5_i4) * exp_theta_ci &
          + 24.0_dp * ci / (omega ** 5_i4)

        res = 0d0
        ! do concurrent (i = _i4: N - 1_i4) reduce(+:res) ! fortran 2023
        do i = 3_i4, N, 4_i4
          a_ = &
            - 352.0_dp / 47.0_dp   * f(i - 2_i4) + 3200.0_dp / 141.0_dp * f(i - 1_i4) &
            - 1088.0_dp / 47.0_dp  * f(i) &
            + 384.0_dp  / 47.0_dp  * f(i + 1_i4) - 32.0_dp  / 141.0_dp   * f(i + 2_i4)
          b_ = &
            + 320.0_dp / 141.0_dp  * f(i - 2_i4) - 384.0_dp / 47.0_dp   * f(i - 1_i4) &
            + 512.0_dp / 47.0_dp   * f(i) &
            - 896.0_dp  / 141.0_dp * f(i + 1_i4) + 64.0_dp  / 47.0_dp   * f(i + 2_i4)
          c_ = &
            + 510.0_dp / 47.0_dp   * f(i - 2_i4) - 3440.0_dp / 141.0_dp * f(i - 1_i4) &
            + 756.0_dp / 47.0_dp   * f(i) &
            - 112.0_dp  / 47.0_dp  * f(i + 1_i4) - 22.0_dp  / 141.0_dp  * f(i + 2_i4)
          d_ = &
            - 935.0_dp / 141.0_dp  * f(i - 2_i4) + 464.0_dp / 47.0_dp   * f(i - 1_i4) &
            - 180.0_dp / 47.0_dp   * f(i) &
            + 80.0_dp  / 141.0_dp  * f(i + 1_i4) + 1.0_dp   / 47.0_dp   * f(i + 2_i4)
          e_ = f(i - 2_i4)

          res = res + ( &
              a_ / (h ** 4_i4) * E + &
              b_ / (h ** 3_i4) * D + &
              c_ / (h ** 2_i4) * C + &
              d_ / h * B + &
              e_ * A &
            ) * exp(ci * omega * x(i - 2_i4))
        end do

        res = res
      end associate
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
      call h%attribute_put(path = "f_data", attribute_name = "a", value = this%a, error = error)
      call h%attribute_put(path = "f_data", attribute_name = "b", value = this%b, error = error)

      call h%dataset_put(path = "f_data.x", value = this%x, error = error)

      call h%close_file(error)

      if (error%has_thrown()) return
    end block
  end procedure save_to_file




  subroutine clear(this)
  implicit none (type, external)
    type(filon_like_integrating_uniform_5points_type), intent(inout) :: this

    if (allocated(this%f)) deallocate(this%f)
    if (allocated(this%x)) deallocate(this%x)
  end subroutine clear
end submodule integrating_on_uniform_5point_impl
