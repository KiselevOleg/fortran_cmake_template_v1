!> @author Haart
!>
!> integration element is a primitive compulting value of integral on an infinitive small step
!>
!> for example f(x_i) * dx for rectangle method
!>
!> or similar for trippetial and gauss methods
module integration_element
use integration_path_part, only: &
  integration_path_part_obj, &
  integrated_function_type, projection_function_type, normalized_delta_type
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = "integral_generator___integration_element"

  public :: integration_element_obj

  type, abstract :: integration_element_obj
  private
  contains
    procedure(run_type), deferred, pass(this) :: run
  end type integration_element_obj

  abstract interface
    !> compulting an inlegral value on a small linear path
    recursive complex(dp) function run_type(this, func, a, b)
    import :: integration_element_obj, projection_function_type, dp
    implicit none (type, external)
      class(integration_element_obj), intent(in) :: this
      procedure(projection_function_type) :: func
      real(dp), intent(in) :: a
      real(dp), intent(in) :: b
    end function run_type
  end interface
end module integration_element
