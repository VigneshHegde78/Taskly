import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class ApiService {
  Future<QuoteModel?> getRandomQuote() async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/quotes/random'));
      if (response.statusCode == 200) {
        return QuoteModel.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
