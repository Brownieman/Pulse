import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int selectedTab = 0; // 0: All, 1: In Progress, 2: Completed
  List<Map<String, dynamic>> tasks = [];
  bool _loading = true;
  String? _error;
  final LocalStorage _localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    print('TaskListScreen initState called'); // DEBUG
    _fetchTasks();
  }

  // FIX: Extracted sorting logic to a reusable method
  void _sortTasks() {
    tasks.sort((a, b) {
      final aDue = a['due'] != null ? DateTime.tryParse(a['due']) : null;
      final bDue = b['due'] != null ? DateTime.tryParse(b['due']) : null;
      if (aDue == null && bDue == null) return 0;
      if (aDue == null) return 1; // Tasks without due dates go to the end
      if (bDue == null) return -1;
      return aDue.compareTo(bDue);
    });
  }

  Future<void> _fetchTasks() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final loadedTasks = await _localStorage.loadTasks();
      print('Loaded ${loadedTasks.length} tasks from storage'); // DEBUG

      // If no tasks, add some sample tasks
      if (loadedTasks.isEmpty) {
        loadedTasks.addAll([
          {
            'id': 1,
            'title': 'Welcome to Task Manager',
            // FIX: Store dates as ISO 8601 strings for correct sorting
            'due': DateTime(2025, 10, 30).toIso8601String(),
            'completed': false
          },
          {
            'id': 2,
            'title': 'Add your first task',
            'due': null,
            'completed': false
          },
          {
            'id': 3,
            'title': 'Mark tasks as completed',
            'due': DateTime(2025, 11, 1).toIso8601String(),
            'completed': true
          },
        ]);
        await _localStorage.saveTasks(loadedTasks);
        print('Added sample tasks'); // DEBUG
      }
      setState(() {
        tasks = loadedTasks;
        _sortTasks(); // FIX: Sort the loaded tasks
        print('Set state with ${tasks.length} tasks'); // DEBUG
      });
    } catch (e) {
      print('Error loading tasks: $e'); // DEBUG
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _updateTaskCompleted(int taskId, bool completed) async {
    // FIX: Optimistic update
    // 1. Find the task in the *local* list
    final taskIndex = tasks.indexWhere((t) => t['id'] == taskId);
    if (taskIndex == -1) return; // Task not found

    // 2. Keep a copy of the old task for rollback
    final oldTask = tasks[taskIndex];
    final updatedTask = Map<String, dynamic>.from(oldTask)
      ..['completed'] = completed;

    // 3. Update the UI *immediately*
    setState(() {
      tasks[taskIndex] = updatedTask;
    });

    // 4. Try to save to storage in the background
    try {
      await _localStorage.updateTask(taskId, updatedTask);
    } catch (e) {
      // 5. If save fails, roll back the UI and show an error
      setState(() {
        tasks[taskIndex] = oldTask; // Put the old one back
        _error = "Failed to update task. Please try again.";
      });
    }
  }

  Future<void> _addTask(String title, String? dueDate) async {
    // FIX: Optimistic update for adding tasks
    try {
      final newTaskMap = {
        'title': title,
        'due': dueDate, // This is now an ISO 8601 string from the dialog
        'completed': false,
        // 'id' will be added by the local_storage service
      };

      // 1. Assume _localStorage.addTask returns the *complete* task with its new ID
      final addedTask = await _localStorage.addTask(newTaskMap);

      // 2. Add it directly to the local list and call setState
      setState(() {
        tasks.add(addedTask);
        _sortTasks(); // 3. Re-sort the local list
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _deleteTask(int taskId) async {
    setState(() {
      tasks.removeWhere((t) => t['id'] == taskId);
      _sortTasks();
    });
    await _localStorage.deleteTask(taskId);
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddTaskDialog(),
    ).then((result) {
      if (result != null) {
        // result['dueDate'] is now an ISO 8601 string or null
        _addTask(result['title'], result['dueDate']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = selectedTab == 0
        ? tasks
        : tasks
            .where((t) => selectedTab == 2
                ? t['completed'] == true
                : t['completed'] != true)
            .toList();

    print(
        'Building TaskListScreen: loading=$_loading, error=$_error, tasks=${tasks.length}, filtered=${filteredTasks.length}, tab=$selectedTab'); // DEBUG

    return Scaffold(
      backgroundColor: const Color(0xFF0A1021),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150), // Increased height for tabs
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Text(
                      'Tasks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.blueAccent.withAlpha(179),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF181A20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withAlpha(77),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () => _showAddTaskDialog(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                child: Row(
                  children: [
                    _buildSegment('All', 0, selectedTab == 0),
                    const SizedBox(width: 8),
                    _buildSegment('In Progress', 1, selectedTab == 1),
                    const SizedBox(width: 8),
                    _buildSegment('Completed', 2, selectedTab == 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text(_error!,
                      style: const TextStyle(color: Colors.redAccent)))
              : ListView.builder(
                  // FIX: Changed to ListView.builder for card layout
                  // FIX: Added padding for the whole list
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, i) {
                    final t = filteredTasks[i];
                    final isCompleted = t['completed'] == true;

                    // FIX: Parse and format the date for display
                    final dueDate =
                        t['due'] != null ? DateTime.tryParse(t['due']) : null;
                    final formattedDate =
                        dueDate != null ? dueDate.toString() : 'No due date';

                    return Container(
                      // FIX: Added margin for spacing between cards
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF181A20),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t['title'] ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      decoration: isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      decorationColor: Colors.grey,
                                      decorationThickness: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Due: $formattedDate', // FIX: Use formatted date
                                    style: TextStyle(
                                      color: isCompleted
                                          ? Colors.grey
                                          : const Color(0xFF64748B),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Checkbox(
                              value: isCompleted,
                              onChanged: (val) {
                                // FIX: This check is still valid and important.
                                // The new task from _addTask *must* have an 'id'.
                                if (t['id'] != null && val != null) {
                                  _updateTaskCompleted(t['id'] as int, val);
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              activeColor: const Color(0xFF2196F3),
                              checkColor: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () {
                                if (t['id'] != null) {
                                  _deleteTask(t['id'] as int);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildSegment(String label, int idx, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = idx),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: selected
                ? const LinearGradient(
                    colors: [Color(0xFFB16CEA), Color(0xFFFF5E69)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: selected ? null : const Color(0xFF23243A),
            border: Border.all(
              color: selected ? Colors.transparent : Colors.grey.shade700,
              width: 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.purpleAccent.withAlpha(51),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _dueDateController = TextEditingController();
  DateTime? _selectedDate; // FIX: State to hold the selected date object

  @override
  void dispose() {
    _titleController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  // FIX: Method to show the date picker
  Future<void> _pickDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        // Format the date for display in the text field
        _dueDateController.text = pickedDate.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0A1021),
      title: const Text(
        'Add New Task',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Task Title',
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB16CEA)),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          // FIX: Updated TextField to be read-only and use onTap
          TextField(
            controller: _dueDateController,
            readOnly: true, // Prevents keyboard from appearing
            onTap: () => _pickDate(context), // Shows date picker
            decoration: const InputDecoration(
              labelText: 'Due Date (optional)',
              labelStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB16CEA)),
              ),
              suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text.trim();
            if (title.isNotEmpty) {
              Navigator.of(context).pop({
                'title': title,
                // FIX: Return the date as an ISO 8601 string, or null
                'dueDate': _selectedDate?.toIso8601String(),
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB16CEA),
          ),
          child: const Text('Add Task'),
        ),
      ],
    );
  }
}
