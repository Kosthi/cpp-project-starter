# C++ Project Starter Kit 🚀

A fast and efficient C++ project starter pack, pre-configured with **GoogleTest**, **fmt**, and other popular C++ libraries to kickstart your development journey.

## **Features**
- **GoogleTest**: Integrated for seamless unit testing.
- **fmt**: Modern formatting library for clean and efficient string formatting.
- **Pre-configured Build System**: Easy-to-use CMake setup for quick project initialization.
- **Cross-Platform**: Works on Linux, macOS, and Windows (with WSL or MinGW).
- **Dependency Management**: Automatically installs required libraries.

## **Quick Start**

### **1. Install Dependencies**
Run the following command to install all required dependencies:
```bash
sudo bash build.sh init
```

### **2. Start Developing**
Once the dependencies are installed, you're all set! Start coding in the `src` directory and write tests in the `tests` directory.

### **3. Build and Run**
Use the provided CMake configuration to build and run your project:
```bash
mkdir build && cd build
cmake ..
make
```

### **4. Run Tests**
Execute your unit tests with:
```bash
./tests/run_tests
```

## **Project Structure**
```
cpp-project-starter/
├── CMakeLists.txt          # Main CMake configuration
├── build.sh                # Setup and build script
├── src/                    # Your source code goes here
├── test/                   # Unit tests using GoogleTest
├── deps/                   # Third-party libraries
└── README.md               # Project documentation
```

## **Included Libraries**
- **GoogleTest**: For unit testing.
- **fmt**: For modern string formatting.
- **CMake**: For build automation.
- **Additional Libraries**: Easily extendable to include more libraries like Boost, spdlog, etc.

## **Why Use This Starter Kit?**
- **Save Time**: No need to spend hours setting up a C++ project from scratch.
- **Best Practices**: Pre-configured with modern C++ development practices.
- **Extensible**: Easily add more libraries or tools as your project grows.

## **Contributing**
Feel free to contribute to this project! Open an issue or submit a pull request to suggest improvements or add new features.

## **License**
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

Enjoy your development! 🎉
