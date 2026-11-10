import 'package:flutter/material.dart';
import '../models/posts.dart';
import '../services/post_services.dart';
import '../widgets/detail_widget.dart';
import 'details_screen.dart';

class PopisEkran extends StatefulWidget {
  const PopisEkran({super.key});

  @override
  State<PopisEkran> createState() => _PopisEkranState();
}

class _PopisEkranState extends State<PopisEkran> {
  final _usluga = const PostService();
  late Future<List<Post>> _posts;
  final _removed = <int>{};
  final _pinned = <int>{};

  @override
  void initState() {
    super.initState();
    _posts = _usluga.fetchPosts();
  }

  Future<void> _reload() {
    setState(() => _posts = _usluga.fetchPosts());
    return _posts;
  }

  void _openDetail(Post post) {
    Navigator.push(
      context,
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (context, animation, secondaryAnimation) => DetailsScreen(
          post: post,
        ),
      ),
    );
  }

  void _togglePin(Post post) {
    setState(() {
      if (!_pinned.remove(post.id)) _pinned.add(post.id);
    });
  }

  void _remove(Post post) {
    setState(() => _removed.add(post.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Uklonjena objava ID: ${post.id}'),
        action: SnackBarAction(
          label: 'Poništi',
          onPressed: () {
            if (!mounted) return;
            setState(() => _removed.remove(post.id));
          },
        ),
      ),
    );
  }

  Widget _buildList(List<Post> posts) {
    final visible = posts.where((post) => !_removed.contains(post.id)).toList();

    if (visible.isEmpty) {
      return Center(
        child: const Text('Nema objava za prikaz'),
      );
    }
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: visible.length,
        itemBuilder: (context, index) {
          final post = visible[index];
          return PostKartica(
            post: post,
            pinned: _pinned.contains(post.id),
            onTap: () => _openDetail(post),
            onLongPress: () => _togglePin(post),
            onDismissed: () => _remove(post),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popis objava')),
      body: FutureBuilder<List<Post>>(
        future: _posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('Provjeri internetsku vezu i pokušaj ponovno'),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _reload, child: const Text('Pokušaj ponovno')),
                ],
              ),
            );
          }
          return _buildList(snapshot.data ?? []);
        },
      ),
    );
  }
}
