
# =============================================================================
# 1. CORE DIRECTORY STRUCTURE
# =============================================================================
# Using $HOME makes this portable across users
export APPS_USER="${APPS_USER:-dc-apps}"
export BASE_HOME="$HOME"

# Centralized Installation & Cache Paths
export INSTALL_ROOT="${BASE_HOME}/INSTALL_DIR"
export PKG_ROOT="${INSTALL_ROOT}/pkg"
export SOURCE_DIR="${BASE_HOME}/SOURCE_DIR"
export CACHE_ROOT="${BASE_HOME}/CACHE_TEMP"

# Python/Pip Specific Caches (Speeds up re-installs)
export PIP_CACHE_DIR="${CACHE_ROOT}/pip_cache_dir"
export XDG_CACHE_HOME="${CACHE_ROOT}/xdg_cache_dir"
export NPM_CONFIG_CACHE="${CACHE_ROOT}/npm"


# ==============================================================================
# 2. CORE COMPILER
# =============================================================================

# sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 100 --slave /usr/bin/g++ g++ /usr/bin/g++-14
export GCC_HOST_COMPILER_PATH=$(which gcc)
# export CC=${GCC_HOST_COMPILER_PATH:-/usr/bin/gcc}
export CXX=$(which g++)
export CC_OPT_FLAGS="-march=native -Wno-sign-compare"
export PATH="${GCC_HOST_COMPILER_PATH}:${PATH}"

# sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-20 100 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-20
export CLANG_CUDA_COMPILER_PATH=$(which clang)

# Auto-create directories if they don't exist (Silence output)
mkdir -p "${PKG_ROOT}" "${CACHE_ROOT}" "${PIP_CACHE_DIR}" "${SOURCE_DIR}" > /dev/null 2>&1

# =============================================================================
# 3. PYTHON MANAGEMENT (PYENV & VENV)
# =============================================================================

# 1. Setup Pyenv paths (but don't let them override an active venv)
export PYENV_ROOT="${PKG_ROOT}/pyenv"

# If NO venv is active, put pyenv on PATH. 
# If a venv IS active, we purposefully DON'T prepend pyenv so the venv wins.
if [ -z "$VIRTUAL_ENV" ]; then
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init -)"
    fi
fi

# Standard Venv Paths
export APPS_VENV="${BASE_HOME}/APPS_VENV"
export PYTHON_VENV_ROOT="${APPS_VENV}/python_venv"

# 2. Smart Alias Logic
if [ -n "$VIRTUAL_ENV" ]; then
    # VIRTUAL ENV ACTIVE: Force 'python' to match the venv's python3
    alias python="$VIRTUAL_ENV/bin/python3"
    
    # Re-assert venv bin at the front of PATH just in case
    export PATH="$VIRTUAL_ENV/bin:$PATH"
else
    # NO VENV: Fallback to system/pyenv python3
    alias python="python3"
fi

export PYTHON_BIN_PATH=$(python -c "import sys; print(sys.executable)")
export PYTHON_LIB_PATH=$(python -c "import sys; print(sys.path[-1])")

# ============================================================================
# 4. NODE VERSION MANAGEMENT (NVM)
# ============================================================================
export NVM_DIR="${PKG_ROOT}/nvm"
export PATH="${NVM_DIR}:${PATH}"

# Initialize nvm if available
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
if command -v nvm >/dev/null 2>&1; then
	nvm use node
	nvm alias default node
fi



# ===========================================================================
# 5. DATASETS HOME PATH
# ===========================================================================

# datasets custom location via KERAS
export KERAS_HOME="/mnt/c/DEV/WSB/DATA_SETS_REPO/keras_repo"
#import os
# Set the custom directory
#os.environ['KERAS_HOME'] = '/path/to/your/custom/folder'
#import tensorflow as tf
# Now datasets will download to /path/to/your/custom/folder/datasets


# =========================================================================
# 6. MACHINE LEARNING FRAMEWORKS (RUNTIME CONFIGURATION)
# =========================================================================

# Enable XLA (Accelerated Linear Algebra) for performance
# export TF_XLA_FLAGS="--tf_xla_auto_jit=2 --tf_xla_cpu_global_jit"
export TF_XLA_FLAGS="--tf_xla_enable_xla_devices=false"

