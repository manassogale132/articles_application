import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import '../widgets/article_card.dart';
import 'article_detail_screen.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({super.key});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArticleProvider>().fetchArticles();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Articles', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.red,
          unselectedLabelColor: Colors.white70,
          tabs: const [Tab(text: 'All Articles'), Tab(text: 'Favorites')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildArticleList(false), _buildArticleList(true)],
      ),
    );
  }

  Widget _buildArticleList(bool favoritesOnly) {
    return Column(
      children: [
        if (!favoritesOnly) _buildSearchBar(),
        Expanded(
          child: Consumer<ArticleProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.error.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${provider.error}'),
                      ElevatedButton(
                        onPressed: () => provider.fetchArticles(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final articles =
                  favoritesOnly ? provider.favoriteArticles : provider.articles;

              if (articles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        favoritesOnly
                            ? Icons.favorite_border
                            : Icons.article_outlined,
                        size: 48.0,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        favoritesOnly
                            ? 'No favorite articles yet'
                            : 'No articles found',
                        style: TextStyle(fontSize: 16.0, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => provider.fetchArticles(),
                child: Scrollbar(
                  thickness: 6,
                  thumbVisibility: true,
                  radius: const Radius.circular(8),
                  child: ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return ArticleCard(
                        article: article,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ArticleDetailScreen(article: article),
                            ),
                          );
                        },
                        onFavoriteToggle: () {
                          provider.toggleFavorite(article.id);
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search Articles...',
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 16),
            onChanged: (value) {
              context.read<ArticleProvider>().searchArticles(value);
            },
          ),
        ),
      ),
    );
  }
}
