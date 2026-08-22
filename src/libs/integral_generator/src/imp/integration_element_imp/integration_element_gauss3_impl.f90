submodule(integration_element_gauss3) integration_element_gauss3_impl
use system_exception___assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not, &
  equals
implicit none (type, external)

  contains

  module procedure integration_element_gauss3_constructor
  end procedure integration_element_gauss3_constructor

  module procedure run
    real(dp), parameter :: domain(2) = [0.0000000000d0, 0.7745966692d0]
    real(dp), parameter :: koef(2) = [0.8888888888d0, 0.5555555556d0]

    interface
      function func(x)
      import :: dp
      implicit none (type, external)
        real(dp), intent(in) :: x
      end function func
    end interface

    call error_assert(location = module_name // &
      ".run", &
      message = "a < b", &
      condition = .not. equals(&
        a, &
        b, &
        1d-7 &
      ) .and. a < b &
    )

    res = 0d0
    res = res + koef(2) * func(unnorm(a, b, - domain(2)))
    res = res + koef(1) * func(unnorm(a, b, domain(1)))
    res = res + koef(2) * func(unnorm(a, b, domain(2)))
    res = res * 0.5d0 * (b - a)

    contains
    pure elemental real(dp) function unnorm(a, b, v) result(res)
    implicit none (type, external)
      real(dp), intent(in) :: a
      real(dp), intent(in) :: b
      real(dp), intent(in) :: v

      res = (v + 1d0) * 0.5d0 * (b - a) + a
    end function unnorm
  end procedure run
end submodule integration_element_gauss3_impl
