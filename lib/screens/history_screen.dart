import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class HistoryScreen extends StatefulWidget {
  final Function(String) onReportClick;

  const HistoryScreen({Key? key, required this.onReportClick})
      : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  List<Report> _filteredReports = [];
  late TabController _tabController;

  // Define issue categories for statistics
  final List<String> issueCategories = [
    'Roads & Infrastructure',
    'Lighting',
    'Water & Sewage',
    'Waste Management',
    'Public Safety',
    'Parks & Recreation',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredReports = mockReports;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search your reports...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),

              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: Colors.blue[600],
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: Colors.blue[600],
                tabs: [
                  Tab(text: 'Reports (${_filteredReports.length})'),
                  Tab(text: 'Statistics'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReportsTab(),
          _buildStatisticsTab(),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return Column(
      children: [
        // Filter Bar
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip('All'),
              _buildFilterChip('Submitted'),
              _buildFilterChip('In Progress'),
              _buildFilterChip('Resolved'),
            ],
          ),
        ),

        // Reports List
        Expanded(
          child: _filteredReports.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredReports.length,
                  itemBuilder: (context, index) {
                    final report = _filteredReports[index];
                    return _buildReportCard(report);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatisticsTab() {
    final totalReports = mockReports.length;
    final submittedReports =
        mockReports.where((r) => r.status == ReportStatus.submitted).length;
    final inProgressReports =
        mockReports.where((r) => r.status == ReportStatus.inProgress).length;
    final resolvedReports =
        mockReports.where((r) => r.status == ReportStatus.resolved).length;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8), // Reduced from 12
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report Statistics',
              style: TextStyle(
                fontSize: 18, // Reduced from 20
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12), // Reduced from 16

            // Overview Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Reports',
                    totalReports.toString(),
                    Icons.description,
                    Colors.blue[600]!,
                  ),
                ),
                SizedBox(width: 10), // Reduced from 12
                Expanded(
                  child: _buildStatCard(
                    'Resolved',
                    resolvedReports.toString(),
                    Icons.check_circle,
                    Colors.green[600]!,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Reduced from 12
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'In Progress',
                    inProgressReports.toString(),
                    Icons.schedule,
                    Colors.blue[600]!,
                  ),
                ),
                SizedBox(width: 10), // Reduced from 12
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    submittedReports.toString(),
                    Icons.pending,
                    Colors.yellow[600]!,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Reduced from 32

            // Category Breakdown
            Text(
              'Reports by Category',
              style: TextStyle(
                fontSize: 16, // Reduced from 18
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12), // Reduced from 16

            ...issueCategories.take(5).map((category) {
              final count =
                  mockReports.where((r) => r.category == category).length;
              if (count == 0) return SizedBox.shrink();

              return Container(
                margin: EdgeInsets.only(bottom: 6), // Reduced from 8
                padding: EdgeInsets.all(12), // Reduced from 16
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8), // Reduced from 12
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 13, // Reduced from 14
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3), // Reduced padding
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius:
                            BorderRadius.circular(10), // Reduced from 12
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 11, // Reduced from 12
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            SizedBox(height: 20), // Add bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(10), // Reduced from 12
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Reduced from 12
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 22, // Reduced from 24
          ),
          SizedBox(height: 4), // Reduced from 6
          Text(
            value,
            style: TextStyle(
              fontSize: 18, // Reduced from 20
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2), // Keep same
          Text(
            title,
            style: TextStyle(
              fontSize: 10, // Reduced from 11
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        selectedColor: Colors.blue[100],
        labelStyle: TextStyle(
          color: isSelected ? Colors.blue[800] : Colors.grey[600],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildReportCard(Report report) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => widget.onReportClick(report.id),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        report.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(report.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        report.statusString.replaceAll('-', ' '),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(report.status),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Description
                Text(
                  report.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),

                // Footer
                Row(
                  children: [
                    Icon(Icons.category, size: 16, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      report.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      _getTimeAgo(report.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                // Photos indicator
                if (report.photos.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(Icons.photo, size: 16, color: Colors.grey[500]),
                        SizedBox(width: 4),
                        Text(
                          '${report.photos.length} photo${report.photos.length > 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No reports found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
