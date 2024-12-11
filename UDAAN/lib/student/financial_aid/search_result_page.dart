import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

// Custom Colors (keep the existing color definitions)
const primaryColor = Color(0xFF512DA8);
const primaryLightColor = Color(0xFFEDE7F6);
const accentColor = Color(0xFF4CAF50);
const cardHeaderGradientStart = Color(0xFF673AB7);
const cardHeaderGradientEnd = Color(0xFF9575CD);
const eligibleColor = Color.fromARGB(255, 61, 147, 66);
const notEligibleColor = Color(0xFFE57373);
const grayTextColor = Color(0xFF757575);

class ScholarshipResultsPage extends StatefulWidget {
  final RangeValues aidAmount;
  final List<String> scholarships;
  final String courseLevel;
  final String location;
  final String fieldOfStudy;

  const ScholarshipResultsPage({
    Key? key,
    required this.aidAmount,
    required this.scholarships,
    required this.courseLevel,
    required this.location,
    required this.fieldOfStudy,
  }) : super(key: key);

  @override
  _ScholarshipResultsPageState createState() => _ScholarshipResultsPageState();
}

class _ScholarshipResultsPageState extends State<ScholarshipResultsPage> {
  late List<Scholarship> originalScholarships;
  late List<Scholarship> filteredScholarships;
  String searchQuery = '';
  String sortBy = 'name';

  @override
  void initState() {
    super.initState();
    // Predefined list of scholarships
    originalScholarships = [
      Scholarship(
        name: 'Vinod Handa Scholarship for Class 1st to Class 8th (2024-25)',
        amount: 15000,
        gender: 'Female',
        maxIncome: 500000,
        location: 'Dehradun',
        academicLevel: 'Class 1-8',
        applicationStart: DateTime(2024, 11, 13),
        applicationEnd: DateTime(2025, 1, 12),
        description:
            'Epsilon Carbon Pvt Ltd, through Epsilon Foundation, supports meritorious students to overcome financial constraints. This scholarship focuses on quality education for female students in Dehradun.',
        eligibility:
            'Female students in Dehradun, family income below 5 lakhs, studying in classes 1-8',
        requiredDocuments:
            'Identity proof, Address proof, Income certificate, Latest marksheet',
        contactEmail: 'epsilon@scholarship.com',
        helpdesk: '1800-123-4567',
        isEligible: true,
      ),
      Scholarship(
        name: 'National Talent Search Scholarship',
        amount: 50000,
        gender: 'Any',
        maxIncome: 1500000,
        location: 'All India',
        academicLevel: 'Class 10',
        applicationStart: DateTime(2024, 8, 1),
        applicationEnd: DateTime(2024, 9, 30),
        description:
            'The National Talent Search Examination (NTSE) is a national-level scholarship program to identify and nurture talented students across India.',
        eligibility:
            'Students studying in Class 10, All genders, Family income below 15 lakhs',
        requiredDocuments:
            'School ID, Aadhar Card, Income certificate, Class 9 marksheet',
        contactEmail: 'ntse@gov.in',
        helpdesk: '011-2696-2580',
        isEligible: false,
      ),
      Scholarship(
        name: 'AICTE Pragati Scholarship for Girls',
        amount: 30000,
        gender: 'Female',
        maxIncome: 800000,
        location: 'All India',
        academicLevel: 'UG Engineering',
        applicationStart: DateTime(2024, 9, 15),
        applicationEnd: DateTime(2024, 10, 31),
        description:
            'AICTE Pragati Scholarship aims to provide assistance for advancement of girls to pursue technical education.',
        eligibility:
            'First year female students of AICTE approved institutions, Family income below 8 lakhs',
        requiredDocuments:
            'Aadhar Card, Income certificate, JEE rank card, College admission letter',
        contactEmail: 'pragati-scholarship@aicte-india.org',
        helpdesk: '011-2958-1000',
        isEligible: true,
      ),
      Scholarship(
        name: 'Kishore Vaigyanik Protsahan Yojana (KVPY)',
        amount: 80000,
        gender: 'Any',
        maxIncome: 2500000,
        location: 'All India',
        academicLevel: 'Class 11-12, UG',
        applicationStart: DateTime(2024, 7, 1),
        applicationEnd: DateTime(2024, 8, 15),
        description:
            'KVPY is an on-going National Program of Fellowship in Basic Sciences, initiated and funded by the Department of Science and Technology, Government of India.',
        eligibility:
            'Students in 11th, 12th standard or 1st year of any UG Program in Basic Sciences',
        requiredDocuments:
            'School/College ID, Aadhar Card, Latest marksheet, Recommendation letter',
        contactEmail: 'kvpy@iisc.ac.in',
        helpdesk: '080-2293-2975',
        isEligible: true,
      ),
      Scholarship(
        name: 'Post-Matric Scholarship for SC Students',
        amount: 25000,
        gender: 'Any',
        maxIncome: 250000,
        location: 'All India',
        academicLevel: 'Class 11-12, UG, PG',
        applicationStart: DateTime(2024, 8, 1),
        applicationEnd: DateTime(2024, 10, 31),
        description:
            'This scholarship aims to support Scheduled Caste students studying at post-matriculation or post-secondary stage to complete their education.',
        eligibility:
            'SC students, Family income below 2.5 lakhs, Studying in recognized institutions',
        requiredDocuments:
            'Caste certificate, Income certificate, Previous year marksheet, Institution verification form',
        contactEmail: 'sc-scholarship@gov.in',
        helpdesk: '1800-111-965',
        isEligible: false,
      ),
    ];
    
    // Apply initial filters
    _applyAllFilters();
  }

