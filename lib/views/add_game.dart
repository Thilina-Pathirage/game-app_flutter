import 'package:flutter/material.dart';
import 'package:gamerev/services/game_service.dart';
import 'package:gamerev/views/home.dart';
import 'package:image_picker/image_picker.dart';

class AddGame extends StatefulWidget {
  const AddGame({Key? key}) : super(key: key);

  @override
  State<AddGame> createState() => _AddGameState();
}

class _AddGameState extends State<AddGame> {
  late final ImagePicker _picker;
  final _gameNameController = TextEditingController();
  final _gameDescController = TextEditingController();
  late XFile _pickedFile;

  final _gameService = GameService();

  bool _validateGameName(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool _validateGameDesc(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool _validateGameImage(String? value) {
    if (value == null || value == "") {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    _pickedFile = XFile('');
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Handle the picked image file
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 21, 21),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Add Game'),
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
                  controller: _gameNameController,
                  decoration: const InputDecoration(
                    labelText: 'Name of the game',
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
                  controller: _gameDescController,
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
                TextButton(
                  onPressed: _pickImage,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    textStyle: const TextStyle(fontSize: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(150, 50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _pickedFile.name != ""
                          ? Text(
                              _pickedFile!.name.substring(0, 20),
                              style: const TextStyle(color: Colors.white),
                              maxLines: 1,
                            )
                          : const Text('Choose Image',
                              style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_validateGameName(_gameNameController.text) &&
                        _validateGameDesc(_gameDescController.text) &&
                        _validateGameImage(_pickedFile.name.toString())) {
                      try {
                        await _gameService.addGame(_gameNameController.text,
                            _gameDescController.text, _pickedFile);

                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                          ModalRoute.withName('/home'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Game added successful!",
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
