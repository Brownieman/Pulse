import 'package:flutter/material.dart';
import 'server_chat_screen.dart';

class ServersScreen extends StatelessWidget {
  const ServersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onBackground),
            onPressed: () {},
          ),
          centerTitle: true,
          title: Text(
            'Servers',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Servers',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildServerCard(
              'Acme Co',
              const Color(0xFF1B4332),
              const Icon(Icons.account_tree_outlined, color: Colors.white),
            ),
            const SizedBox(height: 12),
            _buildServerCard(
              'Design Team',
              Colors.white,
              const Icon(Icons.design_services, color: Color(0xFF1C2439)),
            ),
            const SizedBox(height: 12),
            _buildServerCard(
              'Marketing Crew',
              const Color(0xFF117864),
              const Icon(Icons.campaign_outlined, color: Colors.white),
            ),
            const SizedBox(height: 12),
            _buildServerCard(
              'Product Squad',
              const Color(0xFF2E7D32),
              const Icon(Icons.inventory_2_outlined, color: Colors.white),
            ),
            const SizedBox(height: 32),
            Text(
              'Create a Server',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                // Handle create new server
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'New Server',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerCard(String name, Color backgroundColor, Icon icon) {
    return Builder(
        builder: (context) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServerChatScreen(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: icon,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                      onPressed: () {
                        // Handle server options
                      },
                    ),
                  ],
                ),
              ),
            ));
  }
}
