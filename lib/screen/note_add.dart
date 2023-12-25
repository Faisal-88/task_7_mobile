import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_7/style/app_style.dart';
import 'package:intl/intl.dart';

class NoteAdd extends StatefulWidget {
  const NoteAdd({super.key});

  @override
  State<NoteAdd> createState() => _NoteAddState();
}

class _NoteAddState extends State<NoteAdd> {
  // ignore: non_constant_identifier_names
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  String date = DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now());
  TextEditingController titleController = TextEditingController();
  TextEditingController mainController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: AppStyle.cardsColor[color_id],
          appBar: AppBar(
            backgroundColor: AppStyle.cardsColor[color_id],
            elevation: 0.0,
            title: const Text("Add Note"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Judul',
                  ),
                  style: AppStyle.mainTitle,
                ),
                const SizedBox(height: 8.0),
                Text(date, style: AppStyle.dateTitle,),
                const SizedBox(height: 20.0),
                TextField(
                  controller: mainController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Isi',
                  ),
                  style: AppStyle.mainContent,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppStyle.accentColor,
            shape: const CircleBorder(),
          onPressed: () {
            FirebaseFirestore.instance.collection("Notes").add({
              "note_title": titleController.text,
              "creation_date": date,
              "note_content": mainController.text,
              "color_id": color_id
            }).then((value) {
              if (kDebugMode) {
                print(value.id);
              }
              Navigator.pop(context);
            }).catchError(
              // ignore: invalid_return_type_for_catch_error, avoid_print
              (error) => print("Gagal membuat catatan baru $error"));
          },
        child:const Icon(Icons.save,
          color: Colors.white,
        ),
        ),
    );
  }
}