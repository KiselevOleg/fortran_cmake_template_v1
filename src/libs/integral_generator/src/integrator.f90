!> @author Haart
!>
!> a module for integration a complex function by custom built path
!> with explicit description of path parts
!> for not standart complex integration
module integrator
use integration_template, only: integration_template_obj
use integration_path_part, only: &
  integration_path_part_obj, &
  integrated_function_type, projection_function_type, normalized_delta_type
use integration_element, only: integration_element_obj
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = "integral_generator___integrator"

  public :: integrator_obj, integrator_builder_obj
  public :: integrator_builder_constructor

  type :: integrator_builder_obj
  private
    integer(i4) :: path_part_size
    type(part_obj), allocatable :: part(:)

    real(dp) :: eps

    real(dp) :: max_abs_point_coordinate_value
  contains
    procedure, pass(this) :: build

    procedure, pass(this) :: add_new_path_part
    procedure, pass(this) :: part_integration_strategy

    procedure, private, pass(this) :: last_start_previous
    procedure, private, pass(this) ::  last_start_new
    !> it is recommended to use this instead of transfer boundary point value dirrectly
    !> while a builder is assempled
    !>
    !> last_start() for get the last value
    !>
    !> last_start(new_value) for get the new value
    !> (in this case only visual effect (no side effect in a builder object))
    !>
    !> for confortable inserting new values and not repeating old values
    !> and replace the standart value for all future path parts
    generic :: last_start => last_start_previous, last_start_new
    procedure, private, pass(this) :: last_end_previous
    procedure, private, pass(this) :: last_end_new
    !> it is recommended to use this instead of transfer boundary point value dirrectly
    !> while a builder is assempled
    !>
    !> last_end() for get the last value
    !>
    !> last_end(new_value) for get the new value
    !> (in this case only visual effect (no side effect in a builder object))
    !>
    !> for confortable inserting new values and not repeating old values
    !> and replace the standart value for all future path parts
    generic :: last_end => last_end_previous, last_end_new

    procedure, pass(this) :: set_boundary_points

    procedure, pass(this) :: set_min_abs_point_difference_between_boundary_points

    procedure, pass(this) :: set_accuracy
  end type integrator_builder_obj

  type :: integrator_obj
  private
    type(part_obj), allocatable :: part(:)

    real(dp) :: eps
  contains
    procedure, pass(this) :: integrate
  end type integrator_obj

  interface
    pure elemental &
    type(integrator_builder_obj) module function integrator_builder_constructor( &
      reserve &
    ) result(this)
    implicit none (type, external)
      !> start size of allocated arrays (path part expected size)
      integer(i4), optional, intent(in) :: reserve
    end function integrator_builder_constructor

    !> build an integrator object
    pure type(integrator_obj) module function build(this) result(res)
    implicit none (type, external)
      class(integrator_builder_obj), intent (in) :: this
    end function build

    !> add description of a new path part
    module subroutine add_new_path_part(this, path_part)
    implicit none (type, external)
      class(integrator_builder_obj), intent (inout) :: this
      class(integration_path_part_obj), intent(in) :: path_part
    end subroutine add_new_path_part
    !> add integration strategy for this intagration part
    !> if it is not setted then the last part value is used
    module subroutine part_integration_strategy(this, template, element)
    implicit none (type, external)
      class(integrator_builder_obj), intent (inout) :: this
      !> an integration template for compulting integral on a large domain
      class(integration_template_obj), intent(in) :: template
      !> an integration element formula for a tiny domain (integration step)
      class(integration_element_obj), intent(in) :: element
    end subroutine part_integration_strategy

    pure complex(dp) module function last_start_previous(this) result(res)
    implicit none (type, external)
      class(integrator_builder_obj), intent (in) :: this
    end function last_start_previous
    complex(dp) module function last_start_new(this, value) result(res)
    implicit none (type, external)
      class(integrator_builder_obj), intent (inout) :: this
      complex(dp), intent(in) :: value
    end function last_start_new
    pure complex(dp) module function last_end_previous(this) result(res)
    implicit none (type, external)
      class(integrator_builder_obj), intent (in) :: this
    end function last_end_previous
    complex(dp) module function last_end_new(this, value) result(res)
    implicit none (type, external)
      class(integrator_builder_obj), intent (inout) :: this
      complex(dp), intent(in) :: value
    end function last_end_new

    !> change a current path partstart boundary point
    module subroutine set_boundary_points(this, start, end)
    implicit none (type, external)
      class(integrator_builder_obj), intent (inout) :: this
      complex(dp), intent(in) :: start
      complex(dp), intent(in) :: end
    end subroutine set_boundary_points

    !> add constaint on min distance between boundary points for this path part
    !> default value is setted by default for the first path part
    !> if it is not setted then the last part value is used
    module subroutine set_min_abs_point_difference_between_boundary_points(this, value)
    implicit none (type, external)
      class(integrator_builder_obj), intent (inout) :: this
      real(dp), intent(in) :: value
    end subroutine set_min_abs_point_difference_between_boundary_points

    module subroutine set_max_abs_point_coordinate_value(this, value)
    implicit none (type, external)
      class(integrator_builder_obj), intent (inout) :: this
      real(dp), intent(in) :: value
    end subroutine set_max_abs_point_coordinate_value

    !> set an integration strategy
    !> if it is not setted then the last strategy is used
    module subroutine set_accuracy(this, eps)
    implicit none (type, external)
      class(integrator_builder_obj), intent (inout) :: this
      real(dp), intent(in) :: eps
    end subroutine set_accuracy
  end interface

  interface
    recursive complex(dp) module function integrate(this, func) result(res)
    implicit none (type, external)
      class(integrator_obj), intent (inout) :: this
      procedure(integrated_function_type) :: func
    end function integrate
  end interface















  type :: part_obj
  private
    class(integration_path_part_obj), allocatable :: path_part
    class(integration_template_obj), allocatable :: integrate_template
    class(integration_element_obj), allocatable :: integrate_element
    real(dp) :: min_abs_point_difference_between_start_and_end_points
  contains
    final :: part_obj_destructor
  end type part_obj

  interface
    module subroutine part_obj_destructor(this)
    implicit none (type, external)
      type(part_obj), intent (inout) :: this
    end subroutine part_obj_destructor
  end interface
end module integrator
