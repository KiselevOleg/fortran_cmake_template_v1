!> @author Haart
!>
!> transfer integration path part into integration a real function (projection) on [a, b] where
!> a = start_projection_point(), b = end_projection_point()
!>
!> for line path straight moving from a start point to an end point
module integration_path_part_line
use integration_path_part, only: &
  integration_path_part_obj, &
  integrated_function_type, projection_function_type, normalized_delta_type
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = &
    "integral_generator___integration_path_part_imp___integration_path_part_line"

  public :: integration_path_part_line_obj, integration_path_part_line_constructor

  type, extends(integration_path_part_obj) :: integration_path_part_line_obj
  private
  contains
    procedure, pass(this) :: projection_function => projection_function_obj
    procedure, pass(this) :: normalized_delta => normalized_delta_obj
    procedure, pass(this) :: start_projection_point => start_projection_point
    procedure, pass(this) :: end_projection_point => end_projection_point

    procedure, private, pass(this) :: set_boundary_points_preparate => set_boundary_points_preparate
  end type integration_path_part_line_obj

  interface
    pure elemental &
    type(integration_path_part_line_obj) &
    module function integration_path_part_line_constructor(start, end) result(this)
    implicit none (type, external)
      complex(dp), intent(in) :: start
      complex(dp), intent(in) :: end
    end function integration_path_part_line_constructor

    !> get a projection function got use it in real(dp) line integration
    recursive complex(dp) module function projection_function_obj(this, func, x) result(res)
    implicit none (type, external)
      class(integration_path_part_line_obj), intent(in) :: this
      procedure(integrated_function_type) :: func
      real(dp), intent(in) :: x
    end function projection_function_obj
    !> get a dirrection of current integral step
    !> delta -> abs(delta) for real projection function integration
    !> and delta mult for considering imag part
    pure complex(dp) module function normalized_delta_obj(this, x, dx) result(res)
    implicit none (type, external)
      class(integration_path_part_line_obj), intent(in) :: this
      real(dp), intent(in) :: x
      real(dp), intent(in) :: dx
    end function normalized_delta_obj
    !> get a start point of projection
    !> a start value for projection function argument
    pure real(dp) module function start_projection_point(this) result(res)
      implicit none (type, external)
      class(integration_path_part_line_obj), intent(in) :: this
    end function start_projection_point
    !> get an end point of projection
    !> an end value for projection function argument
    pure real(dp) module function end_projection_point(this) result(res)
      implicit none (type, external)
      class(integration_path_part_line_obj), intent(in) :: this
    end function end_projection_point
  end interface

  interface
    !> set a start and last point of the path part
    pure module subroutine set_boundary_points_preparate(this, start, end)
    implicit none (type, external)
      class(integration_path_part_line_obj), intent(inout) :: this
      complex(dp), intent(in) :: start
      complex(dp), intent(in) :: end
    end subroutine set_boundary_points_preparate
  end interface
end module integration_path_part_line
