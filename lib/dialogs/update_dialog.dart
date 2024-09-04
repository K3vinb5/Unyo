import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const String apiEndpoint =
    "https://api.github.com/repos/K3vinb5/Unyo/releases/latest";
const String latestVersionEndpoint =
    "https://github.com/K3vinb5/Unyo/releases/latest";

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({super.key, required this.markdown});

  final String markdown;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          opacity: 0.1,
          image: NetworkImage("https://i.imgur.com/JEGaQWx.png"),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          // SingleChildScrollView(
          //   child: Theme(
          //     data: Theme.of(context).copyWith(
          //         textTheme:
          //             Theme.of(context).textTheme.apply(bodyColor: Colors.white)),
          //     child: MarkdownBody(data: markdown),
          //   ),
          // ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 8,
                  child: SingleChildScrollView(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                          textTheme: Theme.of(context)
                              .textTheme
                              .apply(bodyColor: Colors.white)),
                      child: MarkdownBody(data: markdown),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(Colors.white),
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 37, 37, 37)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Later"),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                          foregroundColor: MaterialStatePropertyAll(Colors.white),
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 37, 37, 37)),
                        ),
                        onPressed: () {
                          goToLatestRelease();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Download Update"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

void showUpdateDialog(BuildContext context) async {
  var url = Uri.parse(apiEndpoint);
  var response = await http.get(url);
  if (!context.mounted) return;
  if (response.statusCode != 200) {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Color.fromARGB(255, 34, 33, 34),
            title: Text(
              "Error when looking for updates",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          );
        });
  }
  Map<String, dynamic> jsonResponse = json.decode(response.body);
  final String markdown = jsonResponse["body"] as String;
  final String newVersion = jsonResponse["tag_name"] as String;
  if (currentVersion == newVersion) return;
  if (newVersion.contains("ignore")) return;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 34, 33, 34),
        title: Text(
          "New version available, update to version $newVersion",
          style: const TextStyle(color: Colors.white, fontSize: 22),
        ),
        content: UpdateDialog(
          markdown: markdown,
        ),
      );
    },
  );
}

void goToLatestRelease() async {
  if (await canLaunchUrl(Uri.parse(latestVersionEndpoint))) {
    await launchUrl(Uri.parse(latestVersionEndpoint));
  }
}
