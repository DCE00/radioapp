import 'package:flutter/material.dart';
import 'package:radioapp/constants/appcolors.dart';
import 'package:radioapp/utilities/playbutton.dart';
import 'package:audioplayers/audioplayers.dart';

//random streams
const techno = 'http://51.89.148.171/stream';
const timesRadio = 'https://timesradio.wireless.radio/stream';
const activa = 'https://stream.mediasector.es/radio/8000/activafm.mp3';

class HomeScreen extends StatefulWidget {
  final AudioPlayer player;

  const HomeScreen({Key? key, required this.player}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  bool _isOn = false;
  double _emisora = 1;
  String _sourceName = '';

  Future<void> setSource(Source source) async {
    await widget.player.setSource(source);
    await widget.player.resume();
    await widget.player.setPlaybackRate(1);
  }

  //temporal switch
  void sourceSelect(int emisora) {
    switch (emisora) {
      case 0:
        {
          setSource(UrlSource(activa));
          _sourceName = 'Activa FM';
        }
        break;

      case 1:
        {
          setSource(UrlSource(techno));
          _sourceName = 'Techno FM';
        }
        break;

      case 2:
        {
          setSource(UrlSource(timesRadio));
          _sourceName = 'Times Radio';
        }
        break;

      default:
        {
          setSource(UrlSource(activa));
          _sourceName = 'Activa FM';
        }
        break;
    }
  }

  //use of volume to avoid interfering with the stream, better radio "feeling"
  void playPause() {
    setState(() => _isOn = !_isOn);
    _isOn ? widget.player.setVolume(1.0) : widget.player.setVolume(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: AppColors().primaryColor),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 90),
              Text('Radio Station:',
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 28,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold)),
              Text('- $_sourceName',
                  style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 20,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 30,
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 50),
                  activeTickMarkColor: Colors.grey[700],
                  inactiveTickMarkColor: Colors.grey[700],
                  activeTrackColor: Colors.grey[800],
                  inactiveTrackColor: Colors.grey[800],
                ),
                child: Slider.adaptive(
                  value: _emisora,
                  min: 0,
                  max: 2,
                  divisions: 2,
                  thumbColor: Colors.pink,
                  onChanged: (double value) {
                    setState(() {
                      _emisora = value;
                    });
                    sourceSelect(_emisora.toInt());
                  },
                ),
              ),
              const SizedBox(height: 80),
              PlayButton(
                iconSize: 100,
                heightSize: 125,
                widthSize: 125,
                onPressed: () {
                  widget.player.setPlaybackRate(1);
                  sourceSelect(_emisora.toInt());
                  playPause();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
