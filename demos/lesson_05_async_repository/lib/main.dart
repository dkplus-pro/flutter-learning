import 'package:flutter/material.dart';

void main() {
  runApp(const Lesson05App());
}

class Lesson05App extends StatelessWidget {
  const Lesson05App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lesson 05 - Async Repository',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple), useMaterial3: true),
      home: LearningFeedPage(repository: LearningRepository()),
    );
  }
}

class LearningFeedPage extends StatefulWidget {
  const LearningFeedPage({super.key, required this.repository});

  final LearningRepository repository;

  @override
  State<LearningFeedPage> createState() => _LearningFeedPageState();
}

class _LearningFeedPageState extends State<LearningFeedPage> {
  late Future<List<LearningArticle>> _articlesFuture;
  bool _nextRequestShouldFail = false;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  void _loadArticles() {
    // Future 是一次性结果；重试时要创建新的 Future，让 FutureBuilder 收到新任务。
    _articlesFuture = widget.repository.fetchArticles(shouldFail: _nextRequestShouldFail);
  }

  void _simulateError() {
    setState(() {
      _nextRequestShouldFail = true;
      _loadArticles();
    });
  }

  void _retrySuccessfully() {
    setState(() {
      _nextRequestShouldFail = false;
      _loadArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('05｜异步数据与 Repository')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flutter 学习资讯流', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text('UI 只依赖 Repository 抽象，不直接关心数据来自网络、缓存还是测试替身。'),
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: _simulateError,
                  icon: const Icon(Icons.error_outline),
                  label: const Text('模拟错误'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _retrySuccessfully,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重试成功'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<LearningArticle>>(
                future: _articlesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const _LoadingState();
                  }
                  if (snapshot.hasError) {
                    return _ErrorState(message: snapshot.error.toString());
                  }
                  final articles = snapshot.data ?? const <LearningArticle>[];
                  if (articles.isEmpty) {
                    return const Center(child: Text('暂无内容，请稍后再试。'));
                  }
                  return ListView.separated(
                    itemCount: articles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _ArticleCard(article: articles[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text('加载课程数据中...'),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('加载失败：$message', textAlign: TextAlign.center),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});

  final LearningArticle article;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.article_outlined),
        title: Text(article.title),
        subtitle: Text(article.summary),
      ),
    );
  }
}

class LearningRepository {
  Future<List<LearningArticle>> fetchArticles({bool shouldFail = false}) async {
    // 这里用本地延迟模拟网络请求，保持 demo 可离线运行。
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (shouldFail) {
      throw Exception('Repository 模拟错误');
    }
    return const [
      LearningArticle('FutureBuilder 状态机', '用 AsyncSnapshot 明确处理 loading/error/data。'),
      LearningArticle('Repository 边界', '让页面依赖稳定抽象，而不是直接散落请求细节。'),
      LearningArticle('重试策略', '重试的本质是创建新的异步任务并刷新 UI。'),
    ];
  }
}

class LearningArticle {
  const LearningArticle(this.title, this.summary);

  final String title;
  final String summary;
}
