// Supabase Flutter integration setup instructions

1. Add dependencies to pubspec.yaml:

```
dependencies:
  supabase_flutter: ^2.3.4
```

2. Initialize Supabase in main.dart (before runApp):

```
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  runApp(const NewTaskManageApp());
}
```

3. Authentication (sign up, login, sign out):

```
final supabase = Supabase.instance.client;

// Sign up
await supabase.auth.signUp(email: email, password: password);

// Sign in
await supabase.auth.signInWithPassword(email: email, password: password);

// Sign out
await supabase.auth.signOut();
```

4. CRUD Example (Tasks):

```dart
// Fetch tasks for current user
final userId = supabase.auth.currentUser?.id;
final tasks = await supabase.from('tasks').select().eq('user_id', userId);

// Insert task
await supabase.from('tasks').insert({
  'user_id': userId,
  'title': 'New Task',
  'description': 'Details',
  'deadline': DateTime.now().toIso8601String(),
});

// Update task
await supabase.from('tasks').update({'status': 'done'}).eq('id', taskId);

// Delete task
await supabase.from('tasks').delete().eq('id', taskId);
```

5. Real-time subscriptions (Tasks):

```dart
final subscription = supabase
  .from('tasks:user_id=eq.$userId')
  .on(SupabaseEventTypes.all, (payload) {
    // handle insert/update/delete
  })
  .subscribe();
```

6. Secure your keys! Never expose service_role key in your app.

7. See supabase.com/docs/guides/with-flutter for more details.
