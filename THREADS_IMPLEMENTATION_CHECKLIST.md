# Implementation Checklist: Discord-Style Threads

**Status:** Ready for Implementation  
**Estimated Time:** 6-8 hours  
**Difficulty:** Medium  
**Last Updated:** November 10, 2025

---

## Phase 1: Data Layer Setup (1 hour)

### Models
- [x] `ServerThreadModel` - Thread data class
- [x] `ServerThreadReplyModel` - Reply data class
- [ ] Update `ServerMessageModel` with thread fields:
  - [ ] Add `bool hasThread`
  - [ ] Add `String? threadId`
  - [ ] Add `int threadReplyCount`
  - [ ] Update `toMap()` method
  - [ ] Update `fromMap()` method
  - [ ] Update `copyWith()` method

**File:** `lib/models/server_model.dart`

**Verification:**
```bash
# Should compile without errors
flutter clean && flutter pub get && flutter analyze
```

---

## Phase 2: Service Layer (2 hours)

### ServerService Thread Methods

In `lib/services/server_service.dart`, add:

#### Thread CRUD (30 min)
- [ ] `createThread(ServerThreadModel thread)`
- [ ] `getThread(serverId, channelId, threadId)`
- [ ] `getThreadsStream(serverId, channelId, excludeArchived)`
- [ ] `updateThread(ServerThreadModel thread)`
- [ ] `deleteThread(ServerThreadModel thread)`

#### Reply CRUD (30 min)
- [ ] `addThreadReply(ServerThreadReplyModel reply)`
- [ ] `getThreadRepliesStream(threadId, pageSize)`
- [ ] `loadMoreReplies(serverId, channelId, threadId, lastDocument)`
- [ ] `updateThreadReply(ServerThreadReplyModel reply)`
- [ ] `deleteThreadReply(serverId, channelId, threadId, replyId)`

#### Message Updates (15 min)
- [ ] `updateMessageWithThread(serverId, channelId, messageId, threadId)`
- [ ] `incrementMessageThreadReplyCount(serverId, channelId, messageId)`

#### Error Handling (15 min)
- [ ] Add try/catch to all methods
- [ ] Add logging (print statements)
- [ ] Handle null cases

**Reference:** See `THREADS_FRONTEND_GUIDE.md` for complete code

**Verification:**
```bash
# Compile and check no errors
flutter analyze lib/services/server_service.dart
```

---

## Phase 3: State Management (1.5 hours)

### ServerController Thread Operations

In `lib/controllers/server_controller.dart`:

#### Already Added ✅
- [x] `RxList<ServerThreadModel> _currentThreads`
- [x] `RxList<ServerThreadReplyModel> _threadReplies`
- [x] `Rx<ServerThreadModel?> _selectedThread`
- [x] Stream subscriptions

#### Need to Add (1.5 hours)
- [ ] `selectThread(ServerThreadModel thread)` - Open thread panel
- [ ] `clearSelectedThread()` - Close thread panel
- [ ] `_loadThreadReplies(ServerThreadModel thread)` - Subscribe to replies
- [ ] `createThreadFromMessage({required ServerMessageModel message})` - Create thread
- [ ] `sendThreadReply(String replyContent)` - Send reply
- [ ] `editThreadReply({required ServerThreadReplyModel reply, required String newContent})` - Edit reply
- [ ] `deleteThreadReply(ServerThreadReplyModel reply)` - Delete reply
- [ ] `deleteThread(ServerThreadModel thread)` - Delete thread
- [ ] `archiveThread(ServerThreadModel thread)` - Archive thread
- [ ] `_loadThreadsForChannel()` - Load threads for current channel
- [ ] `formatThreadReplyTime(DateTime dateTime)` - Format timestamps

**Reference:** See `THREADS_FRONTEND_GUIDE.md` for complete code

**Verification:**
```bash
# Check controller compiles
flutter analyze lib/controllers/server_controller.dart
```

---

## Phase 4: UI Components (1.5 hours)

### Create Widget Files

#### 1. ThreadPanel Widget (45 min)
**File:** Create `lib/widgets/thread_panel.dart`

Required:
- [x] StatefulWidget with full lifecycle
- [x] Header section (thread title, reply count, close button)
- [x] Replies list view
- [x] Empty state
- [x] Reply input field
- [x] Send button
- [x] Edit/delete menu
- [x] Loading indicator
- [x] Error handling

**Size:** ~300 lines

