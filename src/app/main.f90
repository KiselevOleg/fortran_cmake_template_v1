program main
use static_library_1___math, only:max_new, min_new
use static_library_1___functions, only:abs_x, neg_x
use json_module, only:json_file
use h5fortran, only : hdf5_file
use hdf5
use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64, qp => real128, &
  i1 => int8, i2 => int16, i4 => int32, i8 => int64
implicit none (type, external)
  print *, max_new(1d0, 2d0)
  print *, min_new(1d0, 2d0)
  print *, abs_x([1d0, 2d0, - 1d0])
  print *, neg_x([1d0, 2d0, - 1d0])

  block
    complex(dp) :: a
    real(dp) :: b
    a = (1d0, 2d0)
    b = real(a)

    print *, a, b
  end block

  print *, sin((- 1d0, 0d0)) - sin((- 1d0, - 3d0)), sin((0d0, 1d0)) - sin((0d0, 2d0))

  ! print *, "_________________________________________________________________"
  ! block
  !   real(dp) :: x

  !   x = 0d0
  !   do while (x < 6.28d0)
  !     print *, x, log(exp((0d0, 1d0) * x))

  !     x = x + 1d-2
  !   end do
  ! end block

  block
    integer(i4) :: i, j

    print *, maxval([(sum([(1d0, j = 1, 100)]), i = 1, 100)])
  end block

  block
    type(json_file) :: json
    integer(i4), parameter :: array(7) = [0, 1, 1, 0, 3, 2, 9]

    call json%initialize()

    call json%add("name", "Alex")
    call json%add("age", 25)
    call json%add("numbers", array)

    call json%print_file("output.json")

    call json%destroy()
  end block
  block
    type(json_file) :: json

    character(len = :), allocatable :: name
    integer(i4) :: age
    integer(i4), allocatable :: numbers(:)

    call json%initialize()
    call json%load_file("output.json")

    print *, "json file text"
    call json%print()
    print *

    call json%get("name", name)
    call json%get("age", age)
    call json%get("numbers", numbers)

    block
      logical :: success
      character(len = :), allocatable :: error_message
      call json%check_for_errors(success, error_message)
      if (.not. success) then
        print *, error_message
        deallocate(error_message)
      end if
    end block

    call json%destroy()

    print *, "json data"
    print *, name
    print *, age
    print *, numbers

    if (allocated(name)) deallocate(name)
    if (allocated(numbers)) deallocate(numbers)

    ! matlab
    ! data = jsondecode(fileread('output.json'));
    ! disp(data.name);

    ! python
    ! import json
    ! with open('data.json', 'r', encoding='utf-8') as file:
    !     data = json.load(file)
    ! print(data)
    ! print(data['name'])
  end block
  block
    call execute_command_line("rm -f output.json")
  end block

  block
    integer :: error

    call h5open_f(error)
    if (error /= 0) stop "HDF5 open failed"

    print *, "HDF5 OK"
    call h5close_f(error)
  end block
  block
    integer :: ierr
    integer(HID_T) :: file_id

    call h5open_f(ierr)

    call h5fcreate_f("test.h5", H5F_ACC_TRUNC_F, file_id, ierr)

    print *, "hdf5 ierr=", ierr

    call h5fclose_f(file_id,ierr)

    print *, "2 test passed"
  end block
  block
    type(hdf5_file) :: h

    real(dp), allocatable :: x(:), y(:)
    integer(i4) :: i

    allocate(x(100), y(100))
    x = [(real(i, dp) * 0.1_dp, i = 1, 100)]
    y = [(sin(real(i, dp)) * 0.1_dp, i = 1, 100)]

    !call h%open('test.h5', 'rw')
    call h%open(filename = 'test.h5', action = 'w')
    call h%write('/t', 123_i4)
    print *, "real kind =", kind(x)
    print *, "real size =", storage_size(x(1))
    call h%write('/x', x)
    call h%write('/y', y)
    call h%close()

    call h%open('test.h5', 'r')
    call h%read('/x', x)
    call h%read('/y', y)
    call h%close()

    print *, x(1:5)
    print *, y(1:5)
    print *, minval(y)

    call execute_command_line("rm -f test.h5")
  end block

  ! call test()

  ! call assert(1.0d0 >= 0.0_dp)

  ! print *
  ! print *
  ! print *
  ! pause "print Enter to continue..."
end program main
