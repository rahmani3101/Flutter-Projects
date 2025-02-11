import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CountdownTimerApp());
}

class CountdownTimerApp extends StatelessWidget {
  const CountdownTimerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown Timer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      ),
      home: const CountdownTimerPage(),
    );
  }
}

class CountdownTimerPage extends StatefulWidget {
  const CountdownTimerPage({Key? key}) : super(key: key);

  @override
  _CountdownTimerPageState createState() => _CountdownTimerPageState();
}

class _CountdownTimerPageState extends State<CountdownTimerPage>
    with SingleTickerProviderStateMixin {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  Timer? _timer;
  bool _isRunning = false;
  int _totalSeconds = 0;
  int _remainingSeconds = 0;
  late AnimationController _controller;
  bool _isSoundEnabled = true;
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_remainingSeconds > 0 && !_isRunning) {
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
            _updateTimeValues();
            _progress = _remainingSeconds / _totalSeconds;
            _controller.forward(from: 0);
          } else {
            _timer?.cancel();
            _isRunning = false;
            _progress = 0;
            if (_isSoundEnabled) {
              SystemSound.play(SystemSoundType.alert);
              HapticFeedback.heavyImpact();
            }
          }
        });
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _totalSeconds;
      _progress = 1.0;
      _updateTimeValues();
    });
  }

  void _updateTimeValues() {
    _hours = _remainingSeconds ~/ 3600;
    _minutes = (_remainingSeconds % 3600) ~/ 60;
    _seconds = _remainingSeconds % 60;
  }

  void _setTime(int hours, int minutes, int seconds) {
    setState(() {
      _totalSeconds = hours * 3600 + minutes * 60 + seconds;
      _remainingSeconds = _totalSeconds;
      _progress = 1.0;
      _updateTimeValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 177, 25, 207),
              const Color.fromARGB(255, 85, 15, 15),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimeSetters(),
                    const SizedBox(height: 40),
                    _buildTimerDisplay(),
                    const SizedBox(height: 40),
                    _buildControls(),
                    if (_remainingSeconds == 0 &&
                        !_isRunning &&
                        _totalSeconds > 0)
                      _buildTimeUpMessage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Countdown Timer',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(
              _isSoundEnabled ? Icons.volume_up : Icons.volume_off,
              color: _isSoundEnabled ? Colors.indigo.shade300 : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isSoundEnabled = !_isSoundEnabled;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSetters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTimeInput('Hours', _hours, (value) {
            if (value >= 0 && value <= 23) {
              _setTime(value, _minutes, _seconds);
            }
          }),
          _buildTimeInput('Minutes', _minutes, (value) {
            if (value >= 0 && value <= 59) {
              _setTime(_hours, value, _seconds);
            }
          }),
          _buildTimeInput('Seconds', _seconds, (value) {
            if (value >= 0 && value <= 59) {
              _setTime(_hours, _minutes, value);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildTimeInput(String label, int value, Function(int) onChanged) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.indigo.shade200,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigo.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: !_isRunning ? () => onChanged(value + 1) : null,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.2),
                    ),
                    child: Text(
                      value.toString().padLeft(2, '0'),
                      style: const TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: !_isRunning ? () => onChanged(value - 1) : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 280,
          height: 280,
          child: CircularProgressIndicator(
            value: _progress,
            strokeWidth: 12,
            backgroundColor: Colors.indigo.shade900,
            valueColor: AlwaysStoppedAnimation<Color>(
              _isRunning ? Colors.indigo.shade300 : Colors.grey,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.black26,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Text(
            '${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w300,
              letterSpacing: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildControlButton(
            onPressed: _startTimer,
            icon: Icons.play_arrow,
            color: Colors.green,
            isEnabled: !_isRunning && _remainingSeconds > 0,
          ),
          const SizedBox(width: 20),
          _buildControlButton(
            onPressed: _stopTimer,
            icon: Icons.pause,
            color: Colors.orange,
            isEnabled: _isRunning,
          ),
          const SizedBox(width: 20),
          _buildControlButton(
            onPressed: _resetTimer,
            icon: Icons.refresh,
            color: Colors.red,
            isEnabled: _remainingSeconds != _totalSeconds || _isRunning,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required bool isEnabled,
  }) {
    return Container(
      decoration: BoxDecoration(
        color:
            isEnabled ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(50),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(50),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Icon(
              icon,
              size: 36,
              color: isEnabled ? color : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeUpMessage() {
    return AnimatedOpacity(
      opacity: _remainingSeconds == 0 ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.indigo.shade300.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 98, 115, 211).withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          'Time\'s Up!',
          style: TextStyle(
            fontSize: 24,
            color: Colors.indigo.shade300,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
