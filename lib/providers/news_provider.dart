import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/news_service.dart';
import '../models/news.dart';

final newsServiceProvider = Provider<NewsService>((ref) => NewsService());

// Провайдер для получения списка опубликованных новостей
final publishedNewsProvider = FutureProvider<List<News>>((ref) async {
  final newsService = ref.watch(newsServiceProvider);
  return newsService.getNews(publishedOnly: true);
});

// Провайдер для получения новости по ID
final newsByIdProvider = FutureProvider.family<News?, String>((ref, id) async {
  final newsService = ref.watch(newsServiceProvider);
  return newsService.getNewsById(id);
});

// Провайдер для получения новостей по тегам
final newsByTagsProvider = FutureProvider.family<List<News>, List<String>>((
  ref,
  tags,
) async {
  final newsService = ref.watch(newsServiceProvider);
  return newsService.getNews(tags: tags);
});
