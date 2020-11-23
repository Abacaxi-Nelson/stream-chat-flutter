import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'group_chat_details_screen.dart';

class NewGroupChatScreen extends StatefulWidget {
  @override
  _NewGroupChatScreenState createState() => _NewGroupChatScreenState();
}

class _NewGroupChatScreenState extends State<NewGroupChatScreen> {
  TextEditingController _controller;

  String _userNameQuery = '';

  final _selectedUsers = <User>{};

  bool _isSearchActive = false;

  Timer _debounce;

  void _userNameListener() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted)
        setState(() {
          _userNameQuery = _controller.text;
          _isSearchActive = _userNameQuery.isNotEmpty;
        });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_userNameListener);
  }

  @override
  void dispose() {
    _controller?.clear();
    _controller?.removeListener(_userNameListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(252, 252, 252, 1),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        leading: const StreamBackButton(),
        title: Text(
          'Add Group Members',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_selectedUsers.isNotEmpty)
            IconButton(
              icon: Icon(
                StreamIcons.arrow_right,
                color: Color(0xFF006CFF),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupChatDetailsScreen(
                      selectedUsers: _selectedUsers.toList(growable: false),
                    ),
                  ),
                );
              },
            )
        ],
      ),
      body: UsersBloc(
        child: Column(
          children: [
            Container(
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    StreamIcons.search,
                    color: Colors.black,
                    size: 24,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            if (_selectedUsers.isNotEmpty)
              Container(
                height: 104,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedUsers.length,
                  padding: const EdgeInsets.all(8),
                  separatorBuilder: (_, __) => SizedBox(width: 16),
                  itemBuilder: (_, index) {
                    final user = _selectedUsers.elementAt(index);
                    return Column(
                      children: [
                        Stack(
                          children: [
                            UserAvatar(
                              onlineIndicatorAlignment: Alignment(0.9, 0.9),
                              user: user,
                              showOnlineStatus: true,
                              borderRadius: BorderRadius.circular(32),
                              constraints: BoxConstraints.tightFor(
                                height: 64,
                                width: 64,
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: GestureDetector(
                                onTap: () {
                                  if (_selectedUsers.contains(user)) {
                                    setState(() => _selectedUsers.remove(user));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey.shade100,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Icon(
                                      StreamIcons.close,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          user.name.split(' ')[0],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.02),
                    Colors.white.withOpacity(0.05),
                  ],
                  stops: [0, 1],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 8,
                ),
                child: Text(
                  _isSearchActive
                      ? 'Matches for \"$_userNameQuery\"'
                      : 'On the platform',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: UserListView(
                selectedUsers: _selectedUsers,
                groupAlphabetically: _isSearchActive ? false : true,
                onUserTap: (user, _) {
                  if (!_selectedUsers.contains(user)) {
                    setState(() {
                      _selectedUsers.add(user);
                    });
                  } else {
                    setState(() {
                      _selectedUsers.remove(user);
                    });
                  }
                },
                pagination: PaginationParams(
                  limit: 25,
                ),
                filter: {
                  if (_userNameQuery.isNotEmpty)
                    'name': {
                      r'$autocomplete': _userNameQuery,
                    },
                  'id': {
                    r'$ne': StreamChat.of(context).user.id,
                  }
                },
                sort: [
                  SortOption(
                    'name',
                    direction: 1,
                  ),
                ],
                emptyBuilder: (_) {
                  return LayoutBuilder(
                    builder: (context, viewportConstraints) {
                      return SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Icon(
                                    StreamIcons.search,
                                    size: 96,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text('No user matches these keywords...'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}