  void _applyAllFilters() {
    setState(() {
      filteredScholarships = originalScholarships.where((scholarship) {
        // Filter by aid amount
        bool amountMatch = scholarship.amount >= widget.aidAmount.start &&
            scholarship.amount <= widget.aidAmount.end;

        // Filter by funding types (scholarships)
        bool scholarshipTypeMatch = widget.scholarships.isEmpty || 
            widget.scholarships.any((type) => 
                scholarship.name.toLowerCase().contains(type.toLowerCase()));

        // Filter by course level
        bool courseLevelMatch = widget.courseLevel.isEmpty || 
            scholarship.academicLevel.toLowerCase().contains(widget.courseLevel.toLowerCase());

        // Filter by location
        bool locationMatch = widget.location.isEmpty || 
            scholarship.location.toLowerCase().contains(widget.location.toLowerCase());

        // Filter by field of study
        bool fieldOfStudyMatch = widget.fieldOfStudy.isEmpty || 
            scholarship.name.toLowerCase().contains(widget.fieldOfStudy.toLowerCase());

        // Return true only if all applied filters match
        return amountMatch && 
               scholarshipTypeMatch && 
               courseLevelMatch && 
               locationMatch && 
               fieldOfStudyMatch;
      }).toList();

      // Apply sorting
      _sortScholarships();
    });
  }

  void _sortScholarships() {
    filteredScholarships.sort((a, b) {
      switch (sortBy) {
        case 'amount':
          return b.amount.compareTo(a.amount);
        case 'deadline':
          return a.applicationEnd.compareTo(b.applicationEnd);
        default:
          return a.name.compareTo(b.name);
      }
    });
  }

