# cmake test template

A template project for modern Fortran using CMake,
pFUnit, FORD documentation, dependency management.
It is intended as a starting point for modern Fortran projects.

Features:

- unit testing with pFUnit
- linting
- automatic documentation (FORD)
- dependency management
- MPI support

This project requires and supports only gfortran.

This template assumes you are familiar with:

- Git
- CMake
- unit testing
- lint
- basic Linux terminal commands
- fortran 2018+

And tools:

- Ninja compiles the project.
- pFUnit runs unit tests.
- FORD generates documentation.
- Graphviz visualizes project dependencies.
- JSON files for storing data.
- HDF5 files for storing data.

## Structure

``` text
.
├── .github/                      # GitHub Actions / CI
├── .git/                         # Git metadata
├── .vscode/                      # VS Code configuration
│
├── cmake/                        # CMake modules and scripts
├── external_dependencies/        # Downloaded external dependencies
│
├── src/                          # Project source code
│   ├── app/                      # Executable application
│   └── libs/                     # Reusable library components
│       └── <project_component>/
│           ├── CMakeLists.txt
│           ├── include/          # for C interface or facades for large API (not obligatory)
│           ├── src/
│           ├── tests/
│           └── example/          # (not obligatory)
│
├── build/                        # Build output (generated)
│   ├── main                      # Executable
│   ├── docs/                     # FORD documentation
│   ├── depends.dot               # Graphviz source
│   ├── depends.png               # Dependency graph
│   ├── include_list_all          # Include files from all project components
│   ├── include_external_list_all # Include files from all external dependencies
│   ├── Testing
│   │   └── Temporary
│   │       └── LastTest.log      # test log (with all print)
│   └── src/
│       └── libs/
│           └── <project_component>/
│               ├── <project_component>.a
│               ├── include/
│               └── tests/
│                   └── <test_executable>
│
├── CMakeLists.txt                # Top-level build configuration (connects all project components)
├── ford.md                       # FORD configuration
├── install_external_dependencies_manually.md
├── README.md                     # Project documentation
├── .gitignore
├── .gitattributes
└── .editorconfig
```

## Quick start (fast copy)

Clean and rebuild

```bash
# Clean
clear
rm -fr ./build
# Rebuild
cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Debug --graphviz=./build/depends.dot
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

Generate dependency graph

```bash
# requires to add --graphviz=./build/depends.dot
# cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Release --graphviz=./build/depends.dot
dot -Tpng -o build/depends.png build/depends.dot
```

To add new code to the libs directory it is recommended to use pre-prepared code as an example.

## Requirements

![Fortran](https://img.shields.io/badge/Fortran-2018-blue)
![gfortran](https://img.shields.io/badge/gfortran-15+-orange)
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

![CMake](https://img.shields.io/badge/CMake-3.24+-green)
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

![Ninja](https://img.shields.io/badge/Ninja-1.13+-brightgreen?logo=ninja&logoColor=white)
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

![MPI](https://img.shields.io/badge/MPI-5+-blue)
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

![Python](https://img.shields.io/badge/Python-3.11+-3776AB?logo=python&logoColor=white)
python 3.11+

```bash
# apt
sudo apt update
sudo apt install -y python
python3 --version

# pacman
sudo pacman -S python
python3 --version
```

![Graphviz](https://img.shields.io/badge/Graphviz-required-9900CC)
graphviz

```bash
# apt
sudo apt install graphviz

# pacman
sudo pacman -S extra/graphviz
```

## Usage

### Installation

```bash
git clone https://github.com/KiselevOleg/fortran_cmake_template_v1.git
```

### Build

```bash
cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Debug
# or
cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Release
```

list of all targets

```bash
cmake --build build --target help
```

Install external dependencies (requires an internet connection)

This must be done once before running other targets in a local repository
All data is stored at ./external-dependencies
If this command has already been run recently,
it is not necessary to repeat it, even after a full clean.

```bash
for f in ./cmake/add_dependencies_scripts/*.sh; do bash "$f"; done
```

(parallel version)

```bash
for f in ./cmake/add_dependencies_scripts/*.sh; do bash "$f" & done; wait
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

### Tests

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

### Lint

```bash
cmake --build build --target lint
```

### Documentation

generate code documentation at ./build/docs/index.html

```bash
cmake --build build --target project_docs
```

Generate dependency graph

```bash
# requires to add --graphviz=./build/depends.dot
# cmake -G Ninja -S . -B build -DCMAKE_BUILD_TYPE=Release --graphviz=./build/depends.dot
dot -Tpng -o build/depends.png build/depends.dot
```

### Run

```bash
./build/main
```

### Clean all

```bash
rm -fr ./build
```

### Debug (vs code)

```bash
sudo pacman -S extra/gdb
sudo apt-get install gdb
```

### for vscode

```bash
python -m venv .venv
source ./.venv/bin/activate
pip install fortls
fortls --version
which fortls
```

## Dependencies

This project uses

- pFUnit from NASA Goddard Space Flight Center.
[pFUnit](https://github.com/Goddard-Fortran-Ecosystem/pFUnit.git).

- Fortitude.
[Fortitude](https://github.com/PlasmaFAIR/fortitude.git).

- Fortran linter.
[fortran-linter](https://github.com/cphyc/fortran-linter.git).

- ford for automatic generation code documentation.
[FORD](https://github.com/Fortran-FOSS-Programmers/ford.git)

- json-fortran for creating and writing json files
(recommended for input and out config data that is used by fortran programs).
[jsonfortran](https://github.com/jacobwilliams/json-fortran.git)

- h5fortran for creating and writing hdf5 files
(recommended for input and out large data that is used by fortran programs).
[h5fortran](https://github.com/geospace-code/h5fortran.git)
and hdf5 that is its dependency [hdf5](https://github.com/HDFGroup/hdf5.git)
