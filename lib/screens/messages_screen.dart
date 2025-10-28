import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/contact.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<Contact> contacts = [], filteredContacts = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/data/contacts.json').then((jsonString) {
      final jsonData = json.decode(jsonString);
      setState(() {
        contacts = (jsonData['contacts'] as List)
            .map((e) => Contact.fromJson(e))
            .toList();
        filteredContacts = List.from(contacts);
      });
    });
    _searchController.addListener(() {
      final q = _searchController.text.toLowerCase();
      setState(() {
        filteredContacts = q.isEmpty
            ? List.from(contacts)
            : contacts.where((c) {
                return c.name.toLowerCase().contains(q) ||
                    c.lastMessage.toLowerCase().contains(q) ||
                    c.email.toLowerCase().contains(q);
              }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime? t) {
    if (t == null) return '';
    final now = DateTime.now(),
        today = DateTime(now.year, now.month, now.day),
        yest = today.subtract(const Duration(days: 1)),
        d = DateTime(t.year, t.month, t.day);
    if (d == today) {
      return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    }
    if (d == yest) return 'Yesterday';
    return '${t.day}/${t.month}/${t.year}';
  }

  void _openChat(Contact c) => Navigator.push(
      context, MaterialPageRoute(builder: (_) => ChatScreen(contact: c)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1021),
      body: SafeArea(
        child: contacts.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2439),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.only(
                          top: 3, bottom: 3, left: 16, right: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.search,
                              color: Color(0xFF64748B), size: 22),
                          const SizedBox(width: 13),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                              decoration: const InputDecoration(
                                hintText: 'Search messages',
                                hintStyle: TextStyle(
                                    color: Color(0xFF64748B), fontSize: 16),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, i) {
                          final c = filteredContacts[i];
                          return GestureDetector(
                            onTap: () => _openChat(c),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C2439),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                          radius: 28,
                                          backgroundImage:
                                              AssetImage(c.avatarUrl)),
                                      if (c.status == 'online')
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFF1C2439),
                                                  width: 2),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(c.name,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(_formatTime(c.lastSeen),
                                                style: const TextStyle(
                                                    color: Color(0xFF64748B),
                                                    fontSize: 12)),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(c.lastMessage,
                                                  style: const TextStyle(
                                                      color: Color(0xFF64748B),
                                                      fontSize: 14),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            if (c.unreadCount > 0)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 8),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFF2B5BFF),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text(
                                                    c.unreadCount.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
