!> @author Haart
!>
!> integration element based on gauss method with n = 6
module integration_element_gauss6
use integration_element, only: integration_element_obj
use integration_path_part, only: &
  integration_path_part_obj, &
  integrated_function_type, projection_function_type
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = &
    "integral_generator___integration_element_imp___integration_element_gauss6"

  public :: integration_element_gauss6_obj, integration_element_gauss6_constructor

  type, extends(integration_element_obj) :: integration_element_gauss6_obj
  private
  contains
    procedure, pass(this) :: run => run
  end type integration_element_gauss6_obj

  interface
    pure elemental &
    type(integration_element_gauss6_obj) module function &
    integration_element_gauss6_constructor() result(this)
    implicit none (type, external)
    end function integration_element_gauss6_constructor

    !> compulting an inlegral value on a small linear path
    recursive complex(dp) module function run(this, func, a, b) result(res)
    implicit none (type, external)
      class(integration_element_gauss6_obj), intent(in) :: this
      procedure(projection_function_type) :: func
      real(dp), intent(in) :: a
      real(dp), intent(in) :: b
    end function run
  end interface
end module integration_element_gauss6
