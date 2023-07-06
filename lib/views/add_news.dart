import 'package:flutter/material.dart';
import 'package:gamerev/services/news_service.dart';
import 'package:gamerev/views/game_news.dart';

import 'home.dart';

class AddNews extends StatefulWidget {
  const AddNews({super.key});

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  final _newsService = NewsService();

  bool _validateString(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    } else {
      return true;
    }
  }


  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 21, 21),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Add News'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'News Title',
                    labelStyle: TextStyle(color: Colors.deepOrange),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                  ),
                  cursorColor: Colors.deepOrange,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.deepOrange),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                  ),
                  cursorColor: Colors.deepOrange,
                  style: const TextStyle(color: Colors.white),
                ),
               
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_validateString(_titleController.text) &&
                        _validateString(_descController.text)) {
                      try {
                        await _newsService.addNews(_titleController.text, _descController.text);

                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const GameNewsPage()),
                          ModalRoute.withName('/gameNews'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("News added successful!",
                                style: TextStyle(color: Colors.black)),
                            backgroundColor: Color.fromARGB(255, 254, 216, 0),
                          ),
                        );
                      } catch (e) {
                        // Signup failed, show error message or handle the error
                        print("Request Field: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Request failed!"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("All fields are required!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(150, 50),
                  ),
                  child: const Text('ADD'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
}
}