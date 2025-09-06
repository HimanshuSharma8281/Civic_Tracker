import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class ReportDetailScreen extends StatefulWidget {
  final String reportId;
  final VoidCallback onBack;

  const ReportDetailScreen({
    Key? key,
    required this.reportId,
    required this.onBack,
  }) : super(key: key);

  @override
  _ReportDetailScreenState createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  int _selectedPhotoIndex = 0;

  Report? get _report {
    try {
      return mockReports.firstWhere((r) => r.id == widget.reportId);
    } catch (e) {
      return mockReports.isNotEmpty ? mockReports.first : null;
    }
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.submitted:
        return Colors.yellow[600]!;
      case ReportStatus.inProgress:
        return Colors.blue[600]!;
      case ReportStatus.resolved:
        return Colors.green[600]!;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_report == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Report Not Found'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: widget.onBack,
          ),
        ),
        body: Center(
          child: Text('Report not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar with Photos
          SliverAppBar(
            expandedHeight: _report!.photos.isNotEmpty ? 300 : 120,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: widget.onBack,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // Share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sharing functionality coming soon')),
                  );
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Edit functionality coming soon')),
                      );
                      break;
                    case 'delete':
                      _showDeleteDialog();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit Report'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Report', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Report Details',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: _report!.photos.isNotEmpty
                  ? Stack(
                      children: [
                        PageView.builder(
                          itemCount: _report!.photos.length,
                          onPageChanged: (index) {
                            setState(() {
                              _selectedPhotoIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Image.network(
                              _report!.photos[index],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        if (_report!.photos.length > 1)
                          Positioned(
                            bottom: 80,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _report!.photos.asMap().entries.map((entry) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _selectedPhotoIndex == entry.key
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue[100]!,
                            Colors.blue[200]!,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.description,
                          size: 48,
                          color: Colors.blue[600],
                        ),
                      ),
                    ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _report!.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(_report!.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _getStatusColor(_report!.status).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _report!.statusString.replaceAll('-', ' ').toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(_report!.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  // Meta Information
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.category, 'Category', _report!.category),
                        _buildInfoRow(Icons.location_on, 'Location', _report!.location),
                        _buildInfoRow(Icons.access_time, 'Reported', _getTimeAgo(_report!.createdAt)),
                        if (_report!.updatedAt != null)
                          _buildInfoRow(Icons.update, 'Last Updated', _getTimeAgo(_report!.updatedAt!)),
                        _buildInfoRow(Icons.confirmation_number, 'Report ID', 'CR-${_report!.id}'),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _report!.description,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Admin Comments
                  if (_report!.adminComment != null) ...[
                    Text(
                      'Official Response',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.admin_panel_settings, 
                                  color: Colors.blue[600], size: 20),
                              SizedBox(width: 8),
                              Text(
                                'City Officials',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            _report!.adminComment!,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                  
                  // Progress Timeline
                  Text(
                    'Progress Timeline',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildTimeline(),
                  SizedBox(height: 32),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Contact support
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Contact support feature coming soon')),
                            );
                          },
                          icon: Icon(Icons.support_agent),
                          label: Text('Contact Support'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Update report
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Update report feature coming soon')),
                            );
                          },
                          icon: Icon(Icons.edit),
                          label: Text('Update Report'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final events = [
      {
        'title': 'Report Submitted',
        'time': _getTimeAgo(_report!.createdAt),
        'completed': true,
      },
      {
        'title': 'Under Review',
        'time': _report!.status != ReportStatus.submitted ? 'Completed' : 'Pending',
        'completed': _report!.status != ReportStatus.submitted,
      },
      {
        'title': 'In Progress',
        'time': _report!.status == ReportStatus.inProgress || _report!.status == ReportStatus.resolved 
                ? 'Active' : 'Pending',
        'completed': _report!.status == ReportStatus.inProgress || _report!.status == ReportStatus.resolved,
      },
      {
        'title': 'Resolved',
        'time': _report!.status == ReportStatus.resolved ? 'Completed' : 'Pending',
        'completed': _report!.status == ReportStatus.resolved,
      },
    ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: events.asMap().entries.map((entry) {
          final index = entry.key;
          final event = entry.value;
          final isLast = index == events.length - 1;
          
          return Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: event['completed'] as bool 
                          ? Colors.green[600] 
                          : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: event['completed'] as bool
                        ? Icon(Icons.check, color: Colors.white, size: 14)
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: event['completed'] as bool 
                              ? Colors.grey[800] 
                              : Colors.grey[500],
                        ),
                      ),
                      Text(
                        event['time'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Report'),
        content: Text('Are you sure you want to delete this report? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Delete functionality coming soon')),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}