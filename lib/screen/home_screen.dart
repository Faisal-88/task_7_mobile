import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_7/screen/note_add.dart';
import 'package:flutter_task_7/screen/note_reader.dart';
import 'package:flutter_task_7/style/app_style.dart';
import 'package:flutter_task_7/widget/note_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _deleteNote(String id) async {
  try {
    await FirebaseFirestore.instance.collection('Notes').doc(id).delete();
    if (kDebugMode) {
      print('Catatan berhasil dihapus');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error saat menghapus catatan: $e');
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Notes",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Catatan Terbaru",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Notes").snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      children: snapshot.data!.docs
                          .map<Widget>((note) => noteCard(
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => NoteReader(note)),
                                  );
                                },
                                note,
                                () {
                                  //fungsi delete
                                  _deleteNote(note.id);
                                },
                              ))
                          .toList(),
                    );
                  }
                  return Text("tidak ada Catatan", style: GoogleFonts.nunito(color: Colors.white));
                },
              ),
            ),
          ],
        ),
      ),
      // add catatan
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const NoteAdd()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
