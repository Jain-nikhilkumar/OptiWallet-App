import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  late String authToken;
  final String baseUrl = 'https://api.entity.hypersign.id';
  final String oauthEndpoint = '/api/v1/app/oauth';
  final String didCreateEndpoint = '/api/v1/did/create';
  final String didRegisterEndpoint = '/api/v1/did/register';
  final String presentationEndpoint = '/api/v1/presentation';
  final String verifyPresentationEndpoint = '/api/v1/presentation/verify';

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      // Successful response, parse and return the data
      return jsonDecode(response.body);
    } else {
      // Error response, return an error map
      print('API Error: ${response.statusCode} - ${response.reasonPhrase}');
      return {'error': 'API request failed with status code ${response.statusCode}'};
    }
  }

  Future<void> postOAuthApi() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Api-Secret-Key': '1fc7504b27223b6b0b350c346d91a.437595754a8f3adf8cb85ae7dcbd34d89735fdc5eaf8547148c4e5512549dfdca443e46aee506def00f1565eeef7a7d23',
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$oauthEndpoint'),
        headers: headers,
        // body: '',
      );

      Map<String, dynamic> res = _handleResponse(response);
      authToken = res['token'];

      // return _handleResponse(response);
    } catch (e) {
      print('Error during API call: $e');
      // return {'error': 'An error occurred during the API call.'};
    }
  }

  Future<Map<String, dynamic>> postCreateDid(String namespace) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {'namespace': namespace};

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$didCreateEndpoint'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      return _handleResponse(response);
    } catch (e) {
      print('Error during API call: $e');
      return {'error': 'An error occurred during the API call.'};
    }
  }

  Future<Map<String, dynamic>> postRegisterDid(Map<String, dynamic> requestBody) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$didRegisterEndpoint'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      return _handleResponse(response);
    } catch (e) {
      print('Error during API call: $e');
      return {'error': 'An error occurred during the API call.'};
    }
  }

  Future<Map<String, dynamic>> postSubmitPresentation(Map<String, dynamic> requestBody) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$presentationEndpoint'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      return _handleResponse(response);
    } catch (e) {
      print('Error during API call: $e');
      return {'error': 'An error occurred during the API call.'};
    }
  }

  Future<Map<String, dynamic>> postVerifyPresentation(Map<String, dynamic> requestBody) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$verifyPresentationEndpoint'),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      return _handleResponse(response);
    } catch (e) {
      print('Error during API call: $e');
      return {'error': 'An error occurred during the API call.'};
    }
  }

  Future<Map<String, dynamic>> postRequest(String endPoint, Map<String, dynamic> requestBody) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      // Call postOAuthApi() to get the necessary authentication
      // Map<String, dynamic> authResponse = await postOAuthApi();
      await postOAuthApi();

      // Check if authentication was successful
      if (authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';

        // Now, proceed with the main request
        final response = await http.post(
          Uri.parse('$baseUrl$endPoint'),
          headers: headers,
          body: jsonEncode(requestBody),
        );

        return _handleResponse(response);
      } else {
        // Handle authentication failure
        return {'error': 'Authentication failed.'};
      }
    } catch (e) {
      print('Error during API call: $e');
      return {'error': 'An error occurred during the API call.'};
    }
  }

}
