# 🧵 Threads Visual Guide

## Desktop View

### Main Chat Without Thread
```
┌────────────────┬─────────────────────────────┬────────────────┐
│                │                             │                │
│ #general       │  User: Hey everyone!        │ MEMBERS        │
│ #random        │  Avatar  2m ago             │ ────────────   │
│ #announcements │  ↩️ Reply                   │ 👤 John        │
│                │                             │    Online      │
│                │  User2: Great idea!         │ 👤 Sarah       │
│                │  Avatar  1m ago             │    Online      │
│                │  ↩️ Reply                   │ 👤 Mike        │
│                │                             │    Offline     │
│                │  [Message Input]            │                │
│                │                             │                │
└────────────────┴─────────────────────────────┴────────────────┘

        CHANNELS          MAIN CHAT (70%)           MEMBERS (30%)
```

### Main Chat With Thread Opened
```
┌────────────────┬─────────────────────────┬────────────────┐
│                │                         │ 🧵 THREAD      │
│ #general       │  User: Hey everyone!   │ ───────────── │
│ #random        │  Avatar  2m ago        │ "Hey everyone!"│
│ #announcements │  ↩️ Reply              │ 3 replies      │
│                │                        │ ───────────── │
│                │ User2: Great idea!     │ 👤 John       │
│                │ Avatar  1m ago         │    That's cool │
│                │ ↩️ Reply               │    45s ago     │
│                │                        │                │
│                │ [Message Input]        │ 👤 Sarah      │
│                │                        │    I agree!    │
│                │                        │    1m ago      │
│                │                        │                │
│                │                        │ 👤 You        │
│                │                        │    Nice!       │
│                │                        │    Just now    │
│                │                        │ ───────────── │
│                │                        │ [Reply...]  →  │
└────────────────┴─────────────────────────┴────────────────┘

        CHANNELS       MAIN (50%)         THREAD (50%)
```

---

## Mobile View

### Main Chat
```
┌──────────────────────────────┐
│ ☰  #general      👥          │
├──────────────────────────────┤
│ User: Hey everyone!          │
│ Avatar  2m ago               │
│ ↩️ Reply                      │
│                              │
│ User2: Great idea!           │
│ Avatar  1m ago               │
│ ↩️ Reply                      │
│                              │
│ [Message Input............]→ │
└──────────────────────────────┘

≡ Sidebar Menu (Hidden)
```

### Thread Opened on Mobile
```
┌──────────────────────────────┐
│ Thread                     ← │ (Back button)
│ ───────────────────────────── │
│ "Hey everyone!"              │
│ 3 replies                    │
├──────────────────────────────┤
│ 👤 John                      │
│    That's cool               │
│    45s ago                   │
│                              │
│ 👤 Sarah                     │
│    I agree!                  │
│    1m ago                    │
│                              │
│ 👤 You                       │
│    Nice!                     │
│    Just now                  │
│                              │
├──────────────────────────────┤
│ [Reply to thread....]   →    │
└──────────────────────────────┘
```

---

## Step-by-Step Visual Workflow

### Step 1: Finding a Message to Reply To
```
You see an interesting message in the chat:

┌────────────────────────────────┐
│ 👤 John Smith     2m ago       │
│ "What's everyone's opinion    │
│  on the new feature?"          │
│                                │
│ ↩️ Reply    (click this!)     │
└────────────────────────────────┘
```

### Step 2: Thread Panel Opens
```
When you click "Reply", the thread panel opens:

Right Side Panel:
┌──────────────────────────────┐
│ 🧵 Thread              [X]    │
│ ┌──────────────────────────┐ │
│ │ What's everyone's       │ │
│ │ opinion on the new      │ │
│ │ feature?                │ │
│ └──────────────────────────┘ │
│ 0 replies                    │
├──────────────────────────────┤
│ (Empty - first to reply!)   │
├──────────────────────────────┤
│ [Reply to thread.....]  →    │
└──────────────────────────────┘
```

### Step 3: Type Your Reply
```
You type your response:

┌──────────────────────────────┐
│ [I think it's great and]     │
│ [will help the team a lot]   │
│                              │
│                    [→] Send   │
└──────────────────────────────┘
```

