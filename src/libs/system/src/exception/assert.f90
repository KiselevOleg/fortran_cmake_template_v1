!> @author Haart
!>
!> a module for validation of data
module assert
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = "system___assert"

  public :: error_assert, error_assert_not
  public :: warning_assert, warning_assert_not
  public :: equals

  !> check if numbers are equal with given accuracy
  !>
  !> @example
  !> ```fortran
  !> call warning_assert_not( &
  !>     location = "math.divide", &
  !>     message  = "a must be not equal to b", &
  !>     condition = equals_real64(a, b, 1d-7) )
  !> ```
  interface equals
    module procedure equals_real32
    module procedure equals_complex32
    module procedure equals_real64
    module procedure equals_complex64
    module procedure equals_real128
    module procedure equals_complex128
  end interface

  interface
    !> check if condition is satisfied (else throws an exception)
    !>
    !> @example
    !> ```fortran
    !> call error_assert( &
    !>     location = "math.divide", &
    !>     message  = "b must be >=1d0", &
    !>     condition = b >= 1d0 )
    !> ```
    pure elemental module subroutine error_assert(location, message, condition)
    implicit none (type, external)
      !> location where validation happens (recommended "module_name.procedure_name")
      character(len = *), intent (in) :: location
      !> error description
      character(len = *), intent (in) :: message
      !> condition satisfaction value
      logical, intent (in) :: condition
    end subroutine error_assert
    !> check if condition is not satisfied (else throws an exception)
    !>
    !> @example
    !> ```fortran
    !> call error_assert_not( &
    !>     location = "math.divide", &
    !>     message  = "b must be >=1d0", &
    !>     condition = b < 1d0 )
    !> ```
    pure elemental module subroutine error_assert_not(location, message, condition)
    implicit none (type, external)
      !> location where validation happens (recommended "module_name.procedure_name")
      character(len = *), intent (in) :: location
      !> error description
      character(len = *), intent (in) :: message
      !> condition satisfaction value
      logical, intent (in) :: condition
    end subroutine error_assert_not


    !> check if condition is satisfied (else throws an exception)
    !>
    !> @example
    !> ```fortran
    !> call warning_assert( &
    !>     location = "math.divide", &
    !>     message  = "b should be >=1d0", &
    !>     condition = b >= 1d0 )
    !> ```
    module subroutine warning_assert(location, message, condition)
    implicit none (type, external)
      !> location where validation happens (recommended "module_name.procedure_name")
      character(len = *), intent (in) :: location
      !> warning description
      character(len = *), intent (in) :: message
      !> condition satisfaction value
      logical, intent (in) :: condition
    end subroutine warning_assert
    !> check if condition is not satisfied (else throws an exception)
    !>
    !> @example
    !> ```fortran
    !> call warning_assert_not( &
    !>     location = "math.divide", &
    !>     message  = "b should be >=1d0", &
    !>     condition = b < 1d0 )
    !> ```
    module subroutine warning_assert_not(location, message, condition)
    implicit none (type, external)
      !> location where validation happens (recommended "module_name.procedure_name")
      character(len = *), intent (in) :: location
      !> warning description
      character(len = *), intent (in) :: message
      !> condition satisfaction value
      logical, intent (in) :: condition
    end subroutine warning_assert_not
  end interface

  interface
    !> check if numbers are equal with given accuracy
    !>
    !> @example
    !> ```fortran
    !> call warning_assert_not( &
    !>     location = "math.divide", &
    !>     message  = "a must be not equal to b", &
    !>     condition = equals_real32(a, b, 1s-7) )
    !> ```
    pure elemental logical module function equals_real32(a, b, eps) result(res)
    implicit none (type, external)
      real(sp), intent(in) :: a
      real(sp), intent(in) :: b
      !> absolute accuracy
      real(sp), intent(in) :: eps
    end function equals_real32
    !> check if numbers are equal with given accuracy
    !>
    !> @example
    !> ```fortran
    !> call warning_assert_not( &
    !>     location = "math.divide", &
    !>     message  = "a must be not equal to b", &
    !>     condition = equals_complex32(a, b, 1s-7) )
    !> ```
    pure elemental logical module function equals_complex32(a, b, eps) result(res)
    implicit none (type, external)
      complex(sp), intent(in) :: a
      complex(sp), intent(in) :: b
      !> absolute accuracy
      real(sp), intent(in) :: eps
    end function equals_complex32

    !> check if numbers are equal with given accuracy
    !>
    !> @example
    !> ```fortran
    !> call warning_assert_not( &
    !>     location = "math.divide", &
    !>     message  = "a must be not equal to b", &
    !>     condition = equals_real64(a, b, 1d-7) )
    !> ```
    pure elemental logical module function equals_real64(a, b, eps) result(res)
    implicit none (type, external)
      real(dp), intent(in) :: a
      real(dp), intent(in) :: b
      !> absolute accuracy
      real(dp), intent(in) :: eps
    end function equals_real64
    !> check if numbers are equal with given accuracy
    !>
    !> @example
    !> ```fortran
    !> call warning_assert_not( &
    !>     location = "math.divide", &
    !>     message  = "a must be not equal to b", &
    !>     condition = equals_complex64(a, b, 1d-7) )
    !> ```
    pure elemental logical module function equals_complex64(a, b, eps) result(res)
    implicit none (type, external)
      complex(dp), intent(in) :: a
      complex(dp), intent(in) :: b
      !> absolute accuracy
      real(dp), intent(in) :: eps
    end function equals_complex64

    !> check if numbers are equal with given accuracy
    !>
    !> @example
    !> ```fortran
    !> call warning_assert_not( &
    !>     location = "math.divide", &
    !>     message  = "a must be not equal to b", &
    !>     condition = equals_real128(a, b, 1q-7) )
    !> ```
    pure elemental logical module function equals_real128(a, b, eps) result(res)
    implicit none (type, external)
      real(qp), intent(in) :: a
      real(qp), intent(in) :: b
      !> absolute accuracy
      real(qp), intent(in) :: eps
    end function equals_real128
    !> check if numbers are equal with given accuracy
    !>
    !> @example
    !> ```fortran
    !> call warning_assert_not( &
    !>     location = "math.divide", &
    !>     message  = "a must be not equal to b", &
    !>     condition = equals_complex128(a, b, 1q-7) )
    !> ```
    pure elemental logical module function equals_complex128(a, b, eps) result(res)
    implicit none (type, external)
      complex(qp), intent(in) :: a
      complex(qp), intent(in) :: b
      !> absolute accuracy
      real(qp), intent(in) :: eps
    end function equals_complex128
  end interface
end module assert
