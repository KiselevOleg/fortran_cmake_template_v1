!> @author Haart
!>
!> create, read, write json files
!>
!> Store and retrieve data from JSON objects
module json_api
use json_module, only:json_file
use exception, only: exception_type, assignment(=), &
  EXCEPTION_KIND_TYPE_ERROR, EXCEPTION_KIND_TYPE_WARNING, EXCEPTION_KIND_TYPE_INFO, print_exception
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = "system_io___json_api"

  integer(i1), parameter, public :: &
    JSON_TYPE_INTEGER = 0_i1, &
    JSON_TYPE_REAL = 1_i1, &
    JSON_TYPE_BOOLEAN = 2_i1, &
    JSON_TYPE_STRING = 3_i1, &
    JSON_TYPE_ARRAY = 4_i1, &
    JSON_TYPE_OBJECT = 5_i1, &
    JSON_TYPE_NULL = 6_i1

  type, public :: json_api_type
  private
    type(json_file) :: json_impl
  contains
    procedure, pass(this) :: init

    procedure, pass(this) :: load_from_file
    procedure, pass(this) :: load_from_string
    procedure, pass(this) :: save_to_file
    procedure, pass(this) :: save_to_string

    generic :: get => &
      get_int32, &
      get_real32, get_real64, &
      get_logical, get_string
    generic :: put => &
      put_int32, &
      put_real32, put_real64, &
      put_logical, put_string
    procedure, pass(this) :: exists
    procedure, pass(this) :: remove
    ! procedure, pass(this) :: move_path

    procedure, pass(this) :: is_object
    procedure, pass(this) :: is_array
    procedure, pass(this) :: is_string
    procedure, pass(this) :: is_integer
    procedure, pass(this) :: is_real
    procedure, pass(this) :: is_boolean
    procedure, pass(this) :: is_null
    procedure, pass(this) :: get_element_type

    !procedure, pass(this) :: get_keys

    generic :: array_put => &
      array_put_empty, array_put_int32, array_put_real32, array_put_real64, &
      array_put_logical, array_put_string
    !generic :: array_append_element => &
    !  array_append_element_int32, &
    !  array_append_element_real32, array_append_element_real64, &
    !  array_append_element_logical, array_append_element_string
    procedure, pass(this) :: array_get_size
    generic :: array_get => &
      array_get_int32, &
      array_get_real32, array_get_real64, &
      array_get_logical, array_get_string

    procedure, pass(this) :: clear
    final :: destructor



    procedure, private, pass(this) :: get_int32
    procedure, private, pass(this) :: get_real32
    procedure, private, pass(this) :: get_real64
    procedure, private, pass(this) :: get_logical
    procedure, private, pass(this) :: get_string

    procedure, private, pass(this) :: put_int32
    procedure, private, pass(this) :: put_real32
    procedure, private, pass(this) :: put_real64
    procedure, private, pass(this) :: put_logical
    procedure, private, pass(this) :: put_string

    procedure, private, pass(this) :: array_put_empty
    procedure, private, pass(this) :: array_put_int32
    procedure, private, pass(this) :: array_put_real32
    procedure, private, pass(this) :: array_put_real64
    procedure, private, pass(this) :: array_put_logical
    procedure, private, pass(this) :: array_put_string

    procedure, private, pass(this) :: array_get_int32
    procedure, private, pass(this) :: array_get_real32
    procedure, private, pass(this) :: array_get_real64
    procedure, private, pass(this) :: array_get_logical
    procedure, private, pass(this) :: array_get_string
  end type json_api_type

  type, public :: string_type
    character(len = :), allocatable :: data
  end type string_type

  interface
    module subroutine init(this, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      type(exception_type), intent(inout) :: error
    end subroutine init


    module subroutine load_from_file(this, file, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: file
      type(exception_type), intent(inout) :: error
    end subroutine load_from_file
    module subroutine load_from_string(this, string, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: string
      type(exception_type), intent(inout) :: error
    end subroutine load_from_string
    module subroutine save_to_file(this, file, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: file
      type(exception_type), intent(inout) :: error
    end subroutine save_to_file
    module subroutine save_to_string(this, string, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = :), allocatable, intent(out) :: string
      type(exception_type), intent(inout) :: error
    end subroutine save_to_string

    module subroutine get_int32(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i4), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine get_int32
    module subroutine get_real32(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      real(sp), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine get_real32
    module subroutine get_real64(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      real(dp), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine get_real64
    module subroutine get_logical(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine get_logical
    module subroutine get_string(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = :), allocatable, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine get_string

    module subroutine put_int32(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i4), intent(in) :: value
      type(exception_type), intent(inout) :: error
    end subroutine put_int32
    module subroutine put_real32(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      real(sp), intent(in) :: value
      type(exception_type), intent(inout) :: error
    end subroutine put_real32
    module subroutine put_real64(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      real(dp), intent(in) :: value
      type(exception_type), intent(inout) :: error
    end subroutine put_real64
    module subroutine put_logical(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(in) :: value
      type(exception_type), intent(inout) :: error
    end subroutine put_logical
    module subroutine put_string(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: value
      type(exception_type), intent(inout) :: error
    end subroutine put_string

    module subroutine exists(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine exists
    module subroutine remove(this, path, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      type(exception_type), intent(inout) :: error
    end subroutine remove

    module subroutine is_object(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine is_object
    module subroutine is_array(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine is_array
    module subroutine is_string(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine is_string
    module subroutine is_integer(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine is_integer
    module subroutine is_real(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine is_real
    module subroutine is_boolean(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine is_boolean
    module subroutine is_null(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine is_null
    module subroutine get_element_type(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i1), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine get_element_type

    module subroutine array_put_empty(this, path, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      type(exception_type), intent(inout) :: error
    end subroutine array_put_empty
    module subroutine array_put_int32(this, path, values, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i4), intent(in) :: values(:)
      type(exception_type), intent(inout) :: error
    end subroutine array_put_int32
    module subroutine array_put_real32(this, path, values, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      real(sp), intent(in) :: values(:)
      type(exception_type), intent(inout) :: error
    end subroutine array_put_real32
    module subroutine array_put_real64(this, path, values, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      real(dp), intent(in) :: values(:)
      type(exception_type), intent(inout) :: error
    end subroutine array_put_real64
    module subroutine array_put_logical(this, path, values, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(in) :: values(:)
      type(exception_type), intent(inout) :: error
    end subroutine array_put_logical
    module subroutine array_put_string(this, path, values, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      type(string_type), intent(in) :: values(:)
      type(exception_type), intent(inout) :: error
    end subroutine array_put_string

    module subroutine array_get_size(this, path, value, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i4), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine array_get_size

    module subroutine array_get_int32(this, path, values, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i4), intent(out), allocatable :: values(:)
      type(exception_type), intent(inout) :: error
    end subroutine array_get_int32
    module subroutine array_get_real32(this, path, values, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      real(sp), intent(out), allocatable :: values(:)
      type(exception_type), intent(inout) :: error
    end subroutine array_get_real32
    module subroutine array_get_real64(this, path, values, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      real(dp), intent(out), allocatable :: values(:)
      type(exception_type), intent(inout) :: error
    end subroutine array_get_real64
    module subroutine array_get_logical(this, path, values, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(out), allocatable :: values(:)
      type(exception_type), intent(inout) :: error
    end subroutine array_get_logical
    module subroutine array_get_string(this, path, values, error)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      type(string_type), intent(out), allocatable :: values(:)
      type(exception_type), intent(inout) :: error
    end subroutine array_get_string

    module subroutine clear(this)
    implicit none (type, external)
      class(json_api_type), intent(inout) :: this
    end subroutine clear

    module subroutine destructor(this)
    implicit none (type, external)
      type(json_api_type), intent(inout) :: this
    end subroutine destructor
  end interface


end module json_api
