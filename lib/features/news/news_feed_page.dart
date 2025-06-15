import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../providers/news_provider.dart';
import '../../models/news.dart';

class NewsFeedPage extends ConsumerWidget {
  final bool showAppBar;
  const NewsFeedPage({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(publishedNewsProvider);
    final content = RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(publishedNewsProvider);
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: newsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Ошибка: $e')),
        data: (newsList) {
          if (newsList.isEmpty) {
            return const Center(child: Text('Пока нет новостей'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: newsList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              final news = newsList[index];
              return _buildNewsCard(context, news);
            },
          );
        },
      ),
    );
    if (showAppBar) {
      return Scaffold(
        appBar: AppBar(title: const Text('Новости колледжа')),
        body: content,
      );
    } else {
      return content;
    }
  }

  Widget _buildNewsCard(BuildContext context, News news) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Галерея изображений
          if (news.images.isNotEmpty)
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: news.images.length,
                itemBuilder: (context, i) {
                  final image = news.images[i];
                  return Image.network(
                    image.url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.error_outline)),
                      );
                    },
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  news.content,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${news.createdAt.day}.${news.createdAt.month}.${news.createdAt.year}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (news.tags.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Icon(
                        Icons.tag,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        news.tags.join(', '),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final d = date.toLocal();
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }
}
