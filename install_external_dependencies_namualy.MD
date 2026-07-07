# install dependencies

## install pFUnit (tests)

```bash
mkdir -p external_dependencies
cd external_dependencies
git clone --recursive https://github.com/Goddard-Fortran-Ecosystem/pFUnit.git
cd pFUnit

mkdir build
cd build
cmake ..
make tests
make install

cd ../../..
```

## install Fortran linter (lint)

```bash
mkdir -p external_dependencies
cd external_dependencies
git clone https://github.com/cphyc/fortran-syntax.git
cd fortran-syntax
python -m venv Fortran_linter_environment
source Fortran_linter_environment/bin/activate
pip install . # Please note that depending on your installation, you may have to add sudo

cat > "check.py" << EOL
import os
import subprocess
import glob

def delete_incorrect_warning(text: str) -> str:
  lines = text.splitlines()

  to_remove = []

  for i, line in enumerate(lines):
    if "Warning: Single space after 'print*,' at (1)." in line:
      to_remove.append(i)
    if "Warning: Exactly one space after comment at (1)." in line:
      to_remove.append(i)

  for index in reversed(to_remove):
    if index >= 5:
      lines = lines[:index-5] + lines[index+1:]
    else:
      lines = lines[index+1:]

  return '\n'.join(lines)



files = glob.glob('src/**/*.f90', recursive=True)
files += glob.glob('src/**/*.pf', recursive=True)

if files:
  venv_dir = "./external_dependencies/fortran-syntax/Fortran_linter_environment"
  env = os.environ.copy()
  env["PATH"] = os.path.join(venv_dir, "bin") + os.pathsep + env.get("PATH", "")
  result = subprocess.run(['fortran-linter', '--syntax-only'] + files,
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    env=env
    )
  res = result.stdout.decode('utf-8')
  res += result.stderr.decode('utf-8')
  # res = res.replace("Warning: Single space after 'print*,' at (1).", "Info: Single space after 'print*,' at (1).")
  # print(res)
  res = delete_incorrect_warning(res)

  print(res)

  if "Warning" in res:
    raise RuntimeError("Warning Fortran linter: found")
  else:
    print("lint has finished")
else:
  raise FileNotFoundError("error Fortran linter: no files have found")

EOL

deactivate

cd ../..
```

## install Fortitude (lint)

```bash
mkdir -p external_dependencies
cd external_dependencies
mkdir -p Fortitude
cd Fortitude

python -m venv Fortitude_environment
source Fortitude_environment/bin/activate
pip install fortitude-lint
deactivate

cd ../..
```

## install graphviz (component generation)

install graphviz

```bash
sudo pacman -S extra/graphviz
sudo apt install extra/graphviz
brew install graphviz
```

use graphviz

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release --graphviz=./build/depends.dot
dot -Tpng -o build/depends.png build/depends.dot //install graphviz
```

## install ford (documentation generation)

```bash
mkdir -p external_dependencies
cd external_dependencies
mkdir -p Ford
cd Ford

python -m venv Ford_environment
source Ford_environment/bin/activate
pip install ford
deactivate

cd ../..
```

## install json-fortran (interaction with json files)

```bash
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
```

## install h5fortran (interaction with hdf5 files)

```bash
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
```
