!> @author Haart
!>
!> a module for validation of data
!>
!> exception_type stores an error ans its cause (the error that thrown after recursively)
module exception
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = "system___exception"

  public :: print_exception

  public :: assignment(=)

  integer(i1), parameter, public :: EXCEPTION_KIND_TYPE_ERROR = 1_i1, &
    EXCEPTION_KIND_TYPE_WARNING = 2_i1, EXCEPTION_KIND_TYPE_INFO = 3_i1

  !> for useful tracing print in code
  !>
  !> for more complicated usecases it is recommented to create other formatters
  interface print_exception
    procedure print_exception_to_file
    procedure print_exception_to_console
    procedure print_exception_to_string
  end interface print_exception

  type, public :: exception_type
  private
    character(len = :), allocatable :: where
    integer(i1) :: kind_type = 0_i1
    character(len = :), allocatable :: message
    logical :: present_code = .false.
    integer(i4) :: code = - 1_i4
    type(exception_type), allocatable :: cause

    type(exception_type), pointer :: last_cause => null()
  contains
    procedure, pass(this) :: init

    procedure, pass(this) :: clear

    procedure, pass(this) :: has_thrown
    procedure, pass(this) :: get_where
    procedure, pass(this) :: get_kind_type
    procedure, pass(this) :: get_message
    procedure, pass(this) :: has_code
    procedure, pass(this) :: get_code

    procedure, pass(this) :: throw
    procedure, pass(this) :: throw_if
    procedure, pass(this) :: throw_if_not

    procedure, pass(this) :: has_cause
    procedure, pass(this) :: get_cause
    procedure, pass(this) :: get_cause_pointer
  end type exception_type

  interface assignment(=)
    module procedure exception_type_assign
  end interface

  interface
    recursive pure module subroutine exception_type_assign(lhs, rhs)
    implicit none (type, external)
      type(exception_type), intent(out) :: lhs
      type(exception_type), intent(in)  :: rhs
    end subroutine exception_type_assign
  end interface

  interface
    pure module subroutine init(this)
    implicit none (type, external)
      class(exception_type), intent(inout) :: this
    end subroutine init

    !> clear error information
    !> call error%clear() -> error%has_thrown() == .false.
    pure module subroutine clear(this)
    implicit none (type, external)
      class(exception_type), intent(inout) :: this
    end subroutine clear

    !> check if the object has error
    pure logical module function has_thrown(this) result(res)
    implicit none (type, external)
      class(exception_type), intent(in) :: this
    end function has_thrown
    !> get where the error is raised
    pure module function get_where(this) result(res)
    implicit none (type, external)
      class(exception_type), intent(in) :: this
      character(len = :), allocatable :: res
    end function get_where
    !> get type (EXCEPTION_KIND_TYPE_ERROR, EXCEPTION_KIND_TYPE_WARNING, EXCEPTION_KIND_TYPE_INFO)
    pure integer(i1) module function get_kind_type(this) result(res)
    implicit none (type, external)
      class(exception_type), intent(in) :: this
    end function get_kind_type
    !> get error description
    pure module function get_message(this) result(res)
    implicit none (type, external)
      class(exception_type), intent(in) :: this
      character(len = :), allocatable :: res
    end function get_message
    !> check if code is
    pure logical module function has_code(this) result(res)
    implicit none (type, external)
      class(exception_type), intent(in) :: this
    end function has_code
    !> get code
    pure integer(i4) module function get_code(this) result(res)
    implicit none (type, external)
      class(exception_type), intent(in) :: this
    end function get_code

    !> raise an error
    !>
    !> if the last error is then this error is appended to the list (add a new cause)
    pure module subroutine throw(this, where, kind_type, message, code)
    implicit none (type, external)
      class(exception_type), target, intent(inout) :: this
      character(len = *), intent(in) :: where
      integer(i1), intent(in) :: kind_type
      character(len = *), intent(in) :: message
      integer(i4), optional, intent(in) :: code
    end subroutine throw
    !> raise an error if condition is true
    !>
    !> if the last error is then this error is appended to the list (add a new cause)
    pure module subroutine throw_if (this, where, kind_type, message, condition, code)
    implicit none (type, external)
      class(exception_type), intent(inout) :: this
      character(len = *), intent(in) :: where
      integer(i1), intent(in) :: kind_type
      character(len = *), intent(in) :: message
      integer(i4), optional, intent(in) :: code
      logical, intent(in) :: condition
    end subroutine throw_if
    !> raise an error if condition is false
    !>
    !> if the last error is then this error is appended to the list (add a new cause)
    pure module subroutine throw_if_not(this, where, kind_type, message, condition, code)
    implicit none (type, external)
      class(exception_type), intent(inout) :: this
      character(len = *), intent(in) :: where
      integer(i1), intent(in) :: kind_type
      character(len = *), intent(in) :: message
      integer(i4), optional, intent(in) :: code
      logical, intent(in) :: condition
    end subroutine throw_if_not

    !> check if cause is
    !>
    !> cause - an exception that has been thrown after consireded exception
    !> It is supposed to get trace of the error
    pure module logical function has_cause(this) result(res)
    implicit none (type, external)
      class(exception_type), intent(in) :: this
    end function has_cause

    !> get cause (the next exception at the error trace)
    pure module function get_cause(this) result(res)
    implicit none (type, external)
      class(exception_type), intent(in) :: this
      type(exception_type) :: res
    end function get_cause
    !> get cause (the next exception at the error trace)
    !>
    !> get_cause_pointer returns a non-owning pointer.
    !>
    !> the pointer becomes invalid after clear().
    module function get_cause_pointer(this) result(res)
    implicit none (type, external)
      class(exception_type), target, intent(in) :: this
      type(exception_type), pointer :: res
    end function get_cause_pointer
  end interface

  interface
    module subroutine print_exception_to_file(unit, error)
    implicit none (type, external)
      integer(i4), intent(in) :: unit
      type(exception_type), intent(in) :: error
    end subroutine print_exception_to_file
    module subroutine print_exception_to_console(error)
    implicit none (type, external)
      type(exception_type), intent(in) :: error
    end subroutine print_exception_to_console
    module subroutine print_exception_to_string(unit, error)
    implicit none (type, external)
      character(len = :), allocatable, intent(out) :: unit
      type(exception_type), intent(in) :: error
    end subroutine print_exception_to_string
  end interface
end module exception
