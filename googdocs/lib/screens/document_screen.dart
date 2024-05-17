import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googdocs/colors.dart';
import 'package:googdocs/models/document_model.dart';
import 'package:googdocs/models/error_models.dart';
import 'package:googdocs/repository/auth_repository.dart';
import 'package:googdocs/repository/document_repository.dart';
import 'package:googdocs/repository/socket_repository.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:routemaster/routemaster.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;

  DocumentScreen({
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  TextEditingController titleController =
      TextEditingController(text: 'Untitled document');
  quill.QuillController? _controller;
  ErrorModel? errorModel;
  SocketRepository socketRepository = SocketRepository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();

    socketRepository.changeListener((data) {
      _controller?.compose(
        quill.Delta.fromJson(data['delta']),
        _controller?.selection ?? const TextSelection.collapsed(offset: 0),
        quill.ChangeSource.REMOTE,
      );
    });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        'delta': _controller!.document.toDelta(),
        'room': widget.id,
      });
    });
  }

  void fetchDocumentData() async {
    ErrorModel errorModel =
        await ref.read(documentRepositoryProvider).getDocumentById(
              ref.read(userProvider)!.token,
              widget.id,
            );
    if (errorModel.data != null) {
      titleController.text = (errorModel.data as DocumentModel).title;
      _controller = quill.QuillController(
        document: errorModel.data.content.isEmpty
            ? quill.Document()
            : quill.Document.fromDelta(
                quill.Delta.fromJson(errorModel.data.content),
              ),
        selection: TextSelection.collapsed(offset: 0),
      );
      setState(() {});
    }

    _controller!.document.changes.listen((event) {
      if (event.item3 == quill.ChangeSource.LOCAL) {
        Map<String, dynamic> map = {
          'delta': event.item2,
          'room': widget.id,
        };
        socketRepository.typing(map);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
  }

  void updateDocumentTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateDocumentTitle(
          ref.read(userProvider)!.token,
          widget.id,
          title,
        );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null) {
      return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.brown,
          size: 40,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Routemaster.of(context).replace('/');
                },
                child: Image.asset(
                  'images/docs-logo.png',
                  height: 40,
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      // let user can see the border if user clicks the border
                      borderSide: BorderSide(
                        color: kBlueColor,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  onSubmitted: (value) => updateDocumentTitle(ref, value),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text: 'http://localhost:3000/#/document/${widget.id}',
                  ),
                ).then(
                  (value) => {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Link copied'),
                      ),
                    ),
                  },
                );
              },
              icon: const Icon(Icons.lock),
              label: const Text('Share'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlueColor,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: kGreyColor,
                width: 0.1,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          quill.QuillToolbar.basic(controller: _controller!),
          const SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              width: 750,
              child: Card(
                color: kWhiteColor,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: quill.QuillEditor.basic(
                    controller: _controller!,
                    readOnly: false,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
