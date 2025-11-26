import 'package:dpython/api/python.dart';
import 'package:dpython/frb_generated.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dpython/util/py_path_util.dart';

//
Future<void> main() async {
  await RustLib.init();
  final pyPath = await PythonPathHelper.getPaths();
  initPyEnv(
    pythonHome: pyPath.home,
    libPath: pyPath.libPath,
    sitePackages: pyPath.sitePackages,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  void testImportModule() async {
    try {
      // 1. Call Rust's import to get a Rust object handle.
      // This wrapper internally holds the Python sys module.
      var sysModule = PyModuleWrapper.importModule(moduleName: "sys");

      // 2. Call methods of the module (forwarded through Rust).
      // For example, if we implemented a method in Rust to get the platform.
      // Or just print the module info.
      debugPrint("Imported module: ${sysModule.asStr()}");

      // If you have encapsulated specific business logic, e.g., run_algo
      // await sysModule.runAlgo();
    } catch (e) {
      debugPrint("Error importing python module: $e");
    }
  }

  // Test function 1: Call with no arguments
  // Target Python code: sys.getdefaultencoding() -> returns 'utf-8'
  void testCallFunctionNoArgs() async {
    debugPrint("Testing function call with no arguments...");
    try {
      // 1. Import the sys module
      var sysModule = PyModuleWrapper.importModule(moduleName: "sys");

      // 2. Call the getdefaultencoding function
      // This function takes no arguments and returns the default encoding of the current Python environment
      var result = sysModule.callFunction(funcName: "getdefaultencoding");

      debugPrint("✅ Call successful! Python default encoding: $result");
    } catch (e) {
      debugPrint("❌ Call failed: $e");
    }
  }

  // Test function 2: Call with arguments
  // Target Python code: math.pow(2.0, 3.0) -> returns '8.0'
  void testCallFunctionWithArgs() async {
    debugPrint("Testing function call with arguments...");
    try {
      // 1. Import the math module
      var mathModule = PyModuleWrapper.importModule(moduleName: "math");

      // 2. Call the pow function (calculates power, i.e., 2 to the power of 3)
      var result = mathModule.callFunctionArgs(
        funcName: "pow",
        args: [
          // Note: This corresponds to the PyArgument enum defined in Rust
          PyArgument.float(2.0), // First argument: base
          PyArgument.float(3.0), // Second argument: exponent
        ],
      );

      debugPrint("✅ Call successful! 2.0 to the power of 3.0 is: $result");
    } catch (e) {
      debugPrint("❌ Call failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Python Code Runner')),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: testImportModule,
                  child: const Text("Test Importing Module"),
                ),
                OutlinedButton(
                  onPressed: testCallFunctionNoArgs,
                  child: const Text("Test No-Args Call"),
                ),
                OutlinedButton(
                  onPressed: testCallFunctionWithArgs,
                  child: const Text("Test With-Args Call"),
                ),
                OutlinedButton(
                  onPressed: () async {
                    var res = await PythonUtility.eval(
                      code: "os.name",
                      imports: ["os"],
                      globals: null, // Use default environment
                      locals: null,
                    );
                    debugPrint("os.name result: $res"); // Output: posix or nt
                  },
                  child: const Text("Test Eval 'os.name'"),
                ),
                OutlinedButton(
                  onPressed: () async {
                    // Python: x + y (but executed in a sandbox)
                    var res = await PythonUtility.eval(
                      code: "x + y",
                      imports: [],
                      globals: [
                        ("x", PyArgument.int(10)),
                        ("y", PyArgument.int(20)),
                      ],
                      locals: null, // By default, locals = globals
                    );
                    debugPrint("Eval 'x + y' result: $res"); // Output: 30
                  },
                  child: const Text("Test Eval with Globals"),
                ),
                OutlinedButton(
                  onPressed: () {
                    void debugPythonPath() async {
                      try {
                        debugPrint("--- Debugging Python Path ---");

                        // 1. Print sys.path
                        // Note: the imports parameter automatically injects sys into the context, so you can use it directly in the code.
                        var sysPath = await PythonUtility.eval(
                          code: "str(sys.path)",
                          imports: ["sys"],
                          globals: [],
                          locals: null,
                        );
                        debugPrint("Python Path: $sysPath");

                        // 2. Print sys.executable
                        var sysExe = await PythonUtility.eval(
                          code: "sys.executable",
                          imports: ["sys"],
                          globals: [],
                          locals: null,
                        );
                        debugPrint("Executable: $sysExe");

                        // 3. Try os.name again, this time ensuring the environment
                        var osName = await PythonUtility.eval(
                          code: "os.name",
                          imports: ["os"],
                          globals: [],
                          locals: null,
                        );
                        debugPrint("OS Name: $osName");
                      } catch (e) {
                        debugPrint("Debug Error: $e");
                      }
                    }

                    debugPythonPath();
                  },

                  child: const Text("Debug Python Environment"),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final version = await PythonUtility.getModuleAttr(
                      moduleName: "sys",
                      attrName: "version",
                    );
                    debugPrint("Python version: $version");
                  },
                  child: const Text("Get Python Version"),
                ),
                OutlinedButton(
                    onPressed: testAdvancedObjectManipulation,
                    child: const Text("Advanced Object Tests")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void testAdvancedObjectManipulation() async {
    // 1. Create a Python list
    var pyList = await PythonUtility.evalAsObject(
      code: "[1, 2, 3]",
      globals: null,
      locals: null,
    );

    // 2. Call the append method
    await pyList.callMethod(methodName: "append", args: [PyArgument.int(4)]);

    // 3. Get the length -> 4
    debugPrint("List length: ${pyList.len()}");

    // 4. Get the 0th element -> 1
    var item0 = pyList.getItem(key: PyArgument.int(0));
    debugPrint('List item[0]: ${item0.asInt()}');

    // 5. Use execute to define a class
    await PythonUtility.execute(
      code: """
class Person:
    def __init__(self, name):
        self.name = name
    def greet(self):
        return f"Hello, {self.name}"
""",
      globals: null,
      locals: null,
    );

    // 6. Instantiate this class
    // Assuming it's stored in globals, or we could use evalAsObject("Person('Alice')")
    var person = await PythonUtility.evalAsObject(
      code: "Person('Alice')",
      globals: null,
      locals: null,
    );

    // 7. Access an attribute
    var name = person.getattr(attrName: "name");
    debugPrint("Person.name: ${name.asStr()}"); // "Alice"

    // 8. Call a method
    var greeting = await person.callMethod(methodName: "greet", args: []);
    debugPrint("Person.greet(): ${greeting.asStr()}"); // "Hello, Alice"
  }
}
