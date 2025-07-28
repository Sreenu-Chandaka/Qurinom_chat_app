import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user_model.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/chat/chat_bloc.dart';
import '../bloc/chat/chat_event.dart';
import '../bloc/chat/chat_state.dart';
import '../bloc/message/message_bloc.dart';
import '../bloc/message/message_event.dart';
import 'chat_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    
    try {
      context.read<MessageBloc>().add(ConnectSocket());
    } catch (e) {
      print('Error connecting socket: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            return _buildHomePage(authState.user);
          }
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildHomePage(UserModel user) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                context.read<AuthBloc>().add(LogoutRequested());
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    _getInitials(user),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? user.email,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${user.role.toUpperCase()}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatInitial) {
                  context.read<ChatBloc>().add(LoadChats(user.id));
                  return Center(child: CircularProgressIndicator());
                }

                if (state is ChatLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is ChatError) {
                  print('Chat Error: ${state.message}');
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Error loading chats',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ChatBloc>().add(RefreshChats(user.id));
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ChatLoaded) {
                  final chats = state.chats ?? []; 
                  
                  if (chats.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No chats yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Start a conversation to see your chats here',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ChatBloc>().add(RefreshChats(user.id));
                    },
                    child: ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        
                        if (index < 0 || index >= chats.length) {
                          return SizedBox.shrink();
                        }
                        
                        final chat = chats[index];
                        if (chat == null) {
                          return SizedBox.shrink();
                        }

                        final otherUser = chat.otherUser;

                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                _getUserInitials(otherUser),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              _getUserDisplayName(otherUser),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              chat.lastMessage ?? 'No messages yet',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatTime(chat.lastMessageTime),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            onTap: () {
                              try {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatPage(
                                      chatId: chat.id,
                                      currentUser: user,
                                      otherUserName: _getUserDisplayName(otherUser),
                                    ),
                                  ),
                                );//.*
                              } catch (e) {
                                print('Error navigating to chat: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error opening chat'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  );
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  
  String _getInitials(UserModel user) {
    try {
      if (user.name != null && user.name!.isNotEmpty) {
        return user.name!.substring(0, 1).toUpperCase();
      }
      if (user.email.isNotEmpty) {
        return user.email.substring(0, 1).toUpperCase();
      }
      return 'U';
    } catch (e) {
      print('Error getting initials: $e');
      return 'U';
    }
  }

  
  String _getUserInitials(dynamic otherUser) {
    try {
      if (otherUser?.name != null && otherUser!.name!.isNotEmpty) {
        return otherUser.name!.substring(0, 1).toUpperCase();
      }
      if (otherUser?.email != null && otherUser!.email!.isNotEmpty) {
        return otherUser.email!.substring(0, 1).toUpperCase();
      }
      return 'U';
    } catch (e) {
      print('Error getting user initials: $e');
      return 'U';
    }
  }

  
  String _getUserDisplayName(dynamic otherUser) {
    try {
      if (otherUser?.name != null && otherUser!.name!.isNotEmpty) {
        return otherUser.name!;
      }
      if (otherUser?.email != null && otherUser!.email!.isNotEmpty) {
        return otherUser.email!;
      }
      return 'Unknown User';
    } catch (e) {
      print('Error getting display name: $e');
      return 'Unknown User';
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    try {
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      print('Error formatting time: $e');
      return '';
    }
  }

  @override
  void dispose() {
    try {
      context.read<MessageBloc>().add(DisconnectSocket());
    } catch (e) {
      print('Error disconnecting socket: $e');
    }
    super.dispose();
  }
}