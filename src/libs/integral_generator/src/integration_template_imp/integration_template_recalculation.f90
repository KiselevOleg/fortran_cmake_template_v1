!> @author Haart
!>
!> an integration template for recalculation scheme for guarantee required accuracy
module integration_template_recalculation
use integration_template, only: integration_template_obj
use integration_path_part, only: &
  integration_path_part_obj, &
  integrated_function_type, projection_function_type, normalized_delta_type
use integration_element, only: integration_element_obj
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = &
    "integral_generator___integration_template_imp___integration_template_recalculation"

  public :: integration_template_recalculation_obj, integration_template_recalculation_constructor

  type, extends(integration_template_obj) :: integration_template_recalculation_obj
  private
    real(dp) :: min_step
    real(dp) :: max_step
    real(dp) :: init_step
  contains
    procedure, pass(this) :: run => run
  end type integration_template_recalculation_obj

  interface
    pure elemental type(integration_template_recalculation_obj) &
    module function integration_template_recalculation_constructor( &
      min_step, max_step, init_step &
    ) result(this)
    implicit none (type, external)
      !> a min step for integration
      real(dp), optional, intent(in) :: min_step
      !> a max step for integration
      real(dp), optional, intent(in) :: max_step
      !> a start step for integration
      real(dp), optional, intent(in) :: init_step
    end function integration_template_recalculation_constructor

    !> compulting an inlegral value on a small linear path
    recursive complex(dp) module function run( &
      this, &
      func, a, b, &
      integration_element, &
      eps, &
      normalized_delta &
    ) result(res)
    implicit none (type, external)
      class(integration_template_recalculation_obj), intent(inout) :: this
      procedure(projection_function_type) :: func
      real(dp), intent(in) :: a
      real(dp), intent(in) :: b
      class(integration_element_obj), intent(inout) :: integration_element
      !> required accuracy
      real(dp), intent(in) :: eps
      procedure(normalized_delta_type), optional :: normalized_delta
    end function run
  end interface
end module integration_template_recalculation
