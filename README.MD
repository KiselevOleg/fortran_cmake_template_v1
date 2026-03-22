# cmake test template

This project require and supports only gfortran.

## fast copy

clear and rebuild

```bash
# clear
clear
rm -fr ./build
# rebuild
cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build --target all
clear
cmake --build build --target lint
cmake --build build --target test_extended
cmake --build build --target project_docs
```

run

```bash
./build/main
```

creating dependency graph

```bash
cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Release --graphviz=./build/depends.dot
dot -Tpng -o build/depends.png build/depends.dot //install graphviz
```

## required

gfortran 15+

``` bash
# apt
sudo apt update
sudo apt install -y gcc
gfortran --version

# pacman
sudo pacman -S gcc
gfortran --version
```

cmake 3.24+

``` bash
# apt
sudo apt update
sudo apt install -y cmake
cmake --version

# pacman
sudo pacman -S cmake
cmake --version
```

ninja 1.13+

``` bash
# apt
sudo apt update
sudo apt install -y ninja-build
cmake --version

# pacman
sudo pacman -S extra/ninja
ninja --version
```

mpi 5+

``` bash
# apt
sudo apt update
sudo apt install -y \
  libopenmpi-dev \
  openmpi-bin
mpirun --version

# pacman
sudo pacman -S openmpi
mpirun --version
```

python 3.11+

```bash
# apt
sudo apt update
sudo apt install -y python
python3 --version

# pacman
sudo pacman -S python
python3 --version
```bash

```

graphviz

```bash
# apt
sudo apt install extra/graphviz

# pacman
sudo pacman -S extra/graphviz
```

## use

compilation

```bash
cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Release
```

list of all targets

```bash
cmake --build build --target help
```

install external_dependencies (requires internet connection)

must be done debore all other targets only once for a local repository
all data is stored at ./external-dependencies
if this command is already runed lately then this is not nesessary future even after clean_full

```bash
for f in ./cmake/add_dependencies_scripts/*.sh; do bash "$f"; done
```

or

```bash
cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Debug -DENABLE_TESTS=OFF
cmake --build build --target all_external_dependencies_install
```

compilation

```bash
cmake --build build --target all
```

run tests

```bash
cmake --build build --target test_extended
```

or

```bash
cd build
# ctest -V
ctest --rerun-failed --output-on-failure
cd ..
```

run lint

```bash
cmake --build build --target lint
```

generate code documentation at ./build/docs/index.html

```bash
cmake --build build --target project_docs
```

run a compilled program

```bash
./build/main
```

clean all

```bash
rm -fr ./build
```

create a dependency graph at ./build/depends.png

```bash
cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Release --graphviz=./build/depends.dot
dot -Tpng -o build/depends.png build/depends.dot //install graphviz
```

## debug (vs code)

```bash
sudo pacman -S extra/gdb
sudo apt-get install gdb
```

## dependencies

This project uses pFUnit from NASA Goddard Space Flight Center.
Source code is available at [pFUnit](https://github.com/Goddard-Fortran-Ecosystem/pFUnit.git).

This project uses Fortitude.
Source code is available at [Fortitude](https://github.com/PlasmaFAIR/fortitude.git).

This project uses Fortran linter.
Source code is available at [fortran-linter](https://github.com/cphyc/fortran-linter.git).

This project uses ford for automatic generating code documentation.
Source is available at [FORD](https://github.com/Fortran-FOSS-Programmers/ford.git)

This project uses json-fortran for creating and writing json files (recommended for input and out data that is used by fortran programs).
Source is available at [jsonfortran](https://github.com/jacobwilliams/json-fortran.git)
