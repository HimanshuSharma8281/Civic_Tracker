import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

// Create a more compact statistics layout to fix overflow
// ...existing imports and class definition...

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[600]),
                      SizedBox(width: 12),
                      Text(
                        'Search your reports...',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Tab Bar
                Row(
                  children: [
                    Text(
                      'Reports (5)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Statistics',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2196F3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Container(
                      height: 3,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Report Statistics Title
                Text(
                  'Report Statistics',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),

                // Statistics Cards - Compact Grid
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildCompactStatCard(
                              icon: Icons.description,
                              iconColor: Color(0xFF2196F3),
                              value: '5',
                              label: 'Total Reports',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildCompactStatCard(
                              icon: Icons.check_circle,
                              iconColor: Colors.green,
                              value: '1',
                              label: 'Resolved',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCompactStatCard(
                              icon: Icons.access_time,
                              iconColor: Color(0xFF2196F3),
                              value: '2',
                              label: 'In Progress',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildCompactStatCard(
                              icon: Icons.pending,
                              iconColor: Colors.orange,
                              value: '2',
                              label: 'Pending',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Reports by Category
                Text(
                  'Reports by Category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16),

                // Category Items - Compact
                _buildCategoryItem('Roads & Infrastructure', 1),
                SizedBox(height: 12),
                _buildCategoryItem('Lighting', 1),

                SizedBox(height: 40), // Extra space to ensure no overflow
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
            color: iconColor,
            size: 32,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category, int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            category,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF2196F3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
