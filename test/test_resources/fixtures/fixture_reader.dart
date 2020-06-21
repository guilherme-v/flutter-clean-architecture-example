import 'dart:io';

String fixture(String name) {
  String json;
  try {
    // Runs correctly on C.I/IDE (non relative path)
    json = File('test/test_resources/fixtures/$name').readAsStringSync();
  } catch (e) {
    // Flutter 'test' tool for some reason wants a relative path
    json = File('../test/test_resources/fixtures/$name').readAsStringSync();
  }

  return json;
}
