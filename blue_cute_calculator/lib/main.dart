import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';

/// 配色与布局对齐仓库根目录 [计算器.html]（蓝色可爱小朋友计算器）。
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Color(0xFF87CEFA),
    ),
  );
  runApp(const BlueCalculatorApp());
}

class BlueCalculatorApp extends StatelessWidget {
  const BlueCalculatorApp({super.key});

  static const Color _bodyBg = Color(0xFF87CEFA);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '蓝色可爱小朋友计算器',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _bodyBg,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static const Color _cardBg = Color(0xFFE6F4FF);
  static const Color _shadow = Color(0xFF55A8EE);
  static const Color _numBg = Color(0xFFB3D9FF);
  static const Color _numFg = Color(0xFF0055AA);
  static const Color _opBg = Color(0xFF66B2FF);
  static const Color _clearBg = Color(0xFF3399FF);
  static const Color _equalBg = Color(0xFF0077DD);

  String _display = '';

  void _append(String c) {
    setState(() => _display += c);
  }

  void _clear() {
    setState(() => _display = '');
  }

  void _equals() {
    if (_display.isEmpty) return;
    try {
      final parser = ShuntingYardParser();
      final exp = parser.parse(_display);
      final cm = ContextModel();
      final v = exp.evaluate(EvaluationType.REAL, cm);
      if (v.isNaN || v.isInfinite) {
        setState(() => _display = '错啦');
        return;
      }
      String out;
      if (v == v.roundToDouble()) {
        out = v.round().toString();
      } else {
        out = _trimTrailingZeros(v.toString());
      }
      setState(() => _display = out);
    } catch (_) {
      setState(() => _display = '错啦');
    }
  }

  static String _trimTrailingZeros(String s) {
    if (!s.contains('.')) return s;
    var t = s.replaceFirst(RegExp(r'0+$'), '');
    if (t.endsWith('.')) t = t.substring(0, t.length - 1);
    return t;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final cardW = media.width * 0.92;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Container(
              width: cardW,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(35),
                boxShadow: const [
                  BoxShadow(
                    color: _shadow,
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Screen(
                    displayKey: const ValueKey('calc_display'),
                    text: _display,
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, c) {
                      final inner = c.maxWidth;
                      final btnW = inner * 0.22;
                      final gap = (inner - 4 * btnW) / 3;

                      Widget row(List<Widget> btns) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              btns[0],
                              SizedBox(width: gap),
                              btns[1],
                              SizedBox(width: gap),
                              btns[2],
                              SizedBox(width: gap),
                              btns[3],
                            ],
                          ),
                        );
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          row([
                            _RoundBtn(
                              label: 'C',
                              width: btnW,
                              bg: _clearBg,
                              fg: Colors.white,
                              onTap: _clear,
                            ),
                            _RoundBtn(
                              label: '÷',
                              width: btnW,
                              bg: _opBg,
                              fg: Colors.white,
                              onTap: () => _append('/'),
                            ),
                            _RoundBtn(
                              label: '×',
                              width: btnW,
                              bg: _opBg,
                              fg: Colors.white,
                              onTap: () => _append('*'),
                            ),
                            _RoundBtn(
                              label: '-',
                              width: btnW,
                              bg: _opBg,
                              fg: Colors.white,
                              onTap: () => _append('-'),
                            ),
                          ]),
                          row([
                            _RoundBtn(
                              label: '7',
                              width: btnW,
                              bg: _numBg,
                              fg: _numFg,
                              onTap: () => _append('7'),
                            ),
                            _RoundBtn(
                              label: '8',
                              width: btnW,
                              bg: _numBg,
                              fg: _numFg,
                              onTap: () => _append('8'),
                            ),
                            _RoundBtn(
                              label: '9',
                              width: btnW,
                              bg: _numBg,
                              fg: _numFg,
                              onTap: () => _append('9'),
                            ),
                            _RoundBtn(
                              label: '+',
                              width: btnW,
                              bg: _opBg,
                              fg: Colors.white,
                              onTap: () => _append('+'),
                            ),
                          ]),
                          row([
                            _RoundBtn(
                              label: '4',
                              width: btnW,
                              bg: _numBg,
                              fg: _numFg,
                              onTap: () => _append('4'),
                            ),
                            _RoundBtn(
                              label: '5',
                              width: btnW,
                              bg: _numBg,
                              fg: _numFg,
                              onTap: () => _append('5'),
                            ),
                            _RoundBtn(
                              label: '6',
                              width: btnW,
                              bg: _numBg,
                              fg: _numFg,
                              onTap: () => _append('6'),
                            ),
                            _RoundBtn(
                              label: '.',
                              width: btnW,
                              bg: _numBg,
                              fg: _numFg,
                              onTap: () => _append('.'),
                            ),
                          ]),
                          row([
                            _RoundBtn(
                              label: '1',
                              width: btnW,
                              bg: _numBg,
                              fg: _numFg,
                              onTap: () => _append('1'),
                            ),
                            _RoundBtn(
                              label: '2',
                              width: btnW,
                              bg: _numBg,
                              fg: _numFg,
                              onTap: () => _append('2'),
                            ),
                            _RoundBtn(
                              label: '3',
                              width: btnW,
                              bg: _numBg,
                              fg: _numFg,
                              onTap: () => _append('3'),
                            ),
                            _RoundBtn(
                              label: '0',
                              width: btnW,
                              bg: _numBg,
                              fg: _numFg,
                              onTap: () => _append('0'),
                            ),
                          ]),
                          const SizedBox(height: 10),
                          Center(
                            child: _EqualBtn(
                              width: inner * 0.46,
                              bg: _equalBg,
                              onTap: _equals,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Screen extends StatelessWidget {
  const _Screen({required this.displayKey, required this.text});

  final Key displayKey;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        key: displayKey,
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 42,
          color: Color(0xFF0066CC),
        ),
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  const _RoundBtn({
    required this.label,
    required this.width,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  final String label;
  final double width;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 80,
      child: Material(
        color: bg,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            SystemSound.play(SystemSoundType.click);
            HapticFeedback.lightImpact();
            onTap();
          },
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: fg,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EqualBtn extends StatelessWidget {
  const _EqualBtn({
    required this.width,
    required this.bg,
    required this.onTap,
  });

  final double width;
  final Color bg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 80,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            SystemSound.play(SystemSoundType.click);
            HapticFeedback.lightImpact();
            onTap();
          },
          child: const Center(
            child: Text(
              '等于',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
