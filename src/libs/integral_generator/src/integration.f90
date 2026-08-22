!> @author Haart
!>
!> a facade module for integration a complex function by custom built path
!> with explicit description of path parts
!> for not standart complex integration
!>
!> with all premade tools avaible
!>
!> @example
!>
!> ```fortran
!>
!>      template_recalculation => integration_template_recalculation_constructor, &
!>
!>      integrated_function_type, &
!>      path_part_parallel_Im => integration_path_part_parallel_Im_constructor, &
!>      path_part_parallel_Re => integration_path_part_parallel_Re_constructor, &
!>
!>      element_gauss3 => integration_element_gauss3_constructor, &
!>      element_gauss4 => integration_element_gauss4_constructor, &
!>      element_gauss5 => integration_element_gauss5_constructor, &
!>      element_gauss6 => integration_element_gauss6_constructor, &
!>      element_gauss7 => integration_element_gauss7_constructor, &
!>      element_gauss8 => integration_element_gauss8_constructor
!>
!>    type(integrator_obj) :: integrator
!>
!>    block
!>      type(integrator_builder_obj) :: builder
!>      builder = integrator_builder_constructor()
!>      call builder%add_new_path_part( &
!>        path_part_parallel_Re(builder%last_start((0d0, 0d0)), 3.14159265358979d0) &
!>      )
!>      call builder%part_integration_strategy( &
!>        template_recalculation(), &
!>        element_gauss6() &
!>      )
!>      call builder%set_accuracy(1d-3)
!>      integrator = builder%build()
!>    end block
!>
!>    print *, integrator%integrate(func) ! (2d0, 0d0)
!>    contains
!>    complex(dp) function func(x) result(res)
!>    implicit none (type, external)
!>      complex(dp), intent(in) :: x
!>
!>      if (.not. (0d0 <= real(x) .and. real(x) <= 3.14159265358979d0)) error stop "incorrect x"
!>      if (abs(aimag(x)) > 1d-100) error stop "incorrect x"
!>
!>      res = sin(x)
!>    end function func
!>```
!>
!>    type(integrator_obj) :: integrator_inner, integrator_outer
!>
!>    real(dp), parameter :: eps = 1d-6
!>
!>    complex(dp) :: r
!>
!>    block
!>      type(integrator_builder_obj) :: builder
!>      builder = integrator_builder_constructor()
!>      call builder%add_new_path_part( &
!>        path_part_parallel_Im(builder%last_start((1d-9, 0d0)), - 0.01d0) &
!>      )
!>      call builder%part_integration_strategy( &
!>        template_recalculation(), &
!>        element_gauss3() &
!>      )
!>      call builder%add_new_path_part( &
!>        path_part_parallel_Re(builder%last_end(), 5d0) &
!>      )
!>      call builder%add_new_path_part( &
!>        path_part_parallel_Im(builder%last_end(), 0.01d0) &
!>      )
!>      call builder%add_new_path_part( &
!>        path_part_parallel_Re(builder%last_end(), 45d0) &
!>      )
!>      call builder%set_accuracy(eps)
!>      integrator_outer = builder%build()
!>    end block
!>    block
!>      type(integrator_builder_obj) :: builder
!>      builder = integrator_builder_constructor()
!>      call builder%add_new_path_part( &
!>        path_part_parallel_Re(builder%last_start((0d0, 0d0)), 2d0 * 3.14159265358979d0) &
!>      )
!>      call builder%part_integration_strategy( &
!>        template_recalculation(), &
!>        element_gauss3() &
!>      )
!>      call builder%set_accuracy(eps)
!>      integrator_inner = builder%build()
!>    end block
!>
!>    print *, integrator_outer%integrate(inner_int1) ! pi
!>    contains
!>
!>    complex(dp) function inner_int1(r_) result(res)
!>    implicit none (type, external)
!>      complex(dp), intent(in) :: r_
!>
!>      r = r_
!>
!>      res = integrator_inner%integrate(inner_int2)
!>    end function inner_int1
!>    complex(dp) function inner_int2(phi) result(res)
!>    implicit none (type, external)
!>      complex(dp), intent(in) :: phi
!>
!>      res = surf(x = r * cos(phi), y = r * sin(phi)) * r
!>    end function inner_int2
!>
!>    complex(dp) function surf(x, y) result(res)
!>    implicit none (type, external)
!>      complex(dp), intent(in) :: x
!>      complex(dp), intent(in) :: y
!>
!>      res = exp(- x ** 2 - y ** 2)
!>    end function surf
!>```
module integration
use integrator, only: &
  integrator_obj, integrator_builder_obj, &
  integrator_builder_constructor



use integration_template, only: integration_template_obj

use integration_template_recalculation, only: &
  integration_template_recalculation_obj, integration_template_recalculation_constructor



use integration_path_part, only: &
  integration_path_part_obj, &
  integrated_function_type, projection_function_type, normalized_delta_type

use integration_path_part_parallel_Im, only: &
  integration_path_part_parallel_Im_obj, integration_path_part_parallel_Im_constructor
use integration_path_part_parallel_Re, only: &
  integration_path_part_parallel_Re_obj, integration_path_part_parallel_Re_constructor
use integration_path_part_line, only: &
  integration_path_part_line_obj, integration_path_part_line_constructor
use integration_path_part_custom_curve, only: &
  integration_path_part_custom_curve_obj, integration_path_part_custom_curve_constructor



use integration_element, only: integration_element_obj

use integration_element_gauss3, only: &
  integration_element_gauss3_obj, integration_element_gauss3_constructor
use integration_element_gauss4, only: &
  integration_element_gauss4_obj, integration_element_gauss4_constructor
use integration_element_gauss5, only: &
  integration_element_gauss5_obj, integration_element_gauss5_constructor
use integration_element_gauss6, only: &
  integration_element_gauss6_obj, integration_element_gauss6_constructor
use integration_element_gauss7, only: &
  integration_element_gauss7_obj, integration_element_gauss7_constructor
use integration_element_gauss8, only: &
  integration_element_gauss8_obj, integration_element_gauss8_constructor
implicit none (type, external)
private
  character(len = *), parameter :: module_name = "integral_generator___integration"

  public :: integrator_obj, integrator_builder_obj, &
    integrator_builder_constructor



  public :: integration_template_recalculation_constructor



  public :: integrated_function_type

  public :: integration_path_part_parallel_Im_constructor
  public :: integration_path_part_parallel_Re_constructor
  public :: integration_path_part_line_constructor
  public :: integration_path_part_custom_curve_constructor



  public :: integration_element_gauss3_constructor
  public :: integration_element_gauss4_constructor
  public :: integration_element_gauss5_constructor
  public :: integration_element_gauss6_constructor
  public :: integration_element_gauss7_constructor
  public :: integration_element_gauss8_constructor
end module integration
