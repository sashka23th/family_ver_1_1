import 'dart:convert';

import 'package:family_cash/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

const String baseUrl = "https://family.heshbonai.com/api";

class RemoteRequest {
  final String token;

  RemoteRequest({required this.token});
  final startTime = DateTime.now();
  // Приватный метод для отправки HTTP запросов
  Future<http.Response> call(String url, String method,
      {Map<String, String>? headers, dynamic body}) async {
    final fullUrl = Uri.parse('$baseUrl/$url');

    // Общие заголовки
    final requestHeaders = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      ...?headers, // если дополнительные заголовки переданы, они будут добавлены
    };

    // Выбор метода запроса
    http.Response response;
    switch (method) {
      case 'GET':
        response = await http.get(fullUrl, headers: requestHeaders);
        break;
      case 'POST':
        response = await http.post(
          fullUrl,
          headers: requestHeaders,
          body: json.encode(body), // сериализация тела запроса
        );
        break;
      case 'DELETE':
        response = await http.delete(fullUrl, headers: requestHeaders);
        break;
      default:
        throw Exception('Unsupported HTTP method: $method');
    }

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime).inMilliseconds;
    print('Response time: ${duration} ms');

    if (response.statusCode >= 200 && response.statusCode < 300 ||
        response.statusCode == 404) {
      return response;
    } else {
      throw ServerException(message: 'Failed request: ${response.statusCode}');
    }
  }
}
