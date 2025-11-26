import 'package:dpython/api/python.dart';
import 'package:dpython/frb_generated.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dpython/util/py_path_util.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

// A simple data model for our examples.
class PythonExample {
  final String title;
  final String code;
  final Future<String> Function() function;

  PythonExample({
    required this.title,
    required this.code,
    required this.function,
  });
}

late HighlighterTheme codeTheme;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Required initialization for the Rust-Dart bridge.
  await RustLib.init();
  final pyPath = await PythonPathHelper.getPaths();
  codeTheme = await HighlighterTheme.loadLightTheme();
  initPyEnv(
    pythonHome: pyPath.home,
    libPath: pyPath.libPath,
    sitePackages: pyPath.sitePackages,
  );
  await Highlighter.initialize(['dart']);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  late final List<PythonExample> _examples;

  @override
  void initState() {
    super.initState();
    _examples = _getExamples();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('dpython Flutter Examples')),
      body: WaterfallFlow.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          lastChildLayoutTypeBuilder: (index) => index == _examples.length
              ? LastChildLayoutType.foot
              : LastChildLayoutType.none,
        ),
        itemCount: _examples.length,
        itemBuilder: (context, index) {
          return ExampleCard(example: _examples[index]);
        },
      ),
    );
  }

  // Central place to define all examples.
  List<PythonExample> _getExamples() {
    return [
      PythonExample(
        title: "Get Python Version",
        code: """
final version = await PythonUtility.getModuleAttr(
  moduleName: "sys",
  attrName: "version",
);
return version;""",
        function: () async {
          final version = await PythonUtility.getModuleAttr(
            moduleName: "sys",
            attrName: "version",
          );
          return version;
        },
      ),
      PythonExample(
        title: "Call No-Args Function",
        code: """
var sysModule = PyModuleWrapper.importModule(moduleName: "sys");
var result = sysModule.callFunction(funcName: "getdefaultencoding");
return "Default Encoding: \$result";""",
        function: () async {
          var sysModule = PyModuleWrapper.importModule(moduleName: "sys");
          var result = sysModule.callFunction(funcName: "getdefaultencoding");
          return "Default Encoding: $result";
        },
      ),
      PythonExample(
        title: "Call With-Args Function",
        code: """
var math = PyModuleWrapper.importModule(moduleName: "math");
var result = math.callFunctionArgs(
  funcName: "pow",
  args: [
    PyArgument.float(2.0),
    PyArgument.float(8.0),
  ],
);
return "2.0 ^ 8.0 = \$result";""",
        function: () async {
          var mathModule = PyModuleWrapper.importModule(moduleName: "math");
          var result = mathModule.callFunctionArgs(
            funcName: "pow",
            args: [PyArgument.float(2.0), PyArgument.float(8.0)],
          );
          return "2.0 ^ 8.0 = $result";
        },
      ),
      PythonExample(
        title: "Eval Expression",
        code: """
var res = await PythonUtility.eval(
  code: "os.name",
  imports: ["os"],
);
return "os.name is '\$res'";""",
        function: () async {
          var res = await PythonUtility.eval(code: "os.name", imports: ["os"]);
          return "os.name is '$res'";
        },
      ),
      PythonExample(
        title: "Eval with Globals",
        code: """
var res = await PythonUtility.eval(
  code: "x * y + z",
  globals: [
    ("x", PyArgument.int(5)),
    ("y", PyArgument.int(10)),
    ("z", PyArgument.int(3)),
  ],
);
return "5 * 10 + 3 = \$res";""",
        function: () async {
          var res = await PythonUtility.eval(
            code: "x * y + z",
            globals: [
              ("x", PyArgument.int(5)),
              ("y", PyArgument.int(10)),
              ("z", PyArgument.int(3)),
            ],
            imports: [],
          );
          return "5 * 10 + 3 = $res";
        },
      ),
      PythonExample(
        title: "Advanced: Manipulate Objects",
        code: """
// 1. Create a Python list object
var pyList = await PythonUtility.evalAsObject(
  code: "[1, 'apple', 3]");

// 2. Append an item
await pyList.callMethod(
  methodName: "append", 
  args: [PyArgument.str("banana")]);

// 3. Get an item and convert it
var item = await pyList.getItem(key: PyArgument.int(1));
final itemStr = item.asStr();

// 4. Get new length
final len = pyList.len();

return "List length: \$len, Item[1]: \$itemStr";""",
        function: () async {
          var pyList = await PythonUtility.evalAsObject(
            code: "[1, 'apple', 3]",
          );
          await pyList.callMethod(
            methodName: "append",
            args: [PyArgument.str("banana")],
          );

          var item = pyList.getItem(key: PyArgument.int(1));
          final itemStr = item.asStr();

          final len = pyList.len();

          return "List length: $len, Item[1]: $itemStr";
        },
      ),
    ];
  }
}

// A reusable card widget to display a single Python example.
class ExampleCard extends StatefulWidget {
  final PythonExample example;

  const ExampleCard({super.key, required this.example});

  @override
  State<ExampleCard> createState() => _ExampleCardState();
}

class _ExampleCardState extends State<ExampleCard> {
  String? _result;
  bool _isLoading = false;

  Future<void> _runExample() async {
    setState(() {
      _isLoading = true;
      _result = null;
    });
    try {
      final result = await widget.example.function();
      setState(() {
        _result = result;
      });
    } catch (e) {
      setState(() {
        _result = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resultStyle = theme.textTheme.bodyMedium!.copyWith(
      fontFamily: 'monospace',
      color: _result?.startsWith("Error:") ?? false
          ? Colors.redAccent
          : Colors.green,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: double.infinity),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.example.title, style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                // Code Block
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text.rich(
                    Highlighter(
                      language: 'dart',
                      theme: codeTheme,
                    ).highlight(widget.example.code.trim()),
                  ),
                  // child: SelectableText(
                  //   widget.example.code.trim(),
                  //   style: codeStyle,
                  // ),
                ),
                // Result Section
                Row(
                  children: [
                    const Text(
                      "Result:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : SelectableText(
                              _result ?? 'Press "Run" to execute.',
                              style: resultStyle,
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _runExample,
                    child: const Text('Run'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
