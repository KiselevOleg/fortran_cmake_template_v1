!> @author Haart
!>
!> create, read, write hdf5 files
!>
!> Store and retrieve data from HDF5 objects
module hdf5_api
use h5fortran, only : hdf5_file
use exception, only: exception_type, assignment(=), &
  EXCEPTION_KIND_TYPE_ERROR, EXCEPTION_KIND_TYPE_WARNING, EXCEPTION_KIND_TYPE_INFO, print_exception
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = "system_io___hdf5_api"

  integer(i1), parameter :: &
    DATA_TYPE_INTEGER8 = 0_i1, &
    DATA_TYPE_INTEGER16 = 1_i1, &
    DATA_TYPE_INTEGER32 = 2_i1, &
    DATA_TYPE_INTEGER64 = 3_i1, &
    DATA_TYPE_REAL32 = 4_i1, &
    DATA_TYPE_REAL64 = 5_i1, &
    DATA_TYPE_BOOLEAN = 6_i1, &
    DATA_TYPE_STRING = 7_i1!, & !TODO
    !DATA_TYPE_COMPOUND_DATATYPE = 8_i1
  integer(i1), parameter :: &
    OBJECT_TYPE_GROUP = 0_i1, &
    OBJECT_TYPE_DATASET = 1_i1!, & !TODO
    !OBJECT_TYPE_COMPOUND_DATATYPE = 2_i1, &
    !OBJECT_TYPE_SOFT_LINK = 3_i1, &
    !OBJECT_TYPE_EXTERNAL_LINK = 4_i1

  integer(i1), parameter, public :: &
    OPEN_FILE_TYPE_WRITE = int(B'001', i1), &
    OPEN_FILE_TYPE_READ = int(B'010', i1), &
    OPEN_FILE_TYPE_WRITE_READ = int(B'011', i1)

  type, public :: hdf5_api_type
  private
    type(hdf5_file) :: hdf5_impl
    integer(i1) :: open_file_type = - 1_i1
  contains
    procedure, pass(this) :: init

    procedure, pass(this) :: open_file
    procedure, pass(this) :: close_file

    generic :: attribute_get => &
      attribute_get_int32, attribute_get_int64, &
      attribute_get_real32, attribute_get_real64, &
      attribute_get_string
    generic :: attribute_get_array => &
      attribute_get_int32_array, &
      attribute_get_int64_array, &
      attribute_get_real32_array, attribute_get_real64_array
    generic :: attribute_put => &
      attribute_put_int32, attribute_put_int64, &
      attribute_put_real32, attribute_put_real64, &
      attribute_put_string
    procedure, pass(this) :: attribute_exists
    !procedure, pass(this) :: attribute_remove

    procedure, pass(this) :: attribute_get_rank
    procedure, pass(this) :: attribute_get_shape
    !procedure, pass(this) :: attribute_get_type

    procedure, pass(this) :: object_exists
    !procedure, pass(this) :: object_remove
    !procedure, pass(this) :: object_get_type

    procedure, pass(this) :: object_create_group
    !procedure, pass(this) :: object_remove_group
    !procedure, pass(this) :: object_create_dataset
    !procedure, pass(this) :: object_remove_dataset

    !procedure, pass(this) :: group_get_attributes
    !procedure, pass(this) :: group_get_inner_objects
    !procedure, pass(this) :: dataset_get_attributes

    procedure, pass(this) :: dataset_get_rank
    procedure, pass(this) :: dataset_get_shape
    !procedure, pass(this) :: dataset_get_datatype

    generic :: dataset_get => &
      dataset_get_int32, dataset_get_int64, &
      dataset_get_real32, dataset_get_real64
    generic :: dataset_put => &
      dataset_put_int32, dataset_put_int64, &
      dataset_put_real32, dataset_put_real64

    !generic :: dataset_put_slice
    !generic :: dataset_get_slice

    procedure, pass(this) :: clear
    final :: destructor

    procedure, private, pass(this) :: attribute_get_int8
    procedure, private, pass(this) :: attribute_get_int16
    procedure, private, pass(this) :: attribute_get_int32
    procedure, private, pass(this) :: attribute_get_int64
    procedure, private, pass(this) :: attribute_get_real32
    procedure, private, pass(this) :: attribute_get_real64
    procedure, private, pass(this) :: attribute_get_boolean
    procedure, private, pass(this) :: attribute_get_string

    procedure, private, pass(this) :: attribute_get_int8_array
    procedure, private, pass(this) :: attribute_get_int16_array
    procedure, private, pass(this) :: attribute_get_int32_array
    procedure, private, pass(this) :: attribute_get_int64_array
    procedure, private, pass(this) :: attribute_get_real32_array
    procedure, private, pass(this) :: attribute_get_real64_array
    procedure, private, pass(this) :: attribute_get_boolean_array

    procedure, private, pass(this) :: attribute_put_int8
    procedure, private, pass(this) :: attribute_put_int16
    procedure, private, pass(this) :: attribute_put_int32
    procedure, private, pass(this) :: attribute_put_int64
    procedure, private, pass(this) :: attribute_put_real32
    procedure, private, pass(this) :: attribute_put_real64
    procedure, private, pass(this) :: attribute_put_boolean
    procedure, private, pass(this) :: attribute_put_string

    procedure, private, pass(this) :: dataset_get_int8
    procedure, private, pass(this) :: dataset_get_int16
    procedure, private, pass(this) :: dataset_get_int32
    procedure, private, pass(this) :: dataset_get_int64
    procedure, private, pass(this) :: dataset_get_real32
    procedure, private, pass(this) :: dataset_get_real64
    procedure, private, pass(this) :: dataset_get_boolean

    procedure, private, pass(this) :: dataset_put_int8
    procedure, private, pass(this) :: dataset_put_int16
    procedure, private, pass(this) :: dataset_put_int32
    procedure, private, pass(this) :: dataset_put_int64
    procedure, private, pass(this) :: dataset_put_real32
    procedure, private, pass(this) :: dataset_put_real64
    procedure, private, pass(this) :: dataset_put_boolean
  end type hdf5_api_type

  !> universal standard compression
  !>
  !>compression type
  !>
  !> 0 - no, 1, 2, ..., 9 - max compression
  !>
  !> 5-6 - recommended standard by default
  character(len = *), parameter :: compression_algorithm_gzip = "gzip"
  !> fast compression with less effectiveness
  !>
  !>compression type
  !>
  !> -5 - no, -4, -3, ..., 22 - max compression
  !>
  !> 5-6 - recommended standard by default
  character(len = *), parameter :: compression_algorithm_lzf = "lzf"
  !> specialized for scientific data. Good for some data arrays
  !>
  !>compression type
  !>
  !> 0 - no, 1, 2, ..., 9 - max compression
  !>
  !> 5-6 - recommended standard by default
  character(len = *), parameter :: compression_algorithm_szip = "szip"
  type, public :: dataset_options
    integer(i1) :: data
    integer(i4), allocatable :: shape(:)
    integer(i4), allocatable :: max_shape(:)

    character(len = :), allocatable :: compression_algorithm
    !> must have the same dimensions as the dataset data (rank)
    integer(i4), allocatable :: chunk_size(:)
    integer(i1) :: compression_level
    !> regroup data before compression for best compression quality
    logical :: shuffle_filter
    !> for adding additional correct validation (automatic) if the data is corrupted
    !>
    !> for example: a disk is damaged
    logical :: checksum
  end type dataset_options

  type, public :: string_type
    character(:), allocatable :: data
  end type string_type

  interface
    module subroutine init(this, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      type(exception_type), intent(inout) :: error
    end subroutine init


    module subroutine open_file(this, file, open_file_type, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: file
      integer(i1), intent(in) :: open_file_type
      type(exception_type), intent(inout) :: error
    end subroutine open_file
    module subroutine close_file(this, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      type(exception_type), intent(inout) :: error
    end subroutine close_file



    module subroutine attribute_get_int8(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i1), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_int8
    module subroutine attribute_get_int16(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i2), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_int16
    module subroutine attribute_get_int32(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i4), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_int32
    module subroutine attribute_get_int64(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i8), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_int64
    module subroutine attribute_get_real32(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      real(sp), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_real32
    module subroutine attribute_get_real64(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      real(dp), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_real64
    module subroutine attribute_get_boolean(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      logical, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_boolean
    module subroutine attribute_get_string(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      character(len = :), allocatable, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_string

    module subroutine attribute_get_int8_array(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i1), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_int8_array
    module subroutine attribute_get_int16_array(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i2), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_int16_array
    module subroutine attribute_get_int32_array(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i4), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_int32_array
    module subroutine attribute_get_int64_array(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i8), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_int64_array
    module subroutine attribute_get_real32_array(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      real(sp), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_real32_array
    module subroutine attribute_get_real64_array(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      real(dp), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_real64_array
    module subroutine attribute_get_boolean_array(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      logical, allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_boolean_array
    module subroutine attribute_get_string_array(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      character(len = :), allocatable, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_string_array

    module subroutine attribute_put_int8(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i1), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_put_int8
    module subroutine attribute_put_int16(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i2), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_put_int16
    module subroutine attribute_put_int32(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i4), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_put_int32
    module subroutine attribute_put_int64(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i8), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_put_int64
    module subroutine attribute_put_real32(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      real(sp), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_put_real32
    module subroutine attribute_put_real64(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      real(dp), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_put_real64
    module subroutine attribute_put_boolean(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      logical, intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_put_boolean
    module subroutine attribute_put_string(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      character(len = *), intent(in) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_put_string

    module subroutine attribute_exists(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      logical, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_exists
    module subroutine attribute_remove(this, path, attribute_name, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      type(exception_type), intent(inout) :: error
    end subroutine attribute_remove

    module subroutine attribute_get_rank(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i4), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_rank
    module subroutine attribute_get_shape(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i8), allocatable, intent(out) :: value(:)
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_shape
    module subroutine attribute_get_type(this, path, attribute_name, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: attribute_name
      integer(i1), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine attribute_get_type

    module subroutine object_exists(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine object_exists
    module subroutine object_remove(this, path, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      type(exception_type), intent(inout) :: error
    end subroutine object_remove
    module subroutine object_get_type(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i1), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine object_get_type

    module subroutine object_create_group(this, path, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      type(exception_type), intent(inout) :: error
    end subroutine object_create_group
    module subroutine object_remove_group(this, path, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      type(exception_type), intent(inout) :: error
    end subroutine object_remove_group
    module subroutine object_create_dataset(this, path, parameters, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      type(dataset_options), intent(in) :: parameters
      type(exception_type), intent(inout) :: error
    end subroutine object_create_dataset
    module subroutine object_remove_dataset(this, path, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      type(exception_type), intent(inout) :: error
    end subroutine object_remove_dataset

    module subroutine group_get_attributes(this, path, values, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      type(string_type), allocatable, intent(out) :: values
      type(exception_type), intent(inout) :: error
    end subroutine group_get_attributes
    module subroutine group_get_inner_objects(this, path, values, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      type(string_type), allocatable, intent(out) :: values
      type(exception_type), intent(inout) :: error
    end subroutine group_get_inner_objects
    module subroutine dataset_get_attributes(this, path, values, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      type(string_type), allocatable, intent(out) :: values
      type(exception_type), intent(inout) :: error
    end subroutine dataset_get_attributes

    module subroutine dataset_get_rank(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i4), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine dataset_get_rank
    module subroutine dataset_get_shape(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i8), allocatable, intent(out) :: value(:)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_get_shape
    module subroutine dataset_get_datatype(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i1), intent(out) :: value
      type(exception_type), intent(inout) :: error
    end subroutine dataset_get_datatype

    module subroutine dataset_get_int8(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i1), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_get_int8
    module subroutine dataset_get_int16(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i2), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_get_int16
    module subroutine dataset_get_int32(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i4), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_get_int32
    module subroutine dataset_get_int64(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i8), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_get_int64
    module subroutine dataset_get_real32(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      real(sp), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_get_real32
    module subroutine dataset_get_real64(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      real(dp), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_get_real64
    module subroutine dataset_get_boolean(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_get_boolean
    module subroutine dataset_get_string(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = :), allocatable, intent(out) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_get_string

    module subroutine dataset_put_int8(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i1), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_put_int8
    module subroutine dataset_put_int16(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i2), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_put_int16
    module subroutine dataset_put_int32(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i4), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_put_int32
    module subroutine dataset_put_int64(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      integer(i8), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_put_int64
    module subroutine dataset_put_real32(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      real(sp), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_put_real32
    module subroutine dataset_put_real64(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      real(dp), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_put_real64
    module subroutine dataset_put_boolean(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      logical, intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_put_boolean
    module subroutine dataset_put_string(this, path, value, error)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
      character(len = *), intent(in) :: path
      character(len = *), intent(in) :: value(..)
      type(exception_type), intent(inout) :: error
    end subroutine dataset_put_string

    module subroutine clear(this)
    implicit none (type, external)
      class(hdf5_api_type), intent(inout) :: this
    end subroutine clear

    module subroutine destructor(this)
    implicit none (type, external)
      type(hdf5_api_type), intent(inout) :: this
    end subroutine destructor
  end interface
end module hdf5_api
