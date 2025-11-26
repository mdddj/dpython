import 'dart:io';

class PyPath {
  final String home;
  final String libPath;
  final String sitePackages;

  PyPath(
      {required this.home, required this.libPath, required this.sitePackages});
}

class PythonPathHelper {
  static Future<PyPath> getPaths({String version = "3"}) async {
    final configCommand = 'python$version-config';
    try {
      final result = await Process.run(
        configCommand,
        ['--prefix'],
        runInShell: true,
      );
      if (result.exitCode != 0) {
        throw Exception("Failed to run $configCommand: ${result.stderr}");
      }
      final prefix = result.stdout.toString().trim();
      if (prefix.isEmpty) {
        throw Exception("Python prefix is empty");
      }
      final libDirName = 'python$version';
      final libPath = "$prefix/lib/$libDirName";
      final sitePackages = "$libPath/site-packages";

      return PyPath(home: prefix, libPath: libPath, sitePackages: sitePackages);
    } catch (e) {
      rethrow;
    }
  }
}
