import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
 final String _apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> getMedicalSpecialty(String symptoms) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-4o-mini-search-preview-2025-03-11",
        "messages": [
          {
            "role": "system",
            "content": "Ești un asistent medical inteligent. Primești simptomele unui pacient și sugerezi cea mai potrivită specialitate medicală.Doar o specializare."
          },
          {
            "role": "user",
            "content": "Simptome: $symptoms. Răspunde doar cu numele specialității."
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      return content.trim();
    } else {
      throw Exception("Eroare OpenAI: ${response.body}");
    }
  }
}