# 🧵 Threads Quick Reference

## What Are Threads?

Threads are **focused conversation branches** within channels. Click "Reply" on any message to open a thread.

---

## How to Use Threads

### Start a Thread
1. Find a message in the chat
2. Look for the blue "Reply" button
3. Click it → Thread panel opens on the right
4. Type your reply in the input field
5. Click send or press Enter

### Reply to a Thread
1. Thread panel shows all replies
2. Type in the reply field at the bottom
3. Click the send button (→)
4. Your reply appears instantly

### Close a Thread
- Click the **X button** in the thread header
- Thread panel closes, back to main chat

---

## Thread Panel Layout

```
┌─ THREAD HEADER ─────────────┐
│ Thread                    X  │
│ 📌 Original message title    │ ← Thread title
│ 5 replies                    │ ← Reply count
├─ REPLIES ──────────────────┤
│ 👤 User1  ← 2m ago          │
│   Their reply text...       │
│                             │
│ 👤 User2  ← 1m ago          │
│   Their reply text...       │
│                             │
│ 👤 You    ← just now        │
│   Your reply text...        │
│                             │
├─ INPUT ────────────────────┤
│ Reply to thread...     [→]  │
└─────────────────────────────┘
```

---

## Features

✅ **Reply Button** on every message
✅ **Thread Panel** opens on right side
✅ **Reply Count** shown in header
✅ **Avatars** for each reply author
✅ **Timestamps** for each reply
✅ **User Names** to identify senders
✅ **Easy Close** with X button
✅ **Persistent** while scrolling main chat
✅ **Responsive** on mobile/tablet/desktop
✅ **Discord-style** design

---

## Thread Panel Width

| Device | Width |
|--------|-------|
| Desktop | ~25% | 
| Tablet | ~25% |
| Mobile | Full width (if open) |

---

## Reply Counter

On messages in main chat:
```
[Avatar] User Name  2m ago
This is a message

↩️ Reply (# replies)
```

*Note: Actual reply count backend integration in progress*

---

## Color Scheme

- **Background**: Dark grey (#2C2F33)
- **Accents**: Discord blue (#7289DA)
- **Text**: White for main, grey for secondary
- **Icons**: Blue when active, grey when inactive

---

## Keyboard Shortcuts

| Action | Key |
|--------|-----|
| Send Reply | Enter |
| Close Thread | Esc (future) |
| Focus Input | Tab |

---

## Tips & Tricks

1. **Long Threads?**
   - Scroll through replies in the panel
   - Most recent replies at the bottom

2. **Multiple Threads?**
   - Close current, click Reply on another message
   - Switch between threads quickly

3. **Mobile View?**
   - Thread panel takes full width
   - Swipe or click X to return to main chat

4. **Staying Organized?**
   - Use threads for specific topics
   - Keeps main chat clean
   - Easier to follow conversations

---

## Status

🟢 **Functional**: Reply buttons, thread panel, replies list
🟡 **In Progress**: Backend Firestore integration
🟡 **Planned**: Thread notifications, search, archival

---

## Common Actions

### View Thread Replies
1. Click "Reply" on a message
2. Thread panel shows all replies
3. Scroll to see more
4. Latest replies at bottom

### Add Your Reply
1. Type in the input field
2. Click send button (→)
3. Your reply appears immediately
4. Reply count increases

### Exit Thread
1. Click "X" button in header
2. Return to main chat view
3. Thread data preserved

---

## Responsive Design

### Desktop
- Main chat on left (70%)
- Thread panel on right (30%)
- Full layout visible

### Tablet
- Main chat takes more space
- Thread panel still visible
- Optimized for touch

### Mobile
- Thread panel opens full-width
- Click X to see main chat again
- Swipe-friendly layout

---

## Troubleshooting

**Thread panel not opening?**
- Ensure you clicked the Reply button
- Check internet connection
- Try refreshing the page

**Can't see my reply?**
- Scroll down in thread panel
- Wait a moment for real-time sync
- Check for error messages

**Panel keeps closing?**
- Don't click X accidentally
- Avoid navigation while thread open
- Use close button to exit properly

---

## Coming Soon

🔄 **Auto-refresh** thread replies in real-time
📌 **Thread Notifications** when replied to
🔍 **Search** within threads
📊 **Thread Analytics** (who, when, what)
✏️ **Edit/Delete** your replies
😊 **Reactions** in thread replies

---

## Example Workflow

```
1. View Channel
   Main chat shows messages

2. Notice Interesting Message
   You see something to discuss

3. Click Reply
   Thread panel opens with blue "Reply" button

4. Type Response
   "Great idea! I think we should..."

5. Send Reply
   Click → button

6. See It Appear
   Your reply shows in thread

7. Others Reply
   More people join the thread

8. Keep Discussing
   All replies organized together

9. Close When Done
   Click X, back to main chat

10. Open Again Later
    Click Reply again to continue
```

---

## Quick Stats

- **Feature**: Threads/Conversations
- **Status**: ✅ Live
- **Backend**: ⏳ In Progress
- **Mobile Support**: ✅ Yes
- **Real-time**: ✅ Yes (UI only, backend pending)

---

## Support

For issues or questions:
1. Check this guide first
2. Review the full documentation: `THREADS_IMPLEMENTATION.md`
3. Contact support with screenshots

---

*Version: 1.0 - Quick Reference*
*Last Updated: November 10, 2025*

**Start threading! 🧵✨**