### Step 4: Reply Appears
```
After clicking send, your reply appears:

┌──────────────────────────────┐
│ 🧵 Thread              [X]    │
│ 1 replies                    │
├──────────────────────────────┤
│ 👤 You        Just now       │
│    I think it's great and    │
│    will help the team a lot  │
│                              │
├──────────────────────────────┤
│ [Reply to thread.....]  →    │
└──────────────────────────────┘
```

### Step 5: Others Reply
```
Other team members see and reply to the thread:

┌──────────────────────────────┐
│ 🧵 Thread              [X]    │
│ 3 replies                    │
├──────────────────────────────┤
│ 👤 You        Just now       │
│    I think it's great...     │
│                              │
│ 👤 Sarah      2m ago         │
│    Agreed! Let's ship it     │
│                              │
│ 👤 John       1m ago         │
│    I'll start testing        │
│                              │
├──────────────────────────────┤
│ [Reply to thread.....]  →    │
└──────────────────────────────┘
```

### Step 6: Close Thread
```
When done, click the X button:

┌──────────────────────────────┐
│ 🧵 Thread              [X] ← Click here
│ 3 replies
├──────────────────────────────┤
│ (All replies shown above)
│
└──────────────────────────────┘

✓ Thread closes, main chat displayed again
```

---

## Color Coding Guide

### Message Components
```
👤 = User Avatar (Discord Blue)
Name = White text
Timestamp = Grey text (secondary)
Content = Light grey text
↩️ = Reply button (Discord Blue)
```

### Thread Panel
```
Header: Dark grey background (#2C2F33)
Title: White, bold text
Reply count: Grey, smaller text
Close [X]: Grey icon, top right
Replies: Dark background with white text
Timestamps: Grey, smaller text
Input: Dark grey field with blue send button
```

---

## Layout Transitions

### Desktop: Adding Thread Panel
```
BEFORE:
[40%] Channels | [60%] Main Chat

AFTER:
[20%] Channels | [40%] Main Chat | [40%] Thread

Why? Makes room for thread panel without
removing main chat visibility
```

### Desktop: Hiding Members
```
BEFORE:
[20%] Channels | [50%] Main Chat | [30%] Members

AFTER (with thread):
[20%] Channels | [40%] Main Chat | [40%] Thread

Members panel hidden when thread active
to preserve main chat readability
```

### Mobile: Full-Width Thread
```
BEFORE:
┌────────────────────┐
│ Main Chat          │
└────────────────────┘

AFTER:
┌────────────────────┐
│ Thread Panel       │
│ (Full width)       │
│                    │
│ [Back button]      │
└────────────────────┘

Tap back button or swipe to return to main chat
```

---

## Interactive Elements

### Reply Button
```
Visual State:
┌─────────────────┐
│ ↩️ Reply        │ ← Hover: Highlight blue
└─────────────────┘

Normal: Grey icon, grey text
Hover: Blue icon, blue text
Click: Opens thread panel
```

### Close Button
```
Visual State:
    [X]  ← Top right of thread header

Normal: Grey, faded
Hover: Brighter grey
Click: Closes thread panel
```

### Send Button
```
Visual State:
[Reply...........] →

Normal: Blue arrow icon
Disabled: Grey (while sending)
Hover: Brighter blue
Click: Sends reply
```

---

## Thread States

### Empty Thread
```
👤 Original Message Author
   "First time replying to this message"
   
0 replies shown

📝 Input field active and ready
```

### Thread with Replies
```
👤 Original Message Author
   "First time replying to this message"
   
5 replies shown:

👤 User1 | 1h ago
   Their response...

👤 User2 | 58m ago  
   Their response...

👤 User3 | 2m ago
   Their response...

📝 Input field ready for new reply
```

### Deleted/Archived Thread
```
❌ This thread is no longer available

(Shown with slightly faded styling)
```

---

## Notification Indicators

### Message with Thread Activity
```
Main Chat:
┌──────────────────────────────┐
│ User: Important message      │
│ Avatar  3h ago               │
│ ↩️ Reply (3 replies)         │ ← Shows count!
└──────────────────────────────┘
```

