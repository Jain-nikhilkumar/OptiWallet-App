import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  late String authToken;
  final String baseUrl = 'https://api.entity.hypersign.id';
  final String oauthEndpoint = '/api/v1/app/oauth';
  final String apiUrl = 'https://ent_7d1d2a9.api.entity.hypersign.id/';
  final String didCreateEndpoint = '/api/v1/did/create';
  final String didRegisterEndpoint = '/api/v1/did/register';
  final String presentationEndpoint = '/api/v1/presentation';
  final String verifyPresentationEndpoint = '/api/v1/presentation/verify';

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
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
      'X-Api-Secret-Key': '8e160eaf60f98031d2987b236a8e4.c1f5715c66c7effeab03c2074dc96c68522fa28af58b9607eeba37cf902d721817c3afe10485d6e375341a83c4ad1fe55',
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl$oauthEndpoint'),
        headers: headers,
        // body: '',
      );

      Map<String, dynamic> res = _handleResponse(response);
      authToken = "${res['tokenType'] as String} ${res['access_token'] as String}";

      // res['token'];

      // return _handleResponse(response);
    } catch (e) {
      print('Error during API call: $e');
      // return {'error': 'An error occurred during the API call.'};
    }
  }

  Future<Map<String, dynamic>> postCreateDid({String namespace = 'testnet'}) async {
    try {
      await postOAuthApi();

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': authToken
      };

      final Map<String, dynamic> requestBody = {'namespace': namespace};

      final response = await http.post(
        Uri.parse('$apiUrl$didCreateEndpoint'),
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
    try {
      await postOAuthApi();

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': authToken
      };

      final response = await http.post(
        Uri.parse('$apiUrl$didRegisterEndpoint'),
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
    try {
      await postOAuthApi();

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': authToken
      };

      Map<String,dynamic> presentation = {
        'credentialDocuments': [
          requestBody['credentialDocument']
        ],
        "holderDid": requestBody['credentialDocuments']['credentialSubject']['id'] as String,
        "challenge": "OptiSecure",
        "domain": "optisync.com"
      };

      final response = await http.post(
        Uri.parse('$apiUrl$presentationEndpoint'),
        headers: headers,
        body: jsonEncode(presentation),
      );

      return _handleResponse(response);
    } catch (e) {
      print('Error during API call: $e');
      return {'error': 'An error occurred during the API call.'};
    }
  }

  Future<Map<String, dynamic>> postVerifyPresentation(Map<String, dynamic> requestBody) async {
    try {
      await postOAuthApi();

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': authToken
      };

      final response = await http.post(
        Uri.parse('$apiUrl$verifyPresentationEndpoint'),
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
      'Authorization': authToken
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
