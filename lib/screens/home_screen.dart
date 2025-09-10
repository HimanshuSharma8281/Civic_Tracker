import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class HomeScreen extends StatefulWidget {
  final Function(AppScreen) onNavigate;

  const HomeScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String? _selectedCategory;

  void _filterPins() {
    // This method is for future use when filtering is needed
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.submitted:
        return Colors.red.shade500;
      case ReportStatus.inProgress:
        return Colors.yellow.shade600;
      case ReportStatus.resolved:
        return Colors.green.shade500;
    }
  }

  void _onReportClick(String reportId) {
    widget.onNavigate(AppScreen.detail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Civic Tracker',
          style: TextStyle(
            color: Color(0xFF2196F3),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.grey[600]),
            onPressed: () => widget.onNavigate(AppScreen.notifications),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by location or issue type...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Filters
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: const Text('All Issues'),
                            selected: _selectedCategory == null,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = null;
                                _filterPins();
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: Color(0xFF2196F3),
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: _selectedCategory == null
                                  ? Colors.white
                                  : Color(0xFF2196F3),
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Color(0xFF2196F3),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.construction,
                                size: 16,
                                color: _selectedCategory == 'road'
                                    ? Colors.white
                                    : Color(0xFF2196F3),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Road Issues',
                                style: TextStyle(
                                  color: _selectedCategory == 'road'
                                      ? Colors.white
                                      : Color(0xFF2196F3),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          selected: _selectedCategory == 'road',
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? 'road' : null;
                              _filterPins();
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Color(0xFF2196F3),
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: Color(0xFF2196F3),
                              width: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                size: 16,
                                color: _selectedCategory == 'streetlight'
                                    ? Colors.white
                                    : Color(0xFF2196F3),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Streetlight Issues',
                                style: TextStyle(
                                  color: _selectedCategory == 'streetlight'
                                      ? Colors.white
                                      : Color(0xFF2196F3),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          selected: _selectedCategory == 'streetlight',
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory =
                                  selected ? 'streetlight' : null;
                              _filterPins();
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: Color(0xFF2196F3),
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: Color(0xFF2196F3),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Map Area
            Expanded(
              child: Stack(
                children: [
                  // Mock Map Background
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.green.shade50,
                          Colors.blue.shade50,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Grid Lines
                        CustomPaint(
                          size: Size.infinite,
                          painter: GridPainter(),
                        ),

                        // Map Pins
                        ...mockReports.asMap().entries.map((entry) {
                          final index = entry.key;
                          final report = entry.value;

                          return Positioned(
                            left: (20 + (index * 15) % 60) /
                                100 *
                                MediaQuery.of(context).size.width,
                            top: (30 + (index * 20) % 40) /
                                100 *
                                (MediaQuery.of(context).size.height - 200),
                            child: GestureDetector(
                              onTap: () => _onReportClick(report.id),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 32,
                                    color:
                                        Colors.grey.shade700.withOpacity(0.6),
                                  ),
                                  Positioned(
                                    top: 6,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(report.status),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 2,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        // Street Names
                        const Positioned(
                          left: 60,
                          top: 80,
                          child: Text(
                            'Main Street',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 120,
                          top: 160,
                          child: Text(
                            'Oak Avenue',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 80,
                          bottom: 100,
                          child: Text(
                            'Pine Street',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Legend
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Status Legend',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildLegendItem('Submitted', Colors.red.shade500),
                          _buildLegendItem(
                              'In Progress', Colors.yellow.shade600),
                          _buildLegendItem('Resolved', Colors.green.shade500),
                        ],
                      ),
                    ),
                  ),

                  // Stats
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${mockReports.where((r) => r.status != ReportStatus.resolved).length}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'Active Issues',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 1;

    // Vertical lines
    for (int i = 0; i < 20; i++) {
      final x = i * size.width / 20;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (int i = 0; i < 20; i++) {
      final y = i * size.height / 20;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
