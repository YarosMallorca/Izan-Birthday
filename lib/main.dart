import 'dart:math';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'dart:html' as html;

void main() {
  runApp(const EthanBirthday());
}

class EthanBirthday extends StatelessWidget {
  const EthanBirthday({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
            colorSchemeSeed: Colors.lightGreen, brightness: Brightness.dark),
        themeMode: ThemeMode.dark,
        home: const Scaffold(body: SafeArea(child: IsanScreen())),
      );
}

class IsanScreen extends StatefulWidget {
  const IsanScreen({super.key});

  @override
  State<IsanScreen> createState() => IsanScreenState();
}

enum LocationState { sike, unknown }

class IsanScreenState extends State<IsanScreen> with TickerProviderStateMixin {
  final int _numberOfIsans = 11; // Number of the images in the background
  final _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));
  late final _controllers = List.generate(
      _numberOfIsans,
      (index) => AnimationController(
          vsync: this, duration: const Duration(seconds: 2)));

  late final _animations = List.generate(
      _numberOfIsans,
      (index) => CurvedAnimation(
          parent: _controllers[index], curve: Curves.easeInOut));

  LocationState _locationState = LocationState.unknown;

  @override
  void initState() {
    super.initState();
    for (var controller in _controllers) {
      Future.delayed(
          Duration(milliseconds: _controllers.indexOf(controller) * 200),
          () => controller.repeat(reverse: true));
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    _confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          AnimateGradient(
            duration: const Duration(seconds: 1),
            primaryColors: [
              Colors.black,
              Colors.grey[800]!,
            ],
            secondaryColors: [Colors.grey[800]!, Colors.black],
            child: StaggeredGrid.count(
              crossAxisCount: 3,
              children: List.generate(
                _numberOfIsans,
                (index) => StaggeredGridTile.count(
                  mainAxisCellCount: Random().nextInt(2) + 1,
                  crossAxisCellCount: 1,
                  child: RotationTransition(
                    turns: _animations[index],
                    child: GestureDetector(
                      child: Image.asset(
                        'assets/isan${index + 1}.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                color: Colors.black.withOpacity(0.3),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            FittedBox(
                              child: GestureDetector(
                                onTap: () => html.window.open(
                                  "https://photos.app.goo.gl/cJHd1MYxJJNafzRm6",
                                  '_blank',
                                ),
                                child: const Text(
                                  "Feliz Cumple, Izan!!!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            AnimatedTextKit(animatedTexts: [
                              TypewriterAnimatedText("age++;",
                                  speed: const Duration(milliseconds: 80),
                                  textAlign: TextAlign.center,
                                  textStyle: const TextStyle(fontSize: 32))
                            ]),
                            const SizedBox(height: 20),
                            StatefulBuilder(builder: (context, setState) {
                              if (_locationState == LocationState.unknown) {
                                return Container(
                                  width: 300,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.85),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(Icons.location_pin,
                                                color: Colors.blue),
                                            Text(
                                              "Nadal quiere saber tu IP",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () => setState(() {
                                                _locationState =
                                                    LocationState.sike;
                                              }),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      WidgetStateProperty.all(
                                                          Colors.white),
                                                  backgroundColor:
                                                      WidgetStateProperty.all(
                                                          Colors.blue),
                                                  padding:
                                                      WidgetStateProperty.all(
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 24,
                                                              vertical: 12))),
                                              child: const Text("Aceptar"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => setState(() {
                                                _locationState =
                                                    LocationState.sike;
                                              }),
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                      WidgetStateProperty.all(
                                                          Colors.white),
                                                  backgroundColor:
                                                      WidgetStateProperty.all(
                                                          Colors.red),
                                                  padding:
                                                      WidgetStateProperty.all(
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 24,
                                                              vertical: 12))),
                                              child: const Text("Rechazar"),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                    width: 300,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.85),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Center(
                                      child: FutureBuilder<Response>(
                                          future:
                                              get(Uri.https('api.ipify.org')),
                                          builder: (context, ipSnapshot) {
                                            if (ipSnapshot.hasData &&
                                                ipSnapshot.data!.statusCode ==
                                                    200) {
                                              return FutureBuilder<int>(
                                                  future:
                                                      Battery().batteryLevel,
                                                  builder: (context,
                                                      batterySnapshot) {
                                                    String text =
                                                        "Jajaja, que te esperabas? Tu IP es ${ipSnapshot.data!.body}";
                                                    if (batterySnapshot
                                                        .hasData) {
                                                      text +=
                                                          ", y que haces con un ${batterySnapshot.data}% de batería?";
                                                    }
                                                    return Stack(children: [
                                                      const BouncingTeacher(
                                                          startX: 10,
                                                          startY: 50,
                                                          asset: 'nadal.jpg',
                                                          containerWidth: 300,
                                                          containerHeight: 200),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          text,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ]);
                                                  });
                                            }
                                            return const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                              ),
                                            );
                                          }),
                                    ));
                              }
                            }),
                            const SizedBox(height: 20),
                            Container(
                              color: Colors.black.withOpacity(0.85),
                              child: const BouncingTeacher(
                                  startX: 100,
                                  startY: 50,
                                  asset: 'paye.png',
                                  containerWidth: 300,
                                  containerHeight: 200),
                            ),
                            const SizedBox(height: 20),
                            const FittedBox(
                              child: Text(
                                  "Izan, por favor, aprende Python este verano ;)",
                                  style: TextStyle(
                                      fontSize: 32,
                                      color: Colors.white,
                                      shadows: [
                                        BoxShadow(
                                            blurRadius: 10, color: Colors.black)
                                      ])),
                            ),
                            const Opacity(
                              opacity: 0.5,
                              child: Text(
                                  "Ah, y no violes más hello kitties, que Adri te mata"),
                            ),
                          ],
                        ),
                        const Text("Hecho con ❤️ por Yaros",
                            style: TextStyle(fontSize: 16, color: Colors.white))
                      ]),
                )),
          ),
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
                numberOfParticles: 200,
                minimumSize: const Size(5, 5),
                maximumSize: const Size(20, 20),
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ],
                confettiController: _confettiController),
          ),
        ],
      ),
    );
  }
}

