#!/bin/bash

# readlink -f cannot work on mac
TOPDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

BUILD_SH=$TOPDIR/build.sh

CMAKE_COMMAND="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 --log-level=STATUS"

ALL_ARGS=("$@")
BUILD_ARGS=()
MAKE_ARGS=()
MAKE=make

echo "$0 ${ALL_ARGS[@]}"

function usage
{
  echo "Usage:"
  echo "./build.sh -h"
  echo "./build.sh init                      # Initialize and install dependencies"
  echo "./build.sh clean                     # Clean up build directories"
  echo "./build.sh style                     # Apply coding style to source files"
  echo "./build.sh test [test_case]          # Run tests, optionally specify a test case"
  echo "./build.sh [BuildType] [--make [MakeOptions]]"
  echo ""
  echo "OPTIONS:"
  echo "  -h                      Show this help message"
  echo "  init                    Initialize and install dependencies"
  echo "  clean                   Clean up all build directories"
  echo "  style                   Apply coding style to source files in ./src"
  echo "  test         [test_case] Run tests, optionally specify a test case to run"
  echo "  [BuildType]             Specify build type: debug (default), release, relwithdebinfo, minsizerel"
  echo "  --make       [MakeOptions]  Options to pass to the make command, default: -jN"

  echo ""
  echo "Examples:"
  echo "# Show help."
  echo "./build.sh -h"
  echo ""
  echo "# Initialize the project and install dependencies."
  echo "./build.sh init"
  echo ""
  echo "# Clean up all build directories."
  echo "./build.sh clean"
  echo ""
  echo "# Apply coding style to source files."
  echo "./build.sh style"
  echo ""
  echo "# Run all tests."
  echo "./build.sh test"
  echo ""
  echo "# Run a specific test case."
  echo "./build.sh test my_test_case"
  echo ""
  echo "# Build in debug mode (default) and make with -j24."
  echo "./build.sh debug --make -j24"
  echo ""
  echo "# Build in release mode."
  echo "./build.sh release"
}

function parse_args
{
  make_start=false
  for arg in "${ALL_ARGS[@]}"; do
    if [[ "$arg" == "--make" ]]
    then
      make_start=true
    elif [[ $make_start == false ]]
    then
      BUILD_ARGS+=("$arg")
    else
      MAKE_ARGS+=("$arg")
    fi
  done
}

# try call command make, if use give --make in command line.
function try_make
{
  if [[ $MAKE != false ]]
  then
    # use single thread `make` if concurrent building failed
    $MAKE "${MAKE_ARGS[@]}" || $MAKE
  fi
}

# create build directory and cd it.
function prepare_build_dir
{
  TYPE=$1
  mkdir -p $TOPDIR/build_$TYPE && cd $TOPDIR/build_$TYPE
}

function do_init
{
  git submodule update --init || return
  current_dir=$PWD

  MAKE_COMMAND="make --silent"

  # build googletest
  cd ${TOPDIR}/deps/googletest && \
    mkdir -p build && \
    cd build && \
    ${CMAKE_COMMAND} .. && \
    ${MAKE_COMMAND} -j4 && \
    ${MAKE_COMMAND} install

  # build fmt
  cd ${TOPDIR}/deps/fmt && \
    mkdir -p build && \
    cd build && \
    ${CMAKE_COMMAND} .. && \
    ${MAKE_COMMAND} -j4 && \
    ${MAKE_COMMAND} install

  cd $current_dir
}

function prepare_build_dir
{
  TYPE=$1
  mkdir -p ${TOPDIR}/build_${TYPE}
  rm -f build
  echo "create soft link for build_${TYPE}, linked by directory named build"
  ln -s build_${TYPE} build
  cd ${TOPDIR}/build_${TYPE}
}

function do_build
{
  TYPE=$1; shift
  prepare_build_dir $TYPE || return
  echo "${CMAKE_COMMAND} ${TOPDIR} $@"
  ${CMAKE_COMMAND} -S ${TOPDIR} $@
}

function do_clean
{
  echo "clean build_* dirs"
  find . -maxdepth 1 -type d -name 'build_*' | xargs rm -rf
}

function build
{
  set -- "${BUILD_ARGS[@]}"
  # 将传递的所有参数转换为小写
  BUILD_TYPE=$(echo "$1" | tr '[:upper:]' '[:lower:]')

  case "x$BUILD_TYPE" in
    xrelease)
      do_build "$@" -DCMAKE_BUILD_TYPE=Release
      ;;
    xrelwithdebinfo)
      do_build "$@" -DCMAKE_BUILD_TYPE=RelWithDebInfo
      ;;
    xdebug)
      do_build "$@" -DCMAKE_BUILD_TYPE=Debug
      ;;
    xminsizerel)
      do_build "$@" -DCMAKE_BUILD_TYPE=MinSizeRel
      ;;
    *)
      BUILD_ARGS=(debug "${BUILD_ARGS[@]}")
      build
      ;;
  esac
}

function style
{
  # Check if .clang-format file exists
  if [ ! -f .clang-format ]; then
    echo "Error: .clang-format file not found in the current directory."
    exit 1
  fi

  # 设置要格式化的文件扩展名
  EXTENSIONS=("c" "h" "cpp" "hpp")

  # 查找并格式化文件
  for ext in "${EXTENSIONS[@]}"; do
    find ./src -type f -name "*.$ext" -exec clang-format -i {} +
  done

  echo "Formatting complete!"
}

function run_tests {
  echo "Running test(s)..."
  echo "We may implement it in future!"
}

function main
{
  case "$1" in
    -h)
      usage
      ;;
    init)
      do_init
      ;;
    musl)
      do_musl_init
      ;;
    clean)
      do_clean
      ;;
    style)
      style
      ;;
    test)
      run_tests "$2"
      ;;
    *)
      parse_args
      build
      try_make
      ;;
  esac
}

main "$@"
