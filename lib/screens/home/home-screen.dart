import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:provider/provider.dart';
import 'package:untitled_goodreads_project/components/spinkit-widget.dart';
import 'package:untitled_goodreads_project/constants.dart';
import 'package:untitled_goodreads_project/controller/firestore-controller.dart';
import 'package:untitled_goodreads_project/models/book.dart';
import 'package:untitled_goodreads_project/models/quote.dart';
import 'package:untitled_goodreads_project/models/user.dart';
import 'package:untitled_goodreads_project/screens/home/components/app-bar-title.dart';
import 'package:untitled_goodreads_project/screens/home/components/circular-progress-widget.dart';
import 'package:untitled_goodreads_project/screens/home/components/date-of-today.dart';
import 'package:untitled_goodreads_project/screens/home/components/my-books-card.dart';
import 'package:untitled_goodreads_project/screens/home/components/pop-up-settings.dart';
import 'package:untitled_goodreads_project/screens/home/components/quote-card.dart';
import 'package:untitled_goodreads_project/screens/home/components/weekly-read-chart.dart';
import 'package:untitled_goodreads_project/services/auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class Item {
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final AuthService auth = AuthService();
  bool isFadeIn = false;
  var fadeController = FadeInController();
  AnimationController controller;

  Animation depthAnimation;
  Animation scaleAnimation1;
  Animation scaleAnimation2;
  Animation scaleAnimation3;
  Animation scaleAnimation4;

  @override
  void initState() {
    super.initState();

    FirestoreController().setReadCountList();

    Future.delayed(const Duration(milliseconds: 650), () {
      setState(() {
        isFadeIn = true;
      });
      fadeController.fadeIn();
    });

    controller = AnimationController(
      duration: Duration(milliseconds: 600),
      lowerBound: 0,
      vsync: this,
    );

    depthAnimation = Tween<double>(begin: -10, end: 2).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutExpo));
    scaleAnimation1 = Tween<double>(begin: 0.2, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.bounceInOut));
    scaleAnimation2 = Tween<double>(begin: 0.2, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut));
    scaleAnimation3 = Tween<double>(begin: 0.2, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOutQuad));
    scaleAnimation4 = Tween<double>(begin: 0.2, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));

    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));

    var user = Provider.of<FirebaseUser>(context);
    var size = MediaQuery.of(context).size;

    Matrix4 myMatrix = Matrix4Transform()
        .scaleBy(
            x: scaleAnimation1.value,
            y: scaleAnimation2.value,
            origin: Offset(200, 100))
        .matrix4;
    Matrix4 myMatrix2 = Matrix4Transform()
        .scaleBy(
            x: scaleAnimation1.value,
            y: scaleAnimation4.value,
            origin: Offset(100, 100))
        .matrix4;
    Matrix4 myMatrix3 = Matrix4Transform()
        .scaleBy(
            x: scaleAnimation3.value,
            y: scaleAnimation2.value,
            origin: Offset(100, 100))
        .matrix4;

    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipperOne(),
          child: Container(
            height: size.height * .52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kPrimaryColor, kSecondaryColor],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 110,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kLightBackgroundColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Neumorphic(
                            style: kNeumorphicStyle.copyWith(
                              depth: 1,
                              shape: NeumorphicShape.convex,
                              border: NeumorphicBorder(
                                  color: kLightBackgroundColor, width: 3),
                              boxShape: NeumorphicBoxShape.circle(),
                            ),
                            child: user != null
                                ? CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: CachedNetworkImage(
                                      imageUrl: user?.photoUrl,
                                      imageBuilder: (context, __) => Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.network(
                                          user?.photoUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      fadeInDuration:
                                          Duration(milliseconds: 100),
                                      placeholderFadeInDuration:
                                          Duration(microseconds: 1),
                                      placeholder: (context, _) => Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.asset(
                                          'assets/images/user_placeholder.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    radius: 25,
                                  )
                                : Container()),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(child: AppBarTitle()),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: FadeIn(
                            controller: fadeController,
                            duration: Duration(milliseconds: 800),
                            child: Text(
                              'What are we reading today?',
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
                                      color: kLightBackgroundColor,
                                      fontSize: 16),
                            ),
                          ),
                        ),
