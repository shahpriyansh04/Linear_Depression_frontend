import 'package:flutter/material.dart';
import 'package:udaan_app/student/financial_aid/search_result_page.dart';

class SelectableButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8, bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class FinancialAidFilter extends StatefulWidget {
  @override
  _FinancialAidFilterState createState() => _FinancialAidFilterState();
}

class _FinancialAidFilterState extends State<FinancialAidFilter> {
  RangeValues _currentRangeValues = RangeValues(0, 100000);
  Set<String> selectedFundingTypes = {};
  String? selectedCourseLevel;
  String? selectedLocation;
  String? selectedFieldOfStudy;

  final List<String> fundingTypes = [
    'Educational Grants',
    'Merit Awards',
    'Financial Support',
    'Student Financing',
  ];

  final List<String> courseLevels = [
    'Diploma',
    'Higher Secondary',
    'ITI',
    'Post Graduate/PG Diploma',
    'Primary and Secondary Professional Certificate',
    'Under Graduate',
  ];

  final List<String> fieldsOfStudy = [
    'Engineering & Technology',
    'Medical & Health Sciences',
    'Business & Management',
    'Arts & Humanities',
    'Science & Mathematics',
    'Social Sciences',
    'Law',
    'Agriculture',
  ];

  void _clearAll() {
    setState(() {
      _currentRangeValues = RangeValues(0, 100000);
      selectedFundingTypes.clear();
      selectedCourseLevel = null;
      selectedLocation = null;
      selectedFieldOfStudy = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Financial Aid',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _clearAll,
                    child: Text('Clear All'),
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Aid Amount Range Slider
              _buildSectionTitle('Aid Amount'),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    RangeSlider(
                      values: _currentRangeValues,
                      min: 0,
                      max: 100000,
                      divisions: 20,
                      labels: RangeLabels(
                        '₹${_currentRangeValues.start.round()}',
                        '₹${_currentRangeValues.end.round()}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('₹0'),
                        Text('₹100,000'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Funding Type Selectable Buttons
              _buildSectionTitle('Funding Type'),
              Container(
                padding: EdgeInsets.all(16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: fundingTypes
                      .map((type) => SelectableButton(
                            text: type,
                            isSelected: selectedFundingTypes.contains(type),
                            onTap: () {
                              setState(() {
                                if (selectedFundingTypes.contains(type)) {
                                  selectedFundingTypes.remove(type);
                                } else {
                                  selectedFundingTypes.add(type);
                                }
                              });
                            },
                          ))
                      .toList(),
                ),
              ),

              SizedBox(height: 20),

              // Course Level Dropdown
              _buildSectionTitle('Course Level'),
              _buildDropdown(
                value: selectedCourseLevel,
                items: courseLevels,
                hint: 'Select Course Level',
                onChanged: (String? value) {
                  setState(() {
                    selectedCourseLevel = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Location TextField
              _buildSectionTitle('Location'),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Location',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value;
                    });
                  },
                ),
              ),

              SizedBox(height: 20),

              // Field of Study Dropdown
              _buildSectionTitle('Field of Study'),
              _buildDropdown(
                value: selectedFieldOfStudy,
                items: fieldsOfStudy,
                hint: 'Select Field of Study',
                onChanged: (String? value) {
                  setState(() {
                    selectedFieldOfStudy = value;
                  });
                },
              ),

              SizedBox(height: 32),

              // Search Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScholarshipResultsPage(
                          aidAmount: _currentRangeValues,
                          scholarships: selectedFundingTypes.toList(),
                          courseLevel: selectedCourseLevel ?? '',
                          location: selectedLocation ?? '',
                          fieldOfStudy: selectedFieldOfStudy ?? '',
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.search),
                  label: Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down),
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
