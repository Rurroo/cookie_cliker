import 'package:flutter/material.dart';
import "dart:async";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 141, 101, 26)),
      ),
      home: const MyHomePage(title: 'Cool Flutter App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double cookieCount = 0;
  double lifetimeCookieCount = 0;
  double cookiesPerSecond = 0;
  double cookiesPerSecondMultiplier = 1;
  double cookiesPerClick = 1;
  double cookiesPerClickMultiplier = 1;

  int playTime = 0;

  int cursorsOwned = 0;
  int bakersOwned = 0;
  int farmsOwned = 0;

  int currentPageIndex = 0;

  late Timer _idleTimer;

  @override
  void initState(){
    super.initState();
    _idleTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      idleCookie();
      playTime++;
    });
  }
  @override
  void dispose(){
    _idleTimer.cancel();
    super.dispose();
  }
  
  void idleCookie(){
    setState((){
      cookieCount += (cookiesPerSecond * cookiesPerSecondMultiplier);
      lifetimeCookieCount += (cookiesPerSecond * cookiesPerSecondMultiplier);
    });
  }
  void clickCookie() {
    setState(() {
      cookieCount += (cookiesPerClick * cookiesPerClickMultiplier);
      lifetimeCookieCount += (cookiesPerClick * cookiesPerClickMultiplier);
    });
  }
  int buyBuilding(double cps,int cost,int amountOwned){
    if(cookieCount >= cost+(cost*amountOwned*0.2) && amountOwned < 50){
      setState(() {
        cookiesPerSecond += cps;
        cookieCount -= cost+(cost*amountOwned*0.2);
        amountOwned++;
      });
    }
    return amountOwned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index){
          setState((){
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.cookie),
            label: 'Cookie',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront),
            label: 'Buildings',
          ),
          NavigationDestination(
            icon: Icon(Icons.upgrade),
            label: 'Upgrades',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          )
        ],
      ),
      body: <Widget>[
        //Cookie Screen
        Padding(
        padding: const EdgeInsets.only(top:185),
        child: Center(
          child: Column(
            mainAxisAlignment: .start,
            children: [
              Text(
                '${cookieCount.round()} cockies',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "per second: ${(cookiesPerSecond*cookiesPerSecondMultiplier).round()}",
              ),
              Padding(padding: const EdgeInsets.only(top:65)),
              IconButton(
                icon: Icon(Icons.cookie),
                iconSize: 300,
                onPressed: clickCookie,
              )
            ],
          ),
        ),
      ),
      //Buildings screen
      Padding(
        padding: const EdgeInsets.only(top:75),
        child: Center(
          child: Column(
            children: [
              Text("BUILDINGS",style: Theme.of(context).textTheme.headlineLarge),
              InkWell(
                onTap:(){
                  cursorsOwned = buyBuilding(1, 25, cursorsOwned);
                },
                child:Card(
                  child:ListTile(
                    leading: Icon(Icons.pan_tool_alt),
                    title: Text("Cursor"),
                    subtitle: Text("Cps: 1  Owned:$cursorsOwned Cost:${(25+25*cursorsOwned*0.2).round()}"),
                  )
                ),
              ),
              InkWell(
                onTap:(){
                  bakersOwned = buyBuilding(10, 150, bakersOwned);
                },
                child:Card(
                  child:ListTile(
                    leading: Icon(Icons.bakery_dining),
                    title: Text("Baker"),
                    subtitle: Text("Cps: 10 Owned:$bakersOwned Cost:${(150+150*bakersOwned*0.2).round()}"),
                  )
                ),
              ),
              InkWell(
                onTap:(){
                  farmsOwned = buyBuilding(50, 1000, farmsOwned);
                },
                child:Card(
                  child:ListTile(
                    leading: Icon(Icons.agriculture),
                    title: Text("Farm"),
                    subtitle: Text("Cps: 50 Owned:$farmsOwned Cost:${(1000+1000*farmsOwned*0.2).round()}"),
                  )
                ),
              ),
            ],
          ),
        )
      ),
      //Upgrades screen
      Padding(
        padding: const EdgeInsets.only(top:100),
        child: Text("sup"),
      ),
      //Stats screen
      Padding(
        padding: const EdgeInsets.only(top:100),
        child: Center(
          child: Text(
            "heyheyhey\nLifetime cockies:${lifetimeCookieCount.round()}\nplaytime:${playTime}s",
            style: Theme.of(context).textTheme.headlineMedium
            ),
          ),
        ),
      ][currentPageIndex]
    );
  }
}
