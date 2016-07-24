require "rest-client"
require "json"

url = 'https://api.wmata.com/NextBusService.svc/json/jPredictions?StopID=1001878'



SCHEDULER.every "1m", :first_in => 0 do |job|
  response = RestClient.get url, {"api_key" => '0b30a24a9d3d46ccbf0f4da7364cb6f6'} 

  parsed = JSON.parse(response)
  #puts parsed

  puts "=========="

  array_predictions = parsed["Predictions"]
  #puts array_predictions
  puts parsed['StopName']

  array_predictions.each {
  	|prediction|
  	puts prediction['RouteID'] + " | " + "#{prediction['Minutes']}"
  }

  array_predictions_json = JSON.generate(array_predictions)

  send_event "metro", { timings: array_predictions }
end