//                        Spacer(),
                      ],
                    ),
                    Spacer(),
                    PopUpSettings(
                      user: user,
                      icon: SizedBox(
                        height: 60,
                        width: 60,
                        child: FlareActor(
                          "assets/icons/profile-4.flr",
                          alignment: Alignment.center,
                          color: kLightBackgroundColor,
                          fit: BoxFit.fitHeight,
                          animation: "Untitled",
                        ),
                      ),
                    )
                  ],
                ),
              ),
//              if (isFadeIn)
              Expanded(
                child: FadingEdgeScrollView.fromScrollView(
                  child: ListView(
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    children: [
                      user != null
                          ? StreamBuilder<List<Book>>(
                              stream: FirestoreController.streamBooksByStatus(
                                  user.uid, READING),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                var books = snapshot.data;
                                return snapshot.hasData
                                    ? buildCarousel(
                                        autoPlay: true,
                                        items:
                                            books.length == 0 ? quotes : books,
                                        itemBuilder: books.length != 0
                                            ? (context, index) => Transform(
                                                  transform: myMatrix,
                                                  child: MyBooksCard(
                                                    book: books[index],
                                                    isFadeIn: isFadeIn,
                                                    animation: depthAnimation,
                                                  ),
                                                )
                                            : (context, index) => Transform(
                                                  transform: myMatrix,
                                                  child: QuoteCard(
                                                    quote: quotes[index],
                                                  ),
                                                ))
                                    : buildCarousel(
                                        autoPlay: true,
                                        items: quotes,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: EdgeInsets.only(
                                                top: 20,
                                                bottom: 20,
                                                left: 10,
                                                right: 10),
                                            child: PlaceholderCard(
                                              depthAnimation: depthAnimation,
                                              matrix: myMatrix,
                                              child: Container(
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: kLightBackgroundColor,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Looks empty.. Start reading a book?',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        .copyWith(
                                                            color:
                                                                Colors.black26,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                              })
                          : SpinkitWidget(),
                      user != null
                          ? ProgressGridView(
                              user: user,
                              matrix2: myMatrix2,
                              matrix3: myMatrix3,
                              animation: depthAnimation,
                            )
                          : Container(),
                      SizedBox(height: 20),
                      Transform(
                        transform: myMatrix,
                        child: AspectRatio(
                          aspectRatio: 1.9,
//      width: size.width * .95,
                          child: Neumorphic(
                              margin: EdgeInsets.symmetric(
                                horizontal: 20,
//                                vertical: 20,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              style: kNeumorphicStyle.copyWith(
                                boxShape: NeumorphicBoxShape.roundRect(
                                  BorderRadius.circular(25),
                                ),
                                depth: depthAnimation.value,
                              ),
                              child: WeeklyChartCard(size: size, user: user)),
                        ),
                      ),
                      SizedBox(
                        height: size.height * .02,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCarousel({
    List<dynamic> items,
    Function itemBuilder,
    bool autoPlay,
    Function onPageChanged,
  }) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: items.length,
        itemBuilder: itemBuilder,
        options: CarouselOptions(
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          enlargeCenterPage: true,
          autoPlayAnimationDuration: Duration(milliseconds: 500),
          autoPlayInterval: Duration(seconds: 10),
          autoPlayCurve: Curves.easeInOutSine,
          autoPlay: autoPlay,
          pauseAutoPlayOnManualNavigate: true,
          initialPage: 0,
          aspectRatio: 2.0,
          viewportFraction: 0.95,
          onPageChanged: onPageChanged,
        ),
      ),
    );
  }
}

class PlaceholderCard extends StatelessWidget {
  const PlaceholderCard({
    Key key,
    this.child,
    this.depthAnimation,
    this.matrix,
  }) : super(key: key);

  final Widget child;
  final Animation depthAnimation;
  final Matrix4 matrix;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: matrix,
      child: Neumorphic(
        style: kNeumorphicStyle.copyWith(
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(25),
          ),
          shadowLightColor: Colors.white70,
          depth: depthAnimation.value,
        ),
        child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kLightBackgroundColor,
            ),
            child: Center(child: child)),
      ),
    );
  }
}

