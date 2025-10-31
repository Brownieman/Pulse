import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'screens/chat_screen.dart';
import 'screens/messages_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'firebase_options.dart';
// import 'home_screen.dart';
import 'models/contact.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'screens/auth_screen.dart';
import 'home_screen.dart';
import 'routes/app_pages.dart';
import 'controllers/auth_controller.dart';
import 'controllers/chat_theme_controller.dart';
import 'controllers/main_controller.dart';
import 'controllers/theme_controller.dart';
import 'utils/app_theme.dart';

// Trust Score Section for Dashboard
class _TrustScoreSection extends StatelessWidget {
  final int score;
  final int tier;
  const _TrustScoreSection({required this.score, required this.tier});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16232C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F2C36)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trust Score',
              style: textTheme.titleMedium
                  ?.copyWith(color: const Color(0xFFBFD1DF))),
          const SizedBox(height: 12),
          Text('$score',
              style: textTheme.displaySmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Tier $tier',
              style: textTheme.titleMedium
                  ?.copyWith(color: const Color(0xFF7F95A8))),
        ],
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock orientation to portrait for better mobile UX
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style for Android status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  await Supabase.initialize(
    url: 'https://qmugitnuxgzausbeexhs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFtdWdpdG51eHd6YXVzYmVleGhzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0NzkzMDcsImV4cCI6MjA3NzA1NTMwN30.JbDRJ6rKQM0euPOd1zwvKpBJqCiUF0rXisY_hWbIwiA',
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NewTaskManageApp());
}

// Domain models & state
enum TaskStatus { open, done, missed }

