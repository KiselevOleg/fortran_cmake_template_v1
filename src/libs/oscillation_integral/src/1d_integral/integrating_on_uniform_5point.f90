!> @author Haart
!>
!> a module for evaluating 1D oscillatory integrals using a Filon-like method
!> where the amplitude function is sampled on a uniform grid and locally approximated
!> using consecutive 5 point stencils
!> (i. e. f is replaced with its precomputed grid (init) for the integration process (integrate))
!>
!> $\int_a^b f(x) e^{i\omega x} dx, \omega \rightarrow \infty$
!>
!> The integrand amplitude f(x) is sampled on a uniform grid and approximated
!> by a polynomial on consecutive three-point stencils. The resulting
!> polynomial is integrated analytically against exp(i * omega * x)
module integrating_on_uniform_5point
use system_exception___exception, only: exception_type, assignment(=), &
  EXCEPTION_KIND_TYPE_ERROR, EXCEPTION_KIND_TYPE_WARNING, EXCEPTION_KIND_TYPE_INFO, print_exception
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = &
    "oscillation_integrating___integrating_on_uniform_5point"

  abstract interface
    complex(dp) function integrated_function_type(x) result(res)
    import :: dp
    implicit none (type, external)
      real(dp), intent(in) :: x
    end function integrated_function_type
  end interface

  type, public :: filon_like_integrating_uniform_5points_type
  private
    complex(dp), allocatable :: f(:)
    real(dp), allocatable :: x(:)
    real(dp) :: a, b

    contains
    generic :: init => init_from_file, init_from_function
    procedure, private, pass(this) :: init_from_file
    procedure, private, pass(this) :: init_from_function

    procedure, pass(this) :: integrate

    procedure, pass(this) :: save_to_file
  end type filon_like_integrating_uniform_5points_type

  interface
    module subroutine init_from_function(this, f, a, b, N, error)
    implicit none (type, external)
      class(filon_like_integrating_uniform_5points_type), intent(inout) :: this
      procedure(integrated_function_type) :: f
      !> a < b
      real(dp), intent(in) :: a
      !> a < b
      real(dp), intent(in) :: b
      !>approximate number of grid points (the number of points along the axis used to evaluate f)
      !>
      !> N > 5
      integer(i4), intent(in) :: N
      type(exception_type), intent(inout) :: error
    end subroutine init_from_function
    !> must have the correct structure corresponding to save_to_file
    module subroutine init_from_file(this, file, error)
    implicit none (type, external)
      class(filon_like_integrating_uniform_5points_type), intent(inout) :: this
      !> must have the correct structure corresponding to save_to_file method
      character(len = *), intent(in) :: file
      type(exception_type), intent(inout) :: error
    end subroutine init_from_file

    !> computes the Filon-like approximation of the oscillatory integral
    !>
    !> $\int_a^b f(x) e^{i\omega x} dx, \omega \rightarrow \infty$
    !>
    !> it is highly recommended to guarantee \theta = \omega * h > 0.5, h = step (~ (b - a) / N)
    !> due to the realization constrains
    pure complex(dp) module function integrate(this, omega) result(res)
    implicit none (type, external)
      class(filon_like_integrating_uniform_5points_type), intent(in) :: this
      !> omega > 0 (otherwise error stop raised)
      real(dp), intent(in) :: omega
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
      class(filon_like_integrating_uniform_5points_type), intent(in) :: this
      character(len = *), intent(in) :: file
      type(exception_type), intent(inout) :: error
    end subroutine save_to_file
  end interface
end module integrating_on_uniform_5point
