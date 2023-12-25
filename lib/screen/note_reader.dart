import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_7/style/app_style.dart';
import 'package:intl/intl.dart';

class NoteReader extends StatefulWidget {
  const NoteReader(this.doc, {Key? key}) : super(key: key);
  final QueryDocumentSnapshot doc;

  @override
  State<NoteReader> createState() => _NoteReaderState();
}

class _NoteReaderState extends State<NoteReader> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String _date;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.doc['note_title']);
    _contentController =
        TextEditingController(text: widget.doc['note_content']);
    _date = DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    int color_id = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              style: AppStyle.mainTitle,
              readOnly: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            TextFormField(
              controller: TextEditingController(text: _date),
              readOnly: true,
              style: AppStyle.dateTitle,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _contentController,
                style: AppStyle.mainContent,
                readOnly: false,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await FirebaseFirestore.instance
                .collection('Notes')
                .doc(widget.doc.id)
                .update({
              'note_title': _titleController.text,
              'note_content': _contentController.text,
              'creation_date': _date,
            });

            // Pembaruan berhasil, tampilkan snackbar atau navigasi kembali
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Catatan berhasil diperbarui'),
              ),
            );

            // Navigasi kembali ke layar sebelumnya
            Navigator.pop(context);
          } catch (error) {
            // Tangani kesalahan jika pembaruan gagal
            print('Error updating note: $error');
            // Tampilkan pesan kesalahan jika perlu
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal memperbarui catatan. Silakan coba lagi.'),
              ),
            );
          }
        },
        backgroundColor: AppStyle.accentColor,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
    );
  }
}