class Task {
  Task({required this.id, required this.title, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();

  final String id;
  final String title;
  DateTime? deadline;
  final DateTime createdAt;
  DateTime? completedAt;
  TaskStatus status = TaskStatus.open;
  final List<String> proofs = <String>[];
  final List<String> notes = <String>[];
}

class ChatMessage {
  ChatMessage({required this.text, required this.isUser, DateTime? at})
      : at = at ?? DateTime.now();

  final String text;
  final bool isUser;
  final DateTime at;
}

class AppState extends ChangeNotifier {
  void reset() {
    tasks.clear();
    messages.clear();
    trustScore = 600;
    focusMode = false;
    notifyListeners();
  }

  final List<Task> tasks = <Task>[];
  final List<ChatMessage> messages = <ChatMessage>[];
  int trustScore = 600; // 0..1000
  bool focusMode = false;

  static const int scoreEarly = 15;
  static const int scoreOnTime = 10;
  static const int scoreLate = -5;
  static const int scoreMissed = -10;
  static const int scoreVouch = 5;
  static const int scoreRehab = 3;

  void bootstrapDemoData() {
    addSystemMessage('Welcome to TaskChain Messenger — Prompt-Based Edition.');
    addSystemMessage('Type /help for available commands.');
  }

  void addSystemMessage(String text) {
    messages.add(ChatMessage(text: text, isUser: false));
    notifyListeners();
  }

  void addUserMessage(String text) {
    messages.add(ChatMessage(text: text, isUser: true));
    notifyListeners();
  }

  String get tier {
    if (trustScore >= 850) return 'Elite';
    if (trustScore >= 700) return 'Pro';
    if (trustScore >= 550) return 'Rising';
    return 'Novice';
  }

  int get tierLevel {
    if (trustScore >= 850) return 3;
    if (trustScore >= 700) return 2;
    if (trustScore >= 550) return 1;
    return 0;
  }

  Task createTask(String title) {
    final task = Task(id: (tasks.length + 1).toString(), title: title);
    tasks.add(task);
    notifyListeners();
    return task;
  }

  String setDeadline(String idOrLast, DateTime when) {
    final task = idOrLast.toLowerCase() == 'last'
        ? (tasks.isNotEmpty ? tasks.last : null)
        : tasks.cast<Task?>().firstWhere(
              (t) => t!.id == idOrLast,
              orElse: () => null,
            );
    if (task == null) return 'No matching task to set deadline.';
    task.deadline = when;
    notifyListeners();
    return 'Deadline set for task #${task.id} at ${when.toLocal()}';
  }

  String addProof(String taskId, String proof) {
    final task = tasks.where((t) => t.id == taskId).cast<Task?>().firstOrNull;
    if (task == null) return 'Task not found.';
    task.proofs.add(proof);
    notifyListeners();
    return 'Proof added to task #${task.id}.';
  }

  String markDone(String taskId) {
    final task = tasks.where((t) => t.id == taskId).cast<Task?>().firstOrNull;
    if (task == null) return 'Task not found.';
    final now = DateTime.now();
    task.completedAt = now;
    if (task.deadline == null || now.isBefore(task.deadline!)) {
      final delta = task.deadline == null
          ? scoreOnTime
          : now.isBefore(task.deadline!.subtract(const Duration(hours: 1)))
              ? scoreEarly
              : scoreOnTime;
      trustScore = (trustScore + delta).clamp(0, 1000);
      task.status = TaskStatus.done;
      notifyListeners();
      return 'Task #${task.id} completed. Trust +$delta.';
    } else {
      trustScore = (trustScore + scoreLate).clamp(0, 1000);
      task.status = TaskStatus.done;
      notifyListeners();
      return 'Task #${task.id} completed after deadline. Trust $scoreLate.';
    }
  }

  void evaluateMisses() {
    final now = DateTime.now();
    for (final t in tasks) {
      if (t.status == TaskStatus.open &&
          t.deadline != null &&
          now.isAfter(t.deadline!)) {
        t.status = TaskStatus.missed;
        trustScore = (trustScore + scoreMissed).clamp(0, 1000);
      }
    }
    notifyListeners();
  }

  String appeal(String taskId, String reason) {
    final task = tasks.where((t) => t.id == taskId).cast<Task?>().firstOrNull;
    if (task == null) return 'Task not found for appeal.';
    task.notes.add('Appeal: $reason');
    notifyListeners();
    return 'Appeal submitted for task #${task.id}. Reviewed within 24h.';
  }

  String rehab(String commitment) {
    trustScore = (trustScore + scoreRehab).clamp(0, 1000);
    notifyListeners();
    return 'Rehab plan recorded: "$commitment". Trust +$scoreRehab.';
  }

  String vouch(String handle, String note) {
    trustScore = (trustScore + scoreVouch).clamp(0, 1000);
    notifyListeners();
    return 'Vouch recorded from $handle: $note. Trust +$scoreVouch.';
  }

  String toggleFocus([String? arg]) {
    focusMode = !focusMode;
    notifyListeners();
    return focusMode
        ? 'Focus Mode ON. Notifications minimized.'
        : 'Focus Mode OFF.';
  }

  List<String> scanUpcomingDeadlines() {
    final now = DateTime.now();
    final List<String> notes = <String>[];
    for (final t in tasks) {
      if (t.status == TaskStatus.open && t.deadline != null) {
        final diff = t.deadline!.difference(now);
        if (diff <= const Duration(hours: 1) && diff.isNegative == false) {
          notes.add(
              'Warning: Task #${t.id} "${t.title}" due in ${diff.inMinutes}m.');
        }
      }
    }
    return notes;
  }

  int get openCount => tasks.where((t) => t.status == TaskStatus.open).length;
  List<double> get weeklyCompletionSeries {
    final comp = tasks.where((t) => t.status == TaskStatus.done).length;
    return List<double>.generate(
        12, (i) => (((comp + i) % 10) / 10.0).clamp(0.1, 0.95));
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

// Command processor
class CommandProcessor {
  CommandProcessor(this.state);
  final AppState state;

  List<String> handle(String input) {
    final text = input.trim();
    if (!text.startsWith('/')) {
      return ['Message noted. Convert it to a task with /task <title>.'];
    }
    final parts = text.split(RegExp(r'\s+'));
    final cmd = parts.first.toLowerCase();
    final args = parts.skip(1).toList();

    switch (cmd) {
      case '/help':
        return [
          'Commands: /task <title>, /deadline <id|last> <YYYY-MM-DD HH:mm>, /done <id>, /proof <id> <text>, /appeal <id> <reason>, /rehab <plan>, /vouch <@user> <note>, /focus'
        ];
      case '/task':
        if (args.isEmpty) return ['Usage: /task <title>'];
        final t = state.createTask(args.join(' '));
        return [
          'Task #${t.id} created: "${t.title}". Set a deadline with /deadline ${t.id} <time>.'
        ];
      case '/deadline':
        if (args.length < 2) {
          return ['Usage: /deadline <id|last> <YYYY-MM-DD HH:mm>'];
        }
        final idOrLast = args.first;
        final whenStr = args.skip(1).join(' ');
        final when = DateTime.tryParse(whenStr.replaceFirst(' ', 'T'));
        if (when == null) return ['Invalid date. Example: 2025-09-17 17:30'];
        return [state.setDeadline(idOrLast, when)];
      case '/done':
        if (args.isEmpty) return ['Usage: /done <id>'];
        state.evaluateMisses();
        return [state.markDone(args.first)];
      case '/proof':
        if (args.length < 2) return ['Usage: /proof <id> <url|note>'];
        final id = args.first;
        final proof = args.skip(1).join(' ');
        return [state.addProof(id, proof)];
      case '/appeal':
        if (args.length < 2) return ['Usage: /appeal <id> <reason>'];
        return [state.appeal(args.first, args.skip(1).join(' '))];
      case '/rehab':
        if (args.isEmpty) return ['Usage: /rehab <commitment>'];
        return [state.rehab(args.join(' '))];
      case '/vouch':
        if (args.length < 2) return ['Usage: /vouch <@user> <note>'];
        return [state.vouch(args.first, args.skip(1).join(' '))];
      case '/focus':
        return [state.toggleFocus(args.isEmpty ? null : args.first)];
      default:
        return ['Unknown command. Type /help'];
    }
  }
}

// Root shell with bottom nav
class RootShell extends StatefulWidget {
  const RootShell({super.key, required this.state});
  final AppState state;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildChatArea(),
    );
  }

  int index = 1;
  List<Contact> contacts = [];
  bool contactsLoaded = false;
  Contact? selectedContact;

  @override
  void initState() {
    super.initState();
    _requestAndLoadContacts();
  }

  Future<void> _requestAndLoadContacts() async {
    final status = await Permission.contacts.request();
    if (status.isGranted) {
      final deviceContacts =
          await fc.FlutterContacts.getContacts(withProperties: true);
      setState(() {
        contacts = deviceContacts
            .map((c) => Contact(
                  name: c.displayName,
                  avatarUrl: 'assets/images/contact.png',
                  phone: c.phones.isNotEmpty ? c.phones.first.number : '',
                  email: c.emails.isNotEmpty ? c.emails.first.address : '',
                ))
            .toList();
        contactsLoaded = true;
      });
    }
  }

  Widget _buildChatArea() {
    // Use MessagesScreen as the main chat/messages area
    return const MessagesScreen();
  }

  // _formatTime now handled in ChatListScreen
}

// Chat screen
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.state});
  final AppState state;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scroll = ScrollController();

  void _submit() {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    widget.state.addUserMessage(text);
    final replies = CommandProcessor(widget.state).handle(text);
    for (final r in replies) {
      widget.state.addSystemMessage(r);
    }
    controller.clear();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        if (widget.state.focusMode)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF153040),
            child: const Text(
                'Focus Mode: Distractions muted. Type /focus to exit.'),
          ),
        Expanded(
          child: ListView.builder(
            controller: scroll,
            padding: const EdgeInsets.all(16),
            itemCount: widget.state.messages.length,
            itemBuilder: (context, i) {
              final m = widget.state.messages[i];
              final align =
                  m.isUser ? Alignment.centerRight : Alignment.centerLeft;
              final bubble = BoxDecoration(
                color: m.isUser ? cs.primary.withAlpha(51) : cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1F2C36)),
              );
              return Align(
                alignment: align,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: bubble,
                  child: Text(m.text),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(
                      hintText:
                          'Type /task, /deadline, /done, /proof, /appeal, /rehab, /vouch, /focus'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(onPressed: _submit, icon: const Icon(Icons.send))
            ],
          ),
        )
      ],
    );
  }
}