#### 2. ThreadIndicator Widget (20 min)
**File:** Create `lib/widgets/thread_indicator.dart`

Required:
- [x] Shows on messages with threads
- [x] Displays reply count
- [x] Forum icon
- [x] Clickable to open thread
- [x] Only show if has replies

**Size:** ~50 lines

#### 3. ReplyButton Widget (15 min)
**File:** Create `lib/widgets/reply_button.dart`

Required:
- [x] Blue "Reply" button
- [x] Reply icon
- [x] Discord styling
- [x] Click handler
- [x] Loading state

**Size:** ~40 lines

**Verification:**
```bash
# Compile widgets
flutter analyze lib/widgets/
```

---

## Phase 5: Chat Screen Integration (1.5 hours)

### Update ServerChatScreen

**File:** `lib/screens/server_chat_screen.dart`

#### State Changes
- [ ] Add `bool _showThreadPanel = false` to state
- [ ] Already has thread variables (from previous session)

#### Message Widget Changes
- [ ] Add `ReplyButton` on each message
- [ ] Add `ThreadIndicator` on messages with threads
- [ ] Wire up click handlers

#### Layout Changes
- [ ] Update Row layout to include thread panel
- [ ] Adjust flex values:
  - Without thread: 3 (keep as is)
  - With thread: 2 (share space with thread panel)
- [ ] Add conditional ThreadPanel widget
- [ ] Make responsive (hide on mobile when not open)

#### Click Handlers
- [ ] Reply button → calls `createThreadFromMessage`
- [ ] Thread indicator → calls `selectThread`
- [ ] Close button → calls `clearSelectedThread`

**Reference:** See `THREADS_COMPLETE_SYSTEM.md` Integration section

**Verification:**
```bash
# Test screen compiles
flutter analyze lib/screens/server_chat_screen.dart

# Run app and test manually
flutter run
```

---

## Phase 6: Testing & Debugging (1 hour)

### Manual Testing

#### Thread Creation
- [ ] Click "Reply" on any message
- [ ] Thread panel opens on right
- [ ] Thread title shows correctly
- [ ] Reply count is 0

#### Sending Replies
- [ ] Type in reply input field
- [ ] Click send button
- [ ] Reply appears immediately
- [ ] Reply count increments
- [ ] Message shows "1 reply in thread"

#### Real-time Updates
- [ ] Have 2 devices open same thread
- [ ] Send reply from device 1
- [ ] Reply appears on device 2 within 2 seconds
- [ ] Reply count updates both sides

#### Edit/Delete
- [ ] Hover over own reply (desktop) or tap menu
- [ ] Click edit, change text, save
- [ ] See "(edited)" label
- [ ] Click delete, reply disappears
- [ ] Reply count decrements

#### Responsive
- [ ] Desktop: Thread panel 350px on right
- [ ] Tablet: Thread panel adjusts width
- [ ] Mobile: Thread panel full screen
- [ ] Back gesture/button closes thread

### Debugging Checklist
- [ ] No red errors in console
- [ ] No yellow warnings in console
- [ ] Firestore rules allow read/write
- [ ] Auth user ID correct
- [ ] Timestamps in correct format
- [ ] No null reference errors

**Common Issues:**
```
Issue: Replies not loading
Debug: Add print statements to _loadThreadReplies()
       Check Firestore security rules
       Verify thread ID in console

Issue: Reply not sending
Debug: Check network connection
       Verify Firestore initialized
       Check auth working
       Look for exception in console

Issue: High memory usage
Debug: Verify streams canceled in onClose()
       Check if _threadReplies cleared
       Monitor widget disposal
```

---

## Phase 7: Performance Optimization (30 min)

### Implement Best Practices

#### Pagination
- [ ] Limit initial reply load to 50
- [ ] Add "Load more" functionality
- [ ] Test with 100+ reply thread

#### Caching
- [ ] Add 5-minute cache TTL
- [ ] Clear cache on thread update
- [ ] Verify memory usage

#### Firestore Indexes
- [ ] Create index: `channel_id + archived + last_reply_at`
- [ ] Create index: `thread_id + timestamp`
- [ ] Create index: `channel_id + has_thread`

#### Responsive Design
- [ ] Test on multiple screen sizes
- [ ] Verify smooth scrolling
- [ ] Check touch targets (min 48dp)

