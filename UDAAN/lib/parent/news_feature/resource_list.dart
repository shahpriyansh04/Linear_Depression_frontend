import 'package:flutter/material.dart';
import 'resource_details.dart';

class Resource {
  final String title;
  final String description;
  final String url;

  Resource({required this.title, required this.description, required this.url});
}

class ResourceListScreen extends StatelessWidget {
  const ResourceListScreen({Key? key}) : super(key: key);

  static final List<Resource> resources = [
    Resource(
      title: "Parent Engagement Toolkit",
      description:
          "A comprehensive guide for parents to support their child's education.",
      url: "https://www.ed.gov/parent-and-family-engagement",
    ),
    Resource(
      title: "Dropout Prevention Strategies",
      description:
          "Effective strategies for parents to help prevent school dropout.",
      url: "https://dropoutprevention.org/resources/parent-resources/",
    ),
    Resource(
      title: "Educational Support at Home",
      description:
          "Tips for creating a supportive learning environment at home.",
      url:
          "https://www.understood.org/articles/en/how-to-create-a-homework-space",
    ),
    Resource(
      title: "Importance of Attendance",
      description:
          "Understanding the impact of regular school attendance on academic success.",
      url: "https://www.attendanceworks.org/resources/handouts-for-families/",
    ),
    Resource(
      title: "Communicating with Teachers",
      description: "Guide to effective parent-teacher communication.",
      url: "https://www.edutopia.org/article/new-teachers-working-with-parents",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Change app bar color
        title: const Text('Parent Resources'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body
        child: ListView.builder(
          itemCount: resources.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8), // Card margin
              elevation: 4, // Card shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.all(16), // Padding inside the card
                title: Text(
                  resources[index].title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal, // Title color
                  ),
                ),
                subtitle: Text(
                  resources[index].description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.teal, // Color for the arrow icon
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ResourceDetailScreen(resource: resources[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
