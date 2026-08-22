submodule(regex_api) regex_api_impl
use assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not
implicit none (type, external)

  contains

  module procedure regex_match
    validation: block
      call error%throw_if_not ( &
        where = module_name // ".regex_match", &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "regex object must be compilled", &
        ! code = 0_i4, &
        condition = this%compiled_regex &
      )
      call error%throw_if ( &
        where = module_name // ".regex_match", &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect string", &
        ! code = 0_i4, &
        condition = trim(string) == "" &
      )

      if (error%has_thrown()) return
    end block validation

    execution: block
      integer(i4) :: ind

      ind = regex_library(string = string, pattern = this%regex_preparsed_library_imp)

      call error%throw_if ( &
        where = module_name // ".regex_match", &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "regex invalid", &
        ! code = 0_i4, &
        condition = ind < 0_i4 &
      )
      if (error%has_thrown()) return

      result = ind > 0_i4
    end block execution
  end procedure regex_match

  module procedure regex_find_first_match
    validation: block
      call error%throw_if_not ( &
        where = module_name // ".regex_find_first_match", &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect regex string", &
        ! code = 0_i4, &
        condition = this%compiled_regex &
      )
      call error%throw_if ( &
        where = module_name // ".regex_find_first_match", &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "incorrect string", &
        ! code = 0_i4, &
        condition = trim(string) == "" &
      )

      if (error%has_thrown()) return
    end block validation

    execution: block
      integer(i4) :: ind, length

      ind = regex_library(string = string, pattern = this%regex_preparsed_library_imp, &
        length = length)

      call error%throw_if ( &
        where = module_name // ".regex_find_first_match", &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "regex invalid", &
        ! code = 0_i4, &
        condition = ind < 0_i4 &
      )
      if (error%has_thrown()) return

      start_index = ind
      end_index = ind + length - 1_i4

      if (ind == 0_i4) then
        start_index = - 1_i4
        end_index = - 1_i4
      end if
    end block execution
  end procedure regex_find_first_match

  module procedure compile_regex
    validation: block
      if (error%has_thrown()) return
    end block validation

    this%regex_preparsed_library_imp = parse_pattern(regex_str)
    this%compiled_regex = .true.

    block
      integer(i4) :: ind

      ind = regex_library(string = "test", pattern = this%regex_preparsed_library_imp)

      call error%throw_if ( &
        where = module_name // ".compile_regex", &
        kind_type = EXCEPTION_KIND_TYPE_ERROR, &
        message = "regex invalid", &
        ! code = 0_i4, &
        condition = ind < 0_i4 &
      )
      if (error%has_thrown()) return
    end block
  end procedure compile_regex
end submodule regex_api_impl
