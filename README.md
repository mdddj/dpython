# dpython


# dpython Usage Guide

This guide explains how to use the `dpython` plugin to execute Python code within your Flutter application. The API is designed to be flexible, offering both simple top-level functions for quick execution and a more advanced object-oriented approach for fine-grained control.

## 1. Setup: Initializing the Python Environment

Before calling any Python code, you must initialize the Python environment. This is a critical step that tells the plugin where to find the Python standard library and other packages.

You should call `initPyEnv` once at the start of your application. The `PythonPathHelper` utility can help you determine the correct paths for your embedded Python distribution.

```dart
import 'package:dpython/dpython.dart';
import 'package:dpython/util/py_path_util.dart';

Future<void> main() async {
  // Must be called before any other dpython function
  await RustLib.init(); 

  // Get paths for the embedded Python environment
  final pyPath = await PythonPathHelper.getPaths();
  
  // Initialize the environment
  initPyEnv(
    pythonHome: pyPath.home,
    libPath: pyPath.libPath,
    sitePackages: pyPath.sitePackages,
  );
  
  runApp(const MyApp());
}
```

## 2. Core Concepts: Passing Data with `PyArgument`

When you need to pass data from Dart to Python (e.g., as function arguments or variables in a context), you use the `PyArgument` enum. It wraps standard Dart types into a format that the Rust backend can convert into Python objects.

Supported types include:
- `PyArgument.str(String)`
- `PyArgument.int(int)`
- `PyArgument.float(double)`
- `PyArgument.bool(bool)`
- `PyArgument.listStr(List<String>)`
- `PyArgument.listInt(List<int>)`

## 3. The APIs: Three Ways to Interact with Python

`dpython` offers three main entry points for Python interaction, from simplest to most powerful.

### Level 1: `PythonUtility` - The Quick & Easy API

This class provides static methods for common tasks, like evaluating a simple expression or executing a script. Results are typically returned as strings.

#### Evaluating an expression with `eval`

Use `eval` to execute a single Python expression and get the result as a string.

```dart
// Simple evaluation
String osName = await PythonUtility.eval(
  code: "os.name",
  imports: ["os"], // Automatically imports 'os' module
);
debugPrint("OS Name: $osName"); // Prints: "posix" or "nt"

// Evaluation with a custom context (globals)
String result = await PythonUtility.eval(
  code: "x + y",
  globals: [
    ("x", PyArgument.int(10)),
    ("y", PyArgument.int(20)),
  ],
);
debugPrint("Result: $result"); // Prints: "30"
```

#### Executing statements with `execute`

Use `execute` when you need to run Python statements that don't return a value, such as defining a class or a function.

```dart
await PythonUtility.execute(
  code: """
class Greeter:
    def __init__(self, name):
        self.name = name
    def say_hello(self):
        return f"Hello, {self.name}"
""",
);

// You can now use the 'Greeter' class in subsequent calls
```

### Level 2: `PyModuleWrapper` - Interacting with Modules

If you need to work with a specific Python module repeatedly, you can import it once and then call its functions. This is more efficient than using `eval` for every call.

```dart
// 1. Import the 'math' module
var mathModule = PyModuleWrapper.importModule(moduleName: "math");

// 2. Call a function without arguments
// Example with 'sys' module
var sysModule = PyModuleWrapper.importModule(moduleName: "sys");
var encoding = sysModule.callFunction(funcName: "getdefaultencoding");

// 3. Call a function with arguments
var result = mathModule.callFunctionArgs(
  funcName: "pow",
  args: [
    PyArgument.float(2.0), // base
    PyArgument.float(3.0), // exponent
  ],
);
debugPrint("2^3 is: $result"); // Prints: "8.0"
```

### Level 3: `PyObjectWrapper` - The Advanced API for Full Control

For maximum flexibility, `dpython` allows you to get a handle to *any* Python object and interact with it directly from Dart. This handle is an opaque object of type `PyObjectWrapper`.

You can get a `PyObjectWrapper` by using `PythonUtility.evalAsObject`.

#### Getting an object and converting its type

```dart
// Get a Python list as an object handle
var pyList = await PythonUtility.evalAsObject(code: "[10, 20, 30]");

// Get the length of the list
int length = await pyList.len(); // 3

// Get an item from the list (which is another PyObjectWrapper)
var item = await pyList.getItem(key: PyArgument.int(0));

// Convert the item to a Dart type
int value = await item.asInt();
debugPrint("First item is: $value"); // Prints: 10
```

#### Calling methods and accessing attributes

You can use the object handle to call methods and access attributes on the underlying Python object.

```dart
// Continuing from the 'Greeter' class defined earlier...

// 1. Create an instance of the Greeter class
var person = await PythonUtility.evalAsObject(
  code: "Greeter('World')",
);

// 2. Call a method on the instance
var greeting = await person.callMethod(methodName: "say_hello", args: []);
debugPrint(await greeting.asStr()); // Prints: "Hello, World"

// 3. Get an attribute
var name = await person.getattr(attrName: "name");
debugPrint(await name.asStr()); // Prints: "World"
```