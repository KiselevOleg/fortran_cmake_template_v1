!> @author Haart
!>
!> transfer integration path part into integration a real function (projection) on [a, b] where
!> a = start_projection_point(), b = end_projection_point()
!>
!> for example integration on a circle line -> integration on a line with
!> or integration on a imag line to real line
!>
!> integration from (0d0, 0d0) to (0d0, 1d0) x dx ->
!> integration (0d0, 0d0) to (1d0, 0d0) x * (0d0, 1d0) dx
module integration_path_part
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = &
    "integral_generator___integration_path_part"

  public :: integration_path_part_obj
  public :: integrated_function_type, projection_function_type, normalized_delta_type

  type, abstract :: integration_path_part_obj
  private
    complex(dp) :: start_point
    complex(dp) :: end_point
  contains
    procedure(projection_function_obj_type), deferred, pass(this) :: projection_function
    procedure(normalized_delta_obj_type), deferred, pass(this) :: normalized_delta
    procedure(start_projection_point_type), deferred, pass(this) :: start_projection_point
    procedure(end_projection_point_type), deferred, pass(this) :: end_projection_point

    procedure(set_boundary_points_preparate_type), private, deferred, pass(this) :: &
      set_boundary_points_preparate

    procedure, pass(this) :: set_boundary_points
    procedure, pass(this) :: get_start_point
    procedure, pass(this) :: get_end_point
  end type integration_path_part_obj

  abstract interface
    complex(dp) function integrated_function_type(x)
    import :: dp
    implicit none (type, external)
      complex(dp), intent(in) :: x
    end function integrated_function_type
    complex(dp) function projection_function_type(x)
    import :: dp
    implicit none (type, external)
      real(dp), intent(in) :: x
    end function projection_function_type
    pure complex(dp) function normalized_delta_type(x, dx)
    import :: integration_path_part_obj, dp
    implicit none (type, external)
      real(dp), intent(in) :: x
      real(dp), intent(in) :: dx
    end function normalized_delta_type
  end interface

  abstract interface
    !> get a projection function got use it in real(dp) line integration
    recursive complex(dp) function projection_function_obj_type(this, func, x)
    import :: integration_path_part_obj, integrated_function_type, dp
    implicit none (type, external)
      class(integration_path_part_obj), intent(in) :: this
      procedure(integrated_function_type) :: func
      real(dp), intent(in) :: x
    end function projection_function_obj_type
    !> get a dirrection of current integral step
    !>
    !> delta - multiply koeficient for real projection function integration
    !> that connects the real projection and coresponding imag line
    pure complex(dp) function normalized_delta_obj_type(this, x, dx)
    import :: integration_path_part_obj, dp
    implicit none (type, external)
      class(integration_path_part_obj), intent(in) :: this
      real(dp), intent(in) :: x
      real(dp), intent(in) :: dx
    end function normalized_delta_obj_type
    !> get a start point of projection
    !>
    !> a start value for projection function argument
    pure real(dp) function start_projection_point_type(this)
      import :: integration_path_part_obj, dp
      implicit none (type, external)
      class(integration_path_part_obj), intent(in) :: this
    end function start_projection_point_type
    !> get an end point of projection
    !>
    !> an end value for projection function argument
    pure real(dp) function end_projection_point_type(this)
      import :: integration_path_part_obj, dp
      implicit none (type, external)
      class(integration_path_part_obj), intent(in) :: this
    end function end_projection_point_type
  end interface

  abstract interface
    pure subroutine set_boundary_points_preparate_type(this, start, end)
    import :: integration_path_part_obj, dp
    implicit none (type, external)
      class(integration_path_part_obj), intent(inout) :: this
      complex(dp), intent(in) :: start
      complex(dp), intent(in) :: end
    end subroutine set_boundary_points_preparate_type
  end interface

  interface
    !> set a start and last point of the path part
    pure module subroutine set_boundary_points(this, start, end)
    implicit none (type, external)
      class(integration_path_part_obj), intent(inout) :: this
      complex(dp), intent(in) :: start
      complex(dp), intent(in) :: end
    end subroutine set_boundary_points
    pure complex(dp) module function get_start_point(this) result(res)
    implicit none (type, external)
      class(integration_path_part_obj), intent(in) :: this
    end function get_start_point
    pure complex(dp) module function get_end_point(this) result(res)
    implicit none (type, external)
      class(integration_path_part_obj), intent(in) :: this
    end function get_end_point
  end interface
end module integration_path_part
