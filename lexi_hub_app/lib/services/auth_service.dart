
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'http://10.0.2.2:3000'; // Your backend URL

  Future<String> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'id': email, // Backend expects 'id' for the email field
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['accessToken'] != null) {
          return data['accessToken'];
        }
        throw Exception('Access token not found in response.');
      } else {
        // Handle non-200 responses
        throw Exception('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions like network errors
      throw Exception('An error occurred: $e');
    }
  }
}
