set -e

mkdir -p external_dependencies
cd external_dependencies
if [ -d "hdf5" ]; then
    echo "hdf5 folder exists"
    cd ..
    exit 0
fi
if [ -d "h5fortran" ]; then
    echo "hdf5 folder exists"
    cd ..
    exit 0
fi

git clone https://github.com/HDFGroup/hdf5.git
cd hdf5
git checkout hdf5-1.14.6
mkdir build
cd build
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=OFF \
  -DHDF5_BUILD_FORTRAN=ON \
  -DHDF5_BUILD_CPP_LIB=OFF \
  -DHDF5_BUILD_TOOLS=OFF \
  -DHDF5_BUILD_EXAMPLES=OFF \
  -DHDF5_ENABLE_SZIP_SUPPORT=OFF \
  -DCMAKE_INSTALL_PREFIX=./install
cmake --build . -j
cmake --install .
cd ../..


git clone https://github.com/geospace-code/h5fortran.git
cd h5fortran
mkdir build
cd build
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=./../../hdf5/build/install \
    -DHDF5_ROOT=./../../hdf5/build/install \
    -DCMAKE_INSTALL_PREFIX=./install
cmake --build . -j
cmake --install .
#cmake --workflow build

cd ../../..
