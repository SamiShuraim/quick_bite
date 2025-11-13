import 'package:flutter/material.dart';

import 'login_page.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _controller = PageController();
  int _index = 0;

  final _pages = const [
    ('Browse great dishes', 'Get all your loved foods in one place.'),
    ('Order from chosen chef', 'Pick your favorites and relax.'),
    ('Exclusive deals', 'Unlock promos and save more.'),
    ('Free delivery offers', 'Enjoy free delivery anytime.'),
  ];

  bool get _isLast => _index == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) {
                    final (title, body) = _pages[i];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          height: 220,
                          width: double.infinity,
                          color: Colors.blueGrey.shade300,
                        ),
                        const SizedBox(height: 40),
                        Text(title,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text(body,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black54, height: 1.4)),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_pages.length, (dot) {
                            final active = dot == _index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: active
                                    ? Colors.orange
                                    : Colors.orange.withOpacity(0.3),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_isLast) {
                      _goToLogin();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: Text(_isLast ? 'GET STARTED' : 'NEXT'),
                ),
              ),
              const SizedBox(height: 12),
              if (!_isLast)
                TextButton(
                  onPressed: _goToLogin,
                  child: const Text('Skip', style: TextStyle(color: Colors.black54)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


