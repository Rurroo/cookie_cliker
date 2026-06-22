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

  double playTime = 0;

  int cursorsOwned = 0;
  int cursorCps = 1;
  double cursorMult = 1;
  int cursorUpgradeOwned = 0;

  int bakersOwned = 0;
  int bakerCps = 10;
  double bakerMult = 1;
  int bakerUpgradeOwned = 0;

  int farmsOwned = 0;
  int farmCps = 100;
  double farmMult = 1;
  int farmUpgradeOwned = 0;

  int currentPageIndex = 0;

  late Timer _idleTimer;

  @override
  void initState(){
    super.initState();
    _idleTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      cookiesPerSecond = (cursorsOwned*cursorCps*cursorMult)+(bakersOwned*bakerCps*bakerMult)+(farmsOwned*farmCps*farmMult);
      idleCookie();
      playTime += 0.1;
    });
  }
  @override
  void dispose(){
    _idleTimer.cancel();
    super.dispose();
  }
  
  void idleCookie(){
    setState((){
      cookieCount += (cookiesPerSecond * cookiesPerSecondMultiplier)*0.1;
      lifetimeCookieCount += (cookiesPerSecond * cookiesPerSecondMultiplier)*0.1;
    });
  }
  void clickCookie() {
    setState(() {
      cookieCount += (cookiesPerClick * cookiesPerClickMultiplier);
      lifetimeCookieCount += (cookiesPerClick * cookiesPerClickMultiplier);
    });
  }
  int buyBuilding(int cost,int amountOwned){
    if(cookieCount >= cost+(cost*amountOwned*0.2) && amountOwned < 50){
      setState(() {
        amountOwned++;
        cookieCount -= cost+(cost*amountOwned*0.2);
      });
    }
    return amountOwned;
  }
  dynamic upgradeBuilding(int cost,int upgradeOwned,double mult){
    if(cookieCount >= cost && upgradeOwned == 0){
      setState(() {
        upgradeOwned = 1;
        cookieCount -= cost;
        mult++;
      });
    }
    return (upgradeOwned,mult);
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
              Card(
                child: Row(
                  children: [
                    Expanded(
                      child:ListTile(
                        leading: Icon(Icons.pan_tool_alt),
                        title: Text("Cursor"),
                        subtitle: Text("Cps: ${(cursorCps*cursorMult.round())}  Owned:$cursorsOwned Cost:${(25+25*cursorsOwned*0.2).round()}"),
                      )
                    ),
                    IconButton(
                        onPressed:(){cursorsOwned = buyBuilding(25, cursorsOwned);}, 
                        icon: Icon(Icons.add),)
                  ],
                ),
              ),
              Card(
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: Icon(Icons.bakery_dining),
                        title: Text("Baker"),
                        subtitle: Text("Cps: ${(bakerCps*bakerMult).round()} Owned:$bakersOwned Cost:${(150+150*bakersOwned*0.2).round()}"),
                      ),
                    ),
                    IconButton(
                      onPressed:(){bakersOwned = buyBuilding(125, bakersOwned);},
                      icon: Icon(Icons.add),)
                  ],
                )
              ),
              Card(
                child: Row(
                  children: [
                    Expanded(
                      child:ListTile(
                        leading: Icon(Icons.agriculture),
                        title: Text("Farm"),
                        subtitle: Text("Cps: ${(farmCps*farmMult).round()} Owned:$farmsOwned Cost:${(1000+1000*farmsOwned*0.2).round()}"),
                      )
                    ),
                    IconButton(
                      onPressed:(){farmsOwned = buyBuilding(1000, farmsOwned);},
                      icon: Icon(Icons.add),)
                  ],
                ),
              ),
            ],
          ),
        )
      ),
      //Upgrades screen
      Padding(
        padding: const EdgeInsets.only(top:75),
        child: Center(
          child: Column(
            children: [
              Text("UPGRADES",style: Theme.of(context).textTheme.headlineLarge),
              Card(
                child: Row(
                  children: [
                    Expanded(
                      child:ListTile(
                        leading: Icon(Icons.pan_tool_alt),
                        title: Text("Cursor Upgrade"),
                        subtitle: Text("Double Cursor Cps Cost: 1000"),
                      )
                    ),
                    IconButton(
                        onPressed:(){var result = upgradeBuilding(1000, cursorUpgradeOwned, cursorMult); cursorUpgradeOwned = result.$1; cursorMult = result.$2;}, 
                        icon: Icon(Icons.add),)
                  ],
                ),
              ),
              Card(
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        leading: Icon(Icons.bakery_dining),
                        title: Text("Baker Upgrade"),
                        subtitle: Text("Double Baker Cps Cost: 5000"),
                      ),
                    ),
                    IconButton(
                      onPressed:(){var result = upgradeBuilding(5000, bakerUpgradeOwned, bakerMult); bakerUpgradeOwned = result.$1; bakerMult = result.$2;},
                      icon: Icon(Icons.add),)
                  ],
                )
              ),
              Card(
                child: Row(
                  children: [
                    Expanded(
                      child:ListTile(
                        leading: Icon(Icons.agriculture),
                        title: Text("Far Upgrade"),
                        subtitle: Text("Double Farm Cps Cost: 10000"),
                      )
                    ),
                    IconButton(
                      onPressed:(){var result = upgradeBuilding(10000, farmUpgradeOwned, farmMult); farmUpgradeOwned = result.$1; farmMult = result.$2;},
                      icon: Icon(Icons.add),)
                  ],
                ),
              ),
            ],
          ),
        )
      ),
      //Stats screen
      Padding(
        padding: const EdgeInsets.only(top:100),
        child: Center(
          child: Text(
            "heyheyhey\nLifetime cockies:${lifetimeCookieCount.round()}\nplaytime:${playTime.floor()}s",
            style: Theme.of(context).textTheme.headlineMedium
            ),
          ),
        ),
      ][currentPageIndex]
    );
  }
}
