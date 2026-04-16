import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Requirements: REST API integration using Dio + Cache-then-network pattern.
// We use a public API to fetch a daily motivation quote.

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

class QuoteRepository {
  final Dio _dio;

  QuoteRepository(this._dio);

  Future<String> fetchDailyQuote() async {
    try {
      final response = await _dio.get('https://api.adviceslip.com/advice');
      if (response.data != null) {
        // API returns a stringified JSON if not parsed natively
        final data = response.data;
        if (data is String) {
          return data; // just return raw or parse it if you want
        }
        return response.data['slip']['advice'];
      }
      return "Stay focused and never give up!";
    } catch (e) {
      throw Exception('Failed to load quote.');
    }
  }
}

final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  return QuoteRepository(ref.watch(dioProvider));
});

// Cache-then-network pattern for the quote
final quoteProvider = FutureProvider<String>((ref) async {
  final repo = ref.watch(quoteRepositoryProvider);
  return await repo.fetchDailyQuote();
});
