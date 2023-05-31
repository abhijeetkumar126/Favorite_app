import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final words = nouns.take(50).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite App'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('favorites').listenable(),
        builder: (context, box, child) {
          return ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              final isFavorite = box.get(index) != null;
              return ListTile(
                title: Text(word),
                trailing: IconButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    if (isFavorite) {
                      await box.delete(index);
                      const snackBar = SnackBar(
                        content: Text('Removed Succesfully'),
                        backgroundColor: Colors.grey,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      await box.put(index, word);
                      const snackBar = SnackBar(
                        content: Text('Added succefully'),
                        backgroundColor: Colors.blue,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
