import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

// Mock para http.Client
class MockHttpClient extends Mock implements http.Client {}

// Mock para http.Response
class MockHttpResponse extends Mock implements http.Response {}

// Fake para http.Response
class FakeHttpResponse extends Fake implements http.Response {
  @override
  final int statusCode;
  
  @override
  final String body;
  
  FakeHttpResponse({required this.statusCode, required this.body});
}

// Mock para http.StreamedResponse
class MockStreamedResponse extends Mock implements http.StreamedResponse {}
