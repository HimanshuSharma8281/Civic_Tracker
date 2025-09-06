import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class HomeScreen extends StatefulWidget {
  final Function(AppScreen) onNavigate;

  const HomeScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String _searchQuery = '';
  String? _selectedPin;
  List<String> _activeFilters = [];
  double _zoomLevel = 1.0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  List<Report> get _filteredReports {
    return mockReports.where((report) {
      final matchesSearch = report.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          report.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          report.category.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesFilter = _activeFilters.isEmpty ||
          _activeFilters.contains(report.statusString) ||
          _activeFilters.contains(report.category);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (_activeFilters.contains(filter)) {
        _activeFilters.remove(filter);
      } else {
        _activeFilters.add(filter);
      }
    });
  }

  Report? get _selectedReport {
    if (_selectedPin == null) return null;
    return mockReports.firstWhere((r) => r.id == _selectedPin, orElse: () => mockReports.first);
  }

  Map<String, int> get _statistics {
    return {
      'total': mockReports.length,
      'submitted': mockReports.where((r) => r.status == ReportStatus.submitted).length,
      'inProgress': mockReports.where((r) => r.status == ReportStatus.inProgress).length,
      'resolved': mockReports.where((r) => r.status == ReportStatus.resolved).length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Title row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'City Map',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_filteredReports.length} issues in your area',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        FloatingActionButton.small(
                          onPressed: () => widget.onNavigate(AppScreen.report),
                          backgroundColor: Colors.blue[600],
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    // Search and Filter
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search issues...',
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
                        SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _showFilterModal(),
                          icon: Stack(
                            children: [
                              Icon(Icons.filter_list),
                              if (_activeFilters.isNotEmpty)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      _activeFilters.length.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    
                    // Quick Stats
                    Row(
                      children: [
                        _buildStatCard('Total', _statistics['total']!, Colors.grey[600]!),
                        _buildStatCard('New', _statistics['submitted']!, Colors.yellow[600]!),
                        _buildStatCard('Active', _statistics['inProgress']!, Colors.blue[600]!),
                        _buildStatCard('Fixed', _statistics['resolved']!, Colors.green[600]!),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Map Area
          Expanded(
            child: Stack(
              children: [
                // Map Background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.green[100]!,
                        Colors.blue[100]!,
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: MapPainter(),
                  ),
                ),
                
                // Issue Pins
                ..._filteredReports.asMap().entries.map((entry) {
                  final index = entry.key;
                  final report = entry.value;
                  final isSelected = _selectedPin == report.id;
                  
                  return Positioned(
                    left: MediaQuery.of(context).size.width * (0.3 + index * 0.15),
                    top: MediaQuery.of(context).size.height * (0.35 + index * 0.12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPin = isSelected ? null : report.id;
                        });
                        if (!isSelected) {
                          _animationController.forward();
                        }
                      },
                      child: AnimatedScale(
                        scale: isSelected ? 1.2 : 1.0,
                        duration: Duration(milliseconds: 200),
                        child: Stack(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: _getStatusColor(report.status),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(report.status).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                
                // Map Controls
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: "zoom_in",
                        onPressed: () {
                          setState(() {
                            _zoomLevel = (_zoomLevel + 0.2).clamp(0.5, 2.0);
                          });
                        },
                        backgroundColor: Colors.white,
                        child: Icon(Icons.add, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: "zoom_out",
                        onPressed: () {
                          setState(() {
                            _zoomLevel = (_zoomLevel - 0.2).clamp(0.5, 2.0);
                          });
                        },
                        backgroundColor: Colors.white,
                        child: Icon(Icons.remove, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                
                // Location Button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    heroTag: "location",
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    child: Icon(Icons.my_location, color: Colors.black),
                  ),
                ),
                
                // Floating Report Button
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: FloatingActionButton(
                    heroTag: "report",
                    onPressed: () => widget.onNavigate(AppScreen.report),
                    backgroundColor: Colors.blue[600],
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
                
                // Pin Preview Card
                if (_selectedReport != null)
                  Positioned(
                    bottom: 80,
                    left: 16,
                    right: 16,
                    child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _selectedReport!.photos.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        _selectedReport!.photos.first,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.photo, color: Colors.grey);
                                        },
                                      ),
                                    )
                                  : Icon(Icons.photo, color: Colors.grey),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _selectedReport!.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(_selectedReport!.status).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          _selectedReport!.statusString.replaceAll('-', ' '),
                                          style: TextStyle(
                                            color: _getStatusColor(_selectedReport!.status),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _selectedReport!.description,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _selectedReport!.category,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => widget.onNavigate(AppScreen.detail),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue[600],
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                          minimumSize: Size(0, 0),
                                        ),
                                        child: Text(
                                          'View Details',
                                          style: TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedPin = null;
                                });
                              },
                              icon: Icon(Icons.close, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Bottom Panel
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => widget.onNavigate(AppScreen.history),
                      child: Text('View All'),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ...mockReports.take(2).map((report) => _buildActivityItem(report)).toList(),
                SizedBox(height: 16),
                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLegendItem('New', Colors.yellow[600]!),
                    _buildLegendItem('Active', Colors.blue[600]!),
                    _buildLegendItem('Fixed', Colors.green[600]!),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Report report) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _getStatusColor(report.status),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  report.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
              SizedBox(width: 4),
              Text(
                '2h ago',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter Issues',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['submitted', 'in-progress', 'resolved'].map((status) {
                      final isSelected = _activeFilters.contains(status);
                      return FilterChip(
                        label: Text(status.replaceAll('-', ' ')),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _toggleFilter(status);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: issueCategories.take(6).map((category) {
                      final isSelected = _activeFilters.contains(category);
                      return FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _toggleFilter(category);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  if (_activeFilters.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _activeFilters.clear();
                        });
                      },
                      child: Text('Clear All Filters'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw some simple map-like shapes
    final path1 = Path();
    path1.moveTo(size.width * 0.2, size.height * 0.2);
    path1.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.1,
      size.width * 0.6,
      size.height * 0.2,
    );
    path1.lineTo(size.width * 0.6, size.height * 0.6);
    path1.lineTo(size.width * 0.2, size.height * 0.6);
    path1.close();

    canvas.drawPath(path1, paint);

    paint.color = Colors.blue.withOpacity(0.2);
    final path2 = Path();
    path2.moveTo(0, size.height * 0.6);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.6,
      size.height * 0.6,
    );
    path2.lineTo(size.width * 0.6, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}