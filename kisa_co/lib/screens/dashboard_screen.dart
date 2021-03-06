import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kisaco/models/url_model.dart';
import 'package:kisaco/models/user_model.dart';
import 'package:kisaco/screens/authShort_screen.dart';
import 'package:kisaco/screens/welcome_screen.dart';
import 'analytics_screen.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'package:kisaco/components/rounded_button.dart';
import 'package:link/link.dart';

class DashboardScreen extends StatefulWidget {
  static const String id = 'dashboard_screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //an instance of the URL model comes here
  @override
  Widget build(BuildContext context) {
    List<UrlData> _data =
        Provider.of<UserModel>(context, listen: false).generatedUrl;
    int totalUrls = _data.length;

    int totalViews(_data) {
      int totalViewSum = 0;
      for (int i = 0; i < _data.length; i++) {
        totalViewSum = _data[i].visitor_count + totalViewSum;
      }
      return totalViewSum;
    }

    int userTotalViews = totalViews(_data);

    void _showErrorSnackBar() {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Oops... the URL couldn\'t be opened!'),
        ),
      );
    }

    void openUrlAnalytics(int urlId) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnalyticsScreen(
                  urlId: urlId,
                )),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'User Profile',
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Provider.of<UserModel>(context, listen: false).logout();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (Route<dynamic> route) => false);
                },
                child: Icon(Icons.exit_to_app),
              )),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Stack(
              fit: StackFit.loose,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 330,
                  color: kDarkestPurpleColor,
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: 90,
                      margin: EdgeInsets.only(top: 60),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Image(image: AssetImage('images/logo.png')),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Text(
                      Provider.of<UserModel>(context, listen: false).name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Text(
                      Provider.of<UserModel>(context, listen: false).email,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 77),
                      padding: EdgeInsets.all(10),
                      child: Card(
                        color: kLightPurpleColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                    padding:
                                        EdgeInsets.only(top: 15, bottom: 5),
                                    child: Text("Number of URLs",
                                        style:
                                            TextStyle(color: Colors.black87))),
                                Container(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: Text("$totalUrls",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16))),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 5),
                                    child: Text("Total Views",
                                        style:
                                            TextStyle(color: Colors.black87))),
                                Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text("$userTotalViews",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //UserInfo()
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              decoration: new BoxDecoration(
                color: kOffWhiteColor,
                border: Border.all(
                  color: kBrownColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: new ListView.builder(
                shrinkWrap: true,
                reverse: true,
                padding: EdgeInsets.all(4),
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  UrlData item = _data[index];
                  var date = new DateTime.fromMillisecondsSinceEpoch(
                      item.created_at * 1000);
                  String origUrl = item.orig_url;
                  String shortUrl = item.short_url;
                  String launchUrl = "139.59.155.177:8080/$shortUrl";
                  String creationDate = date.toString().substring(0, 10);
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      //leading: FlutterLogo(size: 56.0),
                      title: Text(
                        'Created at: $creationDate',
                        style: TextStyle(
                          color: kDarkestPurpleColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      subtitle: Link(
                        child: Text(
                          'Click to launch: kisa.co/$shortUrl',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        url: '$origUrl',
                        onError: _showErrorSnackBar,
                      ),
                      trailing: Icon(
                        Icons.show_chart,
                        color: kDarkestPurpleColor,
                      ),
                      onTap: () {
                        openUrlAnalytics(_data[index].url_id);
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 80,
              margin: EdgeInsets.only(top: 0),
              child: RoundedButton(
                title: 'Log Out',
                colour: kLightPurpleColor,
                fontColor: Colors.black87,
                onPressed: () {
                  Provider.of<UserModel>(context, listen: false).logout();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                      (Route<dynamic> route) => false);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        fixedColor: kLightPurpleColor,
        items: [
          BottomNavigationBarItem(
            title: Text("Home"),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text("Analytics"),
            icon: Icon(Icons.show_chart),
          ),
          BottomNavigationBarItem(
            title: Text("Profile"),
            icon: Icon(Icons.dashboard),
          ),
        ],
        onTap: (int index) {
          setState(() {
            switch (index) {
              case 0:
                {
                  // Navigate to Dashboard
                  Navigator.pushNamed(context, AuthShortScreen.id);
                }
                break;
              case 1:
                {
                  // Navigate to Archived List
                  Navigator.pushNamed(context, AnalyticsScreen.id);
                }
                break;
              case 2:
                {
                  // Map
                  Navigator.pushNamed(context, DashboardScreen.id);
                }
                break;
              default:
                {
                  Navigator.pushNamed(context, AuthShortScreen.id);
                }
                break;
            }
          });
        },
      ),
    );
  }
}
