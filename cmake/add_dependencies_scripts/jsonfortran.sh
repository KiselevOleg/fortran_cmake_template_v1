set -e

mkdir -p external_dependencies
cd external_dependencies
if [ -d "json-fortran" ]; then
    echo "json-fortran folder exists"
    cd ..
    exit 0
fi

git clone https://github.com/jacobwilliams/json-fortran.git
cd json-fortran

mkdir build
cd build
cmake ..
make
make check

cd ../../..
