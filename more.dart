import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilibus/accessibility/main_accessibility.dart';
import 'package:mobilibus/app/urban/more/contact/contact_message.dart';
import 'package:mobilibus/intro/introduction_screen/indicator_intro/dots_indicator.dart';
import 'package:mobilibus/utils/Utils.dart';
import 'package:mobilibus/utils/widgets/NotificationWebView.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'more/information/information.dart';
import 'more/pos/points_of_sale.dart';

class More extends StatefulWidget {
  @override
  _More createState() => _More();
}

class _More extends State<More> with AutomaticKeepAliveClientMixin {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences? sharedPreferences;
  int tapCount = 0;
  bool hasRedDot = false;
  String version = '';
  bool visible = false;
  Timer? timer;
  int selectedAsset = 0;
  List<String> assetsName = [
    'assets/mobilibus/access.png',
    'assets/mobilibus/adrianavatar.png',
    'assets/mobilibus/man.png',
    'assets/mobilibus/woman.png',
    'assets/mobilibus/workman.png',
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(), () async {
      sharedPreferences = await SharedPreferences.getInstance();
      version = (await PackageInfo.fromPlatform()).version;
      setState(() {});
    });
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      selectedAsset++;
      if (selectedAsset > assetsName.length - 1) selectedAsset = 0;
      visible = true;
      setState(() {});
      Future.delayed(Duration(seconds: 2, milliseconds: 500),
          () => setState(() => visible = false));
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    hasRedDot = (sharedPreferences?.containsKey('redDot') ?? false
        ? sharedPreferences!.getBool('redDot')
        : false)!;

    // ignore: unused_local_variable
    String urbanProjectNameLabel = Utils.project == null
        ? ''
        : Utils.isMobilibus
            ? Utils.project!.name
            : Utils.project!.city;

    List<dynamic> mores = [
      // {
      //   'icon': Icons.wifi,
      //   'asset': null,
      //   'name': 'Wi-fi',
      //   'action': () => Navigator.of(context).push(MaterialPageRoute( builder: (context) => WifiPage())),
      // },
      // {
      // 'icon': null,
      // 'asset': 'assets/more/metrocard_consulta.svg',
      // 'name': 'SALDO E RECARGA',
      // 'action': () => Navigator.push( context, MaterialPageRoute(builder: (context) => NewTransportCardPage())),
      //'action': () => _openBalanceAndRecharge(),//async {await Navigator.push(context, MaterialPageRoute(builder: (context) => Information()));setState(() {});//},
      // },
      if (Utils.project != null)
        {
          'icon': null,
          'asset': 'assets/more/v3_news.svg',
          'name': 'NOTÍCIAS E ALERTAS',
          'action': () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => Information()));
            setState(() {});
          },
        },
      if (Utils.project != null)
        {
          'icon': null,
          'asset': 'assets/more/v3_store.svg',
          'name': 'PONTOS DE VENDA',
          'action': () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => POS())),
        },
      // {
      //     'icon': null, //Icons.add,
      //     'asset': 'assets/more/metrocard_atendimento.svg',
      //     'name': 'ATENDIMENTO',
      //     'action': () => launchUrl(Uri.parse('https://api.whatsapp.com/send?phone=+554174030760&text=Oi!&app_absent=0'), mode: LaunchMode.externalApplication,),//() => launch('https://api.whatsapp.com/send?phone=+554174030760&text=Oi!&app_absent=0'),//:print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed"),//Share.share('https://api.whatsapp.com/send?phone=5541998153287&text=Oi&app_absent=0', subject: 'Atendimento',),
      // },
      {
        'color': Colors.green,
        'icon': null,
        'asset': 'assets/more/v3_comment.svg',
        'name': 'FALE CONOSCO',
        'action': () {
          const url =
              'https://falegoverno.uberlandia.mg.gov.br/falegoverno/f/t/solicitacoesman?modoJanelaPlc=popup';
             launchUrl(Uri.parse(url),
                mode: LaunchMode.externalApplication);
        },
      },
      {
        'icon': null,
        'asset': 'assets/more/v3_acessibilidade_png.svg',
        'name': 'ACESSIBILIDADE',
        'action': () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainPageAccessibility())),
      },
      {
        'icon': null,
        'asset': 'assets/more/v3_manual.svg',
        'name': 'COMO UTILIZAR',
        'action': () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NotificationWebView(
                'Como Utilizar', 'https://blog.mobilibus.com/manual'))),
      },
      {
        'icon': null, //Icons.share,
        'asset': 'assets/more/compartilhe.svg',
        'name': 'COMPARTILHE',
        'action': () => Share.share(
              'http://app.mobilibus.com/${Utils.landingPageName}',
              subject: 'Compartilhar aplicativo',
              sharePositionOrigin: Rect.fromCenter(
                center: Offset(100, 100),
                width: 100,
                height: 100,
              ),
            ),
      },
    ];

    Color color = Utils.isLightTheme(context)
        ? Colors.black
        : Utils.getColorFromPrimary(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: scaffoldKey,
        // drawer: Drawer(child: SelectCityUrban()),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(Utils.globalStrHeader),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 190,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //Container(height: 160),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                          left: 1,
                          right: 1,
                        ),
                        itemCount: mores.length,
                        itemBuilder: (context, index) {
                          var more = mores[index];
                          IconData? iconData = more['icon'];
                          String? asset = more['asset'];
                          String? name = more['name'];
                          Function() action = more['action'];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 2),
                            child: ListTile(
                              onTap: action,
                              title: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  color: Colors.white,
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      asset == null
                                          ? Icon(
                                              iconData,
                                              color: Utils.globalAccentColor,
                                              size: 40,
                                            )
                                          //: (index == 0 || index == 1)  ?
                                          : SvgPicture.asset(
                                              asset,
                                              color: Utils.globalAccentColor,
                                              height: 40,
                                              width: 40,
                                            ),

                                      //: SvgPicture.asset(asset, color: color, height: 24, width: 24,),
                                      Container(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          name!,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                      ),
                      Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                'Versão: $version',
                                style: TextStyle(color: color),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: color),
                                  children: [
                                    TextSpan(
                                      text: 'Política de Privacidade',
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            GoogleFonts.catamaran().fontFamily,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    NotificationWebView(
                                                        'Política de Privacidade',
                                                        'https://blog.mobilibus.com/privacy'))), //launch('http://app.mobilibus.com/politica-de-privacidade.html'),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
