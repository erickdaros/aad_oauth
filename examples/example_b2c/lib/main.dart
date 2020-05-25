import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'AAD B2C Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'AAD B2C Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final Config configB2Ca = new Config(
    azureTenantId: "3e803cd6-b130-4acb-9f08-951825ab324e",
    clientId: "9f365761-4da4-4011-8bf0-3ebd732d6fd3",
    scope: "9f365761-4da4-4011-8bf0-3ebd732d6fd3 offline_access",
    redirectUri: "https://login.live.com/oauth20_desktop.srf",
    clientSecret: "-Up};d>5vdm0{]oGXkjouzZM",
    isB2C: true,
    azureTenantName: "b2ccenibra",
    userFlow: "B2C_1_AppCENIBRA_Comunidade_Google_InscreverEntrarV2",
  );

  static final Config configB2Cb = new Config(
    azureTenantId: "3e803cd6-b130-4acb-9f08-951825ab324e",
    clientId: "9f365761-4da4-4011-8bf0-3ebd732d6fd3",
    scope: "9f365761-4da4-4011-8bf0-3ebd732d6fd3 offline_access",
    redirectUri: "https://login.live.com/oauth20_desktop.srf",
    clientSecret: "-Up};d>5vdm0{]oGXkjouzZM",
    isB2C: true,
    azureTenantName: "b2ccenibra",
    userFlow: "B2C_1_AppCENIBRA_Comunidade_InscreverEntrarV2",
  );

  //You can have as many B2C flows as you want

  Widget build(BuildContext context) {
    final AadOAuth oauthB2Ca = AadOAuth(configB2Ca, context);
    final AadOAuth oauthB2Cb = AadOAuth(configB2Cb, context);
    // adjust window size for browser login
    var screenSize = MediaQuery.of(context).size;
    var rectSize =
        Rect.fromLTWH(0.0, 25.0, screenSize.width, screenSize.height - 25);
    oauthB2Ca.setWebViewScreenSize(rectSize);

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              "AzureAD B2C A",
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          ListTile(
            leading: Icon(Icons.launch),
            title: Text('Login'),
            onTap: () {
              login(oauthB2Ca);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              logout(oauthB2Ca);
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              "AzureAD B2C B",
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          ListTile(
            leading: Icon(Icons.launch),
            title: Text('Login'),
            onTap: () {
              login(oauthB2Cb);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              logout(oauthB2Cb);
            },
          ),
        ],
      ),
    );
  }

  void showError(dynamic ex) {
    showMessage(ex.toString());
  }

  void showMessage(String text) {
    var alert = new AlertDialog(content: new Text(text), actions: <Widget>[
      new FlatButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void login(AadOAuth oAuth) async {
    try {
      await oAuth.login();
      String accessToken = await oAuth.getAccessToken();
      showMessage("Logged in successfully, your access token: $accessToken");
    } catch (e) {
      //showError(e);
    }
  }

  void logout(AadOAuth oAuth) async {
    await oAuth.logout();
    showMessage("Logged out");
  }
}