# Mixed Precision (Huge speedup on RTX 5080)
export TF_ENABLE_AUTO_MIXED_PRECISION=1
export NVIDIA_TF32_OVERRIDE=1

# LOGGER
export TF_CPP_MIN_LOG_LEVEL="2"
export TF_ENABLE_ONEDNN_OPTS="0"

# Threading (Optimized for single-user workstation)
export TF_GPU_THREAD_MODE="gpu_private"
export TF_GPU_THREAD_COUNT="4"

# --- PyTorch Runtime ---
# RTX 5080 / Blackwell Architecture Compute Capability
# Ensure PyTorch uses the correct CUDA architecture
export CUDA_COMPUTE_CAPABILITIES="12.0"
export TORCH_CUDA_ARCH_LIST="${CUDA_COMPUTE_CAPABILITIES}"
export TF_CUDA_COMPUTE_CAPABILITIES="12.0"

# =======================================================================
# 7. CUDA & GPU CONFIGURATION (RTX 5080 / Blackwell)
# =======================================================================

export CUDA_VERSION="13.1.1"
export CUDA_HOME="/usr/local/cuda-13.1"

# Standardize the path to the generic symlink
export LOCAL_CUDA_PATH="/usr/local/cuda"

# Help build tools find cuDNN
# If you installed cuDNN via 'apt install', keep it as /usr
# If you copied cuDNN into the CUDA folder manually, change this to $CUDA_HOME
export LOCAL_CUDNN_PATH="/usr"
export CUDA_TOOLKIT_PATH="${CUDA_HOME}"
export CUDNN_INSTALL_PATH="${CUDA_HOME}"
# Point to your found headers
export CUDNN_INSTALL_PATH="/usr"
export CUDNN_INCLUDE_PATH="/usr/include/x86_64-linux-gnu"
export CUDNN_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu"

# Also ensure the CUDA path is explicit
export CUDA_TOOLKIT_PATH="/usr/local/cuda"

#export IS_NIGHTLY="nightly"
# For TensorFlow Configure script specifically:
export TF_CUDA_PATHS="${LOCAL_CUDA_PATH},${LOCAL_CUDNN_PATH},${CUDA_HOME}"

# LIBRARY PATHS:
# Crucial for WSL2 to find both CUDA libs and WSL system libs
export LD_LIBRARY_PATH="${CUDA_HOME}/lib64:${CUDA_HOME}/extras/CUPTI/lib64:/usr/lib/wsl/lib:${LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CUDA_HOME}/include

# RTX 5080 / Blackwell Architecture Compute Capability
export CUDA_COMPUTE_CAPABILITIES="12.0" 

# Essential Paths for CUDA Compiler and Libraries
export PATH="${CUDA_HOME}/bin:${PATH}"
export CUDACXX="${CUDA_HOME}/bin/nvcc"


# =============================================================================
# 8. BUILD CONFIGURATION (ONLY FOR COMPILING FROM SOURCE)
# =============================================================================
# Only necessary if you are running 'bazel build' for TensorFlow
# -----------------------------------------------------------------------------
export TF_NEED_CUDA=1
export TF_NEED_TENSORRT=0   # Set to 1 if you strictly need TensorRT
export TF_CUDA_CLANG=0
export TF_NEED_ROCM=0
export TF_NEED_OPENCL_SYCL=0
export TF_NEED_MPI=0
export TF_SET_ANDROID_WORKSPACE=0
export TF_ENABLE_ONEDNN_OPTS=0

# Build version targeting
export TF_CUDA_VERSION="${CUDA_VERSION}"
export TF_CUDA_COMPUTE_CAPABILITIES="${CUDA_COMPUTE_CAPABILITIES}"
export HERMETIC_CUDA_VERSION="${CUDA_VERSION}"
export HERMETIC_CUDA_COMPUTE_CAPABILITIES="${CUDA_COMPUTE_CAPABILITIES}"
export HERMETIC_PYTHON_VERSION=$(python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
# export TF_CUDA_PATHS="${CUDA_HOME}"