class ProgressGridView extends StatelessWidget {
  const ProgressGridView({
    Key key,
    @required this.user,
    this.matrix2,
    this.matrix3,
    this.animation,
  }) : super(key: key);

  final FirebaseUser user;
  final Matrix4 matrix2;
  final Matrix4 matrix3;
  final Animation animation;

  Widget buildProgressCard(BuildContext context, String title, String subtitle,
      int goal, int current) {
    return Transform(
      transform: title == 'Today' ? matrix2 : matrix3,
      child: Neumorphic(
        padding: EdgeInsets.all(20),
        style: kNeumorphicStyle.copyWith(
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(25),
            ),
            depth: animation.value,
            shadowLightColor: Colors.white60),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 24),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontSize: 15, color: Colors.black26),
                ),
                SizedBox(height: 2),
                Expanded(
                  child: CircularProgressWidget(
                      goal: goal.toDouble(), current: current.toDouble()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: StreamBuilder<User>(
          stream: FirestoreController.streamUserData(user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            var userData = snapshot.data;
            return snapshot.hasData && userData.dailyGoal != 0
                ? GridView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: 5, bottom: 45, left: 20, right: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                    ),
                    children: [
                      buildProgressCard(
                          context,
                          'Today',
                          'pages to read',
                          userData.dailyGoal,
                          userData.weeklyReadCount[DateTime.now().weekday - 1]),
                      buildProgressCard(context, '2020', 'books to finish',
                          userData.yearlyGoal, userData.finishedBooks),
                    ],
                  )
                : GridView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: 5, bottom: 40, left: 20, right: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                    ),
                    children: [
                      PlaceholderCard(
                        depthAnimation: animation,
                        matrix: matrix2,
                        child: Text(
                          'Make time for more books in your life by setting goals',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.black26,
                              fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      PlaceholderCard(
                        depthAnimation: animation,
                        matrix: matrix2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Press this button',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.w900),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: FlareActor(
                                  "assets/icons/profile-4.flr",
                                  alignment: Alignment.center,
                                  color: Colors.black26,
//                    isPaused: isPaused,
                                  fit: BoxFit.fitHeight,
                                  animation: "Untitled",
                                ),
                              ),
                            ),
                            Text(
                              'to get started',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.w900),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
          }),
    );
  }
}

class WeeklyChartCard extends StatelessWidget {
  const WeeklyChartCard({
    Key key,
    @required this.size,
    @required this.user,
  }) : super(key: key);

  final Size size;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirestoreController.streamUserData(user?.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData && snapshot.data.dailyGoal != 0
              ? Column(
                  children: [
                    DateOfToday(),
                    SizedBox(height: 10),
                    Flexible(
                      child: WeeklyReadChart(
                        readCounts: snapshot.data.weeklyReadCount,
                        goal: snapshot.data.dailyGoal.toDouble(),
                      ),
                    ),
                  ],
                )
              : Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: kLightBackgroundColor,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 250,
                              child: Text(
                                'You can add books by scanning the barcode',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.w900),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Icon(
                              MdiIcons.barcodeScan,
                              color: Colors.black26,
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: FlareActor(
                                "assets/icons/search-4.flr",
                                alignment: Alignment.center,
                                color: Colors.black26,
//                    isPaused: isPaused,
                                fit: BoxFit.fitHeight,
                                animation: "tabbar_search",
                              ),
                            ),
                            Text(
                              '  or searching the web',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.w900),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
        });
  }
}