// Tasks list
class TasksListScreen extends StatefulWidget {
  final AppState state;
  const TasksListScreen({super.key, required this.state});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  int _tab = 0; // 0: All, 1: In Progress, 2: Completed

  @override
  Widget build(BuildContext context) {
    final tabs = ["All", "In Progress", "Completed"];
    final tabColors = [
      [
        const Color(0xFF2196F3),
        const Color(0xFF00C853)
      ], // Blue, green gradient
      [const Color(0xFF0A2540), const Color(0xFF0A2540)],
      [const Color(0xFF0A2540), const Color(0xFF0A2540)],
    ];
    final tasks = widget.state.tasks;
    List<Task> filtered;
    if (_tab == 1) {
      filtered = tasks.where((t) => t.status == TaskStatus.open).toList();
    } else if (_tab == 2) {
      filtered = tasks.where((t) => t.status == TaskStatus.done).toList();
    } else {
      filtered = tasks;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A2540),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF00C853)],
            ).createShader(bounds);
          },
          child: const Text(
            'Tasks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF00C853)],
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {}, // TODO: Add task creation
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: Row(
              children: List.generate(3, (i) {
                final selected = _tab == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tab = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(horizontal: i == 0 ? 0 : 6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? LinearGradient(colors: tabColors[i])
                            : null,
                        color: selected ? null : const Color(0xFF23243A),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Text(
                          tabs[i],
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final t = filtered[i];
                final isDone = t.status == TaskStatus.done;
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF00C853)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF2196F3),
                      child: Text(
                        '${(i % 4) + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      t.title,
                      style: TextStyle(
                        color: isDone ? Colors.white54 : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        t.deadline != null
                            ? 'Due: ${t.deadline!.toIso8601String().split("T")[0]}'
                            : '',
                        style: TextStyle(
                          color:
                              isDone ? Colors.white38 : const Color(0xFF00C853),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    trailing: Checkbox(
                      value: isDone,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            widget.state.markDone(t.id);
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      activeColor: const Color(0xFF00C853),
                      checkColor: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Dashboard (analytics)
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        _ActiveTasksCard(cs: cs, textTheme: textTheme, count: state.openCount),
        const SizedBox(height: 24),
        _TrustScoreSection(score: state.trustScore, tier: state.tierLevel),
        const SizedBox(height: 24),
        _CompletionCard(points: state.weeklyCompletionSeries),
        const SizedBox(height: 24),
        _UpcomingDeadlines(
            tasks: state.tasks
                .where((t) => t.deadline != null && t.status == TaskStatus.open)
                .take(3)
                .toList()),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ActiveTasksCard extends StatelessWidget {
  const _ActiveTasksCard(
      {required this.cs, required this.textTheme, required this.count});

  final ColorScheme cs;
  final TextTheme textTheme;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF00C853)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Active Tasks',
              style: textTheme.titleMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          Text('$count',
              style: textTheme.displaySmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({required this.points});
  final List<double> points;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF00C853)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00C853)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Task Completion Rate',
              style: textTheme.titleMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('85%',
                  style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(width: 12),
              Text('Last 30 Days +10%',
                  style: textTheme.titleMedium
                      ?.copyWith(color: const Color(0xFF00C853))),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: _SimpleLineChart(points: points),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Week 1',
                  style: textTheme.titleMedium?.copyWith(color: Colors.white)),
              Text('Week 2',
                  style: textTheme.titleMedium?.copyWith(color: Colors.white)),
              Text('Week 3',
                  style: textTheme.titleMedium?.copyWith(color: Colors.white)),
              Text('Week 4',
                  style: textTheme.titleMedium?.copyWith(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class _UpcomingDeadlines extends StatelessWidget {
  const _UpcomingDeadlines({this.tasks = const <Task>[]});
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upcoming Deadlines',
            style:
                textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        for (final t in tasks)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _deadlineItem(t.title, t.deadline!.toLocal().toString()),
          ),
      ],
    );
  }

  Widget _deadlineItem(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(subtitle, style: const TextStyle(color: Color(0xFF7F95A8))),
      ],
    );
  }
}

// Profile screen
class ProfileScreen extends StatelessWidget {
  final AppState state;
  const ProfileScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background color
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  // Profile picture
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage('https://i.imgur.com/2S5kQ6E.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Ethan Carter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Tier ${state.tier}', // Use AppState to get the tier
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Trust Score: ${state.trustScore}', // Use AppState to get the trust score
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionHeader('Account'),
            _buildProfileOption(context, Icons.edit, 'Edit Profile', () {}),
            _buildProfileOption(context, Icons.settings, 'Settings', () {}),
            _buildProfileOption(
                context, Icons.notifications, 'Notifications', () {}),
            _buildProfileOption(context, Icons.lock, 'Privacy', () {}),
            const SizedBox(height: 30),
            _buildSectionHeader('About'),
            _buildProfileOption(
                context, Icons.info, 'About TaskChain Messenger', () {}),
            _buildProfileOption(
                context, Icons.description, 'Terms of Service', () {}),
            _buildProfileOption(
                context, Icons.security, 'Privacy Policy', () {}),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF242424),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleLineChart extends StatelessWidget {
  const _SimpleLineChart({required this.points});

  final List<double> points;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LineChartPainter(points: points),
      size: Size.infinite,
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.points});

  final List<double> points; // 0..1 range

  @override
  void paint(Canvas canvas, Size size) {
    final areaPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0x332D9CDB), Color(0x00000000)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final linePaint = Paint()
      ..color = const Color(0xFF7FBCE6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final bgPaint = Paint()..color = const Color(0xFF0F1A22);
    final gridPaint = Paint()..style = PaintingStyle.stroke;
    // background
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)),
      bgPaint,
    );
    // grid baseline
    for (int i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    if (points.isEmpty) return;
    final spacing = size.width / (points.length - 1);
    final path = Path();
    final area = Path();
    Offset pointAt(int i) {
      final x = i * spacing;
      final y = size.height * (1 - points[i].clamp(0.0, 1.0));
      return Offset(x, y);
    }

    path.moveTo(0, pointAt(0).dy);
    area.moveTo(0, size.height);
    area.lineTo(0, pointAt(0).dy);
    for (int i = 1; i < points.length; i++) {
      final p1 = pointAt(i - 1);
      final p2 = pointAt(i);
      final controlX = (p1.dx + p2.dx) / 2;
      final control1 = Offset(controlX, p1.dy);
      final control2 = Offset(controlX, p2.dy);
      path.cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        p2.dx,
        p2.dy,
      );
      area.cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        p2.dx,
        p2.dy,
      );
    }
    area.lineTo(size.width, size.height);
    area.close();
    canvas.drawPath(area, areaPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  fb_auth.User? _user;
  bool _isLoading = true;
  late final StreamSubscription<fb_auth.User?> _authStateSubscription;

  @override
  void initState() {
    super.initState();
    // Initialize from current Firebase user and listen to auth changes
    _user = fb_auth.FirebaseAuth.instance.currentUser;
    _isLoading = false;
    _authStateSubscription =
        fb_auth.FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A1021),
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    if (_user != null) {
      return const HomeScreen();
    } else {
      return const AuthScreen();
    }
  }
}

