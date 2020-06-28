import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';


class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Language translation",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('zh', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales){
        for(var supportedLocale in supportedLocales){
          if(supportedLocale.languageCode == locale.languageCode && supportedLocale.countryCode == locale.countryCode){
            return supportedLocale;
          } else{return supportedLocales.first;}
        }
      },

      home: LanguageHomePage(title: "Language Testing Page"),
    );
  }
}

class LanguageHomePage extends StatefulWidget {
  final String title;

  LanguageHomePage({Key key, this.title}) : super(key: key);

  @override
  _LanguageHomePageState createState() => _LanguageHomePageState();
}

class _LanguageHomePageState extends State<LanguageHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              AppLocalizations.of(context, context).translate('first_string'),  //of(context)
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
            Text(
              AppLocalizations.of(context, context).translate('second_string'),  //of(context)
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10,),
            Text(
              'This will not be translated',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10)
          ],
        ),
      )
    );
  }
}

