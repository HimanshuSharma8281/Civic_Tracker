import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class NotificationsScreen extends StatefulWidget {
  final Function(String?) onNotificationClick;

  const NotificationsScreen({Key? key, required this.onNotificationClick}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _notifications = List.from(mockNotifications);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  IconData _getNotificationIcon(String title) {
    if (title.contains('Update') || title.contains('Progress')) {
      return Icons.update;
    } else if (title.contains('Resolved') || title.contains('Complete')) {
      return Icons.check_circle;
    } else if (title.contains('Feature') || title.contains('New')) {
      return Icons.new_releases;
    } else if (title.contains('Received') || title.contains('Thank')) {
      return Icons.receipt;
    } else {
      return Icons.notifications;
    }
  }

  Color _getNotificationColor(String title) {
    if (title.contains('Update') || title.contains('Progress')) {
      return Colors.blue[600]!;
    } else if (title.contains('Resolved') || title.contains('Complete')) {
      return Colors.green[600]!;
    } else if (title.contains('Feature') || title.contains('New')) {
      return Colors.purple[600]!;
    } else if (title.contains('Received') || title.contains('Thank')) {
      return Colors.orange[600]!;
    } else {
      return Colors.grey[600]!;
    }
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = NotificationItem(
          id: _notifications[index].id,
          title: _notifications[index].title,
          message: _notifications[index].message,
          timestamp: _notifications[index].timestamp,
          read: true,
          reportId: _notifications[index].reportId,
        );
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((notification) => NotificationItem(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        timestamp: notification.timestamp,
        read: true,
        reportId: notification.reportId,
      )).toList();
    });
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n.id == notificationId);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // Restore notification
            setState(() {
              _notifications = List.from(mockNotifications);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadNotifications = _notifications.where((n) => !n.read).toList();
    final allNotifications = _notifications;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (unreadNotifications.isNotEmpty)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all read',
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  _showNotificationSettings();
                  break;
                case 'clear':
                  _showClearAllDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 20),
                    SizedBox(width: 8),
                    Text('Notification Settings'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, size: 20),
                    SizedBox(width: 8),
                    Text('Clear All'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue[600],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.blue[600],
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Unread'),
                  if (unreadNotifications.isNotEmpty) ...[
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        unreadNotifications.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(text: 'All (${allNotifications.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList(unreadNotifications, showEmpty: true),
          _buildNotificationsList(allNotifications, showEmpty: false),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationItem> notifications, {required bool showEmpty}) {
    if (notifications.isEmpty) {
      return _buildEmptyState(showEmpty);
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: notification.read ? 1 : 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            if (!notification.read) {
              _markAsRead(notification.id);
            }
            if (notification.reportId != null) {
              widget.onNotificationClick(notification.reportId);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: notification.read ? Colors.white : Colors.blue[50],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.title).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.title),
                    color: _getNotificationColor(notification.title),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.read ? FontWeight.w500 : FontWeight.w600,
                              ),
                            ),
                          ),
                          if (!notification.read)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.blue[600],
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getTimeAgo(notification.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          if (notification.reportId != null)
                            Text(
                              'Tap to view report',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Actions
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'read':
                        _markAsRead(notification.id);
                        break;
                      case 'delete':
                        _deleteNotification(notification.id);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    if (!notification.read)
                      PopupMenuItem(
                        value: 'read',
                        child: Row(
                          children: [
                            Icon(Icons.mark_email_read, size: 18),
                            SizedBox(width: 8),
                            Text('Mark as read'),
                          ],
                        ),
                      ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(Icons.more_vert, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isUnreadTab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUnreadTab ? Icons.mark_email_read : Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            isUnreadTab ? 'All caught up!' : 'No notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            isUnreadTab 
                ? 'You have no unread notifications'
                : 'You haven\'t received any notifications yet',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (isUnreadTab) ...[
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _tabController.animateTo(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('View All Notifications'),
            ),
          ],
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notification Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Push Notifications'),
                subtitle: Text('Receive notifications on your device'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: Colors.blue[600],
                ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Email Notifications'),
                subtitle: Text('Get updates via email'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: Colors.blue[600],
                ),
              ),
              ListTile(
                leading: Icon(Icons.schedule),
                title: Text('Notification Schedule'),
                subtitle: Text('Set quiet hours'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Schedule settings coming soon')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear All Notifications'),
        content: Text('Are you sure you want to delete all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _notifications.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All notifications cleared'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      setState(() {
                        _notifications = List.from(mockNotifications);
                      });
                    },
                  ),
                ),
              );
            },
            child: Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}