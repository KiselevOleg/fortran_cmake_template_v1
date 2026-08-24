submodule(hdf5_api) hdf5_api_impl
use hdf5, only: h5aexists_by_name_f
use system_util___regex_api, only: regex_api_type
use assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not, &
  equals
implicit none (type, external)

  contains

  module procedure init
    validation: block
      if (error%has_thrown()) return
    end block validation

    !call check_for_common_errors(this, ".init", error)
  end procedure init

  module procedure open_file
    integer(i4) :: ierr
    logical :: ok

    validation: block
      if (error%has_thrown()) return
    end block validation

    this%open_file_type = open_file_type

    select case(open_file_type)
    case (OPEN_FILE_TYPE_READ)
      call this%hdf5_impl%open(filename = file, action = "r", ok = ok)
    case (OPEN_FILE_TYPE_WRITE)
      call this%hdf5_impl%open(filename = file, action = "w", ok = ok)
    case (OPEN_FILE_TYPE_WRITE_READ)
      call this%hdf5_impl%open(filename = file, action = "rw", ok = ok)
    case default
      call error%throw ( &
        where = module_name // ".open_file", &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect open file type" &
        ! code = 0_i4, &
      )
    end select

    call error%throw_if_not ( &
      where = module_name // ".open_file", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "failed to open the file", &
      ! code = 0_i4, &
      condition = ok &
    )
  end procedure open_file
  module procedure close_file
    validation: block
      if (error%has_thrown()) return
    end block validation

    if (this%open_file_type == - 1_i1) return

    call this%hdf5_impl%close()
    this%open_file_type = - 1_i1
  end procedure close_file

  module procedure attribute_get_int8
    character(len = *), parameter :: procedure_name = "attribute_get_int8"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    call this%hdf5_impl%readattr(path, attribute_name, value)
  end procedure attribute_get_int8
  module procedure attribute_get_int16
    character(len = *), parameter :: procedure_name = "attribute_get_int16"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    call this%hdf5_impl%readattr(path, attribute_name, value)
  end procedure attribute_get_int16
  module procedure attribute_get_int32
    character(len = *), parameter :: procedure_name = "attribute_get_int32"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    call this%hdf5_impl%readattr(path, attribute_name, value)
  end procedure attribute_get_int32
  module procedure attribute_get_int64
    character(len = *), parameter :: procedure_name = "attribute_get_int64"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    call this%hdf5_impl%readattr(path, attribute_name, value)
  end procedure attribute_get_int64
  module procedure attribute_get_real32
    character(len = *), parameter :: procedure_name = "attribute_get_real32"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    call this%hdf5_impl%readattr(path, attribute_name, value)
  end procedure attribute_get_real32
  module procedure attribute_get_real64
    character(len = *), parameter :: procedure_name = "attribute_get_real64"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    call this%hdf5_impl%readattr(path, attribute_name, value)
  end procedure attribute_get_real64
  module procedure attribute_get_boolean
    character(len = *), parameter :: procedure_name = "attribute_get_boolean"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    call this%hdf5_impl%readattr(path, attribute_name, value)
  end procedure attribute_get_boolean
  module procedure attribute_get_string
    character(len = *), parameter :: procedure_name = "attribute_get_string"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    allocate(character(len = 4096) :: value)
    call this%hdf5_impl%readattr(path, attribute_name, value)
    value = trim(value)
  end procedure attribute_get_string

  module procedure attribute_get_int8_array
    character(len = *), parameter :: procedure_name = "attribute_get_int8_array"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_get_int8_array
  module procedure attribute_get_int16_array
    character(len = *), parameter :: procedure_name = "attribute_get_int16_array"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_get_int16_array
  module procedure attribute_get_int32_array
    character(len = *), parameter :: procedure_name = "attribute_get_int32_array"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_get_int32_array
  module procedure attribute_get_int64_array
    character(len = *), parameter :: procedure_name = "attribute_get_int64_array"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_get_int64_array
  module procedure attribute_get_real32_array
    character(len = *), parameter :: procedure_name = "attribute_get_real32_array"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_get_real32_array
  module procedure attribute_get_real64_array
    character(len = *), parameter :: procedure_name = "attribute_get_real64_array"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_get_real64_array
  module procedure attribute_get_boolean_array
    character(len = *), parameter :: procedure_name = "attribute_get_boolean_array"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape, attribute_name)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%readattr(path, attribute_name, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_get_boolean_array

  module procedure attribute_put_int8
    character(len = *), parameter :: procedure_name = "attribute_put_int8"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (1)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (2)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (3)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (4)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (5)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (6)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (7)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_put_int8
  module procedure attribute_put_int16
    character(len = *), parameter :: procedure_name = "attribute_put_int16"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (1)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (2)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (3)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (4)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (5)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (6)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (7)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_put_int16
  module procedure attribute_put_int32
    character(len = *), parameter :: procedure_name = "attribute_put_int32"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (1)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (2)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (3)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (4)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (5)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (6)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (7)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_put_int32
  module procedure attribute_put_int64
    character(len = *), parameter :: procedure_name = "attribute_put_int64"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (1)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (2)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (3)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (4)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (5)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (6)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (7)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_put_int64
  module procedure attribute_put_real32
    character(len = *), parameter :: procedure_name = "attribute_put_real32"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (1)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (2)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (3)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (4)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (5)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (6)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (7)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_put_real32
  module procedure attribute_put_real64
    character(len = *), parameter :: procedure_name = "attribute_put_real64"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (1)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (2)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (3)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (4)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (5)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (6)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (7)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_put_real64
  module procedure attribute_put_boolean
    character(len = *), parameter :: procedure_name = "attribute_put_boolean"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (1)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (2)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (3)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (4)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (5)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (6)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank (7)
      call this%hdf5_impl%writeattr(path, attribute_name, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure attribute_put_boolean
  module procedure attribute_put_string
    character(len = *), parameter :: procedure_name = "attribute_put_string"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    call this%hdf5_impl%writeattr(path, attribute_name, value)
  end procedure attribute_put_string

  module procedure attribute_exists
    character(len = *), parameter :: procedure_name = "attribute_exists"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      if (error%has_thrown()) return
    end block validation

    value = this%hdf5_impl%exist_attr(formatted_path, attribute_name)
  end procedure attribute_exists
  module procedure attribute_remove
    character(len = *), parameter :: procedure_name = "attribute_remove"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    call this%hdf5_impl%delete_attr(formatted_path, attribute_name)
  end procedure attribute_remove

  module procedure attribute_get_rank
    character(len = *), parameter :: procedure_name = "attribute_get_shape"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )
      if (error%has_thrown()) return
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    block
      integer(i8), allocatable :: shape(:)

      call this%hdf5_impl%shape(formatted_path, shape, attribute_name)

      value = size(shape)
    end block
  end procedure attribute_get_rank
  module procedure attribute_get_shape
    character(len = *), parameter :: procedure_name = "attribute_get_shape"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute_name has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_attribute_name(attribute_name) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )
      if (error%has_thrown()) return
      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "attribute does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist_attr(formatted_path, attribute_name) &
      )

      if (error%has_thrown()) return
    end block validation

    call this%hdf5_impl%shape(formatted_path, value, attribute_name)
  end procedure attribute_get_shape

  module procedure object_exists
    character(len = *), parameter :: procedure_name = "object_exists"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      if (error%has_thrown()) return
    end block validation

    value = this%hdf5_impl%exist(formatted_path)
  end procedure object_exists

  module procedure object_create_group
    character(len = *), parameter :: procedure_name = "object_create_group"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      call error%throw_if ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path is already exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    call this%hdf5_impl%create_group(formatted_path)
  end procedure object_create_group

  module procedure dataset_get_rank
    character(len = *), parameter :: procedure_name = "dataset_get_rank"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )
      if (error%has_thrown()) return
    end block validation

    block
      integer(i8), allocatable :: shape(:)

      call this%hdf5_impl%shape(formatted_path, shape)

      value = size(shape)
    end block
  end procedure dataset_get_rank
  module procedure dataset_get_shape
    character(len = *), parameter :: procedure_name = "dataset_get_shape"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    call this%hdf5_impl%shape(formatted_path, value)
  end procedure dataset_get_shape

  module procedure dataset_get_int8
    character(len = *), parameter :: procedure_name = "dataset_get_int8"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_get_int8
  module procedure dataset_get_int16
    character(len = *), parameter :: procedure_name = "dataset_get_int16"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_get_int16
  module procedure dataset_get_int32
    character(len = *), parameter :: procedure_name = "dataset_get_int32"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_get_int32
  module procedure dataset_get_int64
    character(len = *), parameter :: procedure_name = "dataset_get_real32"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_get_int64
  module procedure dataset_get_real32
    character(len = *), parameter :: procedure_name = "dataset_get_real32"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_get_real32
  module procedure dataset_get_real64
    character(len = *), parameter :: procedure_name = "dataset_get_real64"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_get_real64
  module procedure dataset_get_boolean
    character(len = *), parameter :: procedure_name = "dataset_get_boolean"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 1_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path does not exist", &
        ! code = 0_i4, &
        condition = this%hdf5_impl%exist(formatted_path) &
      )

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      block
        allocate(value)
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (1)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (2)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (3)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (4)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (5)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (6)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank (7)
      block
        integer(i8), allocatable :: shape(:)

        call this%hdf5_impl%shape(formatted_path, shape)
        allocate(value(shape(1), shape(2), shape(3), shape(4), shape(5), shape(6), shape(7)))
        call this%hdf5_impl%read(formatted_path, value)
      end block
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_get_boolean

  module procedure dataset_put_int8
    character(len = *), parameter :: procedure_name = "dataset_put_int8"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%write(formatted_path, value)
    rank (1)
      call this%hdf5_impl%write(formatted_path, value)
    rank (2)
      call this%hdf5_impl%write(formatted_path, value)
    rank (3)
      call this%hdf5_impl%write(formatted_path, value)
    rank (4)
      call this%hdf5_impl%write(formatted_path, value)
    rank (5)
      call this%hdf5_impl%write(formatted_path, value)
    rank (6)
      call this%hdf5_impl%write(formatted_path, value)
    rank (7)
      call this%hdf5_impl%write(formatted_path, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_put_int8
  module procedure dataset_put_int16
    character(len = *), parameter :: procedure_name = "dataset_put_int16"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%write(formatted_path, value)
    rank (1)
      call this%hdf5_impl%write(formatted_path, value)
    rank (2)
      call this%hdf5_impl%write(formatted_path, value)
    rank (3)
      call this%hdf5_impl%write(formatted_path, value)
    rank (4)
      call this%hdf5_impl%write(formatted_path, value)
    rank (5)
      call this%hdf5_impl%write(formatted_path, value)
    rank (6)
      call this%hdf5_impl%write(formatted_path, value)
    rank (7)
      call this%hdf5_impl%write(formatted_path, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_put_int16
  module procedure dataset_put_int32
    character(len = *), parameter :: procedure_name = "dataset_put_int32"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%write(formatted_path, value)
    rank (1)
      call this%hdf5_impl%write(formatted_path, value)
    rank (2)
      call this%hdf5_impl%write(formatted_path, value)
    rank (3)
      call this%hdf5_impl%write(formatted_path, value)
    rank (4)
      call this%hdf5_impl%write(formatted_path, value)
    rank (5)
      call this%hdf5_impl%write(formatted_path, value)
    rank (6)
      call this%hdf5_impl%write(formatted_path, value)
    rank (7)
      call this%hdf5_impl%write(formatted_path, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_put_int32
  module procedure dataset_put_int64
    character(len = *), parameter :: procedure_name = "dataset_put_int64"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%write(formatted_path, value)
    rank (1)
      call this%hdf5_impl%write(formatted_path, value)
    rank (2)
      call this%hdf5_impl%write(formatted_path, value)
    rank (3)
      call this%hdf5_impl%write(formatted_path, value)
    rank (4)
      call this%hdf5_impl%write(formatted_path, value)
    rank (5)
      call this%hdf5_impl%write(formatted_path, value)
    rank (6)
      call this%hdf5_impl%write(formatted_path, value)
    rank (7)
      call this%hdf5_impl%write(formatted_path, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_put_int64
  module procedure dataset_put_real32
    character(len = *), parameter :: procedure_name = "dataset_put_real32"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%write(formatted_path, value)
    rank (1)
      call this%hdf5_impl%write(formatted_path, value)
    rank (2)
      call this%hdf5_impl%write(formatted_path, value)
    rank (3)
      call this%hdf5_impl%write(formatted_path, value)
    rank (4)
      call this%hdf5_impl%write(formatted_path, value)
    rank (5)
      call this%hdf5_impl%write(formatted_path, value)
    rank (6)
      call this%hdf5_impl%write(formatted_path, value)
    rank (7)
      call this%hdf5_impl%write(formatted_path, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_put_real32
  module procedure dataset_put_real64
    character(len = *), parameter :: procedure_name = "dataset_put_real64"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%write(formatted_path, value)
    rank (1)
      call this%hdf5_impl%write(formatted_path, value)
    rank (2)
      call this%hdf5_impl%write(formatted_path, value)
    rank (3)
      call this%hdf5_impl%write(formatted_path, value)
    rank (4)
      call this%hdf5_impl%write(formatted_path, value)
    rank (5)
      call this%hdf5_impl%write(formatted_path, value)
    rank (6)
      call this%hdf5_impl%write(formatted_path, value)
    rank (7)
      call this%hdf5_impl%write(formatted_path, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_put_real64
  module procedure dataset_put_boolean
    character(len = *), parameter :: procedure_name = "dataset_put_boolean"

    character(len = :), allocatable :: formatted_path

    validation: block
      if (error%has_thrown()) return

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect file open type", &
        ! code = 0_i4, &
        condition = btest(this%open_file_type, 0_i1) &
      )

      call error%throw_if_not ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "path has incorrect syntax", &
        ! code = 0_i4, &
        condition = is_possible_path(path, formatted_path) &
      )
      if (error%has_thrown()) return

      if (error%has_thrown()) return
    end block validation

    select rank (value)
    rank (0)
      call this%hdf5_impl%write(formatted_path, value)
    rank (1)
      call this%hdf5_impl%write(formatted_path, value)
    rank (2)
      call this%hdf5_impl%write(formatted_path, value)
    rank (3)
      call this%hdf5_impl%write(formatted_path, value)
    rank (4)
      call this%hdf5_impl%write(formatted_path, value)
    rank (5)
      call this%hdf5_impl%write(formatted_path, value)
    rank (6)
      call this%hdf5_impl%write(formatted_path, value)
    rank (7)
      call this%hdf5_impl%write(formatted_path, value)
    rank default
      call error%throw ( &
        where = module_name // "." // procedure_name, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect rank" & !, &
        ! code = 0_i4, &
      )
    end select
  end procedure dataset_put_boolean

  module procedure clear
    if (this%open_file_type == - 1_i1) return

    call this%hdf5_impl%close()
    this%open_file_type = - 1_i1
  end procedure clear
  module procedure destructor
    call this%clear()
  end procedure destructor





  logical function is_possible_attribute_name(name) result(res)
  implicit none (type, external)
    character(len = *), intent(in) :: name

    type(exception_type) :: error
    type(regex_api_type), save :: regex
    logical, save :: not_prepared = .true.

    logical :: v

    if (not_prepared) then
      not_prepared = .false.
      call prepare()
    end if

    if (trim(name) == "") then
      res = .false.
      return
    end if

    v = .false.
    call regex%regex_match(name, v, error)
    res = v

    if (error%has_thrown()) call error_assert_not( &
      location = module_name // ".is_possible_path", &
      message = "unexpected error " // error%get_message() // " .", &
      condition = error%has_thrown() &
    )

    contains
    subroutine prepare()
    implicit none (type, external)
      call regex%compile_regex( &
        "^[a-zA-Z_][a-zA-Z0-9_]*$", &
        error &
      )
      if (error%has_thrown()) call error_assert_not( &
        location = module_name // ".is_possible_attribute_name", &
        message = "unexpected error " // error%get_message() // " .", &
        condition = error%has_thrown() &
      )
    end subroutine prepare
  end function is_possible_attribute_name
  logical function is_possible_path(path, formatted_path) result(res)
  implicit none (type, external)
    character(len = *), intent(in) :: path
    character(len = :), allocatable, intent(out) :: formatted_path

    type(exception_type) :: error
    type(regex_api_type), save :: regex, regex_with_braces
    logical, save :: not_prepared = .true.

    character(len = :), allocatable :: parts(:)

    integer(i4) :: i
    logical :: v

    if (not_prepared) then
      not_prepared = .false.
      call prepare()
    end if

    if (trim(path) == "") then
      res = .false.
      return
    end if
    if (path(1_i4:1_i4) == ".") then
      res = .false.
      return
    end if
    if (path(len(path):len(path)) == ".") then
      res = .false.
      return
    end if

    call split_path(path, parts)
    do i = 1, size(parts)
      v = .false.
      call regex%regex_match(trim(parts(i)), v, error)
      if (v) cycle
      ! call regex_with_braces%regex_match(trim(parts(i)), v, error)
      ! if (v) cycle
      exit
    end do
    res = v

    if (error%has_thrown()) call error_assert_not( &
      location = module_name // ".is_possible_path", &
      message = "unexpected error " // error%get_message() // " .", &
      condition = error%has_thrown() &
    )

    allocate(character(len = (len(path) + 1_i4)) :: formatted_path)
    formatted_path(1:1) = "/"
    formatted_path(2:) = path
    do concurrent (i = 2_i4:len(formatted_path))
      if (formatted_path(i:i) /= ".") cycle

      formatted_path(i:i) = "/"
    end do

    contains
    subroutine prepare()
    implicit none (type, external)
      ! call regex%compile_regex( &
      !   "^([a-zA-Z_][a-zA-Z0-9_]*\.)*" // &
      !   "([a-zA-Z_][a-zA-Z0-9_]*)$", &
      !   error &
      ! )
      call regex%compile_regex( &
        "^[a-zA-Z_][a-zA-Z0-9_]*$", &
        error &
      )
      if (error%has_thrown()) call error_assert_not( &
        location = module_name // ".is_possible_path", &
        message = "unexpected error " // error%get_message() // " .", &
        condition = error%has_thrown() &
      )
    end subroutine prepare
    subroutine split_path(string_path, res)
      character(len = *), intent(in) :: string_path
      character(len = :), allocatable, intent(out) :: res(:)

      integer(i4) :: n, max_len, current_len

      integer(i4) :: i

      n = 1_i4
      max_len = 0_i4
      current_len = 0_i4
      do i = 1_i4, len(string_path)
        if (string_path(i:i) == ".") then
          n = n + 1_i4
          max_len = max(max_len, current_len)
          current_len = 0_i4
          cycle
        end if
        current_len = current_len + 1_i4
      end do
      max_len = max(max_len, current_len)

      allocate(character(len = max_len) :: res(n))
      res = ""

      n = 1_i4
      current_len = 0_i4
      do i = 1_i4, len(string_path)
        if (string_path(i:i) == ".") then
          n = n + 1_i4
          current_len = 0_i4
          cycle
        end if
        current_len = current_len + 1_i4

        res(n)(current_len:current_len) = string_path(i:i)
      end do
    end subroutine split_path
  end function is_possible_path
end submodule hdf5_api_impl
