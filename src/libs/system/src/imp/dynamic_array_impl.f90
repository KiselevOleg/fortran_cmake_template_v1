submodule(dynamic_array) dynamic_array_impl
use assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not
implicit none (type, external)

  contains

  module procedure dynamic_array_real64_constructor
    if (present(reserve)) then
      call error_assert(location = module_name // ".dynamic_array_real64_constructor", &
        message = "reserve >= 1", &
        condition = reserve >= 1 &
      )
      allocate(this%data(reserve))
    else
      allocate(this%data(1))
    end if
  end procedure dynamic_array_real64_constructor

  module procedure add_last_real64
    real(dp), allocatable :: tmp(:)

    associate(n => this%data_size)
      if (size(this%data) <= n) then
        allocate(tmp(1:n))
        tmp(1:n) = this%data(1:n)
        deallocate(this%data)
        allocate(this%data(1:n + n))
        this%data(1:n) = tmp(1:n)
        deallocate(tmp)
      end if

      n = n + 1
      this%data(n) = x
    end associate
  end procedure add_last_real64
  module procedure delete_last_real64
    call error_assert_not(location = module_name // ".delete_last_real64", &
      message = "size == 0", &
      condition = this%data_size == 0 &
    )

    this%data_size = this%data_size - 1
  end procedure delete_last_real64
  module procedure get_value_real64
    call error_assert(location = module_name // ".get_value_real64", &
      message = "i must be [1,size]", &
      condition = 1 <= i .and. i <= this%data_size &
    )

    res = this%data(i)
  end procedure get_value_real64
  module procedure set_value_real64
    call error_assert(location = module_name // ".set_value_real64", &
      message = "i must be [1,size]", &
      condition = 1 <= i .and. i <= this%data_size &
    )

    this%data(i) = value
  end procedure set_value_real64
  module procedure get_size_real64
    res = this%data_size
  end procedure get_size_real64
  module procedure reserve_real64
    real(dp), allocatable :: tmp(:)

    call error_assert(location = module_name // ".reserve_real64", &
      message = "new_size >= 1", &
      condition = new_size >= 1 &
    )

    if (this%data_size >= new_size) return

    associate(n => this%data_size)
      if (size(this%data) <= n) then
        allocate(tmp(1:n))
        tmp(1:n) = this%data(1:n)
        deallocate(this%data)
        allocate(this%data(1:new_size))
        this%data(1:n) = tmp(1:n)
        deallocate(tmp)
      end if
    end associate
  end procedure reserve_real64

  module procedure get_raw_array_real64
    allocate(res(this%data_size))
    res(1:this%data_size) = this%data(1:this%data_size)
  end procedure get_raw_array_real64









    module procedure dynamic_array_int32_constructor
    if (present(reserve)) then
      call error_assert(location = module_name // ".dynamic_array_int32_constructor", &
        message = "reserve >= 1", &
        condition = reserve >= 1 &
      )
      allocate(this%data(reserve))
    else
      allocate(this%data(1))
    end if
  end procedure dynamic_array_int32_constructor

  module procedure add_last_int32
    integer(i4), allocatable :: tmp(:)

    associate(n => this%data_size)
      if (size(this%data) <= n) then
        allocate(tmp(1:n))
        tmp(1:n) = this%data(1:n)
        deallocate(this%data)
        allocate(this%data(1:n + n))
        this%data(1:n) = tmp(1:n)
        deallocate(tmp)
      end if

      n = n + 1
      this%data(n) = x
    end associate
  end procedure add_last_int32
  module procedure delete_last_int32
    call error_assert_not(location = module_name // ".delete_last_int32", &
      message = "size == 0", &
      condition = this%data_size == 0 &
    )

    this%data_size = this%data_size - 1
  end procedure delete_last_int32
  module procedure get_value_int32
    call error_assert(location = module_name // ".get_value_int32", &
      message = "i must be [1,size]", &
      condition = 1 <= i .and. i <= this%data_size &
    )

    res = this%data(i)
  end procedure get_value_int32
  module procedure set_value_int32
    call error_assert(location = module_name // ".set_value_int32", &
      message = "i must be [1,size]", &
      condition = 1 <= i .and. i <= this%data_size &
    )

    this%data(i) = value
  end procedure set_value_int32
  module procedure get_size_int32
    res = this%data_size
  end procedure get_size_int32
  module procedure reserve_int32
    integer(i4), allocatable :: tmp(:)

    call error_assert(location = module_name // ".reserve_int32", &
      message = "new_size >= 1", &
      condition = new_size >= 1 &
    )

    if (this%data_size >= new_size) return

    associate(n => this%data_size)
      if (size(this%data) <= n) then
        allocate(tmp(1:n))
        tmp(1:n) = this%data(1:n)
        deallocate(this%data)
        allocate(this%data(1:new_size))
        this%data(1:n) = tmp(1:n)
        deallocate(tmp)
      end if
    end associate
  end procedure reserve_int32

  module procedure get_raw_array_int32
    allocate(res(this%data_size))
    res(1:this%data_size) = this%data(1:this%data_size)
  end procedure get_raw_array_int32










      module procedure dynamic_array_complex64_constructor
    if (present(reserve)) then
      call error_assert(location = module_name // ".dynamic_array_complex64_constructor", &
        message = "reserve >= 1", &
        condition = reserve >= 1 &
      )
      allocate(this%data(reserve))
    else
      allocate(this%data(1))
    end if
  end procedure dynamic_array_complex64_constructor

  module procedure add_last_complex64
    complex(dp), allocatable :: tmp(:)

    associate(n => this%data_size)
      if (size(this%data) <= n) then
        allocate(tmp(1:n))
        tmp(1:n) = this%data(1:n)
        deallocate(this%data)
        allocate(this%data(1:n + n))
        this%data(1:n) = tmp(1:n)
        deallocate(tmp)
      end if

      n = n + 1
      this%data(n) = x
    end associate
  end procedure add_last_complex64
  module procedure delete_last_complex64
    call error_assert_not(location = module_name // ".delete_last_complex64", &
      message = "size == 0", &
      condition = this%data_size == 0 &
    )

    this%data_size = this%data_size - 1
  end procedure delete_last_complex64
  module procedure get_value_complex64
    call error_assert(location = module_name // ".get_value_complex64", &
      message = "i must be [1,size]", &
      condition = 1 <= i .and. i <= this%data_size &
    )

    res = this%data(i)
  end procedure get_value_complex64
  module procedure set_value_complex64
    call error_assert(location = module_name // ".set_value_int32", &
      message = "i must be [1,size]", &
      condition = 1 <= i .and. i <= this%data_size &
    )

    this%data(i) = value
  end procedure set_value_complex64
  module procedure get_size_complex64
    res = this%data_size
  end procedure get_size_complex64
  module procedure reserve_complex64
    complex(dp), allocatable :: tmp(:)

    call error_assert(location = module_name // ".reserve_int32", &
      message = "new_size >= 1", &
      condition = new_size >= 1 &
    )

    if (this%data_size >= new_size) return

    associate(n => this%data_size)
      if (size(this%data) <= n) then
        allocate(tmp(1:n))
        tmp(1:n) = this%data(1:n)
        deallocate(this%data)
        allocate(this%data(1:new_size))
        this%data(1:n) = tmp(1:n)
        deallocate(tmp)
      end if
    end associate
  end procedure reserve_complex64

  module procedure get_raw_array_complex64
    allocate(res(this%data_size))
    res(1:this%data_size) = this%data(1:this%data_size)
  end procedure get_raw_array_complex64
end submodule dynamic_array_impl
