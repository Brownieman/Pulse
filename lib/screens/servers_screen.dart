import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkzy_beta1/controllers/server_controller.dart';
import 'package:talkzy_beta1/models/server_model.dart';
import 'server_chat_screen.dart';

class ServersScreen extends StatefulWidget {
  const ServersScreen({super.key});

  @override
  State<ServersScreen> createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  late ServerController _serverController;
  bool _showDiscovery = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<ServerController>()) {
      _serverController = Get.put(ServerController());
    } else {
      _serverController = Get.find<ServerController>();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            icon: Icon(Icons.menu,
                color: Theme.of(context).colorScheme.onBackground),
            onPressed: () {
              setState(() => _showDiscovery = !_showDiscovery);
            },
          ),
          centerTitle: true,
          title: Text(
            _showDiscovery ? 'Discover Servers' : 'Servers',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if (!_showDiscovery)
              IconButton(
                icon: Icon(Icons.add_circle_outline,
                    color: Theme.of(context).colorScheme.onBackground),
                onPressed: _showCreateServerDialog,
              ),
          ],
        ),
      ),
      body: _showDiscovery ? _buildDiscoveryView() : _buildMyServersView(),
    );
  }

  Widget _buildMyServersView() {
    return Obx(() {
      if (_serverController.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final servers = _serverController.userServers;

      if (servers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.groups,
                  size: 80,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.3)),
              const SizedBox(height: 16),
              Text(
                'No servers yet',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create or discover a server to get started',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _showCreateServerDialog,
                child: const Text('Create Server'),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Servers (${servers.length})',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              servers.length,
              (index) => Column(
                children: [
                  _buildServerCard(servers[index]),
                  if (index < servers.length - 1) const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Create a New Server',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildCreateServerButton(),
          ],
        ),
      );
    });
  }

  Widget _buildDiscoveryView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search servers...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              _serverController.updateSearchQuery(value);
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Available Servers',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final servers = _serverController.filteredPublicServers;

            if (servers.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'No servers found',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: List.generate(
                servers.length,
                (index) => Column(
                  children: [
                    _buildDiscoveryServerCard(servers[index]),
                    if (index < servers.length - 1) const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildServerCard(ServerModel server) {
    return InkWell(
      onTap: () {
        _serverController.selectServer(server);
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: server.icon != null
                    ? Colors.transparent
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                image: server.icon != null
                    ? DecorationImage(
                        image: NetworkImage(server.icon!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: server.icon == null
                  ? Icon(Icons.groups, color: Colors.white, size: 24)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${server.memberCount} members',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Leave Server'),
                  onTap: () => _showLeaveServerDialog(server),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryServerCard(ServerModel server) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.groups, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      server.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${server.memberCount} members',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (server.description.isNotEmpty)
            Text(
              server.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _serverController.joinServer(server.id),
            child: const Text('Join Server'),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateServerButton() {
    return InkWell(
      onTap: _showCreateServerDialog,
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
              'Create New Server',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateServerDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isPublic = true;

    Get.dialog(
      Dialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create a New Server',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Server Name',
                      hintText: 'e.g., My Team',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'What is this server about?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: isPublic,
                        onChanged: (value) {
                          setState(() => isPublic = value ?? true);
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Public Server (anyone can discover and join)',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (nameController.text.trim().isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please enter a server name',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          _serverController.createServer(
                            name: nameController.text.trim(),
                            description: descriptionController.text.trim(),
                            isPublic: isPublic,
                          );

                          Get.back();
                        },
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLeaveServerDialog(ServerModel server) {
    Get.dialog(
      AlertDialog(
        title: Text('Leave Server?'),
        content: Text('Are you sure you want to leave "${server.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _serverController.leaveServer(server.id);
              Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}
