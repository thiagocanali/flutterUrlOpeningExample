// ignore_for_file: unnecessary_null_comparison

import 'dart:convert' as convert;
// import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilibus/app/urban/more/contact/ContactMessageCadeMeuOnibusWidget.dart';
import 'package:mobilibus/utils/MOBApiUtils.dart';
import 'package:mobilibus/utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactMessageUrban extends StatefulWidget {
  _ContactMessageUrban createState() => _ContactMessageUrban();
}

class _ContactMessageUrban extends State<ContactMessageUrban> {
  String attachment = '';
  Uint8List? uint8ListAttachment;

  TextEditingController teName = TextEditingController();
  TextEditingController teMail = TextEditingController();
  TextEditingController tePhone = TextEditingController();
  TextEditingController teMsg = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  ContactMessageCadeMeuOnibusWidget? contactMessageCadeMeuOnibusWidget;

  @override
  void initState() {
    if (Utils.project!.projectId == 466)
      contactMessageCadeMeuOnibusWidget = ContactMessageCadeMeuOnibusWidget();
    super.initState();
  }

  void send() async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      String name = teName.value.text;
      String mail = teMail.value.text;
      String phone = tePhone.value.text;
      String msg = teMsg.value.text;

      name = (name.isEmpty ? null : name)!;
      mail = (mail.isEmpty ? null : mail)!;
      phone = (phone.isEmpty ? null : phone)!;

      Map<String, dynamic> jsonPost = {
        'projectId': Utils.isBus2 ? -1 : Utils.project!.projectId,
        'name': name,
        'email': mail,
        'phone': phone,
        'message': msg,
        'attachment': attachment,
      };
      String bodyParams = convert.json.encode(jsonPost);
      try {
        var response = await MOBApiUtils.sendMessage(
            Utils.project!.projectId, bodyParams, context);
        if (response != null) {
          String body = convert.utf8.decode(response.bodyBytes);
          Map<String, dynamic> map = convert.json.decode(body);
          bool success = map.containsKey('success') ? map['success'] : false;
          if (success) {
            Navigator.of(context).pop();
            dialogSuccess();
          } else
            dialogError();
        }
      } on Exception {
        dialogError();
      }

