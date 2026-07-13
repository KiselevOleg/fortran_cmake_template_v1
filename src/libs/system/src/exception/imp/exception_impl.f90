submodule(exception) exception_impl
use assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not, &
  equals
implicit none (type, external)

  contains

  module procedure init
  end procedure init
  module procedure clear
    if (allocated(this%where)) deallocate(this%where)
    this%kind_type = 0_i1
    if (allocated(this%message)) deallocate(this%message)
    this%code = - 1_i4
    if (allocated(this%cause)) deallocate(this%cause)

    nullify(this%last_cause)
  end procedure clear

  module procedure has_thrown
    res = allocated(this%message)
  end procedure has_thrown
  module procedure get_where
    call error_assert(location = module_name // ".get_where", &
      message = "error is null", &
      condition = allocated(this%message) &
    )

    res = this%where
  end procedure get_where
  module procedure get_kind_type
    res = this%kind_type
  end procedure get_kind_type
  module procedure get_message
    call error_assert(location = module_name // ".get_message", &
      message = "error is null", &
      condition = allocated(this%message) &
    )

    res = this%message
  end procedure get_message
  module procedure has_code
    call error_assert(location = module_name // ".has_code", &
      message = "error is null", &
      condition = allocated(this%message) &
    )

    res = this%present_code
  end procedure has_code
  module procedure get_code
    call error_assert(location = module_name // ".get_code", &
      message = "there is no code", &
      condition = this%has_code() &
    )

    res = this%code
  end procedure get_code

  module procedure throw
    call error_assert(location = module_name // ".throw", &
      message = "an exception type is incorrect", &
      condition = kind_type == EXCEPTION_KIND_TYPE_ERROR .or. &
        kind_type == EXCEPTION_KIND_TYPE_WARNING .or. kind_type == EXCEPTION_KIND_TYPE_INFO &
    )
    call error_assert(location = module_name // ".throw", &
      message = "message must be not empty string", &
      condition = len(trim(message)) > 0_i4 &
    )
    call error_assert(location = module_name // ".throw", &
      message = "where must be not empty string", &
      condition = len(trim(where)) > 0_i4 &
    )

    if (this%has_thrown()) then
      block
        if (.not.associated(this%last_cause)) then
          block
            type(exception_type), pointer :: t

            t => this

            do while (allocated(t%cause))
              t => t%cause
            end do

            this%last_cause => t
          end block
        end if

        allocate(this%last_cause%cause)

        this%last_cause%cause%where = where
        this%last_cause%cause%kind_type = kind_type
        this%last_cause%cause%message = message
        this%last_cause%cause%present_code = present(code)
        this%last_cause%cause%code = - 1_i4
        if (present(code)) this%last_cause%cause%code = code

        this%last_cause => this%last_cause%cause
      end block
    else
        this%where = where
        this%kind_type = kind_type
        this%message = message
        this%present_code = present(code)
        this%code = - 1_i4
        this%last_cause => this
        if (present(code)) this%code = code
    end if
  end procedure throw
  module procedure throw_if
    if (.not. condition) return

    if (present(code)) then
      call this%throw(where = where, kind_type = kind_type, message = message, code = code)
    else
      call this%throw(where = where, kind_type = kind_type, message = message)
    end if
  end procedure throw_if
  module procedure throw_if_not
    if (condition) return

    if (present(code)) then
      call this%throw(where = where, kind_type = kind_type, message = message, code = code)
    else
      call this%throw(where = where, kind_type = kind_type, message = message)
    end if
  end procedure throw_if_not

  module procedure has_cause
    call error_assert(location = module_name // ".has_cause", &
      message = "there is no error", &
      condition = this%has_thrown() &
    )

    res = allocated(this%cause)
  end procedure has_cause
  module procedure get_cause
    call error_assert(location = module_name // ".get_cause", &
      message = "there is no cause for this exception object", &
      condition = this%has_cause() &
    )

    res = this%cause
  end procedure get_cause
  module procedure get_cause_pointer
    call error_assert(location = module_name // ".get_cause_pointer", &
      message = "there is no cause for this exception object", &
      condition = this%has_cause() &
    )

    res => this%cause
  end procedure get_cause_pointer

  module procedure print_exception_to_string
    unit =  "________________"
    call print_exception_to_string_list(unit, error)
    unit = unit // new_line("a") //  "________________"
  end procedure print_exception_to_string
  recursive subroutine print_exception_to_string_list(unit, error)
  implicit none (type, external)
    character(len = :), allocatable, intent(inout) :: unit
    type(exception_type), intent(in) :: error

    character(len = :), allocatable :: type_str, code_str

    if (.not. error%has_thrown()) return

    select case (error%kind_type)
    case (EXCEPTION_KIND_TYPE_INFO)
      type_str = "INFO    "
    case (EXCEPTION_KIND_TYPE_WARNING)
      type_str = "WARNING    "
    case (EXCEPTION_KIND_TYPE_ERROR)
      type_str = "ERROR    "
    case default
      call error_assert(location = module_name // ".print_exception_to_string_list", &
        message = "unknown exception error%kind_type", &
        condition = .false. &
      )
    end select
    if (error%has_code()) then
      block
        character(len = 32) :: tmp

        write (tmp, "(I0)") error%get_code()
        code_str = trim(tmp)
      end block
    else
      code_str = ""
    end if

    unit = unit // new_line("a") // &
      type_str // " " // code_str // "    " // error%get_where() // " : " // error%get_message()
    unit = unit // new_line("a") // "____"

    if (error%has_cause()) call print_exception_to_string_list(unit, error%get_cause())
  end subroutine print_exception_to_string_list

  module procedure print_exception_to_console
  use, intrinsic :: iso_fortran_env, only: output_unit
    call print_exception_to_file(unit = output_unit, error = error)
  end procedure print_exception_to_console

  module procedure print_exception_to_file
    character(len = :), allocatable :: buffer

    call print_exception_to_string(unit = buffer, error = error)

    write (unit, *) trim(buffer)
  end procedure print_exception_to_file




  module procedure exception_type_assign
    lhs%kind_type = rhs%kind_type
    lhs%present_code = rhs%present_code
    lhs%code = rhs%code
    nullify(lhs%last_cause)

    if (allocated(rhs%where)) then
      lhs%where = rhs%where
    end if

    if (allocated(rhs%message)) then
      lhs%message = rhs%message
    end if

    if (allocated(rhs%cause)) then
      allocate(lhs%cause)
      lhs%cause = rhs%cause
    end if
  end procedure exception_type_assign
end submodule exception_impl