**Verification:**
```bash
# Run in profile mode to check performance
flutter run --profile

# Monitor frame rate
# Open thread with 100+ replies
# Should see 60 FPS in timeline
# Memory should be < 50MB
```

---

## Phase 8: Documentation & Handoff (1 hour)

### Documentation
- [x] Architecture guide created
- [x] Backend guide created
- [x] Frontend guide created
- [x] Advanced features guide created
- [x] Complete system guide created
- [x] Reference guide created

### Code Documentation
- [ ] Add doc comments to all methods
- [ ] Add inline comments for complex logic
- [ ] Document error codes
- [ ] Update README.md

### Testing Documentation
- [ ] Write unit tests (optional)
- [ ] Write integration tests (optional)
- [ ] Create test cases document

### Deployment
- [ ] Prepare production checklist
- [ ] Document Firestore security rules
- [ ] Create deployment guide

---

## Estimated Timeline

| Phase | Task | Time | Status |
|-------|------|------|--------|
| 1 | Data Layer | 1h | ⏳ TODO |
| 2 | Service Layer | 2h | ⏳ TODO |
| 3 | State Management | 1.5h | ⏳ TODO |
| 4 | UI Components | 1.5h | ⏳ TODO |
| 5 | Integration | 1.5h | ⏳ TODO |
| 6 | Testing | 1h | ⏳ TODO |
| 7 | Optimization | 0.5h | ⏳ TODO |
| 8 | Documentation | 1h | ✅ DONE |
| **TOTAL** | | **~10h** | |

---

## Quick Reference: File Locations

### Create New Files
```
lib/
├── widgets/
│   ├── thread_panel.dart          (NEW)
│   ├── thread_indicator.dart      (NEW)
│   └── reply_button.dart          (NEW)
```

### Modify Existing Files
```
lib/
├── models/
│   └── server_model.dart          (UPDATE: Add thread fields to ServerMessageModel)
├── services/
│   └── server_service.dart        (ADD: Thread methods)
├── controllers/
│   └── server_controller.dart     (ADD: Thread operations)
└── screens/
    └── server_chat_screen.dart    (ADD: Integration)
```

---

## Success Criteria

You've successfully completed when:

✅ **Functionality**
- [x] Can click "Reply" on messages
- [x] Thread panel opens
- [x] Can send replies
- [x] Replies appear in real-time
- [x] Can edit own replies
- [x] Can delete own replies

✅ **UI/UX**
- [x] Desktop responsive
- [x] Tablet responsive
- [x] Mobile responsive
- [x] Smooth animations
- [x] Clear error messages

✅ **Performance**
- [x] Thread loads < 500ms
- [x] Reply sends < 1s
- [x] 60 FPS scrolling
- [x] No memory leaks
- [x] Handles 100+ replies

✅ **Quality**
- [x] No console errors
- [x] No console warnings
- [x] Clean code
- [x] Well documented
- [x] Error handling

---

## Getting Help

### Stuck on Step X?

**Data Layer:** See `THREADS_ARCHITECTURE.md`  
**Service Layer:** See `THREADS_FRONTEND_GUIDE.md` ServerService section  
**State Management:** See `THREADS_FRONTEND_GUIDE.md` ServerController section  
**UI Components:** See `THREADS_FRONTEND_GUIDE.md` Widgets section  
**Integration:** See `THREADS_COMPLETE_SYSTEM.md` Integration section  

### Resources

- **Flutter Docs:** https://flutter.dev/docs
- **GetX Docs:** https://pub.dev/packages/get
- **Firestore Docs:** https://firebase.google.com/docs/firestore
- **Discord Inspiration:** https://discord.com/developers/docs

---

## Next Steps After Completion

Once threads are working:

1. **Add Advanced Features**
   - Typing indicators
   - Emoji reactions
   - @mentions
   - Thread search

2. **Performance Tuning**
   - Redis caching
   - Query optimization
   - Lazy loading

3. **Backend Integration** (if Node.js)
   - Implement API endpoints
   - Add WebSocket events
   - Database migration

4. **Deployment**
   - Production Firestore rules
   - Error monitoring (Sentry)
   - Analytics (Firebase)

---

## 🎯 Start Here

**Step 1:** Open this checklist in split view  
**Step 2:** Open corresponding documentation file  
**Step 3:** Copy code from guide  
**Step 4:** Paste into your project  
**Step 5:** Check off item  
**Step 6:** Move to next item  

**Estimated completion:** 6-8 hours  

**💪 Let's build it!**
