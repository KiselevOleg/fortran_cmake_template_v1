submodule(assert) assert_impl
implicit none (type, external)

  contains

  module procedure error_assert
    if (condition) return
    error stop "error error_assert " // location // " : " // message
  end procedure error_assert
  module procedure error_assert_not
    if (.not. condition) return
    error stop "error error_assert_not " // location // " : " // message
  end procedure error_assert_not

  module procedure warning_assert
    if (condition) return
    error stop "warning " // location // " : " // message
  end procedure warning_assert
  module procedure warning_assert_not
    if (.not. condition) return
    error stop "warning " // location // " : " // message
  end procedure warning_assert_not

  module procedure equals_real32
    call error_assert(location = module_name // ".equals_real64", &
      message = "eps > 0.0_sp", &
      condition = eps > 0.0_sp &
    )

    res = abs(a - b) <= eps
  end procedure equals_real32
  module procedure equals_complex32
    call error_assert(location = module_name // ".equals_complex64", &
      message = "eps > 0.0_sp", &
      condition = eps > 0.0_sp &
    )

    res = abs(a - b) <= eps
  end procedure equals_complex32

  module procedure equals_real64
    call error_assert(location = module_name // ".equals_real64", &
      message = "eps > 0d0", &
      condition = eps > 0d0 &
    )

    res = abs(a - b) <= eps
  end procedure equals_real64
  module procedure equals_complex64
    call error_assert(location = module_name // ".equals_complex64", &
      message = "eps > 0d0", &
      condition = eps > 0d0 &
    )

    res = abs(a - b) <= eps
  end procedure equals_complex64

  module procedure equals_real128
    call error_assert(location = module_name // ".equals_real64", &
      message = "eps > 0.0_qp", &
      condition = eps > 0.0_qp &
    )

    res = abs(a - b) <= eps
  end procedure equals_real128
  module procedure equals_complex128
    call error_assert(location = module_name // ".equals_complex64", &
      message = "eps > 0.0_qp", &
      condition = eps > 0.0_qp &
    )

    res = abs(a - b) <= eps
  end procedure equals_complex128
end submodule assert_impl