  void _filterScholarships() {
    setState(() {
      // First apply all predefined filters
      _applyAllFilters();

      // Then apply search query filter
      if (searchQuery.isNotEmpty) {
        filteredScholarships = filteredScholarships
            .where((scholarship) => scholarship.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Scholarship Results',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchAndSort(),
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredScholarships.length,
              itemBuilder: (context, index) {
                return ScholarshipCard(
                    scholarship: filteredScholarships[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndSort() {
    return Container(
      color: primaryColor,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search scholarships',
                hintStyle: GoogleFonts.poppins(color: grayTextColor),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: primaryLightColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: primaryColor),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: GoogleFonts.poppins(),
              onChanged: (value) {
                searchQuery = value;
                _filterScholarships();
              },
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryLightColor),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: sortBy,
                  isExpanded: true,
                  icon: Icon(Icons.sort, color: primaryColor),
                  style: GoogleFonts.poppins(color: Colors.black87),
                  items: [
                    DropdownMenuItem(
                        value: 'name', child: Text('Sort by Name')),
                    DropdownMenuItem(
                        value: 'amount', child: Text('Sort by Amount')),
                    DropdownMenuItem(
                        value: 'deadline', child: Text('Sort by Deadline')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      sortBy = value!;
                      _sortScholarships();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Results: ${filteredScholarships.length}',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.filter_list),
            label: Text('Change Filters'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: primaryColor),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class ScholarshipCard extends StatefulWidget {
  final Scholarship scholarship;

  ScholarshipCard({Key? key, required this.scholarship}) : super(key: key);

  @override
  _ScholarshipCardState createState() => _ScholarshipCardState();
}

class _ScholarshipCardState extends State<ScholarshipCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildKeyHighlights(),
          _buildDescription(),
          _buildAdditionalDetails(),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardHeaderGradientStart,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.scholarship.name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              _buildEligibilityBadge(),
            ],
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor.withOpacity(0.8), accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '₹${NumberFormat('#,##,###').format(widget.scholarship.amount)}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEligibilityBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.scholarship.isEligible ? eligibleColor : notEligibleColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.scholarship.isEligible ? Icons.check_circle : Icons.cancel,
            color: Colors.white,
            size: 16,
          ),
          SizedBox(width: 4),
          Text(
            widget.scholarship.isEligible ? 'Eligible' : 'Not Eligible',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyHighlights() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Highlights',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHighlightItem(Icons.person, widget.scholarship.gender),
              _buildHighlightItem(Icons.attach_money,
                  'Income < ₹${NumberFormat('#,##,###').format(widget.scholarship.maxIncome)}'),
              _buildHighlightItem(
                  Icons.location_on, widget.scholarship.location),
              _buildHighlightItem(
                  Icons.school, widget.scholarship.academicLevel),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryLightColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: primaryColor),
                SizedBox(width: 8),
                Text(
                  '${DateFormat('dd MMM yyyy').format(widget.scholarship.applicationStart)} - ${DateFormat('dd MMM yyyy').format(widget.scholarship.applicationEnd)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: primaryLightColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: primaryColor),
          SizedBox(height: 4),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            widget.scholarship.description,
            style: GoogleFonts.poppins(fontSize: 14, color: grayTextColor),
            maxLines: isExpanded ? null : 3,
            overflow: isExpanded ? null : TextOverflow.ellipsis,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? 'Show Less' : 'Read More',
              style: GoogleFonts.poppins(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalDetails() {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        colorScheme: ColorScheme.light(primary: primaryColor),
      ),
      child: ExpansionTile(
        title: Text(
          'Additional Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailSection(
                    'Eligibility', widget.scholarship.eligibility),
                SizedBox(height: 12),
                _buildDetailSection(
                    'Required Documents', widget.scholarship.requiredDocuments),
                SizedBox(height: 12),
                _buildDetailSection('FAQs', 'Tap to view FAQs'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          content,
          style: GoogleFonts.poppins(fontSize: 14, color: grayTextColor),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement apply functionality
                  },
                  child: Text(
                    'Apply Now',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Implement save for later functionality
                  },
                  child: Text(
                    'Save for Later',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Contact Information',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.email, size: 16, color: grayTextColor),
              SizedBox(width: 8),
              Text(
                widget.scholarship.contactEmail,
                style: GoogleFonts.poppins(fontSize: 12, color: grayTextColor),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone, size: 16, color: grayTextColor),
              SizedBox(width: 8),
              Text(
                widget.scholarship.helpdesk,
                style: GoogleFonts.poppins(fontSize: 12, color: grayTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




class Scholarship {
  final String name;
  final int amount;
  final String gender;
  final int maxIncome;
  final String location;
  final String academicLevel;
  final DateTime applicationStart;
  final DateTime applicationEnd;
  final String description;
  final String eligibility;
  final String requiredDocuments;
  final String contactEmail;
  final String helpdesk;
  final bool isEligible;

  Scholarship({
    required this.name,
    required this.amount,
    required this.gender,
    required this.maxIncome,
    required this.location,
    required this.academicLevel,
    required this.applicationStart,
    required this.applicationEnd,
    required this.description,
    required this.eligibility,
    required this.requiredDocuments,
    required this.contactEmail,
    required this.helpdesk,
    required this.isEligible,
  });
}