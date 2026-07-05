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
