!> @author Haart
!>
!> a module for evaluating 2D oscillatory integrals using a Filon-like method
!> where the amplitude function is sampled on a uniform grid and locally approximated
!> using bilinear interpolation
!> (i. e. f is replaced with its precomputed grid (init) for the integration process (integrate))
!>
!> $\int_{a_x}^{b_x} \int_{a_y}^{b_y} f(x, y) e^{i\omega_x x + i\omega_y y} dy dx$
!>
!> The integrand amplitude f(x, y) is sampled on a uniform grid and approximated and its
!> resulting is integrated analytically multiplying by exp(i * omega * x)
module integrating_surf_uniform_bilinear
use system_exception___exception, only: exception_type, assignment(=), &
  EXCEPTION_KIND_TYPE_ERROR, EXCEPTION_KIND_TYPE_WARNING, EXCEPTION_KIND_TYPE_INFO, print_exception
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = &
    "oscillation_integrating___integrating_surf_uniform_bilinear"

  abstract interface
    complex(dp) function integrated_function_type(x, y) result(res)
    import :: dp
    implicit none (type, external)
      real(dp), intent(in) :: x
      real(dp), intent(in) :: y
    end function integrated_function_type
    logical function mask_function_type(x, y) result(res)
    import :: dp
    implicit none (type, external)
      real(dp), intent(in) :: x
      real(dp), intent(in) :: y
    end function mask_function_type
  end interface

  type, public :: filon_like_integrating_uniform_bilinear_type
  private
    complex(dp), allocatable :: f(:, :)
    logical, allocatable :: considering_mask(:, :)
    real(dp), allocatable :: x(:), y(:)
    real(dp) :: a_x, b_x, a_y, b_y

    contains
    generic :: init => init_from_file, init_from_function
    procedure, private, pass(this) :: init_from_file
    procedure, private, pass(this) :: init_from_function

    procedure, pass(this) :: integrate

    procedure, pass(this) :: save_to_file
  end type filon_like_integrating_uniform_bilinear_type

  interface
    module subroutine init_from_function(this, f, a_x, b_x, a_y, b_y, N_x, N_y, error, mask_f)
    implicit none (type, external)
      class(filon_like_integrating_uniform_bilinear_type), intent(inout) :: this
      procedure(integrated_function_type) :: f
      !> a < b
      real(dp), intent(in) :: a_x
      !> a < b
      real(dp), intent(in) :: b_x
      !> a < b
      real(dp), intent(in) :: a_y
      !> a < b
      real(dp), intent(in) :: b_y
      !> for x
      !>
      !> approximate number of grid points (the number of points along the axis used to evaluate f)
      !>
      !> N > 5
      integer(i4), intent(in) :: N_x
      !> for y
      !>
      !> approximate number of grid points (the number of points along the axis used to evaluate f)
      !>
      !> N > 5
      integer(i4), intent(in) :: N_y
      type(exception_type), intent(inout) :: error
      !> returns .true. if the point (x, y) belongs to the integration domain
      !> and .false. otherwise
      !>
      !> if mask(i, j) == .false., the corresponding cell (all 4) is excluded
      !> from integration rather than simply being set to zero
      !>
      !> for describing an arbitrary domain within the rectangular boundaries
      procedure(mask_function_type), optional :: mask_f
    end subroutine init_from_function
    !> the file must have the format produced by save_to_file.
    module subroutine init_from_file(this, file, error)
    implicit none (type, external)
      class(filon_like_integrating_uniform_bilinear_type), intent(inout) :: this
      !> must have the correct structure corresponding to save_to_file method
      character(len = *), intent(in) :: file
      type(exception_type), intent(inout) :: error
    end subroutine init_from_file

    !> computes the Filon-like approximation of the oscillatory integral
    !>
    !> $\int_{a_x}^{b_x} \int_{a_y}^{b_y} f(x, y) e^{i\omega_x x + i\omega_y y} dy dx$
    pure complex(dp) module function integrate( &
      this, omega_x, omega_y, symmetric_four_quadrants &
    ) result(res)
    implicit none (type, external)
      class(filon_like_integrating_uniform_bilinear_type), intent(in) :: this
      real(dp), intent(in) :: omega_x
      real(dp), intent(in) :: omega_y
      !> if present and .true then
      !> integral is alculated on domain  that dublicated on all 4 coordinate quarters
      !> and without it othewise
      !>
      !> the function is extended to the additional domains by central symmetry
      !> with respect to the origin e. i. f(x,y)=f(x,-y)=f(-x,y)=f(-x,-y)
      !>
      !> for example integrating on x = [0, 1] y = [0 1] -> x = [-1 1] y = [-1 1]
      !>
      !> for example integrating on x = [1, 2] y = [2 3] ->
      !> x = [1, 2] y = [2 3] +
      !> x = [1, 2] y = [-3 -2] +
      !> x = [-2, -1] y = [2 3] +
      !> x = [-2, -1] y = [-3 -2]
      logical, optional, intent(in) :: symmetric_four_quadrants
    end function integrate

    !> save current prepared function data as a hdf5 file with specific format
    !>
    !> this can be useful if the function is too heavy to recalculate it every integrating process
    !>
    !> instead of this case the function can be calculated only once
    !> and saved as prepared data arrays
    !>
    !> this file can be loaded by init method
    module subroutine save_to_file(this, file, error)
    implicit none (type, external)
      class(filon_like_integrating_uniform_bilinear_type), intent(in) :: this
      character(len = *), intent(in) :: file
      type(exception_type), intent(inout) :: error
    end subroutine save_to_file
  end interface
end module integrating_surf_uniform_bilinear