### Thread Badge
```
Future Feature:
┌────────────────┐
│ #general [1]   │ ← New threads
│ #random [3]    │ ← Unread replies
└────────────────┘
```

---

## Responsive Breakpoints

### When Thread Panel Appears/Hides
```
Desktop (> 1200px):
┌────┬──────────┬──────────┐
│Ch │ Main(50%)│ Thread   │
└────┴──────────┴──────────┘
Thread always visible

Tablet (800-1200px):
┌────┬──────────────────────┐
│Ch │ Main + Thread        │
└────┴──────────────────────┘
Thread toggles when opened

Mobile (< 800px):
┌──────────────────┐
│ Main or Thread   │
│ (Full width)     │
└──────────────────┘
Swipe to switch
```

---

## Accessibility

### Keyboard Navigation
```
Tab:        Move between elements
Enter:      Send reply / Activate button
Escape:     Close thread panel
Arrows:     Scroll through replies
```

### Screen Reader
```
"Reply button" - Identifies as clickable
"Thread panel" - Container landmark
"Close button" - Self-explanatory
"Send button" - Self-explanatory
```

### Color Contrast
```
Text on Background: WCAG AA compliant
Icons vs Background: High contrast
Disabled State: Still readable
Focus Indicators: Visible outlines
```

---

## Visual Hierarchy

### Main Chat Message
```
1. Avatar (largest, first focus)
2. Username (white, bold)
3. Timestamp (grey, small)
4. Message content (primary text)
5. Reply button (action)
```

### Thread Reply
```
1. Avatar (smaller than main)
2. Username (white)
3. Timestamp (grey, small)
4. Reply content (primary text)
```

### Thread Header
```
1. Title (largest, "Thread")
2. Thread subject (bold)
3. Reply count (grey, small)
4. Close button (right side)
```

---

## Common Patterns

### Scrolling Behavior
```
Main Chat:
- Scrolls down to see new messages
- Latest messages at bottom

Thread Panel:
- Same pattern: newest replies at bottom
- Auto-scroll when new reply added
```

### Input Behavior
```
Main Chat Input:
- Grows when you type multiple lines
- Max height ~3 lines
- Send on Enter

Thread Input:
- Smaller initially
- Same grow behavior
- Send on Enter or button
```

---

## Examples

### Example Workflow: Daily Standup
```
1. Team lead posts: "Daily standup at 2pm"
2. You click Reply → Thread opens
3. You type: "I'll be there"
4. Manager replies: "Thanks"
5. Sarah replies: "Count me in"
6. Close thread → Back to main chat

Result: Standup discussion organized in thread
        Main chat stays clean
        Easy to find all standup messages
```

### Example Workflow: Bug Discussion
```
1. Dev posts: "Found critical bug in auth"
2. You click Reply → Thread opens
3. You ask: "What's the error message?"
4. Dev replies: "500 Internal Server Error"
5. You reply: "I'll take a look"
6. You then reply: "Fixed in commit abc123"
7. Team lead replies: "Deployed to staging"
8. Close thread

Result: Full bug discussion in one thread
        Doesn't clutter #general chat
        Easy to reference later
```

---

## Animation Flows

### Opening Thread
```
1. Click Reply button
   ↓
2. Thread panel slides in from right (350ms)
   ↓
3. Thread title fades in
   ↓
4. Replies list appears with stagger animation
   ↓
5. Input field ready for focus
```

### Sending Reply
```
1. Click send button
   ↓
2. Input clears
   ↓
3. Reply appears at bottom with fade-in
   ↓
4. Auto-scrolls to new reply
   ↓
5. Reply count increments
```

### Closing Thread
```
1. Click X button
   ↓
2. Thread panel slides out left (350ms)
   ↓
3. Main chat becomes full width again
   ↓
4. Focus returns to main chat
```

---

## This is Threads! 🎉

Visual representation complete. Start threading by clicking Reply on any message!

---

*Version: 1.0 - Visual Guide*
*Last Updated: November 10, 2025*
