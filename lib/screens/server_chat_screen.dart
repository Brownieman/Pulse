import 'package:flutter/material.dart';

class ServerChatScreen extends StatelessWidget {
  const ServerChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMessage(
                  context,
                  'Olivia',
                  'Hey team, just wanted to check in on the progress for the Q3 report. How are we looking?',
                  '',
                  '10:30 AM',
                ),
                const SizedBox(height: 24),
                _buildMessage(
                  context,
                  'Liam',
                  'Morning Olivia! I\'ve just finished compiling the marketing data. It\'s looking really promising.',
                  '',
                  '10:32 AM',
                  additionalContent: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'I\'ll drop the preliminary findings in the #reports channel shortly.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTaskAssignment(
                  context,
                  'Finalize Q3 Presentation Deck',
                  'Noah',
                  'Olivia',
                  'Tomorrow',
                  isPriority: true,
                ),
              ],
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessage(
    BuildContext context,
    String name,
    String message,
    String avatarUrl,
    String time, {
    Widget? additionalContent,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue,
          backgroundImage: AssetImage(avatarUrl),
          child: avatarUrl.isEmpty
              ? Text(
                  name[0],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.9),
                  fontSize: 15,
                ),
              ),
              if (additionalContent != null) additionalContent,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskAssignment(
    BuildContext context,
    String taskName,
    String assignee,
    String assignedBy,
    String dueDate, {
    bool isPriority = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.task_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Task Assigned',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '10:35 AM',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            taskName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Assigned to ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              Text(
                '@$assignee',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                ' by ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              Text(
                '@$assignedBy',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (isPriority)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'High Priority',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (isPriority) const SizedBox(width: 12),
              Icon(
                Icons.calendar_today,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Due: $dueDate',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon:
                Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            onPressed: () {},
          ),
          Expanded(
            child: Builder(
              builder: (context) => TextField(
              decoration: InputDecoration(
                hintText: 'Message #general-chat',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.sentiment_satisfied_alt,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.gif_box_outlined, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
