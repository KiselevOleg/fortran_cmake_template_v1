submodule(integration_element_gauss7) integration_element_gauss7_impl
use system_exception___assert, only: error_assert, error_assert_not, &
  warning_assert, warning_assert_not, &
  equals
implicit none (type, external)

  contains

  module procedure integration_element_gauss7_constructor
  end procedure integration_element_gauss7_constructor

  module procedure run
    real(dp), parameter :: domain(4) = [&
      0.0000000000d0, 0.405845151377d0, 0.741531185599d0, 0.949107912343d0 &
    ]
    real(dp), parameter :: koef(4) = [&
      0.417959183673d0, 0.381830050505d0, 0.279705391489d0, 0.129484966169d0 &
    ]

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
    res = res + koef(4) * func(unnorm(a, b, - domain(4)))
    res = res + koef(3) * func(unnorm(a, b, - domain(3)))
    res = res + koef(2) * func(unnorm(a, b, - domain(2)))
    res = res + koef(1) * func(unnorm(a, b, domain(1)))
    res = res + koef(2) * func(unnorm(a, b, domain(2)))
    res = res + koef(3) * func(unnorm(a, b, domain(3)))
    res = res + koef(4) * func(unnorm(a, b, domain(4)))
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
end submodule integration_element_gauss7_impl
