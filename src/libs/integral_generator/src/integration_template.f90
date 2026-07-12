!> @author Haart
!>
!> integration template for compulting an integral on a projection function from
!> integration_path_part using a given integration element
!>
!> for example it can be simple sum of elements with constant step (sor simplest algorithms)
!>   integral = sum([(element(x(i), x(i + 1)), i = 1, N])
!>
!> or reculculation algorithm template for constant step
!>
!> or reculculation algorithm template for dynamic step
!>
!> or sum of integral elements by a given array x in constructor
module integration_template
use integration_path_part, only: &
  integration_path_part_obj, &
  integrated_function_type, projection_function_type, normalized_delta_type
use integration_element, only: integration_element_obj
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = "integral_generator___integration_template"

  public :: integration_template_obj

  type, abstract :: integration_template_obj
  private
  contains
    procedure(run_type), deferred, pass(this) :: run
  end type integration_template_obj

  abstract interface
    !> compulting an inlegral value on a small linear path
    recursive &
    complex(dp) function run_type(this, func, a, b, integration_element, eps, normalized_delta)
    import :: &
      integration_element_obj, &
      integration_template_obj, &
      projection_function_type, &
      dp
    implicit none (type, external)
      class(integration_template_obj), intent(inout) :: this
      procedure(projection_function_type) :: func
      real(dp), intent(in) :: a
      real(dp), intent(in) :: b
      class(integration_element_obj), intent(inout) :: integration_element
      !> required accuracy
      real(dp), intent(in) :: eps
      procedure(normalized_delta_type), optional :: normalized_delta
    end function run_type
  end interface
end module integration_template
