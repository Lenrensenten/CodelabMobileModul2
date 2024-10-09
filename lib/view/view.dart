import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/http_controller.dart';
import 'webview_page.dart';

class ArticleView extends StatelessWidget {
  final HttpController controller = Get.put(HttpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.web),
            onPressed: () {
              Get.to(() => WebViewPage(
                  url: 'https://wutheringwaves.kurogames.com/en/main/'));
            },
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.articles.value == null
                ? const Center(child: Text('No articles found'))
                : ListView.builder(
                    itemCount: controller.articles.value?.articles.length ?? 0,
                    itemBuilder: (context, index) {
                      final article =
                          controller.articles.value!.articles[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => WebViewPage(url: article.url));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (article.urlToImage.isNotEmpty)
                                Image.network(
                                  article.urlToImage,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: Icon(Icons.error),
                                      ),
                                    );
                                  },
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      article.description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'By ${article.author}',
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        Text(
                                          article.publishedAt
                                              .toString()
                                              .split(' ')[0],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.fetchArticles,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
