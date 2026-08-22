set -e

mkdir -p external_dependencies
cd external_dependencies
if [ -d "fortran-regex" ]; then
    echo "fortran-regex folder exists"
    cd ..
    exit 0
fi

git clone https://github.com/perazz/fortran-regex.git
cd fortran-regex
#../../.venv/bin/fpm build
#../../.venv/bin/fpm install --prefix ./build/release

python -m venv .venv
source ./.venv/bin/activate
pip install fpm
deactivate
./.venv/bin/fpm build
./.venv/bin/fpm install --prefix ./build/release

cd ../..