class NewTaskManageApp extends StatefulWidget {
  const NewTaskManageApp({super.key});

  @override
  State<NewTaskManageApp> createState() => _NewTaskManageAppState();
}

class _NewTaskManageAppState extends State<NewTaskManageApp> {
  // final AppState _appState = AppState();
  // bool _showSplash = true;
  // bool _isLoggedIn = false;
  // late final StreamSubscription<AuthState> _authSub;
  // int _screen = 0; // 0: welcome, 1: signup, 2: login

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ThemeController
    final themeController = Get.put(ThemeController());
    
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskChain Messenger',
      theme: AppTheme.lightTheme(
        accentColor: AppTheme.getAccentColor(themeController.accentColor),
      ),
      darkTheme: AppTheme.darkTheme(
        accentColor: AppTheme.getAccentColor(themeController.accentColor),
      ),
      themeMode: themeController.themeMode,
      getPages: AppPages.pages,
      initialBinding: BindingsBuilder(() {
        if (!Get.isRegistered<AuthController>()) Get.put(AuthController());
        if (!Get.isRegistered<ChatThemeController>()) {
          Get.put(ChatThemeController());
        }
        if (!Get.isRegistered<MainController>()) {
          Get.put(MainController());
        }
        if (!Get.isRegistered<ThemeController>()) {
          Get.put(ThemeController());
        }
      }),
      home: const AuthWrapper(),
    ));
  }
}