      isLoading = false;
      setState(() {});
    }
  }

  void dialogSuccess() => showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Sucesso!',
            style: TextStyle(color: Utils.getColorByLuminanceTheme(context)),
          ),
          content: Text(
            'Recebemos sua mensagem, obrigado!',
            style: TextStyle(color: Utils.getColorByLuminanceTheme(context)),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Fechar',
                style:
                    TextStyle(color: Utils.getColorByLuminanceTheme(context)),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            )
          ],
        ),
      );

  void dialogError() => showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Erro!',
            style: TextStyle(color: Utils.getColorByLuminanceTheme(context)),
          ),
          content: Text(
            'Não foi possível enviar sua mensagem, tente novamente mais tarde.',
            style: TextStyle(color: Utils.getColorByLuminanceTheme(context)),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Fechar',
                style:
                    TextStyle(color: Utils.getColorByLuminanceTheme(context)),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
            )
          ],
        ),
      );

  // void getImage() async => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //           backgroundColor: Theme.of(context).primaryColor,
  //           title: Text(
  //             'Selecione como deseja anexar',
  //             style: TextStyle(color: Utils.getColorByLuminanceTheme(context)),
  //           ),
  //           content: Container(
  //             height: 300,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: <Widget>[
  //                 TextButton(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: <Widget>[
  //                       Icon(
  //                         Icons.camera_enhance,
  //                         color: Utils.getColorByLuminanceTheme(context),
  //                         size: 50,
  //                       ),
  //                       Text(
  //                         'Câmera',
  //                         style: TextStyle(
  //                             color: Utils.getColorByLuminanceTheme(context),
  //                             fontSize: 25),
  //                       ),
  //                     ],
  //                   ),
  //                   onPressed: () => updateImage(ImageSource.camera),
  //                 ),
  //                 TextButton(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: <Widget>[
  //                       Icon(
  //                         Icons.image,
  //                         color: Utils.getColorByLuminanceTheme(context),
  //                         size: 50,
  //                       ),
  //                       Text(
  //                         'Galeria',
  //                         style: TextStyle(
  //                             color: Utils.getColorByLuminanceTheme(context),
  //                             fontSize: 25),
  //                       ),
  //                     ],
  //                   ),
  //                   onPressed: () => updateImage(ImageSource.gallery),
  //                 ),
  //                 TextButton(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: <Widget>[
  //                       Icon(
  //                         Icons.cancel,
  //                         color: Utils.getColorByLuminanceTheme(context),
  //                         size: 50,
  //                       ),
  //                       Text(
  //                         'Cancelar',
  //                         style: TextStyle(
  //                             color: Utils.getColorByLuminanceTheme(context),
  //                             fontSize: 25),
  //                       ),
  //                     ],
  //                   ),
  //                   onPressed: () => Navigator.of(context).pop(),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ));

  bool isJpgSignature(Uint8List bytes) {
    List signature = bytes.sublist(0, 4).toList();

    List jpgSignature1 = [255, 216, 255, 224];
    List jpgSignature2 = [255, 216, 255, 225];
    List jpgSignature3 = [255, 216, 255, 232];

    bool isJpg1 = listEquals(jpgSignature1, signature);
    bool isJpg2 = listEquals(jpgSignature2, signature);
    bool isJpg3 = listEquals(jpgSignature3, signature);
    return isJpg1 || isJpg2 || isJpg3;
  }

  void updateImage(ImageSource source) async {
    var image = await ImagePicker().pickImage(
      source: source,
      maxHeight: 2000,
      maxWidth: 2000,
      //imageQuality: 70,
    );
    if (image == null) return;
    Uint8List bytes = await image.readAsBytes();
    if (bytes != null && isJpgSignature(bytes)) {
      uint8ListAttachment = bytes;
      attachment = convert.base64Encode(uint8ListAttachment!);
      setState(() => Navigator.of(context).pop());
    } else
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text(
                  'Erro',
                  style:
                      TextStyle(color: Utils.getColorByLuminanceTheme(context)),
                ),
                content: Text(
                  'O arquivo selecionado não é compatível, selecione um arquivo num formato JPG/JPEG ou bata uma foto',
                  style:
                      TextStyle(color: Utils.getColorByLuminanceTheme(context)),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'Fechar',
                      style: TextStyle(
                          color: Utils.getColorByLuminanceTheme(context)),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
  }

  // Widget imageAttacher() => Column(
  //       children: <Widget>[
  //         ListTile(
  //           onTap: () => getImage(),
  //           title: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: <Widget>[
  //               Icon(
  //                 Icons.photo_camera,
  //                 size: 20,
  //                 color: Theme.of(context).primaryColor,
  //               ),
  //               Container(
  //                 width: MediaQuery.of(context).size.width - 100,
  //                 child: Text('Clique aqui para anexar uma imagem (Opcional)'),
  //               )
  //             ],
  //           ),
  //           subtitle: Text(
  //             'JPG/JPEG com dimensão máxima de 2000x2000 pixels',
  //             style: TextStyle(color: Colors.grey),
  //           ),
  //         ),
  //         if (uint8ListAttachment != null)
  //           TextButton(
  //             onPressed: () {
  //               attachment = '';
  //               uint8ListAttachment = null;
  //               setState(() {});
  //             },
  //             child: Image.memory(uint8ListAttachment!),
  //           ),
  //         Container(
  //           padding: EdgeInsets.only(bottom: 100),
  //         ),
  //       ],
  //     );

  @override
  Widget build(BuildContext context) {
    Color themeColor = Utils.getColorByLuminanceTheme(context);
    TextStyle textStyle = TextStyle(color: themeColor);

    TextFormField tffName = TextFormField(
      validator: (text) => text!.length == 0 ? 'Campo obrigatório' : null,
      controller: teName,
      maxLines: 1,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Nome (Obrigatório)',
        filled: true,
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      ),
    );

    TextFormField tffMail = TextFormField(
      validator: (text) {
        RegExp regex = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
        if (!regex.hasMatch(text!))
          return 'E-mail inválido';
        else
          return null;
      },
      maxLines: 1,
      controller: teMail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'E-mail (Obrigatório)',
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
    );

    TextFormField tffMessage = TextFormField(
      validator: (text) => text!.length == 0 ? 'Campo obrigatório' : null,
      controller: teMsg,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Mensagem (Obrigatório)',
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );

    TextFormField tffPhone = TextFormField(
      maxLines: 1,
      controller: tePhone,
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(14),
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.singleLineFormatter,
      ],
      decoration: InputDecoration(
        labelText: 'Telefone (Opcional)',
        filled: true,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Utils.globalPrimaryColor,
        title: Text('Entre em contato', style: textStyle),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeColor),
          onPressed: () => Navigator.pop(context, () => setState(() {})),
        ),
      ),
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              onPressed: () => send(),
              child: Icon(Icons.send),
            ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Utils.isLightTheme(context)
                          ? Utils.getColorFromPrimary(context)
                          : Colors.black)),
            )
          : ListView(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        tffName,
                        SizedBox(height: 20),
                        tffMail,
                        SizedBox(height: 20),
                        tffPhone,
                        if (Utils.project!.projectId == 466)
                          contactMessageCadeMeuOnibusWidget!,
                        SizedBox(height: 20),
                        tffMessage,
                      ],
                    ),
                  ),
                ),
                // imageAttacher(),
                Container(
                  padding: EdgeInsets.all(15),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Clique para abrir Web View',
                      style: new TextStyle(color: Colors.blue),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          launchUrlString(
                              'https://falegoverno.uberlandia.mg.gov.br/falegoverno/f/t/solicitacoesman?modoJanelaPlc=popup');
                        },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                ),
              ],
            ),
    );
  }
}
