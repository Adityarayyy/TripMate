import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey = 'AIzaSyDpado7-X28SCJyLswYkMbfp-DgIZ4G904';
  final GenerativeModel model;

  GeminiService() : model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: 'AIzaSyDpado7-X28SCJyLswYkMbfp-DgIZ4G904');

  Future<String> generateItinerary(String tripName, String destination, String duration, String budget, String people) async {
    final String prompt = '''
    Act as an AI-powered itinerary planner. I am traveling to **$destination** for **$duration** days with **$people** and my budget is **$budget**.

    ### **Instructions:**  
    1. **Recommend 2-3 lodging options** based on budget. Each hotel must include **hotel name, price per night, and a valid link to the hotel website**.  
    2. **Create a detailed day-wise itinerary** in the following format:  
       - **Morning:** Activity description  
       - **Afternoon:** Activity description  
       - **Evening:** Activity description  
    3. Each day must include **places to visit, local experiences, and cultural highlights**.  
    4. **Suggest famous restaurants for dinner** (include cuisine type and a valid restaurant link).  
    5. Provide **budget-friendly travel tips** at the end.  
    6. Ensure the response is **pure JSON format** (no extra text or headings).  

    ### **JSON Response Format:**
    {
      "title": "$tripName",
      "lodgingOptions": [
        {
          "hotelName": "<Hotel 1 Name>",
          "price": "<Price per night>",
          "link": "<Hotel website link>"
        },
        {
          "hotelName": "<Hotel 2 Name>",
          "price": "<Price per night>",
          "link": "<Hotel website link>"
        }
      ],
      "days": [
        {
          "dayNumber": 1,
          "title": "<Day 1 Title>",
          "morning": "<Morning activity>",
          "afternoon": "<Afternoon activity>",
          "evening": "<Evening activity>",
          "dinnerRecommendation": {
            "restaurantName": "<Restaurant Name>",
            "cuisine": "<Type of food>",
            "link": "<Restaurant website link>"
          }
        },
        {
          "dayNumber": 2,
          "title": "<Day 2 Title>",
          "morning": "<Morning activity>",
          "afternoon": "<Afternoon activity>",
          "evening": "<Evening activity>",
          "dinnerRecommendation": {
            "restaurantName": "<Restaurant Name>",
            "cuisine": "<Type of food>",
            "link": "<Restaurant website link>"
          }
        }
      ],
      "budgetFriendlyTips": [
        "<Tip 1>",
        "<Tip 2>",
        "<Tip 3>"
      ]
    }
    Ensure the JSON follows this structure with no extra characters or headings like 'json'. Do not include any additional text before or after the JSON structure.. The response should be **well-structured and easy to parse** for a Flutter app.
    ''';

    final response = await model.generateContent([Content.text(prompt)]);

    

   String itinerary = response.text ?? "Error: Unable to generate itinerary.";

  // Remove the first 3-4 characters
  if (itinerary.length > 7) {
    itinerary = itinerary.substring(8);  // Removes the first 4 characters
  }

  int removeLastN = 3;
  if (itinerary.length > removeLastN) {
    itinerary = itinerary.substring(0, itinerary.length - removeLastN);
  }

  return itinerary;

    
  }
}









// import 'package:google_generative_ai/google_generative_ai.dart';

// class GeminiService {
//   final String apiKey = 'AIzaSyDpado7-X28SCJyLswYkMbfp-DgIZ4G904';

 
  
//   final GenerativeModel model;

//   GeminiService() : model = GenerativeModel(model: 'gemini-1.5-pro', apiKey: 'AIzaSyDpado7-X28SCJyLswYkMbfp-DgIZ4G904');

//   Future<String> generateItinerary(String tripName, String destination, String duration, String budget, String people) async {
//     final String prompt = "Create a detailed travel itinerary for a trip named $tripName to $destination."
//         " The trip will last $duration days for $people people with a budget of $budget."
//         " Provide daily activities, sightseeing recommendations, and hotel suggestions within budget.";
        

//     final response = await model.generateContent([Content.text(prompt)]);

//     return response.text ?? "Error: Unable to generate itinerary.";
//   }
// }