/// Bouncing Paye Widget
class BouncingTeacher extends StatefulWidget {
  const BouncingTeacher(
      {super.key,
      required this.startX,
      required this.startY,
      required this.asset,
      required this.containerWidth,
      required this.containerHeight});

  final double startX;
  final double startY;
  final String asset;

  final double containerWidth;
  final double containerHeight;

  @override
  State<BouncingTeacher> createState() => _BouncingTeacherState();
}

class _BouncingTeacherState extends State<BouncingTeacher>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dx = 2.0;
  double _dy = 2.0;
  double _xPos = 0.0;
  double _yPos = 0.0;

  final double _imageHeight = 60, _imageWidth = 60;

  Color _overlayColor = Colors.red;

  final Random _random = Random();

  @override
  void initState() {
    _xPos = widget.startX;
    _yPos = widget.startY;
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100))
      ..addListener(() {
        setState(() {
          _xPos += _dx;
          _yPos += _dy;

          if ((_xPos >= widget.containerWidth - _imageWidth || _xPos <= 0) &&
              (_yPos >= widget.containerHeight - _imageHeight || _yPos <= 0)) {
            _dx = -_dx;
            _dy = -_dy;
            _overlayColor = Color.fromRGBO(_random.nextInt(256),
                _random.nextInt(256), _random.nextInt(256), 1.0);
          } else if (_xPos >= widget.containerWidth - _imageWidth ||
              _xPos <= 0) {
            _dx = -_dx;
            _overlayColor = Color.fromRGBO(_random.nextInt(256),
                _random.nextInt(256), _random.nextInt(256), 1.0);
          } else if (_yPos >= widget.containerHeight - _imageHeight ||
              _yPos <= 0) {
            _dy = -_dy;
            _overlayColor = Color.fromRGBO(_random.nextInt(256),
                _random.nextInt(256), _random.nextInt(256), 1.0);
          }
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.containerWidth,
      height: widget.containerHeight,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: _xPos,
            top: _yPos,
            child: ClipRRect(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    _overlayColor.withOpacity(0.7), BlendMode.multiply),
                child: GestureDetector(
                  onTap: () =>
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(milliseconds: 1200),
                    content: const Text("Bro no me pegues"),
                    action: SnackBarAction(
                        label: "ME DA IGUAL",
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        onPressed: () => html.window
                            .open("https://youtu.be/dQw4w9WgXcQ", "_blank")),
                  )),
                  child: Image.asset(
                    'assets/${widget.asset}',
                    width: _imageWidth,
                    height: _imageHeight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
