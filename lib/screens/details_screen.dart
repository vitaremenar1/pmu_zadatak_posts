import 'package:flutter/material.dart';
import '../models/posts.dart';

class DetailsScreen extends StatelessWidget {
  final Post post;

  const DetailsScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final post = this.post;
    return Scaffold(
      appBar: AppBar(title: Text('Objava #${post.id}')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.pink.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Korisnik ID: ${post.userId}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Sadržaj objave:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Text(post.body, style: const TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }
}
