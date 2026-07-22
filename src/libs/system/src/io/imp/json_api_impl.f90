submodule(json_api) json_api_impl
use json_module, only: json_core, json_value, &
  json_integer, json_real, json_logical, json_string, json_null, json_object, json_array
use assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not, &
  equals
implicit none (type, external)

  contains

  module procedure init
    call this%json_impl%initialize()

    call check_for_common_errors(this, ".init", error)
  end procedure init

  module procedure load_from_file
    call this%json_impl%load_file(file)

    call check_for_common_errors(this, ".load_from_file", error)
  end procedure load_from_file
  module procedure load_from_string
    call error%throw_if ( &
      where = module_name // ".load_from_string", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect", &
      ! code = 0_i4, &
      condition = trim(string) == "" &
    )

    call this%json_impl%load_from_string(string)

    call check_for_common_errors(this, ".load_from_string", error)
  end procedure load_from_string
  module procedure save_to_file
    call this%json_impl%print_file(file)

    call check_for_common_errors(this, ".save_to_file", error)
  end procedure save_to_file
  module procedure save_to_string
    call this%json_impl%print_to_string(string)

    call check_for_common_errors(this, ".save_to_string", error)
  end procedure save_to_string

  module procedure get_int32
    call this%json_impl%get(path, value)

    call check_for_common_errors(this, ".get_int32", error)
  end procedure get_int32
  module procedure get_real32
    call this%json_impl%get(path, value)

    call check_for_common_errors(this, ".get_real32", error)
  end procedure get_real32
  module procedure get_real64
    call this%json_impl%get(path, value)

    call check_for_common_errors(this, ".get_real64", error)
  end procedure get_real64
  module procedure get_logical
    call this%json_impl%get(path, value)

    call check_for_common_errors(this, ".get_logical", error)
  end procedure get_logical
  module procedure get_string
    call this%json_impl%get(path, value)

    call check_for_common_errors(this, ".get_string", error)
  end procedure get_string

  module procedure put_int32
    logical :: found

    if (this%json_impl%valid_path(path)) then
      call this%json_impl%update(path, value, found)
    else
      call this%json_impl%add(path, value, found)
    end if

    call check_for_common_errors(this, ".put_int32", error)
  end procedure put_int32
  module procedure put_real32
    logical :: found

    if (this%json_impl%valid_path(path)) then
      call this%json_impl%update(path, value, found)
    else
      call this%json_impl%add(path, value, found)
    end if

    call check_for_common_errors(this, ".put_real32", error)
  end procedure put_real32
  module procedure put_real64
    logical :: found

    if (this%json_impl%valid_path(path)) then
      call this%json_impl%update(path, value, found)
    else
      call this%json_impl%add(path, value, found)
    end if

    call check_for_common_errors(this, ".put_real64", error)
  end procedure put_real64
  module procedure put_logical
    logical :: found

    if (this%json_impl%valid_path(path)) then
      call this%json_impl%update(path, value, found)
    else
      call this%json_impl%add(path, value, found)
    end if

    call check_for_common_errors(this, ".put_logical", error)
  end procedure put_logical
  module procedure put_string
    logical :: found

    if (this%json_impl%valid_path(path)) then
      call this%json_impl%update(path, value, found)
    else
      call this%json_impl%add(path, value, found)
    end if

    call check_for_common_errors(this, ".put_string", error)
  end procedure put_string


  module procedure exists
    value = this%json_impl%valid_path(path)

    call check_for_common_errors(this, ".exists", error)
  end procedure exists
  module procedure remove
    if (.not. this%json_impl%valid_path(path)) then
      call error%throw ( &
        where = module_name // ".move_path", &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "new_path is incorrect" &
        ! code = 0_i4 &
      )
    end if

    call this%json_impl%remove(path)

    call check_for_common_errors(this, ".remove", error)
  end procedure remove

  module procedure get_element_type
    integer(i4) :: t

    call error%throw_if_not ( &
      where = module_name // ".get_element_type", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect", &
      ! code = 0_i4, &
      condition = this%json_impl%valid_path(path) &
    )

    call this%json_impl%info(path, var_type = t)

    select case (t)
    case (json_integer)
      value = JSON_TYPE_INTEGER
    case (json_real)
      value = JSON_TYPE_REAL
    case (json_logical)
      value = JSON_TYPE_BOOLEAN
    case (json_string)
      value = JSON_TYPE_STRING
    case (json_object)
      value = JSON_TYPE_OBJECT
    case (json_array)
      value = JSON_TYPE_ARRAY
    case (json_null)
      value = JSON_TYPE_NULL
    case default
      call error%throw ( &
        where = module_name // ".get_element_type", &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "unexcepted exception. unknown json type" &
        ! code = 0_i4 &
      )
    end select

    call check_for_common_errors(this, ".get_element_type", error)
  end procedure get_element_type
  module procedure is_object
    integer(i1) :: t

    call get_element_type(this, path, t, error)

    value = t == JSON_TYPE_OBJECT

    call check_for_common_errors(this, ".is_object", error)
  end procedure is_object
  module procedure is_array
    integer(i1) :: t

    call get_element_type(this, path, t, error)

    value = t == JSON_TYPE_ARRAY

    call check_for_common_errors(this, ".is_array", error)
  end procedure is_array
  module procedure is_string
    integer(i1) :: t

    call get_element_type(this, path, t, error)

    value = t == JSON_TYPE_STRING

    call check_for_common_errors(this, ".is_string", error)
  end procedure is_string
  module procedure is_integer
    integer(i1) :: t

    call get_element_type(this, path, t, error)

    value = t == JSON_TYPE_INTEGER

    call check_for_common_errors(this, ".is_integer", error)
  end procedure is_integer
  module procedure is_real
    integer(i1) :: t

    call get_element_type(this, path, t, error)

    value = t == JSON_TYPE_REAL

    call check_for_common_errors(this, ".is_real", error)
  end procedure is_real
  module procedure is_boolean
    integer(i1) :: t

    call get_element_type(this, path, t, error)

    value = t == JSON_TYPE_BOOLEAN

    call check_for_common_errors(this, ".is_boolean", error)
  end procedure is_boolean
  module procedure is_null
    integer(i1) :: t

    call get_element_type(this, path, t, error)

    value = t == JSON_TYPE_NULL

    call check_for_common_errors(this, ".is_null", error)
  end procedure is_null

  module procedure array_put_empty
    integer(i4) :: m(0)

    call error%throw_if ( &
      where = module_name // ".array_put_empty", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect", &
      ! code = 0_i4, &
      condition = this%json_impl%valid_path(path) &
    )

    call this%json_impl%add(path, m)

    call check_for_common_errors(this, ".array_put_empty", error)
  end procedure array_put_empty
  module procedure array_put_int32
    call error%throw_if ( &
      where = module_name // ".array_put_int32", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect", &
      ! code = 0_i4, &
      condition = this%json_impl%valid_path(path) &
    )

    call this%json_impl%add(path, values)

    call check_for_common_errors(this, ".array_put_int32", error)
  end procedure array_put_int32
  module procedure array_put_real32
    call error%throw_if ( &
      where = module_name // ".array_put_real32", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect", &
      ! code = 0_i4, &
      condition = this%json_impl%valid_path(path) &
    )

    call this%json_impl%add(path, values)

    call check_for_common_errors(this, ".array_put_real32", error)
  end procedure array_put_real32
  module procedure array_put_real64
    call error%throw_if ( &
      where = module_name // ".array_put_real64", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect", &
      ! code = 0_i4, &
      condition = this%json_impl%valid_path(path) &
    )

    call this%json_impl%add(path, values)

    call check_for_common_errors(this, ".array_put_real64", error)
  end procedure array_put_real64
  module procedure array_put_logical
    call error%throw_if ( &
      where = module_name // ".array_put_logical", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect", &
      ! code = 0_i4, &
      condition = this%json_impl%valid_path(path) &
    )

    call this%json_impl%add(path, values)

    call check_for_common_errors(this, ".array_put_logical", error)
  end procedure array_put_logical
  module procedure array_put_string
    integer(i4) :: i

    character(len = :), allocatable :: strs(:)

    call error%throw_if ( &
      where = module_name // ".array_put_string", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect", &
      ! code = 0_i4, &
      condition = this%json_impl%valid_path(path) &
    )

    call this%array_put(path, error)
    if (error%has_thrown()) return
    allocate( &
      character(len = maxval([(len(values(i)%data), i = 1_i4, size(values))])) :: &
      strs(size(values)) &
    )
    do i = 1, size(values)
      strs(i) = values(i)%data
    end do
    call this%json_impl%add(path, strs)

    call check_for_common_errors(this, ".array_put_string", error)
  end procedure array_put_string

  module procedure array_get_size
    logical :: is_array_v

    call this%is_array(path, is_array_v, error)
    if (error%has_thrown()) return
    call error%throw_if_not ( &
      where = module_name // ".array_get_size", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect or a value is not an array", &
      ! code = 0_i4, &
      condition = is_array_v &
    )

    call this%json_impl%info(path, n_children = value)

    call check_for_common_errors(this, ".array_get_size", error)
  end procedure array_get_size

  module procedure array_get_int32
    logical :: is_array_v

    call this%is_array(path, is_array_v, error)
    if (error%has_thrown()) return
    call error%throw_if_not ( &
      where = module_name // ".array_get_int32", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect or a value is not an array", &
      ! code = 0_i4, &
      condition = is_array_v &
    )

    call this%json_impl%get(path, values)

    call check_for_common_errors(this, ".array_get_int32", error)
  end procedure array_get_int32
  module procedure array_get_real32
    logical :: is_array_v

    call this%is_array(path, is_array_v, error)
    if (error%has_thrown()) return
    call error%throw_if_not ( &
      where = module_name // ".array_get_real32", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect or a value is not an array", &
      ! code = 0_i4, &
      condition = is_array_v &
    )

    call this%json_impl%get(path, values)

    call check_for_common_errors(this, ".array_get_real32", error)
  end procedure array_get_real32
  module procedure array_get_real64
    logical :: is_array_v

    call this%is_array(path, is_array_v, error)
    if (error%has_thrown()) return
    call error%throw_if_not ( &
      where = module_name // ".array_get_real64", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect or a value is not an array", &
      ! code = 0_i4, &
      condition = is_array_v &
    )

    call this%json_impl%get(path, values)

    call check_for_common_errors(this, ".array_get_real64", error)
  end procedure array_get_real64
  module procedure array_get_logical
    logical :: is_array_v

    call this%is_array(path, is_array_v, error)
    if (error%has_thrown()) return
    call error%throw_if_not ( &
      where = module_name // ".array_get_logical", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect or a value is not an array", &
      ! code = 0_i4, &
      condition = is_array_v &
    )

    call this%json_impl%get(path, values)

    call check_for_common_errors(this, ".array_get_logical", error)
  end procedure array_get_logical
  module procedure array_get_string
    character(len = :), allocatable :: data(:)
    integer(i4), allocatable :: len_data_i(:)
    logical :: is_array_v

    integer(i4) :: i

    call this%is_array(path, is_array_v, error)
    if (error%has_thrown()) return
    call error%throw_if_not ( &
      where = module_name // ".array_get_logical", &
      kind_type = EXCEPTION_KIND_TYPE_ERROR, &
      message = "path is incorrect or a value is not an array", &
      ! code = 0_i4, &
      condition = is_array_v &
    )

    call this%json_impl%get(path, data, len_data_i)
    allocate(values(size(data)))
    do i = 1, size(data)
      values(i)%data = data(i)(1:len_data_i(i))
    end do

    call check_for_common_errors(this, ".array_get_logical", error)
  end procedure array_get_string

  module procedure clear
    call this%json_impl%destroy()
  end procedure clear

  module procedure destructor
    call this%json_impl%destroy()
  end procedure destructor





  subroutine check_for_common_errors(this, where, error)
  implicit none (type, external)
    type(json_api_type), intent(inout) :: this
    character(len = *), intent(in) :: where
    type(exception_type), intent(inout) :: error

    logical :: status_ok
    character(len = :), allocatable :: error_message

    call this%json_impl%check_for_errors(status_ok = status_ok, error_msg = error_message)
    if (.not. status_ok) then
      call error%throw_if_not ( &
        where = module_name // where, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = error_message, &
        ! code = 0_i4, &
        condition = status_ok &
      )
    end if
  end subroutine check_for_common_errors
  subroutine check_for_common_errors_core(this, where, error)
  implicit none (type, external)
    type(json_core), intent(inout) :: this
    character(len = *), intent(in) :: where
    type(exception_type), intent(inout) :: error

    logical :: status_ok
      character(len = :), allocatable :: error_message

      call this%check_for_errors(status_ok = status_ok, error_msg = error_message)
      if (.not. status_ok) call error%throw_if_not ( &
        where = module_name // where, &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = error_message, &
        ! code = 0_i4, &
        condition = status_ok &
      )
  end subroutine check_for_common_errors_core
end submodule json_api_impl
