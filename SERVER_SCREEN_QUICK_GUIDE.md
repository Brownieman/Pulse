# 🚀 Server Screen - Quick Reference Guide

## What's New

The Server Screen is now **completely functional** with full real-time messaging, channel management, task assignment, and member management capabilities.

---

## 📱 Screen Overview

### Servers Screen (List View)
Shows all servers you're a member of with quick actions to create new servers or discover public ones.

**Top Features:**
- 📌 **Create Server** - Tap the `+` icon to create a new server
- 🔍 **Discover** - Tap the menu icon to switch to discovery mode
- 🚪 **Leave Server** - Tap the three-dot menu on any server card

### Server Chat Screen (Detail View)
The main communication hub with channels, messages, members, and tasks.

**Layout:**
```
┌─────────────────────────────────────────────────────────────┐
│ Server Name | # channel-name    [👥 📋 ⋮]                   │
├─────────────────────────────────────────────────────────────┤
│ # general | # announcements | # random                       │
├─────────────────────────────────────────────────────────────┤
│                                                 ┌──────────┐  │
│                                                 │ Members  │  │
│  Alice: Hey everyone!                          │ (5)      │  │
│  [12:34]                                        │─────────┤  │
│                                                 │ Alice 🟢 │  │
│  You: Hi there!                                 │ Bob 🔴   │  │
│  [12:35]                                        │ Carol 🟢 │  │
│                                                 │ Dave 🔴  │  │
│                                                 │ Eve 🟢   │  │
│                                                 └──────────┘  │
├─────────────────────────────────────────────────────────────┤
│ [+] [Type message here...] [😊] [Send]                       │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎮 How to Use

### 1️⃣ Create a Server

```
Servers Screen → [+] Button → Enter Details → Create
```

**Details:**
- **Server Name** (Required)
- **Description** (Optional)
- **Public** (Checkbox) - Allow anyone to discover and join

✨ A "general" channel is automatically created for new servers.

### 2️⃣ Join a Public Server

```
Servers Screen → Menu (≡) → Search → [Join Server] Button
```

**Features:**
- Search by server name or description
- See member count before joining
- One-click join process

### 3️⃣ Send a Message

```
1. Select a server
2. Select a channel from the top tabs
3. Type your message
4. Tap [Send] Button
```

**Tips:**
- Messages auto-scroll to bottom
- See sender name and timestamp
- Only your messages have delete option

### 4️⃣ Switch Channels

Simply tap the channel name tab at the top of the chat area.

**Active channel** is highlighted in your theme's primary color.

### 5️⃣ Create a New Channel

```
Chat Input [+] → [Create Channel] → Enter Name & Description → Create
```

**Features:**
- Optional description
- Automatically added to channel list
- Shows on channel selector immediately

### 6️⃣ Assign a Task

```
Chat Input [+] → [Assign Task] → Fill Details → Create
```

**Task Details:**
- **Title** (Required)
- **Description** (Optional)
- **Assign To** (Required)
- **Due Date** (Required)
- **Priority** (Optional) - High priority checkbox

### 7️⃣ Manage Tasks

**Desktop View:**
- Tasks appear in right sidebar
- Tap to expand and see full details
- Change status with dropdown (Pending → In Progress → Completed)
- Delete button available

**Mobile View:**
- Tap tasks icon (📋) in AppBar to show/hide
- Same management as desktop

### 8️⃣ View Server Members

```
AppBar [👥] → Tap to Toggle Member Panel
```

**Shows:**
- Member avatars with initials
- Display names
- Online/Offline status (🟢 Online, 🔴 Offline)
- Member count

---

## 🎯 Key Features

### Real-Time Updates ⚡
- Messages appear instantly
- New members show up immediately
- Task updates reflect instantly
- Online status updates in real-time

### Channel Management 📋
- Create multiple channels
- Switch between channels
- View channel info (name, type, created date)
- Channel descriptions

### Task Management ✅
- Assign tasks to specific members
- Set due dates with date picker
- Mark as high priority
- Track status (Pending/In Progress/Completed)
- Visual status indicators
- Easy deletion

### Member Management 👥
- See all server members
- Online/offline indicators
- Quick member count
- Member avatars

### Search 🔍
- Search public servers
- Find servers by name or description
- Filter results in real-time

---

## 🎨 UI Elements

### Message Bubbles
- **Your Messages:** Colored (right-aligned)
- **Others' Messages:** Neutral color (left-aligned)
- **Timestamps:** Relative time (e.g., "2m ago", "12:34 PM")
- **Edit Badge:** Shows if message was edited
- **Delete:** Menu on hover (your messages only)

### Task Cards
- **Title:** Primary, with strikethrough if completed
- **Assignee:** Shows who the task is assigned to
- **Status Dot:** Color-coded (Pending=Gray, In Progress=Orange, Completed=Green)
- **Priority Badge:** Red badge if high priority
- **Expand:** Click to see full details

### Channel Tabs
- **Active:** Primary color background
- **Inactive:** Neutral background
- **Scrollable:** Scroll horizontally if many channels

---

## ⌨️ Keyboard Shortcuts (When Implemented)

- **Enter** - Send message (when in message input)
- **Esc** - Close dialogs
- **Ctrl+K** - Quick server/channel search (future)

---

## 🔐 Permissions & Actions

| Action | Who Can Do It |
|--------|---|
| Create Server | Anyone logged in |
| Delete Server | Server owner only |
| Join Public Server | Anyone logged in |
| Leave Server | Any member |
| Send Messages | Server members |
| Delete Own Message | Message sender |
| Delete Others' Message | ❌ Not allowed |
| Create Channel | Server members |
| Create Task | Server members |
| Assign Task | Server members |
| Update Task | Anyone |
| Delete Task | Creator/Admin (can be extended) |

---

## 🐛 Troubleshooting

### Messages Not Appearing?
- ✅ Check internet connection
- ✅ Make sure you're in the right channel
- ✅ Try switching channels and back

### Task Not Showing?
- ✅ Ensure task was created in current channel
- ✅ Refresh the channel view
- ✅ Check if task panel is visible (tap 📋 icon)

### Can't Join Server?
- ✅ Check if server is public
- ✅ You might already be a member
- ✅ Check your internet connection

### Member List Empty?
- ✅ Might be loading - wait a moment
- ✅ Try closing and reopening member panel

### Don't See Your Message?
- ✅ Check that send button icon is not grayed out (means sending)
- ✅ Check internet connection
- ✅ Try sending a shorter message

---

## 💡 Tips & Tricks

1. **Quick Server Switch:** Tap the server name in AppBar to jump to server list
2. **Channel Search:** Use server description search to find specific servers
3. **Priority Tasks:** Mark important tasks as high priority for visibility
4. **Task Status:** Update task status as you progress through your work
5. **Member Presence:** Check online indicators to see who's active
6. **Channel Organization:** Create channels by topic (announcements, random, projects, etc.)
7. **Message Context:** Timestamps help you track conversation flow

---

## 📊 Statistics & Metrics

- **Max Channels per Server:** Unlimited
- **Max Members per Server:** Unlimited
- **Max Tasks per Channel:** Unlimited
- **Message History:** Real-time, persisted in Firebase
- **Task History:** All tasks tracked with status

---

## 🔄 Data Syncing

All data is synced in real-time:
- Servers: Sync every time you open the app
- Channels: Sync when you select a server
- Messages: Stream updates as they're sent
- Tasks: Stream updates as they're created/updated
- Members: Stream updates as members join/leave

---

## 🎓 Next Steps

1. ✅ Create your first server
2. ✅ Invite team members to join
3. ✅ Create channels for different topics
4. ✅ Start sending messages
5. ✅ Create and assign tasks
6. ✅ Track task progress with status updates

---

## 📞 Support

For issues or feature requests:
1. Check the troubleshooting section above
2. Review the implementation document
3. Check app logs for detailed error messages

---

**Enjoy using the Server Screen! 🎉**
