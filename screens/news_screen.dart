// lib/screens/news_screen.dart
import 'package:flutter/material.dart';
import '../widgets/news_card.dart';
import '../models/news.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late List<News> newsList;
  late News featuredNews;
  String activeCategory = 'all';
  bool isLoading = true;
  bool isRefreshing = false;

  final List<Map<String, String>> categories = [
    {'id': 'all', 'label': 'All'},
    {'id': 'climate', 'label': 'Climate Change'},
    {'id': 'sustainability', 'label': 'Sustainability'},
    {'id': 'tech', 'label': 'Tech'},
    {'id': 'policy', 'label': 'Policy'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isRefreshing = true;
    });

    // In a real app, fetch from an API
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      newsList = getSampleNews();
      featuredNews = getFeaturedNews();
      isLoading = false;
      isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header with refresh button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Environment Updates',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: Icon(
                  Icons.refresh,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  isRefreshing ? 'Refreshing...' : 'Refresh',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) =>
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category['label']!),
                      selected: activeCategory == category['id'],
                      onSelected: (selected) {
                        setState(() {
                          activeCategory = category['id']!;
                        });
                      },
                      selectedColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                        color: activeCategory == category['id']
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
              ).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Featured news
          _buildFeaturedNewsCard(),
          const SizedBox(height: 16),

          // News list
          ...getFilteredNews().map((news) =>
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: NewsCard(news: news),
              ),
          ),

          // Load more button
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              'Load More Updates',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedNewsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            featuredNews.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Featured',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(featuredNews.publishedAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  featuredNews.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  featuredNews.summary,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Read more',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${monthNames[date.month - 1]}';
  }

  List<News> getFilteredNews() {
    if (activeCategory == 'all') {
      return newsList;
    }
    return newsList
        .where((news) => news.category.toLowerCase() == activeCategory)
        .toList();
  }

  // Sample data generators
  News getFeaturedNews() {
    return News(
      id: 1,
      title: 'New Solar Technology Increases Efficiency by 40%',
      content: 'Scientists have developed a new kind of solar panel that can generate electricity even on cloudy days, potentially revolutionizing renewable energy adoption.',
      summary: 'Scientists have developed a new kind of solar panel that can generate electricity even on cloudy days, potentially revolutionizing renewable energy adoption.',
      imageUrl: 'https://images.unsplash.com/photo-1508514177221-188b1cf16e9d',
      category: 'Technology',
      isFeatured: true,
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    );
  }

  List<News> getSampleNews() {
    return [
      News(
        id: 2,
        title: 'Global Carbon Emissions Drop 2% in First Quarter',
        content: 'In a promising sign for climate action, global carbon emissions have decreased by 2% during the first quarter of this year compared to the same period last year.',
        summary: 'Analysis suggests work-from-home policies and increased renewable energy adoption are contributing factors.',
        imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71',
        category: 'Climate',
        isFeatured: false,
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      News(
        id: 3,
        title: 'Major Retailer Commits to 100% Recycled Packaging',
        content: 'One of the world\'s largest retail chains announced today its commitment to eliminate all virgin plastic from its packaging by 2025.',
        summary: 'The retail giant announced plans to eliminate all virgin plastic from packaging by 2025.',
        imageUrl: 'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09',
        category: 'Sustainability',
        isFeatured: false,
        publishedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      News(
        id: 4,
        title: 'City Announces Major Investment in Bicycle Infrastructure',
        content: 'The city council has approved a 50 million investment in expanding bicycle lanes and bicycle-friendly infrastructure throughout the metropolitan area.',
        summary: 'New investment aims to make cycling safer and more convenient for commuters.',
        imageUrl: 'https://images.unsplash.com/photo-1526613879466-f0f6e92cdb2d',
        category: 'Policy',
        isFeatured: false,
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
}