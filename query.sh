curl -X POST "https://fertiscan-document-intelligence.cognitiveservices.azure.com/formrecognizer/documentModels/prebuilt-read:analyze?api-version=2023-07-31" \
-H "Ocp-Apim-Subscription-Key: 54f8cb3eea3945d8b86b4383e637923e" \
-H "Content-Type: application/json" \
-d '{
  "urlSource": "https://raw.githubusercontent.com/Azure-Samples/cognitive-services-REST-api-samples/master/curl/form-recognizer/rest-api/invoice.pdf"
}'
