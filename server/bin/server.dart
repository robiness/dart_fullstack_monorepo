import 'dart:convert';
import 'dart:io';

import 'package:shared/shared_model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..post('/model', _modelHandler)
  ..get('/', _rootHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Future<Response> _modelHandler(Request req) async {
  final modelString = await req.readAsString();
  print('Received SharedModel with value: ${jsonDecode(modelString)}');
  final model = SharedModel.fromJson(jsonDecode(modelString));
  return Response.ok('Received SharedModel with value: ${model.value}\n');
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addMiddleware(corsMiddleware()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

// Middleware for handling CORS
Middleware corsMiddleware() {
  return createMiddleware(requestHandler: (Request request) {
    if (request.method == 'OPTIONS') {
      return Response.ok('', headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type',
      });
    }
    return null;
  }, responseHandler: (Response response) {
    return response.change(headers: {
      'Access-Control-Allow-Origin': '*', // Adjust as needed
      // Add other headers as needed
    });
  });
}
