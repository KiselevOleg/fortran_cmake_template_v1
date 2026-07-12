!> @author Haart
!>
!> A dynamic size array for not high-perfomance-required code.
!> For easy way to get allocatable array with ubdefined size.
!> Supported only primitive types.
module dynamic_array
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
private
  character(len = *), parameter :: module_name = "system___dynamic_array"

  public :: dynamic_array_real64, dynamic_array_real64_constructor
  public :: dynamic_array_int32, dynamic_array_int32_constructor
  public :: dynamic_array_complex64, dynamic_array_complex64_constructor











  !> A dynamic size array for real64
  type :: dynamic_array_real64
  private
    real(dp), allocatable :: data(:)
    integer(i4) :: data_size = 0
  contains
    !> add a new value at the end
    procedure, pass(this) :: add_last => add_last_real64
    !> delete the last value
    procedure, pass(this) :: delete_last => delete_last_real64
    procedure, pass(this) :: get_value => get_value_real64
    procedure, pass(this) :: set_value => set_value_real64
    procedure, pass(this) :: get_size => get_size_real64
    !> preallocate inner data
    procedure, pass(this) :: reserve => reserve_real64

    !> get a result raw allocatable array
    procedure, pass(this) :: get_raw_array => get_raw_array_real64
  end type dynamic_array_real64

  interface
    !> constructor
    pure elemental module function dynamic_array_real64_constructor(reserve) result(this)
    implicit none (type, external)
      integer(i4), optional, intent(in) :: reserve
      type(dynamic_array_real64) :: this
    end function dynamic_array_real64_constructor

    !> add a new element at the end of the array (increment its size by 1 and set a new value)
    module subroutine add_last_real64(this, x)
    implicit none (type, external)
      class(dynamic_array_real64), intent(inout) :: this
      real(dp), intent(in) :: x
    end subroutine add_last_real64
    !> delete the last element (decrement its size by 1 with loosing a coresponding value)
    module subroutine delete_last_real64(this)
    implicit none (type, external)
      class(dynamic_array_real64), intent(inout) :: this
    end subroutine delete_last_real64
    !> get value
    real(dp) pure module module function get_value_real64(this, i) result(res)
    implicit none (type, external)
      class(dynamic_array_real64), intent(in) :: this
      !> index
      integer(i4), intent(in) :: i
    end function get_value_real64
    !> set value
    module subroutine set_value_real64(this, i, value)
    implicit none (type, external)
      class(dynamic_array_real64), intent(inout) :: this
      !> index
      integer(i4), intent(in) :: i
      !> a new value
      real(dp), intent(in) :: value
    end subroutine set_value_real64
    !> get size
    pure integer(i4) module function get_size_real64(this) result(res)
    implicit none (type, external)
      class(dynamic_array_real64), intent(in) :: this
    end function get_size_real64
    !> allocate a memory fixed size for optimization for future increasing size
    module subroutine reserve_real64(this, new_size)
    implicit none (type, external)
      class(dynamic_array_real64), intent(inout) :: this
      integer(i4), intent(in) :: new_size
    end subroutine reserve_real64

    !> get raw allocatable array
    pure module function get_raw_array_real64(this) result(res)
    implicit none (type, external)
      class(dynamic_array_real64), intent(in) :: this
      real(dp), allocatable :: res(:)
    end function get_raw_array_real64
  end interface










  !> A dynamic size array for int32
    type :: dynamic_array_int32
  private
    integer(i4), allocatable :: data(:)
    integer(i4) :: data_size = 0
  contains
    !> add a new value at the end
    procedure, pass(this) :: add_last => add_last_int32
    !> delete the last value
    procedure, pass(this) :: delete_last => delete_last_int32
    procedure, pass(this) :: get_value => get_value_int32
    procedure, pass(this) :: set_value => set_value_int32
    procedure, pass(this) :: get_size => get_size_int32
    !> preallocate inner data
    procedure, pass(this) :: reserve => reserve_int32

    !> get a result raw allocatable array
    procedure, pass(this) :: get_raw_array => get_raw_array_int32
  end type dynamic_array_int32

  interface
    !> constructor
    pure elemental module function dynamic_array_int32_constructor(reserve) result(this)
    implicit none (type, external)
      integer(i4), optional, intent(in) :: reserve
      type(dynamic_array_int32) :: this
    end function dynamic_array_int32_constructor

    !> add a new element at the end of the array (increment its size by 1 and set a new value)
    module subroutine add_last_int32(this, x)
    implicit none (type, external)
      class(dynamic_array_int32), intent(inout) :: this
      integer(i4), intent(in) :: x
    end subroutine add_last_int32
    !> delete the last element (decrement its size by 1 with loosing a coresponding value)
    module subroutine delete_last_int32(this)
    implicit none (type, external)
      class(dynamic_array_int32), intent(inout) :: this
    end subroutine delete_last_int32
    !> get value
    integer(i4) pure module module function get_value_int32(this, i) result(res)
    implicit none (type, external)
      class(dynamic_array_int32), intent(in) :: this
      !> index
      integer(i4), intent(in) :: i
    end function get_value_int32
    !> set value
    module subroutine set_value_int32(this, i, value)
    implicit none (type, external)
      class(dynamic_array_int32), intent(inout) :: this
      !> index
      integer(i4), intent(in) :: i
      !> a new value
      integer(i4), intent(in) :: value
    end subroutine set_value_int32
    !> get size
    pure integer(i4) module function get_size_int32(this) result(res)
    implicit none (type, external)
      class(dynamic_array_int32), intent(in) :: this
    end function get_size_int32
    !> allocate a memory fixed size for optimization for future increasing size
    module subroutine reserve_int32(this, new_size)
    implicit none (type, external)
      class(dynamic_array_int32), intent(inout) :: this
      integer(i4), intent(in) :: new_size
    end subroutine reserve_int32

    !> get raw allocatable array
    pure module function get_raw_array_int32(this) result(res)
    implicit none (type, external)
      class(dynamic_array_int32), intent(in) :: this
      integer(i4), allocatable :: res(:)
    end function get_raw_array_int32
  end interface










  !> A dynamic size array for complex64
  type :: dynamic_array_complex64
  private
    complex(dp), allocatable :: data(:)
    integer(i4) :: data_size = 0
  contains
    !> add a new value at the end
    procedure, pass(this) :: add_last => add_last_complex64
    !> delete the last value
    procedure, pass(this) :: delete_last => delete_last_complex64
    procedure, pass(this) :: get_value => get_value_complex64
    procedure, pass(this) :: set_value => set_value_complex64
    procedure, pass(this) :: get_size => get_size_complex64
    !> preallocate inner data
    procedure, pass(this) :: reserve => reserve_complex64

    !> get a result raw allocatable array
    procedure, pass(this) :: get_raw_array => get_raw_array_complex64
  end type dynamic_array_complex64

  interface
    !> constructor
    pure elemental module function dynamic_array_complex64_constructor(reserve) result(this)
    implicit none (type, external)
      integer(i4), optional, intent(in) :: reserve
      type(dynamic_array_complex64) :: this
    end function dynamic_array_complex64_constructor

    !> add a new element at the end of the array (increment its size by 1 and set a new value)
    module subroutine add_last_complex64(this, x)
    implicit none (type, external)
      class(dynamic_array_complex64), intent(inout) :: this
      complex(dp), intent(in) :: x
    end subroutine add_last_complex64
    !> delete the last element (decrement its size by 1 with loosing a coresponding value)
    module subroutine delete_last_complex64(this)
    implicit none (type, external)
      class(dynamic_array_complex64), intent(inout) :: this
    end subroutine delete_last_complex64
    !> get value
    complex(dp) pure module module function get_value_complex64(this, i) result(res)
    implicit none (type, external)
      class(dynamic_array_complex64), intent(in) :: this
      !> index
      integer(i4), intent(in) :: i
    end function get_value_complex64
    !> set value
    module subroutine set_value_complex64(this, i, value)
    implicit none (type, external)
      class(dynamic_array_complex64), intent(inout) :: this
      !> index
      integer(i4), intent(in) :: i
      !> a new value
      complex(dp), intent(in) :: value
    end subroutine set_value_complex64
    !> get size
    pure integer(i4) module function get_size_complex64(this) result(res)
    implicit none (type, external)
      class(dynamic_array_complex64), intent(in) :: this
    end function get_size_complex64
    !> allocate a memory fixed size for optimization for future increasing size
    module subroutine reserve_complex64(this, new_size)
    implicit none (type, external)
      class(dynamic_array_complex64), intent(inout) :: this
      integer(i4), intent(in) :: new_size
    end subroutine reserve_complex64

    !> get raw allocatable array
    pure module function get_raw_array_complex64(this) result(res)
    implicit none (type, external)
      class(dynamic_array_complex64), intent(in) :: this
      complex(dp), allocatable :: res(:)
    end function get_raw_array_complex64
  end interface
end module dynamic_array
