!> @author Haart
!>
!> A module for regex tools
module regex_api
use regex_module, only: regex_library => regex, regex_preparsed_library => regex_pattern, &
  parse_pattern
use exception, only: exception_type, assignment(=), &
  EXCEPTION_KIND_TYPE_ERROR, EXCEPTION_KIND_TYPE_WARNING, EXCEPTION_KIND_TYPE_INFO, print_exception
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = "system_util___regex_api"

  type, public :: regex_api_type
  private
    logical :: compiled_regex = .false.
    type(regex_preparsed_library) :: regex_preparsed_library_imp
  contains
    procedure, pass(this) :: compile_regex

    procedure, pass(this) :: regex_match
    procedure, pass(this) :: regex_find_first_match
  end type regex_api_type

  interface
    !> check if a string marches a regular expresiion
    module subroutine regex_match(this, string, result, error)
    implicit none (type, external)
      class(regex_api_type), intent(in) :: this
      character(len = *), intent(in) :: string
      logical, intent(out) :: result
      type(exception_type), intent(inout) :: error
    end subroutine regex_match

    !> find a first march substring
    !>
    !> result = string(start_index:end_index)
    module subroutine regex_find_first_match(this, string, start_index, end_index, error)
    implicit none (type, external)
      class(regex_api_type), intent(in) :: this
      character(len = *), intent(in) :: string
      !> the first index of the result
      !>
      !> equal to -1_i4 if there is no result
      integer(i4), intent(out) :: start_index
      !> the end index of the result
      !>
      !> equal to -1_i4 if there is no result
      integer(i4), intent(out) :: end_index
      type(exception_type), intent(inout) :: error
    end subroutine regex_find_first_match

    !> set a regex tring pattern
    module subroutine compile_regex(this, regex_str, error)
    implicit none (type, external)
      class(regex_api_type), intent(inout) :: this
      character(len = *), intent(in) :: regex_str
      type(exception_type), intent(inout) :: error
    end subroutine compile_regex
  end interface
end module regex_api
