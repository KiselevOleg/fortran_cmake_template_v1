set -e

cd ../../../external_dependencies/

if [ -d "Error_Fns_Dawson_Intgrl_Cmplx" ]; then
    echo "Error_Fns_Dawson_Intgrl_Cmplx folder exists"
    cd ../src/libs/oscillation_integrating
    exit 0
fi

git clone https://github.com/mofrehzaghloul/Error_Fns_Dawson_Intgrl_Cmplx.git
cd Error_Fns_Dawson_Intgrl_Cmplx

mkdir build
cd build

gfortran -O3 -fPIC -I. -J. -c ../src/set_rk.f90
gfortran -O3 -fPIC -I. -J. -c ../src/Faddeyeva_v3_mod_rk.f90

ar rcs libfaddeyeva.a *.o
gfortran -shared -o libfaddeyeva.so *.o

mkdir include
cp *.mod include/

cd ..

cd ../src/libs/oscillation_integrating
