import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycollege/models/news.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'news';

  // Создание новости
  Future<News> createNews({
    required String title,
    required String content,
    required String authorId,
    required List<NewsImage> images,
    required List<String> tags,
  }) async {
    final newsRef = _firestore.collection(_collection);
    final now = DateTime.now();

    final newsData = {
      'title': title,
      'content': content,
      'authorId': authorId,
      'images': images.map((img) => img.toJson()).toList(),
      'tags': tags,
      'isPublished': false,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    };

    final docRef = await newsRef.add(newsData);
    return News.fromJson({'id': docRef.id, ...newsData});
  }

  // Обновление новости
  Future<void> updateNews(
    String id, {
    String? title,
    String? content,
    List<NewsImage>? images,
    List<String>? tags,
  }) async {
    final newsRef = _firestore.collection(_collection).doc(id);
    final updates = <String, dynamic>{
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    if (title != null) updates['title'] = title;
    if (content != null) updates['content'] = content;
    if (images != null)
      updates['images'] = images.map((img) => img.toJson()).toList();
    if (tags != null) updates['tags'] = tags;

    await newsRef.update(updates);
  }

  // Удаление новости
  Future<void> deleteNews(String id) async {
    final newsRef = _firestore.collection(_collection).doc(id);
    final newsDoc = await newsRef.get();

    if (!newsDoc.exists) {
      throw Exception('Новость не найдена');
    }

    await newsRef.delete();
  }

  // Публикация новости
  Future<void> publishNews(String id) async {
    final newsRef = _firestore.collection(_collection).doc(id);
    await newsRef.update({
      'isPublished': true,
      'publishedAt': Timestamp.fromDate(DateTime.now()),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Отмена публикации новости
  Future<void> unpublishNews(String id) async {
    final newsRef = _firestore.collection(_collection).doc(id);
    await newsRef.update({
      'isPublished': false,
      'publishedAt': null,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Получение списка новостей
  Future<List<News>> getNews({
    bool publishedOnly = false,
    int? limit,
    List<String>? tags,
  }) async {
    Query query = _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true);

    if (publishedOnly) {
      query = query.where('isPublished', isEqualTo: true);
    }

    if (tags != null && tags.isNotEmpty) {
      query = query.where('tags', arrayContainsAny: tags);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map(
          (doc) => News.fromJson({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          }),
        )
        .toList();
  }

  // Получение новости по ID
  Future<News?> getNewsById(String id) async {
    final newsRef = _firestore.collection(_collection).doc(id);
    final newsDoc = await newsRef.get();

    if (!newsDoc.exists) {
      return null;
    }

    return News.fromJson({
      'id': newsDoc.id,
      ...newsDoc.data() as Map<String, dynamic>,
    });
  }

  // Валидация URL изображения
  bool validateImageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}
