program main
use static_library_1___math, only:max_new, min_new
use static_library_1___functions, only:abs_x, neg_x
use json_module, only:json_file
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

  ! call test()

  ! call assert(1.0d0 >= 0.0_dp)

  ! print *
  ! print *
  ! print *
  ! pause "print Enter to continue..."
end program main
