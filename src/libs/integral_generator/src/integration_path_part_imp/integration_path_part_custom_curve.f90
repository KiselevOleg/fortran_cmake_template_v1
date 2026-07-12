!> @author Haart
!>
!> transfer integration path part into integration a real function (projection) on [a, b] where
!> a = start_projection_point(), b = end_projection_point()
!>
!> for a potentially any continuous curve that can be described by a function curve on
!> a line [start_boundary_point, end_boundary_point]
!>
!> @details
!>
!> key parameters
!>
!>     start == start_boundary_point - a start point where this path part has a begin
!>
!>     end == end_boundary_point - an end point where this path part has a finish
!>
!>     curve(t) - a function for describing a path aurve x(t) where t - parameter
!>
!>     scale - a scale parameter for describing "depth" of the curve between [start ,end]
!>     (only for the direction perpendicular to this segment)
!>
!> this function must be defined on a domain [-1, 1]
!> and should be normalized (|max(curve) on [-1, 1]| == 1)
!>
!>     x in [-1, 1]
!>
!>     y in [-1, 1] and exists x in [-1, 1] where curve(x) == 1 or curve(x) == -1
!>
!>     == 0 when abs(x) == 1
!>
!> then it automatically will normalized to a path part by this scheme
!>
!>     1) considering a new coordinate system where
!>
!>     start_boundary_point -> (-1, 0) (Re axis)
!>
!>     end_boundary_point -> (1, 0) (Re axis)
!>
!>     rotate/scale the Im axis such that the maximum of the curve
!>     corresponds to the given scale in the imaginary direction
!>
!>     |max(curve) on [-1, 1]| == scale
!>
!>     angle(new Im axis, original Im axis) == angle(new Re axis, original Re axis)
!>
!>     2) Integration func on this curve in this new coordinat system laid on the original system
!>
!>     \int_\Gamma f(x) dx = \int\limits_{-1}^{1} f(x(t)) x'(t) dt
!>
!>     where
!>
!>     \Gamma - the curve
!>
!>     f(x) - func
!>
!>     x'(z) - the curve tangent component
!>
!> or this can be imaginied with this (porentialy using) formula that describes
!> the integration curve that is constructed from the curve function
!>
!>     x(t) = start + (end − start) * 2 * (t + 1) ​ + i * scale * curve(t)
!>
!> for an example
!>
!>     start_boundary_point = (1, 1)
!>
!>     end_boundary_point = (1, 5)
!>
!>     curve = - sqrt(1 - x ** 2) (a bottom half circle)
!>
!>     scale = 4
!>
!>     then the path part is a half circle that is on Re >= 1 halfspace
!>     of the original coordinat system
!>
!>```txt
!>Im /|\.
!>    |
!>    |
!>    |
!>  5 |  x
!>    |    \.
!>    |      \.
!>    |        |
!>    |       /|\.
!>    |        |
!>    |      /
!>    |    /
!>  1 |  x
!>    |
!>    |              \.
!>--------------------
!>    |  1     4     /
!>    |
!>```
!>
!>     similarly for
!>
!>         curve = sqrt(1 - x ** 2)
!>
!>         it is a half circle on Re <= 1
!>```txt
!>      Im /|\.
!>          |
!>          |
!>          |
!>        5 |  x
!>          |/
!>        / |
!>      |   |
!>     /|\  |
!>      |   |
!>        \ |
!>          |\.
!>        1 |  x
!>          |
!>          |              \.
!>--------------------------
!>     -3   |  1           /
!>          |
!>```
!>
!>         start_boundary_point = (1, 1) and end_boundary_point = (5, 1)
!>
!>         it is a half circle on Im <= 1
!>
!>```txt
!>Im /|\.
!>    |
!>    |
!>  1 |  x              x
!>    |  \             /
!>    |   \           /     \.
!>---------------------------
!>    |  1  \       /   5   /
!>    |      \  \  /
!> -3 |       -----
!>    |         /.
!>    |
!>```
!>
!>         start_boundary_point = (5, 1) and end_boundary_point = (1, 1)
!>
!>         it is a half circle on Im >= 1
!>         (with changing dirrection of tangent due to
!>         changing ordering the start and the end points)
!>
!>```txt
!>Im /|\.
!>    |        /
!>  5 |      -----
!>    |     /  \  \.
!>    |    /       \.
!>    |   /         \.
!>  1 |  x           x
!>    |
!>    |                  \.
!>------------------------
!>    |  1           5   /
!>    |
!>```
!>
module integration_path_part_custom_curve
use integration_path_part, only: &
  integration_path_part_obj, &
  integrated_function_type, projection_function_type, normalized_delta_type
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = &
    "integral_generator___integration_path_part_imp___integration_path_part_custom_curve"

  public :: integration_path_part_custom_curve_obj, integration_path_part_custom_curve_constructor

  type, extends(integration_path_part_obj) :: integration_path_part_custom_curve_obj
  private
    procedure(curve_form), nopass, pointer :: form
    real(dp) :: scale
  contains
    procedure, pass(this) :: projection_function => projection_function_obj
    procedure, pass(this) :: normalized_delta => normalized_delta_obj
    procedure, pass(this) :: start_projection_point => start_projection_point
    procedure, pass(this) :: end_projection_point => end_projection_point

    procedure, private, pass(this) :: set_boundary_points_preparate => set_boundary_points_preparate
  end type integration_path_part_custom_curve_obj

  abstract interface
    pure real(dp) function curve_form(x)
    import :: dp
    implicit none (type, external)
      real(dp), intent(in) :: x
    end function curve_form
  end interface

  interface
    pure &
    type(integration_path_part_custom_curve_obj) &
    module function integration_path_part_custom_curve_constructor( &
      start, end, curve, scale, without_checking_curve &
    ) result(this)
    implicit none (type, external)
      complex(dp), intent(in) :: start
      complex(dp), intent(in) :: end
      !> a curve function (template) that is normalized
      !>
      !> (x in [- 1, 1], max(curve(x)) == 1, curve(- 1d0) == 0d0, curve(1d0) == 0d0)
      procedure(curve_form) :: curve
      !> a scale value for set a depth of curve (max distanse from a line [start, end])
      !> (a possible formula for depth = curve(t) * scale)
      real(dp), intent(in) :: scale
      !> if (.not. present(without_checking_curve) .or. .true.) then
      !> check if curve is incorrect by counting it in many points
      !>
      !> it is not reconebd if the integrator builder object is used in hard perfomance compalting
      !> or if the function is too slow or has important side effects
      !>
      !> default is .true. due to it is considered by default that this function is pure and light
      !> and the integrator builder object is outside hard perfomance compulting
      !> (using ideology that for not critical performance code
      !> safe, flexibility, control, validation, evidence, undertrandability,
      !> code clean, predictability
      !> are more importante than performance and code size)
      logical, optional, intent(in) :: without_checking_curve
    end function integration_path_part_custom_curve_constructor

    !> get a projection function got use it in real(dp) line integration
    recursive complex(dp) module function projection_function_obj(this, func, x) result(res)
    implicit none (type, external)
      class(integration_path_part_custom_curve_obj), intent(in) :: this
      procedure(integrated_function_type) :: func
      real(dp), intent(in) :: x
    end function projection_function_obj
    !> get a dirrection of current integral step
    !> delta -> abs(delta) for real projection function integration
    !> and delta mult for considering imag part
    pure complex(dp) module function normalized_delta_obj(this, x, dx) result(res)
    implicit none (type, external)
      class(integration_path_part_custom_curve_obj), intent(in) :: this
      real(dp), intent(in) :: x
      real(dp), intent(in) :: dx
    end function normalized_delta_obj
    !> get a start point of projection
    !> a start value for projection function argument
    pure real(dp) module function start_projection_point(this) result(res)
      implicit none (type, external)
      class(integration_path_part_custom_curve_obj), intent(in) :: this
    end function start_projection_point
    !> get an end point of projection
    !> an end value for projection function argument
    pure real(dp) module function end_projection_point(this) result(res)
      implicit none (type, external)
      class(integration_path_part_custom_curve_obj), intent(in) :: this
    end function end_projection_point
  end interface

  interface
    !> set a start and last point of the path part
    pure module subroutine set_boundary_points_preparate(this, start, end)
    implicit none (type, external)
      class(integration_path_part_custom_curve_obj), intent(inout) :: this
      complex(dp), intent(in) :: start
      complex(dp), intent(in) :: end
    end subroutine set_boundary_points_preparate
  end interface
end module integration_path_part_custom_curve
