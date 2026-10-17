import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dev_utils/dev_models.dart';

class DevCheatsheetsScreen extends StatelessWidget {
  const DevCheatsheetsScreen({super.key});

  final List<Map<String, String>> _gitCommands = const [
    {'cmd': 'git status', 'desc': 'Check modified and staged files status'},
    {'cmd': 'git add .', 'desc': 'Stage all modified changes for commit'},
    {'cmd': 'git commit -m "feat: initial commit"', 'desc': 'Commit staged changes with message'},
    {'cmd': 'git push origin main', 'desc': 'Push local commits to remote repository'},
    {'cmd': 'git checkout -b feature/new-branch', 'desc': 'Create and switch to a new branch'},
  ];

  final List<Map<String, String>> _httpCodes = const [
    {'code': '200 OK', 'desc': 'Standard response for successful HTTP requests'},
    {'code': '201 Created', 'desc': 'Request fulfilled and new resource created'},
    {'code': '400 Bad Request', 'desc': 'Server cannot process request due to client error'},
    {'code': '401 Unauthorized', 'desc': 'Authentication required or invalid credentials'},
    {'code': '404 Not Found', 'desc': 'Requested resource could not be found on server'},
    {'code': '500 Internal Server Error', 'desc': 'Generic server error response'},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Developer Cheat Sheets'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Git Cheatsheet'),
              Tab(text: 'HTTP Codes'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Git Cheatsheet
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                devHero('Git Commands Reference', 'Essential Git version control commands for daily workflow', Colors.deepOrange, Icons.fork_right),
                const SizedBox(height: 16),
                ..._gitCommands.map((item) => Card(
                      child: ListTile(
                        title: Text(item['cmd']!, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, color: Colors.blue)),
                        subtitle: Text(item['desc']!),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: item['cmd']!));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['cmd']} copied!')));
                          },
                        ),
                      ),
                    )),
              ],
            ),

            // Tab 2: HTTP Status Codes
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                devHero('HTTP Status Codes', 'REST API response status code meanings and guides', Colors.teal, Icons.http),
                const SizedBox(height: 16),
                ..._httpCodes.map((item) => Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item['code']!.startsWith('2') ? Colors.green : Colors.red.shade100,
                          child: Text(item['code']!.split(' ')[0], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(item['code']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item['desc']!),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
